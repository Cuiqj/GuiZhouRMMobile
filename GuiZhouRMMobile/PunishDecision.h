//
//  PunishDecision.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-27.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PunishDecision : NSManagedObject

@property (nonatomic, retain) NSString * account_number;
@property (nonatomic, retain) NSString * case_desc;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * caseobject_number;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * court;
@property (nonatomic, retain) NSString * dsrname;
@property (nonatomic, retain) NSString * enforceORG;
@property (nonatomic, retain) NSString * immediately;
@property (nonatomic, retain) NSString * law_disobey;
@property (nonatomic, retain) NSString * law_gist;
@property (nonatomic, retain) NSString * organization;
@property (nonatomic, retain) NSString * punish_decision;
@property (nonatomic, retain) NSString * punish_org_link_address;
@property (nonatomic, retain) NSString * punish_org_link_man;
@property (nonatomic, retain) NSString * punish_org_link_tel;
@property (nonatomic, retain) NSString * punish_other;
@property (nonatomic, retain) NSNumber * punish_sum;
@property (nonatomic, retain) NSString * punishreason;
@property (nonatomic, retain) NSString * recheck_org1;
@property (nonatomic, retain) NSString * recheck_org2;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSDate * send_date;
@property (nonatomic, retain) NSString * stop_address;
@property (nonatomic, retain) NSNumber * unload_num;
@property (nonatomic, retain) NSString * witness;
@property (nonatomic, retain) NSString * citizen_id;

//读取案号对应的记录
+(PunishDecision *)punishDecisionForCase:(NSString *)caseID;
+ (PunishDecision *)newPunishDecisionForCase:(NSString *)caseID;
@end
