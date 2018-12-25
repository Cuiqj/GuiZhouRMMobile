//
//  CaseSampleDetailModel.m
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-17.
//
//
#import "CaseSampleDetailModel.h"

@implementation CaseSampleDetailModel

- (id)initWithCaseSampleDetail:(CaseSampleDetail *)caseSampleDetail{
    self = [super init];
    if (self && caseSampleDetail) {
        self.name = caseSampleDetail.name;
        self.spec = caseSampleDetail.spec;
        self.quantity = caseSampleDetail.quantity.stringValue;
        self.unit = caseSampleDetail.unit;
        self.description = caseSampleDetail.description_text;
        self.remark = caseSampleDetail.remark;
        self.object_address = caseSampleDetail.object_address;
    } else {
        return nil;
    }
    return self;
}

@end
