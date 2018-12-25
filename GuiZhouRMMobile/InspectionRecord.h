//
//  InspectionRecord.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-8-23.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InspectionRecord : NSManagedObject

@property (nonatomic, retain) NSString * inspection_id;
@property (nonatomic, retain) NSString * inspection_type;
@property (nonatomic, retain) NSString * inspection_item;
@property (nonatomic, retain) NSString * roadsegment_id;
@property (nonatomic, retain) NSNumber * station;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * measure;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSDate * start_time;
@property (nonatomic, retain) NSString * fix;
@property (nonatomic, retain) NSString * relationid;
@property (nonatomic, retain) NSString * relationType;

+ (NSArray *)recordsForInspection:(NSString *)inspectionID;
+(InspectionRecord *)caseInfoForID:(NSString *)caseID;
+ (NSInteger)recordsCountForInspection:(NSString *)inspectionID;
@end
