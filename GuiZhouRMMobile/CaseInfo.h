//
//  CaseInfo.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-11-6.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UploadDataProtocol.h"

typedef enum _kGuiZhouRMCaseProcessType {
    kGuiZhouRMCaseProcessTypeFA = 120,
    kGuiZhouRMCaseProcessTypePEI = 130,
    kGuiZhouRMCaseProcessTypeQIANG = 140
} kGuiZhouRMCaseProcessType;

@interface CaseInfo : NSManagedObject<UploadDataProtocol>

@property (nonatomic, retain) NSString * badcar_sum;
@property (nonatomic, retain) NSString * badwound_sum;
@property (nonatomic, retain) NSString * case_address;
@property (nonatomic, retain) NSString * case_mark2;
@property (nonatomic, retain) NSString * case_mark3;
@property (nonatomic, retain) NSNumber * case_process_type;
@property (nonatomic, retain) NSString * case_reason;
@property (nonatomic, retain) NSString * case_style;
@property (nonatomic, retain) NSString * case_type;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * casereason;
@property (nonatomic, retain) NSString * death_sum;
@property (nonatomic, retain) NSString * fleshwound_sum;
@property (nonatomic, retain) NSDate * happen_date;
@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSString * organization_id;
@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) NSString * roadsegment_id;
@property (nonatomic, retain) NSString * side;
@property (nonatomic, retain) NSNumber * station_end;
@property (nonatomic, retain) NSNumber * station_start;
@property (nonatomic, retain) NSString * weather;
@property (nonatomic, retain) NSNumber * yesornotype;
@property (nonatomic, retain) NSDate * record_date;
@property (nonatomic, retain) NSString * citizen_name;
@property (nonatomic, retain) NSString * badcar_type;
@property (nonatomic, retain) NSString * peccancy_type;
@property (nonatomic, retain) NSString * case_from;
@property (nonatomic, retain) NSString * case_from_inspection;
@property (nonatomic, retain) NSString * case_from_party;
@property (nonatomic, retain) NSString * case_from_inform;
@property (nonatomic, retain) NSString * case_from_department;
@property (nonatomic, retain) NSString * case_from_other;
@property (nonatomic, retain) NSString * initialuser;
@property (nonatomic, retain) NSString * file_pre;

//读取案号对应的案件信息记录
+(CaseInfo *)caseInfoForID:(NSString *)caseID;

//删除对应案号的信息记录
+ (void)deleteCaseInfoForID:(NSString *)caseID;

//删除无用的空记录
+ (void)deleteEmptyCaseInfo;

//获取最大的caseMark3数值
+ (NSInteger)maxCaseMark3;

//返回案号格式
- (NSString *)caseCodeFormat;

//返回案号
- (NSString *)caseCodeString;
@end
