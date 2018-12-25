//
//  Citizen.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-6.
//
//

#import "Citizen.h"


@implementation Citizen

@dynamic address;
@dynamic age;
@dynamic automobile_address;
@dynamic automobile_number;
@dynamic automobile_owner;
@dynamic automobile_pattern;
@dynamic card_no;
@dynamic driver;
@dynamic nation;
@dynamic nationality;
@dynamic org_name;
@dynamic org_principal;
@dynamic org_principal_duty;
@dynamic org_principal_tel_number;
@dynamic org_tel_number;
@dynamic original_home;
@dynamic party;
@dynamic party_type;
@dynamic postalcode;
@dynamic profession;
@dynamic remark;
@dynamic sex;
@dynamic tel_number;
@dynamic citizen_flag;
@dynamic legal_spokesman;
@dynamic automobile_owner_address;
@dynamic automobile_owner_flag;
@dynamic automobile_trademark;
@dynamic driver_address;
@dynamic driver_relation;
@dynamic driver_tel;
@dynamic duty;
@dynamic identity_card;
@dynamic org_address;
@dynamic organizer_desc;
@dynamic caseinfo_id;
@dynamic proxyaddress;
@dynamic proxyage;
@dynamic proxyidentity;
@dynamic proxyman;
@dynamic proxysex;
@dynamic proxytel;
@dynamic proxyunit;

+ (Citizen *)citizenForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@",caseID];
    fetchRequest.predicate=predicate;
    if ([context countForFetchRequest:fetchRequest error:nil] > 0) {
        return [[context executeFetchRequest:fetchRequest error:nil] objectAtIndex:0];
    } else {
        return nil;
    }
}

/*
+ (Citizen *)citizenForName:(NSString *)autoNumber nexus:(NSString *)nexus case:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@ && nexus==%@ && automobile_number==%@",caseID,nexus,autoNumber];
    fetchRequest.predicate=predicate;
    if ([context countForFetchRequest:fetchRequest error:nil]>0) {
        return [[context executeFetchRequest:fetchRequest error:nil] lastObject];
    } else {
        return nil;
    }
}
*/

- (NSString *)companyAndDutyString
{
    NSString *orgName = self.org_name ? self.org_name: @"";
    NSString *profession = self.profession ? self.profession : @"";
    return [NSString stringWithFormat:@"%@ %@", orgName, profession];
}

//add by lxm 2013.05.10
+ (Citizen *)citizenForCitizenName:(NSString *)name nexus:(NSString *)nexus case:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"proveinfo_id==%@ && nexus==%@",caseID,nexus];
    fetchRequest.predicate=predicate;
    if ([context countForFetchRequest:fetchRequest error:nil]>0) {
        return [[context executeFetchRequest:fetchRequest error:nil] lastObject];
    } else {
        return nil;
    }
}
@end
