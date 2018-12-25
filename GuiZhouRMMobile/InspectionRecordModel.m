//
//  InspectionRecordModel.m
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "InspectionRecordModel.h"
#import "InspectionRecord.h"

@implementation InspectionRecordModel

- (id)initWithInspectionRecord:(InspectionRecord *)record{
    self = [super init];
    if (self && record) {
        self.inspection_id = record.inspection_id;
        self.inspection_type = record.inspection_type;
        self.inspection_item = record.inspection_item;
        self.roadsegment_id = record.roadsegment_id;
        self.station = record.station.stringValue;
        self.location = record.location;
        self.status = record.status;
        self.measure = record.measure;
        self.remark = record.remark;
        self.start_time = [self.dateFormatter stringFromDate:record.start_time];
    } else {
        return nil;
    }
    return self;
}

@end
