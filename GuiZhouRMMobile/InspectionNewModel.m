//
//  InspectionNewModel.m
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "InspectionNewModel.h"
#import "Inspection.h"
#import "InspectionRecordNormal.h"
#import "InspectionRecord.h"

@implementation InspectionNewModel

- (id)initWithInspection:(Inspection *)inspection{
    self = [super init];
    if (self && inspection) {
        self.carcode = inspection.carcode;
        self.classe = inspection.classe;
        self.date_inspection = [self.dateFormatter stringFromDate:inspection.date_inspection];
        self.delivertext = inspection.delivertext;
        self.duty_leader = inspection.duty_leader;
        self.description = inspection.inspection_description;
        self.myid = inspection.inspection_id;
        self.inspection_line = inspection.inspection_line;
        self.inspection_milimetres = inspection.inspection_milimetres.stringValue;
        self.inspection_place = inspection.inspection_place;
        self.inspectionor_name = inspection.inspectionor_name;
        self.isdeliver = inspection.isdeliver.stringValue;
        self.organization_id = inspection.organization_id;
        self.recorder_name = inspection.recorder_name;
        self.remark = inspection.remark;
        self.time_end = [self.dateFormatter stringFromDate:inspection.time_end];
        self.time_start = [self.dateFormatter stringFromDate:inspection.time_start];
        self.weather = inspection.weather;
        self.orgName = inspection.orgname;
        self.jianzheng_address1 = inspection.jianzheng_address1;
        self.jianzheng_address2 = inspection.jianzheng_address2;
        self.jianzheng_name1 = inspection.jianzheng_name1;
        self.jianzheng_name2 = inspection.jianzheng_name2;
        self.jianzheng_tel1 = inspection.jianzheng_tel1;
        self.jianzheng_tel2 = inspection.jianzheng_tel2;
        self.roadsegment_ids = inspection.roadsegment_ids;
        self.isnew = @"1";
        self.isusual = inspection.isusual;
    } else {
        return nil;
    }
    return self;
}

@end
