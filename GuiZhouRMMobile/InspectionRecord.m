//
//  InspectionRecord.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-8-23.
//
//

#import "InspectionRecord.h"


@implementation InspectionRecord

@dynamic inspection_id;
@dynamic inspection_type;
@dynamic inspection_item;
@dynamic roadsegment_id;
@dynamic station;
@dynamic location;
@dynamic status;
@dynamic measure;
@dynamic remark;
@dynamic start_time;
@dynamic fix;
@dynamic relationid;
@dynamic relationType;

+ (NSArray *)recordsForInspection:(NSString *)inspectionID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    if (![inspectionID isEmpty]) {
        [fetchRequest setPredicate:[NSPredicate  predicateWithFormat:@"inspection_id == %@",inspectionID]];
    } else {
        [fetchRequest setPredicate:nil];
    }
    return [context executeFetchRequest:fetchRequest error:nil];
}

+(InspectionRecord *)caseInfoForID:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"InspectionRecord" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"inspection_id==%@",caseID];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    NSArray *fetchResult=[context executeFetchRequest:fetchRequest error:nil];
    if (fetchResult.count>0) {
        return [fetchResult objectAtIndex:0];
    } else {
        return nil;
    }
}

+ (NSInteger)recordsCountForInspection:(NSString *)inspectionID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate  predicateWithFormat:@"inspection_id == %@",inspectionID]];
    return [context countForFetchRequest:fetchRequest error:nil];
}
@end
