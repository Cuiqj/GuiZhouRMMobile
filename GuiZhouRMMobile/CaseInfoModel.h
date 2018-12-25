//
//  CaseInfoModel.h
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "UpDataModel.h"
#import "CaseInfo.h"

@interface CaseInfoModel : UpDataModel

@property (nonatomic, retain) NSString * case_address;
@property (nonatomic, retain) NSString * case_code;
@property (nonatomic, retain) NSString * case_from;
@property (nonatomic, retain) NSString * case_from_department;
@property (nonatomic, retain) NSString * case_from_inform;
@property (nonatomic, retain) NSString * case_from_inspection;
@property (nonatomic, retain) NSString * case_from_other;
@property (nonatomic, retain) NSString * case_from_party;
@property (nonatomic, retain) NSString * case_yearno;
@property (nonatomic, retain) NSString * case_no;
@property (nonatomic, retain) NSString * casereason;
@property (nonatomic, retain) NSString * casetype;
@property (nonatomic, retain) NSString * case_style;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * happen_date;
@property (nonatomic, retain) NSString * organization_id;
@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) NSString * roadsegment_id;
@property (nonatomic, retain) NSString * side;
@property (nonatomic, retain) NSString * station_end;
@property (nonatomic, retain) NSString * station_start;
@property (nonatomic, retain) NSString * weater;
@property (nonatomic, retain) NSString * peccancy_type;
@property (nonatomic, retain) NSString * badcar_type;
@property (nonatomic, retain) NSString * case_reason;
@property (nonatomic, retain) NSString * citizen_name;
@property (nonatomic, retain) NSString * clerk;
@property (nonatomic, retain) NSString * recorderName;
@property (nonatomic, retain) NSString * date_casereg;
- (id)initWithCaseInfo:(CaseInfo *)caseInfo;

@end
