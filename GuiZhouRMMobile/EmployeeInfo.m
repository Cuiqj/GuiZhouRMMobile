//
//  EmployeeInfo.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-17.
//
//

#import "EmployeeInfo.h"
#import "OrgInfo.h"


@implementation EmployeeInfo

@dynamic cardid;
@dynamic duty;
@dynamic employee_id;
@dynamic enforce_code;
@dynamic name;
@dynamic orderdesc;
@dynamic organization_id;
@dynamic sex;
@dynamic telephone;

+ (EmployeeInfo *)EmployeeInfoForID:(NSString *)employeeID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"employee_id == %@",employeeID]];
    NSArray *temp=[context executeFetchRequest:fetchRequest error:nil];
    if (temp.count>0) {
        return [temp lastObject];
    } else {
        return nil;
    }
}

+ (NSString *)orgAndDutyForUserName:(NSString *)username{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@",username]];
    if ([context countForFetchRequest:fetchRequest error:nil] > 0) {
        id info = [[context executeFetchRequest:fetchRequest error:nil] objectAtIndex:0];
        NSString *duty = [info duty]?[info duty]:@"";
        OrgInfo *org = [OrgInfo orgInfoForOrgID:[info organization_id]];
        NSString *orgName = [org orgname]?[org orgname]:@"";
        return [NSString stringWithFormat:@"(%@)%@",orgName,duty];
    } else {
        return @"";
    }
}

+ (NSString *)enforceCodeForUserName:(NSString *)username{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@",username]];
    if ([context countForFetchRequest:fetchRequest error:nil] > 0) {
        id info = [[context executeFetchRequest:fetchRequest error:nil] objectAtIndex:0];
        return [info enforce_code]?[info enforce_code]:@"";
    } else {
        return @"";
    }
}

+ (NSArray *)allEmployeeInfo{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:nil];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"orderdesc" ascending:YES selector:@selector(localizedStandardCompare:)];
    [fetchRequest setSortDescriptors:@[sort]];
    return [context executeFetchRequest:fetchRequest error:nil];
}
@end
