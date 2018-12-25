//
//  CaseServiceReceipt.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DataSynchronizeProtocol.h"

@interface CaseServiceReceipt : NSManagedObject <DataSynchronizeProtocol>

@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * help_receiver;
@property (nonatomic, retain) NSString * incepter_name;
@property (nonatomic, retain) NSString * reason;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSDate * send_date;
@property (nonatomic, retain) NSString * service_company;
@property (nonatomic, retain) NSString * service_position;

+ (CaseServiceReceipt *)caseServiceReceiptForCase:(NSString *)caseID;
+ (CaseServiceReceipt *)newCaseServiceReceiptForCase:(NSString *)caseID;
@end
