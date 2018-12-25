//
//  Citizen.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-6.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Citizen : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * automobile_address;
@property (nonatomic, retain) NSString * automobile_number;
@property (nonatomic, retain) NSString * automobile_owner;
@property (nonatomic, retain) NSString * automobile_pattern;
@property (nonatomic, retain) NSString * card_no;
@property (nonatomic, retain) NSString * driver;
@property (nonatomic, retain) NSString * nation;
@property (nonatomic, retain) NSString * nationality;
@property (nonatomic, retain) NSString * org_name;
@property (nonatomic, retain) NSString * org_principal;
@property (nonatomic, retain) NSString * org_principal_duty;
@property (nonatomic, retain) NSString * org_principal_tel_number;
@property (nonatomic, retain) NSString * org_tel_number;
@property (nonatomic, retain) NSString * original_home;
@property (nonatomic, retain) NSString * party;
@property (nonatomic, retain) NSString * party_type;
@property (nonatomic, retain) NSString * postalcode;
@property (nonatomic, retain) NSString * profession;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * tel_number;
@property (nonatomic, retain) NSString * citizen_flag;
@property (nonatomic, retain) NSString * legal_spokesman;
@property (nonatomic, retain) NSString * automobile_owner_address;
@property (nonatomic, retain) NSString * automobile_owner_flag;
@property (nonatomic, retain) NSString * automobile_trademark;
@property (nonatomic, retain) NSString * driver_address;
@property (nonatomic, retain) NSString * driver_relation;
@property (nonatomic, retain) NSString * driver_tel;
@property (nonatomic, retain) NSString * duty;
@property (nonatomic, retain) NSString * identity_card;
@property (nonatomic, retain) NSString * org_address;
@property (nonatomic, retain) NSString * organizer_desc;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * proxyaddress;
@property (nonatomic, retain) NSNumber * proxyage;
@property (nonatomic, retain) NSString * proxyidentity;
@property (nonatomic, retain) NSString * proxyman;
@property (nonatomic, retain) NSString * proxysex;
@property (nonatomic, retain) NSString * proxytel;
@property (nonatomic, retain) NSString * proxyunit;

+ (Citizen *)citizenForCase:(NSString *)caseID;

- (NSString *)companyAndDutyString;
+ (Citizen *)citizenForCitizenName:(NSString *)name nexus:(NSString *)nexus case:(NSString *)caseID;
@end
