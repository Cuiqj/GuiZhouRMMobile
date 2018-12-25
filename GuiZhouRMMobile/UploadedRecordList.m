//
//  UploadedRecordList.m
//  GuiZhouRMMobile
//
//  Created by XU SHIWEN on 13-8-12.
//
//

#import "UploadedRecordList.h"

@implementation UploadedRecordList

@dynamic findStr;
@dynamic tableName;
@dynamic uploadedDate;

+ (UploadedRecordList *)newUploadedRecord
{
    NSManagedObjectContext *context = [[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UploadedRecordList" inManagedObjectContext:context];
    UploadedRecordList *newObject = [[UploadedRecordList alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    return newObject;
}

@end
