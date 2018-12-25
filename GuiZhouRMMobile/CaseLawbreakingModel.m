//
//  CaseLawbreakingModel.m
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-17.
//
//
#import "CaseLawbreakingModel.h"

@implementation CaseLawbreakingModel

- (id)initWithCaseLawbreaking:(CaseLawBreaking *)caseLawBreaking{
    self = [super init];
    if (self && caseLawBreaking) {
        self.code = caseLawBreaking.code;
        self.date_appeal = [self.dateFormatter stringFromDate:caseLawBreaking.date_appeal];
        self.date_send = [self.dateFormatter stringFromDate:caseLawBreaking.date_send];
        self.linkman = caseLawBreaking.linkman;
        self.flag = caseLawBreaking.flag.stringValue;
        self.remark = caseLawBreaking.remark;
        self.fact = caseLawBreaking.fact;
        self.punish_mode = caseLawBreaking.punish_mode;
        self.punish_reason = caseLawBreaking.punish_reason;
        self.punish_org = caseLawBreaking.punish_org;
        self.link_phone = caseLawBreaking.link_phone;
        self.link_addr = caseLawBreaking.link_addr;
        self.law_disobey = caseLawBreaking.law_disobey;
        self.law_gist = caseLawBreaking.law_gist;
        self.citizen_right = caseLawBreaking.citizen_right.stringValue;
        self.citizen_id = caseLawBreaking.citizen_id;
        self.postcode = caseLawBreaking.postcode;
        self.witness = caseLawBreaking.witness;
        self.punish_other = caseLawBreaking.punish_other;
        self.flag_StatePlea = caseLawBreaking.flag_StatePlea;
        self.flag_Listen = caseLawBreaking.flag_Listen;
        self.lawbreakingreason = caseLawBreaking.lawbreakingreason;
    } else {
        return nil;
    }
    return self;
}

@end
