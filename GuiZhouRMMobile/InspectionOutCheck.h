//
//  InspectionOutCheck.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-9-12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InspectionOutCheck : NSManagedObject

@property (nonatomic, retain) NSString * inspection_id;
@property (nonatomic, retain) NSString * checktext;
@property (nonatomic, retain) NSString * checkresult;
@property (nonatomic, retain) NSString * remark;

+ (NSArray *)outChecksForInspection:(NSString *)inspectionID;
@end
