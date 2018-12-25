//
//  UnlimitedUnloadNoticeModel.h
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-17.
//
//
#import "UpDataModel.h"
#import "UnlimitedUnloadNotice.h"

@interface UnlimitedUnloadNoticeModel : UpDataModel

@property (nonatomic, retain) NSString * roadName;//路线名
@property (nonatomic, retain) NSString * carNumber;//车牌号
@property (nonatomic, retain) NSString * zou;//轴数
@property (nonatomic, retain) NSString * goods;//运输货物
@property (nonatomic, retain) NSString * weight;//车货总重（吨）
@property (nonatomic, retain) NSString * unlimit;//超限（吨）
@property (nonatomic, retain) NSString * unload;//责令卸载（吨）
@property (nonatomic, retain) NSString * sendDate;//发文日期
@property (nonatomic, retain) NSString * limitDate;//自行卸载限定日期
@property (nonatomic, retain) NSString * dsrname;//
@property (nonatomic, retain) NSString * ah;//

- (id)initWithUnlimitedUnloadNotice:(UnlimitedUnloadNotice *)unlimitedUnloadNotice;
@end

