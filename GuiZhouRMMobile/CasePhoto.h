//
//  CasePhoto.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-4.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UploadDataProtocol.h"

@interface CasePhoto : NSManagedObject <UploadDataProtocol>

@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * photo_name;
@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSString * case_code;
@property (nonatomic, retain) NSString * citizen_party;

+(NSArray *)casePhotosForCase:(NSString *)caseID;
//修改照片所有案件信息
+(void)upDatePhotoInfoForCase:(NSString *)caseID;

+(void)deletePhotoForCase:(NSString *)caseID photoName:(NSString *)photoName;
@end
