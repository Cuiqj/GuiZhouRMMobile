//
//  CaseInquire.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DataSynchronizeProtocol.h"

@interface CaseInquire : NSManagedObject <DataSynchronizeProtocol>

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * answerer_name;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * company_duty;
@property (nonatomic, retain) NSString * inquirer_name;
@property (nonatomic, retain) NSString * inquiry_note;
@property (nonatomic, retain) NSString * locality;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * postalcode;
@property (nonatomic, retain) NSString * recorder_name;
@property (nonatomic, retain) NSString * relation;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSDate * date_inquired_start;
@property (nonatomic, retain) NSDate * date_inquired_end;
@property (nonatomic, retain) NSNumber * inquired_times;
@property (nonatomic, retain) NSString * inquirer_name2;
@property (nonatomic, retain) NSString * id_card;
@property (nonatomic, retain) NSString * inquirer1_no;
@property (nonatomic, retain) NSString * inquirer2_no;
@property (nonatomic, retain) NSString * recorder_no;
@property (nonatomic, retain) NSString * inquirer_org;
@property (nonatomic, retain) NSString * edu_level;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * myid;

+ (NSArray *)allInquireForCase:(NSString *)caseID;

+ (CaseInquire *)inquirerForCase:(NSString *)caseID ForID:(NSString *)inquirerID;

@end
