//
//  OrgSysType.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OrgSysType : NSManagedObject

@property (nonatomic, retain) NSString * code_name;
@property (nonatomic, retain) NSString * type_value;
@property (nonatomic, retain) NSString * remark;

+ (NSArray *)typeValueForCodeName:(NSString *)codeName;

@end
