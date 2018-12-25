//
//  CaseCount.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-28.
//
//

#import "CaseCount.h"


@implementation CaseCount

@dynamic caseinfo_id;
@dynamic caseCountReason;
@dynamic caseCountRemark;
@dynamic caseCountSendDate;
@dynamic case_citizen_info;

//读取案号对应的记录
+(CaseCount *)caseCountForCase:(NSString *)caseID{
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

+ (CaseCount *)newCaseCountForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    CaseCount *caseCount = [[CaseCount alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    caseCount.caseinfo_id = caseID;
    [[AppDelegate App] saveContext];
    return caseCount;
}

+ (void)synchronizeDataWithObject:(id)object modified:(BOOL *)modified
{
    if (object == nil) {
        return;
    }
    
    if ([object isKindOfClass:[CaseInfo class]]) {     
        CaseInfo *caseInfo = (CaseInfo *)object;
        NSString *caseID = caseInfo.caseinfo_id;
        CaseCount *caseCount = [CaseCount caseCountForCase:caseID];
        if (caseCount != nil) {
            NSString *caseCountReason = [caseInfo.casereason stringByReplacingOccurrencesOfString:@"涉嫌" withString:@""];
            // 更新案由
            if (![caseCount.caseCountReason isEqualToString:caseCountReason]) {
                caseCount.caseCountReason = caseCountReason;
                *modified = YES;
            }
        }
    } else if ([object isKindOfClass:[CaseDeformation class]]) {
        CaseDeformation *deform = (CaseDeformation *)object;
        NSString *caseID = deform.caseinfo_id;
        CaseCount *caseCount = [CaseCount caseCountForCase:caseID];
        if (caseCount != nil) {
            double moneySumDouble = [CaseDeformation deformSumPriceForCase:caseID];
            NSNumber *moneySum = @(moneySumDouble);
            NSString *moneySumString = [moneySum numberConvertToChineseCapitalNumberString];
            // 更新金额大写
            if (![caseCount.case_citizen_info isEqualToString:moneySumString]) {
                caseCount.case_citizen_info = moneySumString;
                *modified = YES;
            }
        }
    }
    if (*modified == YES) {
        NSLog(@"CaseCount updated");
    }
}

@end
