//
//  CaseCountModel.m
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-17.
//
//
#import "CaseCountModel.h"

@implementation CaseCountModel

- (id)initWithCaseCount:(CaseCount *)caseCount{
    self = [super init];
    if (self && caseCount) {
        self.caseCountReason = caseCount.caseCountReason;
        self.caseCountRemark = caseCount.caseCountRemark;
        self.caseCountSendDate = [self.dateFormatter stringFromDate:caseCount.caseCountSendDate];
        self.case_citizen_info = caseCount.case_citizen_info;
    } else {
        return nil;
    }
    return self;
}

@end
