//
//  RoadSegment.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "RoadSegment.h"

@implementation RoadSegment

@dynamic code;
@dynamic name;
@dynamic organizationid;
@dynamic placeprefix1;
@dynamic placeprefix2;
@dynamic road_id;
@dynamic roadsegment_id;
@dynamic station_start;
@dynamic station_end;
@dynamic place_start;
@dynamic place_end;
@dynamic driveway_count;
@dynamic road_grade;
@dynamic group_id;
@dynamic group_flag;
@dynamic delflag;

/*
//根据路段ID返回路段名称
+ (NSString *)roadNameFromSegment:(NSString *)segmentID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"roadsegment_id == %@",segmentID]];
    NSArray *temp=[context executeFetchRequest:fetchRequest error:nil];
    if (temp.count>0) {
        id obj=[temp objectAtIndex:0];
        return [obj name];
    } else {
        return @"";
    }
}

//返回所有的路段名称和路段号
+ (NSArray *)allRoadSegments{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:nil];
    return [context executeFetchRequest:fetchRequest error:nil];
}
*/

@end
