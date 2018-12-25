//
//  CaseProveInfo.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-20.
//
//

#import "CaseProveInfo.h"


@implementation CaseProveInfo

@dynamic case_short_desc;
@dynamic caseinfo_id;
@dynamic caseproveinfo_id;
@dynamic citizen_address;
@dynamic citizen_age;
@dynamic citizen_duty;
@dynamic citizen_name;
@dynamic citizen_no;
@dynamic citizen_sex;
@dynamic citizen_tel;
@dynamic end_date_time;
@dynamic event_desc;
@dynamic invitee;
@dynamic invitee_org_duty;
@dynamic organizer;
@dynamic organizer_org_duty;
@dynamic party;
@dynamic party_address;
@dynamic party_age;
@dynamic party_card;
@dynamic party_org_duty;
@dynamic party_sex;
@dynamic party_tel;
@dynamic prover_place;
@dynamic prover1;
@dynamic prover1_code;
@dynamic prover1_duty;
@dynamic prover2;
@dynamic prover2_code;
@dynamic prover2_duty;
@dynamic recorder;
@dynamic recorder_duty;
@dynamic remark;
@dynamic start_date_time;
@dynamic recorder_code;

//读取案号对应的勘验记录
+(CaseProveInfo *)proveInfoForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseProveInfo" inManagedObjectContext:context];
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

+ (void)synchronizeDataWithObject:(id)object modified:(BOOL *)modified
{
    if (object == nil) {
        return;
    }
    
    if ([object isKindOfClass:[Citizen class]] || [object isKindOfClass:[CaseInfo class]]) {
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
        CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:caseID];
        if (proveInfo != nil) {
            NSString *caseDescription = [caseInfo.citizen_name stringByAppendingString:caseInfo.casereason];
            NSString *citizenDuty = (citizen == nil ? @"" : [citizen companyAndDutyString]);
            // 更新案由
            if (![proveInfo.case_short_desc isEqualToString:caseDescription]) {
                proveInfo.case_short_desc = caseDescription;
                *modified = YES;
            }
            // 更新勘验检查场所
            if (![proveInfo.prover_place isEqualToString:caseInfo.case_address]) {
                proveInfo.prover_place = caseInfo.case_address;
                *modified = YES;
            }
            // 更新天气情况
            if (![proveInfo.organizer isEqualToString:caseInfo.weather]) {
                proveInfo.organizer = caseInfo.weather;
                *modified = YES;
            }
            // 更新当事人姓名
            if (![proveInfo.citizen_name isEqualToString:caseInfo.citizen_name]) {
                proveInfo.citizen_name = caseInfo.citizen_name;
                *modified = YES;
            }
            // 更新单位及职务
            if (![proveInfo.citizen_duty isEqualToString:citizenDuty]) {
                proveInfo.citizen_duty = citizenDuty;
                *modified = YES;
            }
            if (citizen != nil) {
                // 更新性别
                if (![proveInfo.citizen_sex isEqualToString:citizen.sex]) {
                    proveInfo.citizen_sex = citizen.sex;
                    *modified = YES;
                }
                // 更新年龄
                if (![proveInfo.citizen_age isEqualToNumber:citizen.age]) {
                    proveInfo.citizen_age =  citizen.age;
                    *modified = YES;
                }
                // 更新身份证号
                if (![proveInfo.citizen_no isEqualToString:citizen.identity_card]) {
                    proveInfo.citizen_no = citizen.identity_card;
                    *modified = YES;
                }
                // 更新住址
                if (![proveInfo.citizen_address isEqualToString:citizen.address]) {
                    proveInfo.citizen_address = citizen.address;
                    *modified = YES;
                }
                // 更新联系电话
                if (![proveInfo.citizen_tel isEqualToString:citizen.tel_number]) {
                    proveInfo.citizen_tel = citizen.tel_number;
                    *modified = YES;
                }
            }
        }
    }
    
    if (*modified == YES) {
        NSLog(@"CaseProveInfo updated");
    }
}

@end
