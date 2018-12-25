//
//  CaseProveInfo.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-20.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DataSynchronizeProtocol.h"

@interface CaseProveInfo : NSManagedObject <DataSynchronizeProtocol>

@property (nonatomic, retain) NSString * case_short_desc;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * caseproveinfo_id;
@property (nonatomic, retain) NSString * citizen_address;
@property (nonatomic, retain) NSNumber * citizen_age;
@property (nonatomic, retain) NSString * citizen_duty;
@property (nonatomic, retain) NSString * citizen_name;
@property (nonatomic, retain) NSString * citizen_no;
@property (nonatomic, retain) NSString * citizen_sex;
@property (nonatomic, retain) NSString * citizen_tel;
@property (nonatomic, retain) NSDate * end_date_time;
@property (nonatomic, retain) NSString * event_desc;
@property (nonatomic, retain) NSString * invitee;
@property (nonatomic, retain) NSString * invitee_org_duty;
@property (nonatomic, retain) NSString * organizer;
@property (nonatomic, retain) NSString * organizer_org_duty;
@property (nonatomic, retain) NSString * party;
@property (nonatomic, retain) NSString * party_address;
@property (nonatomic, retain) NSNumber * party_age;
@property (nonatomic, retain) NSString * party_card;
@property (nonatomic, retain) NSString * party_org_duty;
@property (nonatomic, retain) NSString * party_sex;
@property (nonatomic, retain) NSString * party_tel;
@property (nonatomic, retain) NSString * prover_place;
@property (nonatomic, retain) NSString * prover1;
@property (nonatomic, retain) NSString * prover1_code;
@property (nonatomic, retain) NSString * prover1_duty;
@property (nonatomic, retain) NSString * prover2;
@property (nonatomic, retain) NSString * prover2_code;
@property (nonatomic, retain) NSString * prover2_duty;
@property (nonatomic, retain) NSString * recorder;
@property (nonatomic, retain) NSString * recorder_duty;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSDate * start_date_time;
@property (nonatomic, retain) NSString * recorder_code;

//读取案号对应的勘验记录
+(CaseProveInfo *)proveInfoForCase:(NSString *)caseID;

@end
