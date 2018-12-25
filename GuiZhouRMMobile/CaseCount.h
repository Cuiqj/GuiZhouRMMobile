//
//  CaseCount.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-28.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DataSynchronizeProtocol.h"

@interface CaseCount : NSManagedObject <DataSynchronizeProtocol>

@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * caseCountReason;
@property (nonatomic, retain) NSString * caseCountRemark;
@property (nonatomic, retain) NSDate * caseCountSendDate;
@property (nonatomic, retain) NSString * case_citizen_info;

//读取案号对应的记录
+ (CaseCount *)caseCountForCase:(NSString *)caseID;
+ (CaseCount *)newCaseCountForCase:(NSString *)caseID;
@end
