//
//  CaseCountDetailModel.h
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-17.
//
//
#import "UpDataModel.h"
#import "CaseCountDetail.h"

@interface CaseCountDetailModel : UpDataModel

@property (nonatomic, retain) NSString * parent_id;//主表id
@property (nonatomic, retain) NSString * roadasset_name;//路产名称
@property (nonatomic, retain) NSString * rasset_size;//规格
@property (nonatomic, retain) NSString * quantity;//数量
@property (nonatomic, retain) NSString * unit;//单位
@property (nonatomic, retain) NSString * price;//单价
@property (nonatomic, retain) NSString * total_price;//总价
@property (nonatomic, retain) NSString * remark;//备注
@property (nonatomic, retain) NSString * AssetId;//资产id

- (id)initWithCaseCountDetail:(CaseCountDetail *)caseCountDetail;
@end

