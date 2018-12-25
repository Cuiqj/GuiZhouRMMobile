//
//  InspectionRecordNormal.h
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-28.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InspectionRecordNormal : NSManagedObject

@property (nonatomic, retain) NSString * inspection_id;
@property (nonatomic, retain) NSString * roadsegment_id;
@property (nonatomic, retain) NSString * roadsegment_name;
@property (nonatomic, retain) NSNumber * start_station;
@property (nonatomic, retain) NSNumber * end_station;
@property (nonatomic, retain) NSDate * start_time;
@property (nonatomic, retain) NSDate * end_time;

+ (NSArray *)normalsForInspection:(NSString *)inspectionID;
@end
