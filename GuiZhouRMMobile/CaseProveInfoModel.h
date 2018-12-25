//
//  CaseProveInfoModel.h
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "UpDataModel.h"
#import "CaseProveInfo.h"

@interface CaseProveInfoModel : UpDataModel
@property (nonatomic, retain) NSString * case_short_desc;//案由
@property (nonatomic, retain) NSString * prover1;//勘查人1
@property (nonatomic, retain) NSString * prover1_duty;//单位及职务
@property (nonatomic, retain) NSString * prover2;//勘查人2
@property (nonatomic, retain) NSString * prover2_duty;//单位及职务
@property (nonatomic, retain) NSString * prover_place;//勘验场所
@property (nonatomic, retain) NSString * recorder;//勘察记录人
@property (nonatomic, retain) NSString * recorder_duty;//单位及职务
@property (nonatomic, retain) NSString * invitee;//被邀请人
@property (nonatomic, retain) NSString * invitee_org_duty;//被邀请人单位及职务
@property (nonatomic, retain) NSString * organizer;//组织者
@property (nonatomic, retain) NSString * organizer_org_duty;//组织代表单位及职务
@property (nonatomic, retain) NSString * start_date_time;//勘验开始时间
@property (nonatomic, retain) NSString * end_date_time;//勘验结束时间
@property (nonatomic, retain) NSString * party;//当事人（代理人）
@property (nonatomic, retain) NSString * party_sex;//性别
@property (nonatomic, retain) NSString * party_age;//年龄
@property (nonatomic, retain) NSString * party_card;//身份证号
@property (nonatomic, retain) NSString * party_org_duty;//单位及职务
@property (nonatomic, retain) NSString * party_address;//地址
@property (nonatomic, retain) NSString * party_tel;//联系电话
@property (nonatomic, retain) NSString * event_desc;//事件简况及现场描述
@property (nonatomic, retain) NSString * sketch;//现场草图
@property (nonatomic, retain) NSString * register_reason;//立案依据
@property (nonatomic, retain) NSString * prover_opinion;//承办人意见
@property (nonatomic, retain) NSString * prover_sign;//签名
@property (nonatomic, retain) NSString * prover_sign_date;//签名时间
@property (nonatomic, retain) NSString * principal_opinion;//负责人审批意见
@property (nonatomic, retain) NSString * principal_sign;//负责人签名
@property (nonatomic, retain) NSString * principal_sign_date;//负责人签名日期
@property (nonatomic, retain) NSString * remark;//备注
@property (nonatomic, retain) NSString * maintain_notice_id;//维修通知单编号
@property (nonatomic, retain) NSString * scrap_time;//取回残值限期
@property (nonatomic, retain) NSString * scrap_address;//取回残值地点
@property (nonatomic, retain) NSString * scrap_date;//残值告知书发送日期
@property (nonatomic, retain) NSString * maker;//制单人
@property (nonatomic, retain) NSString * investigater;//审核人
@property (nonatomic, retain) NSString * comment;//当事人意见
@property (nonatomic, retain) NSString * shootDate;//现场照片拍摄日期
@property (nonatomic, retain) NSString * prover1_code;//执法证号1
@property (nonatomic, retain) NSString * prover2_code;//执法证号2
@property (nonatomic, retain) NSString * recorder_code;//执法证号（记录人）
@property (nonatomic, retain) NSString * citizen_name;//当事人
@property (nonatomic, retain) NSString * citizen_sex;//性别
@property (nonatomic, retain) NSString * citizen_age;//年龄
@property (nonatomic, retain) NSString * citizen_no;//身份证号
@property (nonatomic, retain) NSString * citizen_duty;//单位及职务
@property (nonatomic, retain) NSString * citizen_address;//住址
@property (nonatomic, retain) NSString * citizen_tel;//联系电话

- (id)initWithCaseProveInfo:(CaseProveInfo *)caseProveInfo;

@end
