//
//  CaseDeformationModel.h
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "UpDataModel.h"
#import "CaseDeformation.h"

@interface CaseDeformationModel : UpDataModel
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * parent_id;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * quantity;
@property (nonatomic, retain) NSString * rasset_size;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * roadasset_name;
@property (nonatomic, retain) NSString * total_price;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSString * assetId;

- (id)initWithCaseDeformation:(CaseDeformation *)caseDeformation;
@end
