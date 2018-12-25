//
//  InspectionRecordNormalModel.m
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "InspectionRecordNormalModel.h"

@implementation InspectionRecordNormalModel

- (id)initWithInspectionRecordNormal:(InspectionRecordNormal *)normal{
    self = [super init];
    if (self && normal) {
        self.inspection_id = normal.inspection_id;
        self.roadsegment_id = normal.roadsegment_id;
        self.roadsegment_name = normal.roadsegment_name;
        self.start_station = [[NSString alloc] initWithFormat:@"%d",normal.start_station.integerValue/1000];
        self.end_station =[[NSString alloc] initWithFormat:@"%d",normal.end_station.integerValue/1000];
        self.start_time = [self.dateFormatter stringFromDate:normal.start_time];
        self.end_time = [self.dateFormatter stringFromDate:normal.end_time];
    } else {
        return nil;
    }
    return self;
}
@end
