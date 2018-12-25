//
//  CaseServiceFiles.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CaseInfo.h"

extern NSString * const CaseServiceFilesDefaultSendWay;

@interface CaseServiceFiles : NSManagedObject

@property (nonatomic, retain) NSDate * receipt_date;
@property (nonatomic, retain) NSString * repeiptername;
@property (nonatomic, retain) NSString * service_file;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * servicer_name;
@property (nonatomic, retain) NSString * reason;
@property (nonatomic, retain) NSString * servicer_name2;
@property (nonatomic, retain) NSString * send_way;
@property (nonatomic, retain) NSString * send_address;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * receipter_name;

//读取案号对应的记录
+(NSArray *)caseServiceFilesForCase:(NSString *)caseID;
+ (CaseServiceFiles *)newCaseServiceFilesForID:(NSString *)caseID;
+ (NSArray *)serviceFilesForProcessType:(kGuiZhouRMCaseProcessType)processType andYesOrNoType:(BOOL)YesOrNoType;

@end


