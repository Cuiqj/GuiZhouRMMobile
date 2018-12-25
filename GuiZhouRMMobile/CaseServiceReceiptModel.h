//
//  CaseServiceReceiptModel.h
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-17.
//
//
#import "UpDataModel.h"
#import "CaseServiceReceipt.h"

@interface CaseServiceReceiptModel : UpDataModel

@property (nonatomic, retain) NSString * incepter_name;//受送达人
@property (nonatomic, retain) NSString * service_company;//送达单位
@property (nonatomic, retain) NSString * service_position;//送达地点
@property (nonatomic, retain) NSString * help_receiver;//代收人
@property (nonatomic, retain) NSString * send_date;//发送日期
@property (nonatomic, retain) NSString * remark;//备注
@property (nonatomic, retain) NSString * reason;//


- (id)initWithCaseServiceReceipt:(CaseServiceReceipt *)caseServiceReceipt;
@end

