//
//  CitizenModel.h
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "UpDataModel.h"
#import "Citizen.h"

@interface CitizenModel : UpDataModel

@property (nonatomic, retain) NSString * parent_id;//案件id
@property (nonatomic, retain) NSString * patry_type;//当事人类型(当事人与车主的关系)
@property (nonatomic, retain) NSString * party;//当事人名称（）
@property (nonatomic, retain) NSString * citizen_flag;//当事人性质（单位/个人）
@property (nonatomic, retain) NSString * sex;//性别
@property (nonatomic, retain) NSString * legal_spokesman;//法定代表人
@property (nonatomic, retain) NSString * age;//年龄
@property (nonatomic, retain) NSString * nation;//民族
@property (nonatomic, retain) NSString * original_home;//籍贯
@property (nonatomic, retain) NSString * tel_number;//联系电话
@property (nonatomic, retain) NSString * postalcode;//邮政编码
@property (nonatomic, retain) NSString * address;//所在地址
@property (nonatomic, retain) NSString * profession;//职业
@property (nonatomic, retain) NSString * duty;//职务
@property (nonatomic, retain) NSString * org_name;//所属机构名称
@property (nonatomic, retain) NSString * org_address;//单位地址
@property (nonatomic, retain) NSString * org_tel_number;//所属机构电话
@property (nonatomic, retain) NSString * org_principal;//所属机构法人
@property (nonatomic, retain) NSString * org_principal_tel_number;//所属机构法人电话
@property (nonatomic, retain) NSString * org_principal_duty;//机构法人职务
@property (nonatomic, retain) NSString * driver;//驾驶员名称
@property (nonatomic, retain) NSString * automobile_pattern;//车型
@property (nonatomic, retain) NSString * automobile_number;//车号
@property (nonatomic, retain) NSString * automobile_address;//车辆所在地
@property (nonatomic, retain) NSString * automobile_owner;//车主姓名
@property (nonatomic, retain) NSString * automobile_owner_address;//车主地址
@property (nonatomic, retain) NSString * automobile_owner_flag;//车主性质（单位/个人）
@property (nonatomic, retain) NSString * nationality;//国籍
@property (nonatomic, retain) NSString * identity_card;//身份证号
@property (nonatomic, retain) NSString * card_no;//驾驶证号码
@property (nonatomic, retain) NSString * organizer_desc;//组织代表
@property (nonatomic, retain) NSString * remark;//其它信息
@property (nonatomic, retain) NSString * proxyman;//代理人
@property (nonatomic, retain) NSString * proxysex;//代理人性别
@property (nonatomic, retain) NSString * proxyage;//代理人年龄
@property (nonatomic, retain) NSString * proxytel;//代理人电话
@property (nonatomic, retain) NSString * proxyaddress;//代理人地址
@property (nonatomic, retain) NSString * proxyunit;//代理人单位
@property (nonatomic, retain) NSString * proxyidentity;//代理人身份证
@property (nonatomic, retain) NSString * driver_relation;//与车辆所有人关系
@property (nonatomic, retain) NSString * driver_tel;//驾驶员电话
@property (nonatomic, retain) NSString * driver_address;//驾驶员住址
@property (nonatomic, retain) NSString * automobile_trademark;//车辆品牌

- (id)initWithCitizen:(Citizen *)citizen;
@end
