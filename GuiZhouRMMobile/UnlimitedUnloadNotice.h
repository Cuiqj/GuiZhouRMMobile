//
//  UnlimitedUnloadNotice.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-27.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UnlimitedUnloadNotice : NSManagedObject

@property (nonatomic, retain) NSString * ah;
@property (nonatomic, retain) NSString * carNumber;
@property (nonatomic, retain) NSString * dsrname;
@property (nonatomic, retain) NSString * goods;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSDate * limitDate;
@property (nonatomic, retain) NSString * roadName;
@property (nonatomic, retain) NSDate * sendDate;
@property (nonatomic, retain) NSNumber * unlimit;
@property (nonatomic, retain) NSNumber * unload;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * zou;

//读取案号对应的记录
+ (UnlimitedUnloadNotice *)unlimitedUnloadNoticeForCase:(NSString *)caseID;
+ (UnlimitedUnloadNotice *)newUnlimitedUnloadNoticeForCase:(NSString *)caseID;
@end
