//
//  CaseCountModel.h
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-17.
//
//
#import "UpDataModel.h"
#import "CaseCount.h"

@interface CaseCountModel : UpDataModel

@property (nonatomic, retain) NSString * caseCountReason;//案由
@property (nonatomic, retain) NSString * caseCountRemark;//备注
@property (nonatomic, retain) NSString * caseCountSendDate;//发文日期
@property (nonatomic, retain) NSString * case_citizen_info;//案件和当事人信息

- (id)initWithCaseCount:(CaseCount *)caseCount;
@end

