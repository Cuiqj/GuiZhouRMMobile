//
//  InspectionRecordNormal.m
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-28.
//
//

#import "InspectionRecordNormal.h"


@implementation InspectionRecordNormal

@dynamic inspection_id;
@dynamic roadsegment_id;
@dynamic roadsegment_name;
@dynamic start_station;
@dynamic end_station;
@dynamic start_time;
@dynamic end_time;

+ (NSArray *)normalsForInspection:(NSString *)inspectionID{
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
@end
