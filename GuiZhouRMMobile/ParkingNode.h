//
//  ParkingNode.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ParkingNode : NSManagedObject

@property (nonatomic, retain) NSString * belong_org;
@property (nonatomic, retain) NSString * citizen_address;
@property (nonatomic, retain) NSString * citizen_automobile_trademark;
@property (nonatomic, retain) NSString * citizen_car_property;
@property (nonatomic, retain) NSString * citizen_driving_no;
@property (nonatomic, retain) NSString * citizen_happen_address;
@property (nonatomic, retain) NSString * citizen_name;
@property (nonatomic, retain) NSString * citizen_tel;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSDate * date_end;
@property (nonatomic, retain) NSDate * date_send;
@property (nonatomic, retain) NSDate * date_start;
@property (nonatomic, retain) NSString * deal_org;
@property (nonatomic, retain) NSString * deal_org_address;
@property (nonatomic, retain) NSString * deal_org_linkman;
@property (nonatomic, retain) NSString * deal_org_tel;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * linkAddress;
@property (nonatomic, retain) NSString * linkMan;
@property (nonatomic, retain) NSString * linkTel;
@property (nonatomic, retain) NSString * park_address;
@property (nonatomic, retain) NSString * reason;
@property (nonatomic, retain) NSString * reject_reason_date;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * parkno;
@property (nonatomic, retain) NSString * yearno;
@property (nonatomic, retain) NSString * time_stop;
@property (nonatomic, retain) NSString * unlimited_law_items;
@property (nonatomic, retain) NSString * unlimited_law_main;


+ (ParkingNode *)parkingNodeForCase:(NSString *)caseID;
+ (void)deleteAllParkingNodeForCase:(NSString *)caseID;

@end
