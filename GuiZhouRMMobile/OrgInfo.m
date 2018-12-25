//
//  OrgInfo.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-16.
//
//

#import "OrgInfo.h"


@implementation OrgInfo

@dynamic belongtoid;
@dynamic myid;
@dynamic orderdesc;
@dynamic orgname;
@dynamic orgshortname;
@dynamic principal;
@dynamic linkman;
@dynamic address;
@dynamic telephone;
@dynamic faxnumber;
@dynamic postcode;
@dynamic orgtype;
@dynamic defaultuserid;
@dynamic file_pre;
@dynamic org_jc;
@dynamic jzFlag;

+ (OrgInfo *)orgInfoForOrgID:(NSString *)orgID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"myid == %@",orgID]];
    NSArray *temp=[context executeFetchRequest:fetchRequest error:nil];
    if (temp.count>0) {
        return [temp lastObject];
    } else {
        return nil;
    }
}

+ (NSArray *)allOrgInfo{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:nil];
    return [context executeFetchRequest:fetchRequest error:nil];
}

@end
