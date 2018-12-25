//
//  PunishDecision.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-27.
//
//

#import "PunishDecision.h"


@implementation PunishDecision

@dynamic account_number;
@dynamic case_desc;
@dynamic caseinfo_id;
@dynamic caseobject_number;
@dynamic code;
@dynamic court;
@dynamic dsrname;
@dynamic enforceORG;
@dynamic immediately;
@dynamic law_disobey;
@dynamic law_gist;
@dynamic organization;
@dynamic punish_decision;
@dynamic punish_org_link_address;
@dynamic punish_org_link_man;
@dynamic punish_org_link_tel;
@dynamic punish_other;
@dynamic punish_sum;
@dynamic punishreason;
@dynamic recheck_org1;
@dynamic recheck_org2;
@dynamic remark;
@dynamic send_date;
@dynamic stop_address;
@dynamic unload_num;
@dynamic witness;
@dynamic citizen_id;

//读取案号对应的记录
+(PunishDecision *)punishDecisionForCase:(NSString *)caseID{
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

+ (PunishDecision *)newPunishDecisionForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    PunishDecision *punishDecision = [[PunishDecision alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    punishDecision.caseinfo_id = caseID;
    [[AppDelegate App] saveContext];
    return punishDecision;
}

@end
