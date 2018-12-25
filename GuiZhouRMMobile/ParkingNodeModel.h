//
//  ParkingNodeModel.h
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "UpDataModel.h"
#import "ParkingNode.h"

@interface ParkingNodeModel : UpDataModel
@property (nonatomic, retain) NSString * code;//流水号
@property (nonatomic, retain) NSString * yearno;//年号
@property (nonatomic, retain) NSString * parkno;//顺序号
@property (nonatomic, retain) NSString * park_address;//停车地点
@property (nonatomic, retain) NSString * date_start;//停车时间
@property (nonatomic, retain) NSString * date_end;//停驶结束时间
@property (nonatomic, retain) NSString * date_send;//下达日期
@property (nonatomic, retain) NSString * remark;//备注
@property (nonatomic, retain) NSString * time_stop;//停驶期限
@property (nonatomic, retain) NSString * deal_org;//处理机构
@property (nonatomic, retain) NSString * deal_org_address;//处理机构地址
@property (nonatomic, retain) NSString * deal_org_tel;//处理机构联系电话
@property (nonatomic, retain) NSString * recheck_org;//复议机构
@property (nonatomic, retain) NSString * recheck_detail;//具体政府或交通局
@property (nonatomic, retain) NSString * court;//法院
@property (nonatomic, retain) NSString * externals;//车辆外观状况
@property (nonatomic, retain) NSString * damage_place;//损坏位置
@property (nonatomic, retain) NSString * deal_org_linkman;//处理机构联系人
@property (nonatomic, retain) NSString * unlimited_law_items;//违反法律
@property (nonatomic, retain) NSString * unlimited_law_main;//违反法律详细内容
@property (nonatomic, retain) NSString * reason;//责令停驶原因
@property (nonatomic, retain) NSString * linkAddress;//执法机构地址
@property (nonatomic, retain) NSString * linkMan;//联系人
@property (nonatomic, retain) NSString * linkTel;//联系电话
@property (nonatomic, retain) NSString * reject_reason_date;//拒收事由、日期
@property (nonatomic, retain) NSString * belong_org;//车辆所属单位
@property (nonatomic, retain) NSString * citizen_name;//当事人姓名
@property (nonatomic, retain) NSString * citizen_address;//当事人住址
@property (nonatomic, retain) NSString * citizen_tel;//当事人联系电话
@property (nonatomic, retain) NSString * citizen_driving_no;//当事人驾驶证号
@property (nonatomic, retain) NSString * citizen_car_property;//车牌号或机具名称
@property (nonatomic, retain) NSString * citizen_automobile_trademark;//厂牌型号
@property (nonatomic, retain) NSString * citizen_happen_address;//案发地点


- (id)initWithParkingNode:(ParkingNode *)parkNode;
@end
