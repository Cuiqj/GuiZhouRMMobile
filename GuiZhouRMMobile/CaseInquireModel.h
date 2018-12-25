//
//  CaseInquireModel.h
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "UpDataModel.h"
#import "CaseInquire.h"

@interface CaseInquireModel : UpDataModel
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * age;
@property (nonatomic, retain) NSString * answerer_name;
@property (nonatomic, retain) NSString * company_duty;
@property (nonatomic, retain) NSString * date_inquired_end;
@property (nonatomic, retain) NSString * date_inquired_start;
@property (nonatomic, retain) NSString * edu_level;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * id_card;
@property (nonatomic, retain) NSString * inquired_times;
@property (nonatomic, retain) NSString * inquirer1_no;
@property (nonatomic, retain) NSString * inquirer2_no;
@property (nonatomic, retain) NSString * inquirer_name;
@property (nonatomic, retain) NSString * inquirer_name2;
@property (nonatomic, retain) NSString * inquirer_org;
@property (nonatomic, retain) NSString * inquiry_note;
@property (nonatomic, retain) NSString * locality;
@property (nonatomic, retain) NSString * parent_id;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * postalcode;
@property (nonatomic, retain) NSString * recorder_name;
@property (nonatomic, retain) NSString * recorder_no;
@property (nonatomic, retain) NSString * relation;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * sex;

- (id)initWithCaseInquire:(CaseInquire *)caseInquire;

@end
