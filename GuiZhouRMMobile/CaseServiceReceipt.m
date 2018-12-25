//
//  CaseServiceReceipt.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-18.
//
//

#import "CaseServiceReceipt.h"


@implementation CaseServiceReceipt

@dynamic caseinfo_id;
@dynamic help_receiver;
@dynamic incepter_name;
@dynamic reason;
@dynamic remark;
@dynamic send_date;
@dynamic service_company;
@dynamic service_position;

//读取案号对应的记录
+ (CaseServiceReceipt *)caseServiceReceiptForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@",caseID];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    NSArray *fetchResult=[context executeFetchRequest:fetchRequest error:nil];
    if (fetchResult.count>0) {
        return [fetchResult objectAtIndex:0];
    } else {
        return nil;
    }
}

+ (CaseServiceReceipt *)newCaseServiceReceiptForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    CaseServiceReceipt *caseServiceReceipt = [[CaseServiceReceipt alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    caseServiceReceipt.caseinfo_id = caseID;
    [[AppDelegate App] saveContext];
    return caseServiceReceipt;
}

+ (void)synchronizeDataWithObject:(id)object modified:(BOOL *)modified
{
    if (object == nil) {
        return;
    }
    
    if ([object isKindOfClass:[CaseInfo class]] || [object isKindOfClass:[Citizen class]]) {
        NSString *caseID = nil;
        CaseInfo *caseInfo = nil;
        Citizen *citizen = nil;
        if ([object isKindOfClass:[CaseInfo class]]) {
            caseInfo = (CaseInfo *)object;
            caseID = caseInfo.caseinfo_id;
            citizen = [Citizen citizenForCase:caseID];
        } else if ([object isKindOfClass:[Citizen class]]) {
            citizen = (Citizen *)object;
            caseID = citizen.caseinfo_id;
            caseInfo = [CaseInfo caseInfoForID:caseID];
        }
        CaseServiceReceipt *receipt = [CaseServiceReceipt caseServiceReceiptForCase:caseID];
        if (receipt != nil) {
            // 更新受送达人
            if (![receipt.incepter_name isEqualToString:caseInfo.citizen_name]) {
                receipt.incepter_name = caseInfo.citizen_name;
                *modified = YES;
            }
            // 更新案由
            NSString *reason = nil;
            NSString *citizenInfo = nil;
            if (citizen != nil) {
                if ([citizen.citizen_flag isEqualToString:@"单位"]) {
                    citizenInfo = [NSString stringWithFormat:@"%@%@",citizen.party, citizen.driver];
                } else {
                    citizenInfo = [NSString stringWithFormat:@"%@",citizen.party];
                }
            }
            reason = [NSString stringWithFormat:@"%@%@",citizenInfo, caseInfo.casereason];
            if (![receipt.reason isEqualToString:reason]) {
                receipt.reason = reason;
                *modified = YES;
            }
        }
    }
    
    if (*modified == YES) {
        NSLog(@"CaseServiceReceipt updated");
    }
}

@end
