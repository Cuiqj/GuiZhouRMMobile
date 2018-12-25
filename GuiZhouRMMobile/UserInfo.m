//
//  UserInfo.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-26.
//
//

#import "UserInfo.h"


@implementation UserInfo

@dynamic account;
@dynamic employee_id;
@dynamic myid;
@dynamic orgid;
@dynamic password;
@dynamic username;
@dynamic isadmin;


+ (UserInfo *)userInfoForUserID:(NSString *)userID {
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"myid == %@",userID]];
    NSArray *temp=[context executeFetchRequest:fetchRequest error:nil];
    if (temp.count>0) {
        return [temp lastObject];
    } else {
        return nil;
    }
}

+ (NSArray *)allUserInfo{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isadmin == NO"]];
    return [context executeFetchRequest:fetchRequest error:nil];
}
@end
