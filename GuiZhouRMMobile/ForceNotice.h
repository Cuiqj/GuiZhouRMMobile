//
//  ForceNotice.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-27.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ForceNotice : NSManagedObject

@property (nonatomic, retain) NSString * basis_law;
@property (nonatomic, retain) NSString * break_law;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * change_action;
@property (nonatomic, retain) NSString * change_limit;
@property (nonatomic, retain) NSString * change_spot;
@property (nonatomic, retain) NSDate * change_time;
@property (nonatomic, retain) NSDate * date_send;
@property (nonatomic, retain) NSString * dsrname;
@property (nonatomic, retain) NSString * fact;
@property (nonatomic, retain) NSDate * handle_time;
@property (nonatomic, retain) NSNumber * isStop;
@property (nonatomic, retain) NSString * linkAddress;
@property (nonatomic, retain) NSString * linkMan;
@property (nonatomic, retain) NSString * linkTel;

//读取案号对应的记录
+(ForceNotice *)forceNoticeForCase:(NSString *)caseID;
+ (ForceNotice *)newForceNoticeForCase:(NSString *)caseID;
@end
