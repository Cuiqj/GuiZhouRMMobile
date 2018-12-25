//
//  InspectionCheck.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-9-12.
//
//

#import "InspectionCheck.h"


@implementation InspectionCheck

@dynamic inspection_id;
@dynamic checktext;
@dynamic remark;
@dynamic checkresult;

+ (NSArray *)checksForInspection:(NSString *)inspectionID{
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
