//
//  AtonementNotice.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DataSynchronizeProtocol.h"

@interface AtonementNotice : NSManagedObject <DataSynchronizeProtocol>

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSDate * date_send;
@property (nonatomic, retain) NSString * case_desc;
@property (nonatomic, retain) NSString * witness;
@property (nonatomic, retain) NSString * pay_reason;
@property (nonatomic, retain) NSString * pay_mode;
@property (nonatomic, retain) NSString * pay_bank;
@property (nonatomic, retain) NSNumber * pay_real;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * law_zhan;
@property (nonatomic, retain) NSString * law_pei;
@property (nonatomic, retain) NSString * atonementreason;
@property (nonatomic, retain) NSString * linkAddress;
@property (nonatomic, retain) NSString * linkMan;
@property (nonatomic, retain) NSString * linkTel;
@property (nonatomic, retain) NSDate * caseDeformationSendDate;
@property (nonatomic, retain) NSString * fixed_legal;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * layweifan;
@property (nonatomic, retain) NSString * layyiju;

+(AtonementNotice *)atonementNoticeForCase:(NSString *)caseID;
+(AtonementNotice *)newAtonementNoticeForCase:(NSString *)caseID;
@end
