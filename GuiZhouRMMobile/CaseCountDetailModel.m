//
//  CaseCountDetailModel.m
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-17.
//
//
#import "CaseCountDetailModel.h"

@implementation CaseCountDetailModel
 
- (id)initWithCaseCountDetail:(CaseCountDetail *)caseCountDetail{
    self = [super init];
    if (self && caseCountDetail) {
        self.parent_id = caseCountDetail.caseinfo_id;
        self.roadasset_name = caseCountDetail.roadasset_name;
        self.rasset_size = caseCountDetail.rasset_size;
        self.quantity = caseCountDetail.quantity.stringValue;
        self.unit = caseCountDetail.unit;
        self.price = caseCountDetail.price.stringValue;
        self.total_price = caseCountDetail.total_price.stringValue;
        self.remark = caseCountDetail.remark;
        self.AssetId = caseCountDetail.assetId;
    } else {
        return nil;
    }
    return self;
}

@end
