//
//  AtonementNoticeModel.h
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-17.
//
//
#import "UpDataModel.h"
#import "AtonementNotice.h"

@interface AtonementNoticeModel : UpDataModel

@property (nonatomic, retain) NSString * code;//字号
@property (nonatomic, retain) NSString * date_send;//下达日期
@property (nonatomic, retain) NSString * check_organization;//复核单位
@property (nonatomic, retain) NSString * case_desc;//案件详细信息
@property (nonatomic, retain) NSString * witness;//所附证据
@property (nonatomic, retain) NSString * pay_reason;//赔偿原因
@property (nonatomic, retain) NSString * pay_mode;//赔补偿方式
@property (nonatomic, retain) NSString * pay_bank;//交款银行
@property (nonatomic, retain) NSString * pay_real;//实际索赔金额
@property (nonatomic, retain) NSString * layyiju;//法律依据
@property (nonatomic, retain) NSString * layweifan;//违反法规
@property (nonatomic, retain) NSString * remark;//备注
@property (nonatomic, retain) NSString * law_zhan;//占（利）用标准第几项
@property (nonatomic, retain) NSString * law_pei;//赔（补）偿标准第几项
@property (nonatomic, retain) NSString * atonementreason;//案由（赔补偿）
@property (nonatomic, retain) NSString * linkAddress;//许可单位地址
@property (nonatomic, retain) NSString * linkMan;//联系人
@property (nonatomic, retain) NSString * linkTel;//联系电话
@property (nonatomic, retain) NSString * CaseDeformationSendDate;//路损清单发文日期
@property (nonatomic, retain) NSString * fixed_legal;//

- (id)initWithAtonementNotice:(AtonementNotice *)atonementNotice;
@end

