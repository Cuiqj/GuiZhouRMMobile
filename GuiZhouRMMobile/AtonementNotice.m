//
//  AtonementNotice.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-18.
//
//

#import "AtonementNotice.h"


@implementation AtonementNotice

@dynamic code;
@dynamic date_send;
@dynamic case_desc;
@dynamic witness;
@dynamic pay_reason;
@dynamic pay_mode;
@dynamic pay_bank;
@dynamic pay_real;
@dynamic remark;
@dynamic law_zhan;
@dynamic law_pei;
@dynamic atonementreason;
@dynamic linkAddress;
@dynamic linkMan;
@dynamic linkTel;
@dynamic caseDeformationSendDate;
@dynamic fixed_legal;
@dynamic caseinfo_id;
@dynamic layweifan;
@dynamic layyiju;

//读取案号对应的记录
+(AtonementNotice *)atonementNoticeForCase:(NSString *)caseID{
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

+ (AtonementNotice *)newAtonementNoticeForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    AtonementNotice *atonementnotice = [[AtonementNotice alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    atonementnotice.caseinfo_id = caseID;
    [[AppDelegate App] saveContext];
    return atonementnotice;
}

+ (void)synchronizeDataWithObject:(id)object modified:(BOOL *)modified
{
    if (object == nil) {
        return;
    }
    
    if ([object isKindOfClass:[Citizen class]] ||[object isKindOfClass:[CaseInfo class]]) {
        
        Citizen *citizen = nil;
        NSString *caseID = nil;
        CaseInfo *caseInfo = nil;
        
        if ([object isKindOfClass:[Citizen class]] ) {
            citizen = (Citizen *)object;
            caseID = citizen.caseinfo_id;
            caseInfo =  [CaseInfo caseInfoForID:caseID];
        } else if ([object isKindOfClass:[CaseInfo class]]) {
            caseInfo = (CaseInfo *)object;
            caseID = caseInfo.caseinfo_id;
            citizen = [Citizen citizenForCase:caseID];
        }
        
        AtonementNotice *notice = [AtonementNotice atonementNoticeForCase:caseID];
        if (notice != nil) {
            NSString *citizenString = nil;
            if (citizen != nil) {
                if ([citizen.citizen_flag isEqualToString:@"单位"]) {
                    citizenString = [[NSString alloc] initWithFormat:@"%@%@",citizen.party, citizen.driver];
                } else {
                    citizenString = [[NSString alloc] initWithFormat:@"%@",citizen.party];
                }
            }

            NSString *atonementReason = [NSString stringWithFormat:@"%@%@", citizenString, [caseInfo.casereason stringByReplacingOccurrencesOfString:@"涉嫌" withString:@""]];
            //更新案由
            if (![notice.atonementreason isEqualToString:atonementReason]) {
                notice.atonementreason = atonementReason;
                *modified = YES;
            }
        }
    } else if ([object isKindOfClass:[CaseDeformation class]]) {
        CaseDeformation *deformation = (CaseDeformation *)object;
        NSString *caseID = deformation.caseinfo_id;
        
        AtonementNotice *notice = [AtonementNotice atonementNoticeForCase:caseID];
        if (notice != nil) {
            double moneySumDouble = [CaseDeformation deformSumPriceForCase:caseID];
            NSNumber *moneySum = @(moneySumDouble);
            NSString *moneySumString = [moneySum numberConvertToChineseCapitalNumberString];
            //更新大写金额
            if (![notice.pay_mode isEqualToString:moneySumString]) {
                notice.pay_mode = moneySumString;
                *modified = YES;
            }
            //更新小写金额
            if (![notice.pay_real isEqualToNumber:moneySum]) {
                notice.pay_real = moneySum;
                *modified = YES;
            }
        }
        
    }
    
    if (*modified == YES) {
        NSLog(@"AtonementNotice updated");
    }
}

@end
