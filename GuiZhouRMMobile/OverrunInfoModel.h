//
//  OverrunInfoModel.h
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-25.
//
//
#import "UpDataModel.h"
#import "UnlimitedUnloadNoticeModel.h"

@interface OverrunInfoModel : UpDataModel

@property (nonatomic, retain) NSString * goods_name;//货物名称
@property (nonatomic, retain) NSString * goods_num;//货物大小
@property (nonatomic, retain) NSString * carsallweight;//车货总重
@property (nonatomic, retain) NSString * overlimit;//超过限制数
@property (nonatomic, retain) NSString * roadid;//运输路线
@property (nonatomic, retain) NSString * stationstart;//运输起点
@property (nonatomic, retain) NSString * stationend;//运输终点
@property (nonatomic, retain) NSString * zhoushu;//车辆轴数
@property (nonatomic, retain) NSString * hezai;//车辆核载
@property (nonatomic, retain) NSString * weifalicheng;//违法行驶里程
@property (nonatomic, retain) NSString * zhiliangchaoxian;//质量超限（吨）
@property (nonatomic, retain) NSString * chicunchaogao;//尺寸超高(米) 
@property (nonatomic, retain) NSString * chicunchaokuan;//尺寸超宽(米) 
@property (nonatomic, retain) NSString * send_date;//发文时间
@property (nonatomic, retain) NSString * parent_id;//
@property (nonatomic, retain) NSString * remark;//
@property (nonatomic, retain) NSString * caseinfo_id;

- (id)initWithOverrunInfo:(UnlimitedUnloadNoticeModel *)unlimitedUnloadNoticeModel;
@end

