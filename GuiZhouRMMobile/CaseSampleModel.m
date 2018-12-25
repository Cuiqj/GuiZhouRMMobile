//
//  CaseSampleModel.m
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-17.
//
//
#import "CaseSampleModel.h"

@implementation CaseSampleModel

- (id)initWithCaseSample:(CaseSample *)caseSample{
    self = [super init];
    if (self && caseSample) {
        self.name = caseSample.name;
        self.legal_person = caseSample.legal_person;
        self.sex = caseSample.sex;
        self.age = caseSample.age.stringValue;
        self.phone = caseSample.phone;
        self.postalcode = caseSample.postalcode;
        self.address = caseSample.address;
        self.date_sample_start = [self.dateFormatter stringFromDate:caseSample.date_sample_start];
        self.date_sample_end = [self.dateFormatter stringFromDate:caseSample.date_sample_end];
        self.place = caseSample.place;
        self.remark = caseSample.remark;
        self.taking_names = caseSample.taking_names;
        self.taking_company = caseSample.taking_company;
        self.taking_postalcode = caseSample.taking_postalcode;
        self.person_incharge = caseSample.person_incharge;
        self.taking_company_tel = caseSample.taking_company_tel;
        self.send_date = [self.dateFormatter stringFromDate:caseSample.send_date];
        self.case_sample_reason = caseSample.case_sample_reason;
    } else {
        return nil;
    }
    return self;
}

@end
