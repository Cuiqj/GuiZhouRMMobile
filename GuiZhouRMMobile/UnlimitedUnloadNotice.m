//
//  UnlimitedUnloadNotice.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-27.
//
//

#import "UnlimitedUnloadNotice.h"


@implementation UnlimitedUnloadNotice

@dynamic ah;
@dynamic carNumber;
@dynamic dsrname;
@dynamic goods;
@dynamic caseinfo_id;
@dynamic limitDate;
@dynamic roadName;
@dynamic sendDate;
@dynamic unlimit;
@dynamic unload;
@dynamic weight;
@dynamic zou;

//读取案号对应的记录
+(UnlimitedUnloadNotice *)unlimitedUnloadNoticeForCase:(NSString *)caseID{
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

+ (UnlimitedUnloadNotice *)newUnlimitedUnloadNoticeForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    UnlimitedUnloadNotice *unlimitedUnloadNotice = [[UnlimitedUnloadNotice alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    unlimitedUnloadNotice.caseinfo_id = caseID;
    [[AppDelegate App] saveContext];
    return unlimitedUnloadNotice;
}
@end
