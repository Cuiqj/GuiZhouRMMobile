//
//  EmployeeInfo.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EmployeeInfo : NSManagedObject

@property (nonatomic, retain) NSString * cardid;
@property (nonatomic, retain) NSString * duty;
@property (nonatomic, retain) NSString * employee_id;
@property (nonatomic, retain) NSString * enforce_code;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * orderdesc;
@property (nonatomic, retain) NSString * organization_id;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * telephone;

+ (EmployeeInfo *)EmployeeInfoForID:(NSString *)employeeID;
+ (NSArray *)allEmployeeInfo;
+ (NSString *)orgAndDutyForUserName:(NSString *)username;
+ (NSString *)enforceCodeForUserName:(NSString *)username;
@end
