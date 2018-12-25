//
//  CaseMap.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-4.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UploadDataProtocol.h"

@interface CaseMap : NSManagedObject <UploadDataProtocol>

@property (nonatomic, retain) NSString * case_code;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * citizen_party;
@property (nonatomic, retain) NSString * map_path;
@property (nonatomic, retain) NSNumber * isuploaded;
@property (nonatomic, retain) NSString * map_item;

+ (CaseMap *)caseMapForCase:(NSString *)caseID;
+ (void)upDateMapInfoForCase:(NSString *)caseID;
@end
