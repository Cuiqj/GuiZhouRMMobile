//
//  RoadWayClosedModel.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-21.
//
//

#import "UpDataModel.h"
#import "RoadWayClosed.h"

@interface RoadWayClosedModel : UpDataModel
@property (nonatomic, retain) NSString * closed_reason;
@property (nonatomic, retain) NSString * closed_roadway;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * inportant;
@property (nonatomic, retain) NSString * org_id;
@property (nonatomic, retain) NSString * put_flag;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * roadsegment_id;
@property (nonatomic, retain) NSString * station_end;
@property (nonatomic, retain) NSString * station_start;
@property (nonatomic, retain) NSString * time_end;
@property (nonatomic, retain) NSString * time_start;

- (id)initWithRoadWayClosed:(RoadWayClosed *)roadWayClosed;
@end
