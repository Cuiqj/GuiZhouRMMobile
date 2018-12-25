//
//  UploadedDataManager.h
//  GuiZhouRMMobile
//
//  Created by XU SHIWEN on 13-8-12.
//
//

#import <Foundation/Foundation.h>

@interface UploadedDataManager : NSObject
- (void)addUploadedRecord:(NSString*)tableName withFindStr:(NSString *)findStr;
- (void)writeToDB;
- (void)getUploadedRecords:(int)count;
- (void)removeExpireRecord:(NSArray*)fileList;
- (void)asyncDel;
@end
