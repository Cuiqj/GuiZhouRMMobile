//
//  CaseLawBreaking.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-27.
//
//

#import "CaseLawBreaking.h"


@implementation CaseLawBreaking

@dynamic caseinfo_id;
@dynamic citizen_id;
@dynamic citizen_right;
@dynamic code;
@dynamic date_appeal;
@dynamic date_send;
@dynamic fact;
@dynamic flag;
@dynamic flag_Listen;
@dynamic flag_StatePlea;
@dynamic law_disobey;
@dynamic law_gist;
@dynamic lawbreakingreason;
@dynamic link_addr;
@dynamic link_phone;
@dynamic linkman;
@dynamic postcode;
@dynamic punish_mode;
@dynamic punish_org;
@dynamic punish_other;
@dynamic punish_reason;
@dynamic punish_sum;
@dynamic remark;
@dynamic witness;
//读取案号对应的记录
+(CaseLawBreaking *)caseLawBreakingForCase:(NSString *)caseID{
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

+ (CaseLawBreaking *)newCaseLawBreakingForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    CaseLawBreaking *caseLawBreaking = [[CaseLawBreaking alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    caseLawBreaking.caseinfo_id = caseID;
    [[AppDelegate App] saveContext];
    return caseLawBreaking;
}
@end
