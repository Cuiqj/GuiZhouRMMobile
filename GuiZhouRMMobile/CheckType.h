//
//  CheckType.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-8-23.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CheckType : NSManagedObject

@property (nonatomic, retain) NSString * checktype_id;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * item;
+(NSArray *)allCheckType;
@end
