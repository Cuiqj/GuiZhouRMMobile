//
//  CaseServiceFilesModel.h
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-17.
//
//
#import "UpDataModel.h"
#import "CaseServiceFiles.h"

@interface CaseServiceFilesModel : UpDataModel

@property (nonatomic, retain) NSString * parent_id;//主表id
@property (nonatomic, retain) NSString * service_file;//送达文书名称
@property (nonatomic, retain) NSString * servicer_name;//送达人
@property (nonatomic, retain) NSString * servicer_name2;//送达人2
@property (nonatomic, retain) NSString * receipt_date;//收到日期
@property (nonatomic, retain) NSString * receipter_name;//收件人
@property (nonatomic, retain) NSString * send_address;//送达地点
@property (nonatomic, retain) NSString * send_way;//送达方式
@property (nonatomic, retain) NSString * remark;//备注
@property (nonatomic, retain) NSString * reason;//

- (id)initWithCaseServiceFiles:(CaseServiceFiles *)caseServiceFiles;
@end

