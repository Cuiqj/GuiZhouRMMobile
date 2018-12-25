//
//  InspectionRecordNormalModel.h
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "UpDataModel.h"
#import "InspectionRecordNormal.h"

@interface InspectionRecordNormalModel : UpDataModel
@property (nonatomic, retain) NSString * end_station;
@property (nonatomic, retain) NSString * end_time;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * inspection_id;
@property (nonatomic, retain) NSString * roadsegment_id;
@property (nonatomic, retain) NSString * roadsegment_name;
@property (nonatomic, retain) NSString * start_station;
@property (nonatomic, retain) NSString * start_time;

- (id)initWithInspectionRecordNormal:(InspectionRecordNormal *)normal;
@end
