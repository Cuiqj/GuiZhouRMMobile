//
//  CheckItemDetails.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-9-7.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CheckItemDetails : NSManagedObject

@property (nonatomic, retain) NSString * checkitem_id;
@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSNumber * theindex;
@property (nonatomic, retain) NSString * remark;

+ (NSArray *)detailsForItem:(NSString *)checkItemID;
@end
