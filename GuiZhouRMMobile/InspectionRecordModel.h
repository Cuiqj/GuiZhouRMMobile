//
//  InspectionRecordModel.h
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "UpDataModel.h"
#import "InspectionRecord.h"

@interface InspectionRecordModel : UpDataModel
@property (nonatomic, retain) NSString * end_station;
@property (nonatomic, retain) NSString * end_time;
@property (nonatomic, retain) NSString * inspection_id;
@property (nonatomic, retain) NSString * inspection_item;
@property (nonatomic, retain) NSString * inspection_type;
@property (nonatomic, retain) NSString * isunusual;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * measure;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * roadsegment_id;
@property (nonatomic, retain) NSString * start_station;
@property (nonatomic, retain) NSString * start_time;
@property (nonatomic, retain) NSString * station;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * take_steps;

- (id)initWithInspectionRecord:(InspectionRecord *)record;
@end
