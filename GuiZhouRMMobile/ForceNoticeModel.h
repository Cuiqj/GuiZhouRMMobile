//
//  ForceNoticeModel.h
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-17.
//
//
#import "UpDataModel.h"
#import "ForceNotice.h"

@interface ForceNoticeModel : UpDataModel

@property (nonatomic, retain) NSString * fact;//违法事实
@property (nonatomic, retain) NSString * break_law;//违反法律
@property (nonatomic, retain) NSString * basis_law;//依据法律
@property (nonatomic, retain) NSString * change_spot;//第几项需立刻改正
@property (nonatomic, retain) NSString * change_limit;//第几项需限期改正
@property (nonatomic, retain) NSString * change_time;//改正期限
@property (nonatomic, retain) NSString * change_action;//改正内容和要求
@property (nonatomic, retain) NSString * handle_time;//到本机关接受处理限期
@property (nonatomic, retain) NSString * date_send;//发文日期
@property (nonatomic, retain) NSString * linkAddress;//执法机构地址
@property (nonatomic, retain) NSString * linkMan;//联系人
@property (nonatomic, retain) NSString * linkTel;//联系电话
@property (nonatomic, retain) NSString * dsrname;//

- (id)initWithForceNotice:(ForceNotice *)ForceNotice;
@end

