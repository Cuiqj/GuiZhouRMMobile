//
//  OrgInfo.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OrgInfo : NSManagedObject

@property (nonatomic, retain) NSString * belongtoid;
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * orderdesc;
@property (nonatomic, retain) NSString * orgname;
@property (nonatomic, retain) NSString * orgshortname;
@property (nonatomic, retain) NSString * principal;
@property (nonatomic, retain) NSString * linkman;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * faxnumber;
@property (nonatomic, retain) NSString * postcode;
@property (nonatomic, retain) NSString * orgtype;
@property (nonatomic, retain) NSString * defaultuserid;
@property (nonatomic, retain) NSString * file_pre;
@property (nonatomic, retain) NSString * org_jc;
@property (nonatomic, retain) NSString * jzFlag;

+ (OrgInfo *)orgInfoForOrgID:(NSString *)orgID;
+ (NSArray *)allOrgInfo;

@end
