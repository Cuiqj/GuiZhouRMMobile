//
//  Road.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Road : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * delflag;
@property (nonatomic, retain) NSString * road_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * place_end;
@property (nonatomic, retain) NSString * place_start;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSNumber * station_start;
@property (nonatomic, retain) NSNumber * station_end;

//返回所有的道路数据
+ (NSArray *)allRoads;

//根据道路ID返回名称
+ (NSString *)roadNameFromID:(NSString *)roadID;
@end
