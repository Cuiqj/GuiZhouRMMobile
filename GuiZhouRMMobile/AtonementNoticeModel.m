//
//  AtonementNoticeModel.m
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-17.
//
//
#import "AtonementNoticeModel.h"

@implementation AtonementNoticeModel

- (id)initWithAtonementNotice:(AtonementNotice *)atonementNotice{
    self = [super init];
    if (self && atonementNotice) {
        self.code = atonementNotice.code;
        self.date_send = [self.dateFormatter stringFromDate:atonementNotice.date_send];
        self.case_desc = atonementNotice.case_desc;
        self.witness = atonementNotice.witness;
        self.pay_reason = atonementNotice.pay_reason;

        self.pay_bank = atonementNotice.pay_bank;
        self.pay_real = atonementNotice.pay_real.stringValue;
        self.layyiju = atonementNotice.layyiju;
        self.layweifan = atonementNotice.layweifan;
        self.remark = atonementNotice.remark;
        self.law_zhan = atonementNotice.law_zhan;
        self.law_pei = atonementNotice.law_pei;
        self.atonementreason = atonementNotice.atonementreason;
        self.linkAddress = atonementNotice.linkAddress;
        self.linkMan = atonementNotice.linkMan;
        self.linkTel = atonementNotice.linkTel;
        self.CaseDeformationSendDate = [self.dateFormatter stringFromDate:atonementNotice.caseDeformationSendDate];
        self.fixed_legal = atonementNotice.fixed_legal;
    } else {
        return nil;
    }
    return self;
}

@end
