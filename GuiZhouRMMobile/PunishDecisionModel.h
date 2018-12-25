//
//  PunishDecisionModel.h
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-17.
//
//
#import "UpDataModel.h"
#import "PunishDecision.h"

@interface PunishDecisionModel : UpDataModel

@property (nonatomic, retain) NSString * proveinfo_id;//案件编号
@property (nonatomic, retain) NSString * code;//文号
@property (nonatomic, retain) NSString * organization;//交款银行
@property (nonatomic, retain) NSString * account_number;//账号
@property (nonatomic, retain) NSString * send_date;//下达日期
@property (nonatomic, retain) NSString * case_desc;//违法事实及依据
@property (nonatomic, retain) NSString * law_disobey;//违反法律条文
@property (nonatomic, retain) NSString * law_gist;//依据法律条文
@property (nonatomic, retain) NSString * remark;//备注
@property (nonatomic, retain) NSString * punish_decision;//处罚决定
@property (nonatomic, retain) NSString * recheck_org1;//复议单位1
@property (nonatomic, retain) NSString * recheck_org2;//复议单位2
@property (nonatomic, retain) NSString * punish_sum;//处罚金额
@property (nonatomic, retain) NSString * citizen_id;//当事人编号
@property (nonatomic, retain) NSString * immediately;//是否当场处罚(是否)
@property (nonatomic, retain) NSString * unload_num;//卸载货物数量
@property (nonatomic, retain) NSString * stop_address;//责令停驶地点
@property (nonatomic, retain) NSString * punish_org_link_man;//处罚机关联系人
@property (nonatomic, retain) NSString * punish_org_link_address;//处罚机关联系地址
@property (nonatomic, retain) NSString * caseobject_number;//物件保存记录
@property (nonatomic, retain) NSString * witness;//证据材料
@property (nonatomic, retain) NSString * punish_other;//其它处罚方式
@property (nonatomic, retain) NSString * punish_org_link_tel;//处罚机关联系电话
@property (nonatomic, retain) NSString * court;//起诉法院
@property (nonatomic, retain) NSString * punishreason;//案由（处罚决定）
@property (nonatomic, retain) NSString * enforceORG;//
@property (nonatomic, retain) NSString * dsrname;//

- (id)initWithPunishDecision:(PunishDecision *)punishDecision;
@end

