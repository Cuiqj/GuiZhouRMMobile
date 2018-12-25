//
//  CaseSampleDetailModel.h
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-17.
//
//
#import "UpDataModel.h"
#import "CaseSampleDetail.h"

@interface CaseSampleDetailModel : UpDataModel

@property (nonatomic, retain) NSString * parent_id;//主表id
@property (nonatomic, retain) NSString * name;//证据名称
@property (nonatomic, retain) NSString * spec;//规格
@property (nonatomic, retain) NSString * quantity;//数量
@property (nonatomic, retain) NSString * unit;//单位
@property (nonatomic, retain) NSString * description;//描述
@property (nonatomic, retain) NSString * remark;//备注
@property (nonatomic, retain) NSString * object_address;//被抽样物品存放地点

- (id)initWithCaseSampleDetail:(CaseSampleDetail *)caseSampleDetail;
@end

