//
//  CaseInquireModel.m
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "CaseInquireModel.h"

@implementation CaseInquireModel

- (id)initWithCaseInquire:(CaseInquire *)caseInquire{
    self = [super init];
    if (self && caseInquire) {
        self.address = caseInquire.address;
        self.age = caseInquire.age.stringValue;
        self.answerer_name = caseInquire.answerer_name;
        self.company_duty = caseInquire.company_duty;
        self.date_inquired_end = [self.dateFormatter stringFromDate:caseInquire.date_inquired_end];
        self.date_inquired_start = [self.dateFormatter  stringFromDate:caseInquire.date_inquired_start];
        self.edu_level= caseInquire.edu_level;
        self.parent_id = caseInquire.caseinfo_id;
        self.inquired_times = caseInquire.inquired_times.stringValue;
        self.inquirer1_no = caseInquire.inquirer1_no;
        self.inquirer2_no = caseInquire.inquirer2_no;
        self.inquirer_name = caseInquire.inquirer_name;
        self.inquirer_name2 = caseInquire.inquirer_name2;
        self.inquirer_org = caseInquire.inquirer_org;
        self.inquiry_note = caseInquire.inquiry_note;
        self.locality = caseInquire.locality;
        self.phone = caseInquire.phone;
        self.postalcode = caseInquire.postalcode;
        self.recorder_name = caseInquire.recorder_name;
        self.recorder_no = caseInquire.recorder_no;
        self.relation = caseInquire.relation;
        self.remark = caseInquire.remark;
        self.sex = caseInquire.sex;
        self.id_card = caseInquire.id_card;
    } else {
        return nil;
    }
    return self;
}
@end
