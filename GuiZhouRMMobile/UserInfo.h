//
//  UserInfo.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-26.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSString * employee_id;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * orgid;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * isadmin;

+ (UserInfo *)userInfoForUserID:(NSString *)userID;

+ (NSArray *)allUserInfo;
@end
