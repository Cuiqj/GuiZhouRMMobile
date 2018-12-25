//
//  PunishDecisionModel.m
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-17.
//
//
#import "PunishDecisionModel.h"

@implementation PunishDecisionModel

- (id)initWithPunishDecision:(PunishDecision *)punishdecision{
    self = [super init];
    if (self && punishdecision) {
        self.proveinfo_id = punishdecision.caseinfo_id;
        self.code = punishdecision.code;
        self.organization = punishdecision.organization;
        self.account_number = punishdecision.account_number;
        self.send_date = [self.dateFormatter stringFromDate:punishdecision.send_date];
        self.case_desc = punishdecision.case_desc;
        self.law_disobey = punishdecision.law_disobey;
        self.law_gist = punishdecision.law_gist;
        self.remark = punishdecision.remark;
        self.punish_decision = punishdecision.punish_decision;
        self.recheck_org1 = punishdecision.recheck_org1;
        self.recheck_org2 = punishdecision.recheck_org2;
        self.punish_sum = punishdecision.punish_sum.stringValue;
        self.citizen_id = punishdecision.citizen_id;
        self.immediately = punishdecision.immediately;

        self.unload_num = punishdecision.unload_num.stringValue;
        self.stop_address = punishdecision.stop_address;
        self.punish_org_link_man = punishdecision.punish_org_link_man;
        self.punish_org_link_address = punishdecision.punish_org_link_address;
        self.caseobject_number = punishdecision.caseobject_number;
        self.witness = punishdecision.witness;
        self.punish_other = punishdecision.punish_other;
        self.punish_org_link_tel = punishdecision.punish_org_link_tel;
        self.court = punishdecision.court;
        self.punishreason = punishdecision.punishreason;
        self.enforceORG = punishdecision.enforceORG;
        self.dsrname = punishdecision.dsrname;
    } else {
        return nil;
    }
    return self;
}

@end
