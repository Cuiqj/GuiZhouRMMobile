//
//  Inspection.h
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-28.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UploadDataProtocol.h"

@interface Inspection : NSManagedObject <UploadDataProtocol>

@property (nonatomic, retain) NSString * carcode;
@property (nonatomic, retain) NSString * classe;
@property (nonatomic, retain) NSDate * date_inspection;
@property (nonatomic, retain) NSString * delivertext;
@property (nonatomic, retain) NSString * duty_leader;
@property (nonatomic, retain) NSString * inspection_description;
@property (nonatomic, retain) NSString * inspection_id;
@property (nonatomic, retain) NSString * inspection_line;
@property (nonatomic, retain) NSNumber * inspection_milimetres;
@property (nonatomic, retain) NSString * inspection_place;
@property (nonatomic, retain) NSString * inspectionor_name;
@property (nonatomic, retain) NSNumber * isdeliver;
@property (nonatomic, retain) NSString * isusual;
@property (nonatomic, retain) NSString * organization_id;
@property (nonatomic, retain) NSString * recorder_name;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSDate * time_end;
@property (nonatomic, retain) NSDate * time_start;
@property (nonatomic, retain) NSString * weather;
@property (nonatomic, retain) NSString * orgname;
@property (nonatomic, retain) NSString * jianzheng_name1;
@property (nonatomic, retain) NSString * jianzheng_address1;
@property (nonatomic, retain) NSString * jianzheng_tel1;
@property (nonatomic, retain) NSString * jianzheng_name2;
@property (nonatomic, retain) NSString * jianzheng_address2;
@property (nonatomic, retain) NSString * jianzheng_tel2;
@property (nonatomic, retain) NSString * roadsegment_ids;
@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSDate * record_date;

+ (NSArray *)inspectionForID:(NSString *)inspectionID;

+ (void)deleteInspectionForID:(NSString *)inspectionID;
@end
