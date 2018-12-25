//
//  CaseSampleDetail.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-27.
//
//

#import "CaseSampleDetail.h"


@implementation CaseSampleDetail

@dynamic caseinfo_id;
@dynamic description_text;
@dynamic name;
@dynamic object_address;
@dynamic quantity;
@dynamic remark;
@dynamic spec;
@dynamic unit;

//读取案号对应的记录
+ (NSArray *)caseSampleDetailsForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id ==%@",caseID];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    return [context executeFetchRequest:fetchRequest error:nil];
}

+ (CaseSampleDetail *)newCaseSampleDetailForID:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    CaseSampleDetail *caseSample = [[CaseSampleDetail alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    caseSample.caseinfo_id = caseID;
    [[AppDelegate App] saveContext];
    return caseSample;
}
@end
