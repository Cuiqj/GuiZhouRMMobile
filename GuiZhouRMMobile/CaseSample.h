//
//  CaseSample.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-27.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DataSynchronizeProtocol.h"

@interface CaseSample : NSManagedObject <DataSynchronizeProtocol>

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * case_sample_reason;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSDate * date_sample_end;
@property (nonatomic, retain) NSDate * date_sample_start;
@property (nonatomic, retain) NSString * legal_person;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * person_incharge;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) NSString * postalcode;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSDate * send_date;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * taking_company;
@property (nonatomic, retain) NSString * taking_company_tel;
@property (nonatomic, retain) NSString * taking_names;
@property (nonatomic, retain) NSString * taking_postalcode;

//读取案号对应的记录
+(CaseSample *)caseSampleForCase:(NSString *)caseID;
+ (CaseSample *)newCaseSampleForCase:(NSString *)caseID;
@end
