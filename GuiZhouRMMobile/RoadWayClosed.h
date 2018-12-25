//
//  RoadWayClosed.h
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UploadDataProtocol.h"

@interface RoadWayClosed : NSManagedObject <UploadDataProtocol>

@property (nonatomic, retain) NSString * closed_reason;
@property (nonatomic, retain) NSString * closed_result;
@property (nonatomic, retain) NSString * closed_roadway;
@property (nonatomic, retain) NSString * creator;
@property (nonatomic, retain) NSString * fix;
@property (nonatomic, retain) NSString * inportant;
@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSString * it_company;
@property (nonatomic, retain) NSString * it_duty;
@property (nonatomic, retain) NSString * it_telephone;
@property (nonatomic, retain) NSString * maintainplan_id;
@property (nonatomic, retain) NSString * org_id;
@property (nonatomic, retain) NSNumber * promulgate;
@property (nonatomic, retain) NSString * put_flag;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * roadsegment_id;
@property (nonatomic, retain) NSString * roadwayclosed_id;
@property (nonatomic, retain) NSNumber * station_end;
@property (nonatomic, retain) NSNumber * station_start;
@property (nonatomic, retain) NSDate * time_end;
@property (nonatomic, retain) NSDate * time_start;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSDate * record_date;

+ (NSArray *)roadWayCloseInfoForID:(NSString *)roadWayCloseID;
@end
