//
//  CaseLawbreakingModel.h
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-17.
//
//
#import "UpDataModel.h"
#import "CaseLawbreaking.h"

@interface CaseLawbreakingModel : UpDataModel

@property (nonatomic, retain) NSString * code;//违字好
@property (nonatomic, retain) NSString * date_appeal;//调查处理时间
@property (nonatomic, retain) NSString * date_send;//下达日期
@property (nonatomic, retain) NSString * linkman;//联系人
@property (nonatomic, retain) NSString * flag;//是否责令当事人停止违法行为[(0/1)]
@property (nonatomic, retain) NSString * remark;//备注
@property (nonatomic, retain) NSString * fact;//违法事实
@property (nonatomic, retain) NSString * punish_mode;//处罚方式
@property (nonatomic, retain) NSString * punish_reason;//处罚依据
@property (nonatomic, retain) NSString * punish_org;//处罚机关
@property (nonatomic, retain) NSString * link_phone;//处罚机关联系电话
@property (nonatomic, retain) NSString * link_addr;//处罚机关联系地址
@property (nonatomic, retain) NSString * law_disobey;//违反法律
@property (nonatomic, retain) NSString * law_gist;//依据法律
@property (nonatomic, retain) NSString * citizen_right;//公民权利( 1：听证/ 0：申辩）
@property (nonatomic, retain) NSString * citizen_id;//当事人编号
@property (nonatomic, retain) NSString * postcode;//邮编
@property (nonatomic, retain) NSString * witness;//证据材料
@property (nonatomic, retain) NSString * punish_sum;//罚款金额
@property (nonatomic, retain) NSString * punish_other;//其它处罚
@property (nonatomic, retain) NSString * flag_StatePlea;//是否有陈述、申辩权利
@property (nonatomic, retain) NSString * flag_Listen;//是否有要求组织听证权利
@property (nonatomic, retain) NSString * lawbreakingreason;//案由

- (id)initWithCaseLawbreaking:(CaseLawBreaking *)caseLawBreaking;
@end

