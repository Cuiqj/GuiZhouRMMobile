//
//  RoadWayClosedModel.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-21.
//
//

#import "RoadWayClosedModel.h"

@implementation RoadWayClosedModel

- (id)initWithRoadWayClosed:(RoadWayClosed *)roadWayClosed{
    self = [super init];
    if (self && roadWayClosed) {
        self.closed_reason = roadWayClosed.closed_reason;
        self.closed_roadway = roadWayClosed.closed_roadway;
        self.myid = roadWayClosed.roadwayclosed_id;
        self.inportant = roadWayClosed.inportant;
        self.org_id = roadWayClosed.org_id;
        self.put_flag = roadWayClosed.put_flag;
        self.remark = roadWayClosed.remark;
        self.roadsegment_id = roadWayClosed.roadsegment_id;
        self.station_end = roadWayClosed.station_end.stringValue;
        self.station_start = roadWayClosed.station_start.stringValue;
        self.time_start = [self.dateFormatter stringFromDate:roadWayClosed.time_start];
        self.time_end = [self.dateFormatter stringFromDate:roadWayClosed.time_end];
    } else {
        return nil;
    }
    return self;
}
@end
