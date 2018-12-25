//
//  ForceNotice.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-27.
//
//

#import "ForceNotice.h"


@implementation ForceNotice

@dynamic basis_law;
@dynamic break_law;
@dynamic caseinfo_id;
@dynamic change_action;
@dynamic change_limit;
@dynamic change_spot;
@dynamic change_time;
@dynamic date_send;
@dynamic dsrname;
@dynamic fact;
@dynamic handle_time;
@dynamic isStop;
@dynamic linkAddress;
@dynamic linkMan;
@dynamic linkTel;

//读取案号对应的记录
+(ForceNotice *)forceNoticeForCase:(NSString *)caseID{
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

+ (ForceNotice *)newForceNoticeForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    ForceNotice *forceNotice = [[ForceNotice alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    forceNotice.caseinfo_id = caseID;
    [[AppDelegate App] saveContext];
    return forceNotice;
}
@end
