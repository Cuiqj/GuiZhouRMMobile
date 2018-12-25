//
//  RoadSegment.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-6-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


/*
 ***********************************************
 RoadSegement贵州暂时废弃不用，所有采用RoadID保存
 ***********************************************
*/


@interface RoadSegment : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * organizationid;
@property (nonatomic, retain) NSString * placeprefix1;
@property (nonatomic, retain) NSString * placeprefix2;
@property (nonatomic, retain) NSString * road_id;
@property (nonatomic, retain) NSString * roadsegment_id;
@property (nonatomic, retain) NSNumber * station_start;
@property (nonatomic, retain) NSNumber * station_end;
@property (nonatomic, retain) NSString * place_start;
@property (nonatomic, retain) NSString * place_end;
@property (nonatomic, retain) NSString * driveway_count;
@property (nonatomic, retain) NSString * road_grade;
@property (nonatomic, retain) NSString * group_id;
@property (nonatomic, retain) NSNumber * group_flag;
@property (nonatomic, retain) NSString * delflag;

//根据路段ID返回路段名称
//+ (NSString *)roadNameFromSegment:(NSString *)segmentID;

//返回所有的路段名称和路段号
//+ (NSArray *)allRoadSegments;
@end
