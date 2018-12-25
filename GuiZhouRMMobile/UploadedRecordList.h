//
//  UploadedRecordList.h
//  GuiZhouRMMobile
//
//  Created by XU SHIWEN on 13-8-12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UploadedRecordList : NSManagedObject

@property (nonatomic, retain) NSString * findStr;
@property (nonatomic, retain) NSString * tableName;
@property (nonatomic, retain) NSDate * uploadedDate;

+ (UploadedRecordList *)newUploadedRecord;

@end
