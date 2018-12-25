//
//  CaseInfoModel.m
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "CaseInfoModel.h"
#import "OrgInfo.h"
#import "UserInfo.h"

@implementation CaseInfoModel

- (id)initWithCaseInfo:(CaseInfo *)caseInfo{
    self = [super init];
    if (self && caseInfo) {
        self.case_address = caseInfo.case_address;
        self.case_no = caseInfo.case_mark3;
        self.case_yearno = caseInfo.case_mark2;
        self.case_style = caseInfo.case_style;
        self.myid = caseInfo.caseinfo_id;
        self.happen_date = [self.dateFormatter  stringFromDate:caseInfo.happen_date];
        self.organization_id = caseInfo.organization_id;
        self.place = caseInfo.place;
        self.roadsegment_id = caseInfo.roadsegment_id;
        self.side = caseInfo.side;
        self.station_end = caseInfo.station_end.stringValue;
        self.station_start  = caseInfo.station_start.stringValue;
        NSString *codeString = @"";
        switch (caseInfo.case_process_type.integerValue) {
            case 120:{
                self.casetype = @"行政处罚案件";
                codeString = @"罚";
            }
                break;
            case 130:{
                self.casetype = @"赔（补）偿案件";
                codeString = @"赔";
            }
                break;
            case 140:{
                self.casetype = @"强制措施案件";
                codeString = @"强";
            }
                break;
            default:
                break;
        }
        NSString *caseCodeFormat = [caseInfo caseCodeFormat];
        self.case_code = [NSString stringWithFormat:caseCodeFormat,codeString];
        self.case_reason = caseInfo.case_reason;
        self.weater = caseInfo.weather;
        self.peccancy_type = caseInfo.peccancy_type;
        self.badcar_type = caseInfo.badcar_type;
        self.case_from = caseInfo.case_from;
        self.case_from_department = caseInfo.case_from_department;
        self.case_from_inform = caseInfo.case_from_inform;
        self.case_from_inspection = caseInfo.case_from_inspection;
        self.case_from_other = caseInfo.case_from_other;
        self.case_from_party = caseInfo.case_from_party;
        self.casereason = caseInfo.casereason;
        self.date_casereg = [self.dateFormatter stringFromDate:caseInfo.record_date];
        NSString *username = [[UserInfo userInfoForUserID:caseInfo.initialuser] username];
        self.clerk = username;
        self.recorderName = username;
        self.citizen_name = caseInfo.citizen_name;
    } else {
        return nil;
    }
    return self;
}
@end
