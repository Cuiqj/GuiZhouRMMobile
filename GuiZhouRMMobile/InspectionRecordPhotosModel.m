//
//  InspectionRecordPhotosModel.m
//  GuiZhouRMMobile
//
//  Created by luna on 14-1-23.
//
//

#import "InspectionRecordPhotosModel.h"
#import "InspectionRecord.h"

@implementation InspectionRecordPhotosModel

@synthesize inspection_id;
@synthesize parent_id;
@synthesize sketch;
@synthesize description;
@synthesize uploadName;
@synthesize shootName;
@synthesize uploadTime;
@synthesize shootTime;
@synthesize num;

+ (NSArray *)casePhotosForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"InspectionRecordPhotosModel" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"inspection_id == %@",caseID];
    fetchRequest.predicate=predicate;
    return [context executeFetchRequest:fetchRequest error:nil];
}

@end
