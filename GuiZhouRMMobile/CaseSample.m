//
//  CaseSample.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-27.
//
//

#import "CaseSample.h"


@implementation CaseSample

@dynamic address;
@dynamic age;
@dynamic case_sample_reason;
@dynamic caseinfo_id;
@dynamic date_sample_end;
@dynamic date_sample_start;
@dynamic legal_person;
@dynamic name;
@dynamic person_incharge;
@dynamic phone;
@dynamic place;
@dynamic postalcode;
@dynamic remark;
@dynamic send_date;
@dynamic sex;
@dynamic taking_company;
@dynamic taking_company_tel;
@dynamic taking_names;
@dynamic taking_postalcode;

//读取案号对应的记录
+ (CaseSample *)caseSampleForCase:(NSString *)caseID{
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

+ (CaseSample *)newCaseSampleForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    CaseSample *caseSample = [[CaseSample alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    caseSample.caseinfo_id = caseID;
    [[AppDelegate App] saveContext];
    return caseSample;
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
        CaseSample *sample = [CaseSample caseSampleForCase:caseID];
        if (sample != nil) {
            // 被抽样取证人（单位）
            if (![sample.name isEqualToString:caseInfo.citizen_name]) {
                sample.name = caseInfo.citizen_name;
                *modified = YES;
            }
            //抽样取证地点
            if (![sample.place isEqualToString:caseInfo.case_address]) {
                sample.place = caseInfo.case_address;
                *modified = YES;
            }
            //法定代表人或负责人
            if (citizen != nil && [citizen.citizen_flag isEqualToString:@"单位"]) {
                if (![sample.legal_person isEqualToString:citizen.legal_spokesman]) {
                    sample.legal_person = citizen.legal_spokesman;
                    *modified = YES;
                }
            } else {
                if (![sample.legal_person isEqualToString:@""]) {
                    sample.legal_person = @"";
                    *modified = YES;
                }
            }
            if (citizen != nil) {
                //地址
                if (![sample.address isEqualToString:citizen.address]) {
                    sample.address = citizen.address;
                    *modified = YES;
                }
                //联系电话
                if (![sample.phone isEqualToString:citizen.tel_number]) {
                    sample.phone = citizen.tel_number;
                    *modified = YES;
                }
            }
        }
    }
    
    if (*modified == YES) {
        NSLog(@"CaseSample updated");
    }
}


@end
