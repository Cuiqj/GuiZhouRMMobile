//
//  CheckItems.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-9-7.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CheckItems : NSManagedObject

@property (nonatomic, retain) NSString * checkitem_id;
@property (nonatomic, retain) NSString * checktext;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSNumber * checktype;

+ (NSArray *)allCheckItemsForType:(NSInteger)checkType;
@end
