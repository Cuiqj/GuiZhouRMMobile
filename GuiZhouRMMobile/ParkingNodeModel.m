//
//  ParkingNodeModel.m
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "ParkingNodeModel.h"

@implementation ParkingNodeModel
- (id)initWithParkingNode:(ParkingNode *)parkNode{
    self = [super init];
    if (self && parkNode) {
        self.code = parkNode.code;
        self.yearno = parkNode.yearno;

        self.park_address = parkNode.park_address;
        self.date_start = [self.dateFormatter stringFromDate:parkNode.date_start];
        self.date_end = [self.dateFormatter stringFromDate:parkNode.date_end];
        self.date_send = [self.dateFormatter stringFromDate:parkNode.date_send];
        self.remark = parkNode.remark;
        self.time_stop = parkNode.time_stop;
        self.deal_org = parkNode.deal_org;
        self.deal_org_address = parkNode.deal_org_address;
        self.deal_org_tel = parkNode.deal_org_tel;

        self.deal_org_linkman = parkNode.deal_org_linkman;
        self.unlimited_law_items = parkNode.unlimited_law_items;
        self.unlimited_law_main = parkNode.unlimited_law_main;
        self.reason = parkNode.reason;
        self.linkAddress = parkNode.linkAddress;
        self.linkMan = parkNode.linkMan;
        self.linkTel = parkNode.linkTel;
        self.reject_reason_date = parkNode.reject_reason_date;
        self.belong_org = parkNode.belong_org;
        self.citizen_name = parkNode.citizen_name;
        self.citizen_address = parkNode.citizen_address;
        self.citizen_tel = parkNode.citizen_tel;
        self.citizen_driving_no = parkNode.citizen_driving_no;
        self.citizen_car_property = parkNode.citizen_car_property;
        self.citizen_automobile_trademark = parkNode.citizen_automobile_trademark;
        self.citizen_happen_address = parkNode.citizen_happen_address;
    } else {
        return nil;
    }
    return self;
}
@end
