//
//  CaseDeformationModel.m
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "CaseDeformationModel.h"

@implementation CaseDeformationModel
- (id)initWithCaseDeformation:(CaseDeformation *)caseDeformation{
    self = [super init];
    if (self && caseDeformation) {
        self.assetId = caseDeformation.assetId;
        self.parent_id = caseDeformation.caseinfo_id;
        self.price = caseDeformation.price.stringValue;
        self.quantity = caseDeformation.quantity.stringValue;
        self.rasset_size = caseDeformation.rasset_size;
        self.remark = caseDeformation.remark;
        self.roadasset_name = caseDeformation.roadasset_name;
        self.total_price = caseDeformation.total_price.stringValue;
        self.unit = caseDeformation.unit;
    } else {
        return nil;
    }
    return self;
}
@end
