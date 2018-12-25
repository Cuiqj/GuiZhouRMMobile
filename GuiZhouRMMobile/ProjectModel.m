//
//  ProjectModel.m
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "ProjectModel.h"
#import "UserInfo.h"

@implementation ProjectModel
- (id)initWithCaseInfo:(CaseInfo *)caseInfo{
    self = [super init];
    if (self && caseInfo) {
        self.myid = caseInfo.caseinfo_id;
        self.process_id = caseInfo.case_process_type.stringValue;
        switch (caseInfo.case_process_type.integerValue) {
            case 120:
                self.process_name = @"行政处罚案件";
                break;
            case 130:
                self.process_name = @"赔补偿案件";
                break;
            case 140:
                self.process_name = @"强制措施案件";
                break;
            default:
                break;
        }        
        self.inituser_account = [[UserInfo userInfoForUserID:caseInfo.initialuser] account];;
    } else {
        return nil;
    }
    return self;
}
@end
