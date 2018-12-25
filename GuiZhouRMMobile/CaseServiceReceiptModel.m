//
//  CaseServiceReceiptModel.m
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-17.
//
//
#import "CaseServiceReceiptModel.h"

@implementation CaseServiceReceiptModel

- (id)initWithCaseServiceReceipt:(CaseServiceReceipt *)caseServiceReceipt{
    self = [super init];
    if (self && caseServiceReceipt) {
        self.incepter_name = caseServiceReceipt.incepter_name;
        self.service_company = caseServiceReceipt.service_company;
        self.service_position = caseServiceReceipt.service_position;
        self.help_receiver = caseServiceReceipt.help_receiver;
        self.send_date = [self.dateFormatter stringFromDate:caseServiceReceipt.send_date];
        self.remark = caseServiceReceipt.remark;
        self.reason = caseServiceReceipt.reason;
    } else {
        return nil;
    }
    return self;
}

@end
