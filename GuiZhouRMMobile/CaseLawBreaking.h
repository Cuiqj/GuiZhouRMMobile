//
//  CaseLawBreaking.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-27.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CaseLawBreaking : NSManagedObject

@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * citizen_id;
@property (nonatomic, retain) NSNumber * citizen_right;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSDate * date_appeal;
@property (nonatomic, retain) NSDate * date_send;
@property (nonatomic, retain) NSString * fact;
@property (nonatomic, retain) NSNumber * flag;
@property (nonatomic, retain) NSString * flag_Listen;
@property (nonatomic, retain) NSString * flag_StatePlea;
@property (nonatomic, retain) NSString * law_disobey;
@property (nonatomic, retain) NSString * law_gist;
@property (nonatomic, retain) NSString * lawbreakingreason;
@property (nonatomic, retain) NSString * link_addr;
@property (nonatomic, retain) NSString * link_phone;
@property (nonatomic, retain) NSString * linkman;
@property (nonatomic, retain) NSString * postcode;
@property (nonatomic, retain) NSString * punish_mode;
@property (nonatomic, retain) NSString * punish_org;
@property (nonatomic, retain) NSString * punish_other;
@property (nonatomic, retain) NSString * punish_reason;
@property (nonatomic, retain) NSString * punish_sum;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * witness;
+(CaseLawBreaking *)caseLawBreakingForCase:(NSString *)caseID;
+ (CaseLawBreaking *)newCaseLawBreakingForCase:(NSString *)caseID;
@end
