//
//  CaseProveInfoModel.m
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "CaseProveInfoModel.h"
#import "CaseProveInfo.h"

@implementation CaseProveInfoModel
- (id)initWithCaseProveInfo:(CaseProveInfo *)caseProveInfo{
    self = [super init];
    if (self && caseProveInfo) {
        self.case_short_desc = caseProveInfo.case_short_desc;
        self.prover1 = caseProveInfo.prover1;
        self.prover1_duty = caseProveInfo.prover1_duty;
        self.prover2 = caseProveInfo.prover2;
        self.prover2_duty = caseProveInfo.prover2_duty;
        self.prover_place = caseProveInfo.prover_place;
        self.recorder = caseProveInfo.recorder;
        self.recorder_duty = caseProveInfo.recorder_duty;
        self.invitee = caseProveInfo.invitee;
        self.invitee_org_duty = caseProveInfo.invitee_org_duty;
        self.organizer = caseProveInfo.organizer;
        self.organizer_org_duty = caseProveInfo.organizer_org_duty;
        self.start_date_time = [self.dateFormatter stringFromDate:caseProveInfo.start_date_time];
        self.end_date_time = [self.dateFormatter stringFromDate:caseProveInfo.end_date_time];
        self.party = caseProveInfo.party;
        self.party_sex = caseProveInfo.party_sex;
        self.party_age = caseProveInfo.party_age.stringValue;
        self.party_card = caseProveInfo.party_card;
        self.party_org_duty = caseProveInfo.party_org_duty;
        self.party_address = caseProveInfo.party_address;
        self.party_tel = caseProveInfo.party_tel;
        self.event_desc = caseProveInfo.event_desc;
        self.remark = caseProveInfo.remark;
        self.prover1_code = caseProveInfo.prover1_code;
        self.prover2_code = caseProveInfo.prover2_code;
        self.recorder_code = caseProveInfo.recorder_code;
        self.citizen_name = caseProveInfo.citizen_name;
        self.citizen_sex = caseProveInfo.citizen_sex;
        self.citizen_age = caseProveInfo.citizen_age.stringValue;
        self.citizen_no = caseProveInfo.citizen_no;
        self.citizen_duty = caseProveInfo.citizen_duty;
        self.citizen_address = caseProveInfo.citizen_address;
        self.citizen_tel = caseProveInfo.citizen_tel;
    } else {
        return nil;
    }
    return self;
}
@end
