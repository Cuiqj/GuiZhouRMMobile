//
//  CaseInquire.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-18.
//
//

#import "CaseInquire.h"


@implementation CaseInquire

@dynamic address;
@dynamic age;
@dynamic answerer_name;
@dynamic caseinfo_id;
@dynamic company_duty;
@dynamic inquirer_name;
@dynamic inquiry_note;
@dynamic locality;
@dynamic phone;
@dynamic postalcode;
@dynamic recorder_name;
@dynamic relation;
@dynamic sex;
@dynamic date_inquired_start;
@dynamic date_inquired_end;
@dynamic inquired_times;
@dynamic inquirer_name2;
@dynamic id_card;
@dynamic inquirer1_no;
@dynamic inquirer2_no;
@dynamic recorder_no;
@dynamic inquirer_org;
@dynamic edu_level;
@dynamic remark;
@dynamic myid;

+ (NSArray *)allInquireForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@",caseID];
    fetchRequest.predicate=predicate;
    return [context executeFetchRequest:fetchRequest error:nil];
}

+ (CaseInquire *)inquirerForCase:(NSString *)caseID ForID:(NSString *)inquirerID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@ && myid == %@",caseID,inquirerID];
    fetchRequest.predicate=predicate;
    if ([context countForFetchRequest:fetchRequest error:nil] > 0) {
        return [[context executeFetchRequest:fetchRequest error:nil] objectAtIndex:0];
    } else {
        return nil;
    }
}

+ (void)synchronizeDataWithObject:(Citizen *)citizen modified:(BOOL *)modified
{
    if (citizen == nil) {
        return;
    }
    
    if ([citizen isKindOfClass:[Citizen class]]) {
        NSString *caseID = citizen.caseinfo_id;
        NSArray *caseInquires = [CaseInquire allInquireForCase:caseID];
        if (caseInquires.count > 0) {
            for (CaseInquire *inquire in caseInquires) {
                if ([inquire.relation isEqualToString:@"当事人"]) {
                    if (![inquire.answerer_name isEqualToString:citizen.party]) {
                        inquire.answerer_name = citizen.party;
                        *modified = YES;
                    }
                    if (![inquire.sex isEqualToString:citizen.sex]) {
                        inquire.sex = citizen.sex;
                        *modified = YES;
                    }
                    if (inquire.age.integerValue != citizen.age.integerValue) {
                        inquire.age = @(citizen.age.integerValue);
                        *modified = YES;
                    }
                    if (![inquire.address isEqualToString:citizen.address]) {
                        inquire.address = citizen.address;
                        *modified = YES;
                    }
                    if (![inquire.phone isEqualToString:citizen.tel_number]) {
                        inquire.phone = citizen.tel_number;
                        *modified = YES;
                    }
                    if (![inquire.postalcode isEqualToString:citizen.postalcode]) {
                        inquire.postalcode = citizen.postalcode;
                        *modified = YES;
                    }
                    if (![inquire.id_card isEqualToString:citizen.identity_card]) {
                        inquire.id_card = citizen.identity_card;
                        *modified = YES;
                    }
                    if (![inquire.company_duty isEqualToString:[citizen companyAndDutyString]]) {
                        inquire.company_duty = [citizen companyAndDutyString];
                        *modified = YES;
                    }
                }
            }
        }
    }
    
    if (*modified == YES) {
        NSLog(@"CaseInquire updated");
    }
}

@end
