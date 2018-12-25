//
//  UploadedDataManager.m
//  GuiZhouRMMobile
//
//  Created by XU SHIWEN on 13-8-12.
//
//

#import "UploadedDataManager.h"
#import "UploadedRecordList.h"

@interface UploadedDataManager()
@property (nonatomic,strong) NSMutableArray* tempUploadedRecordArray;
@end

@implementation UploadedDataManager

- (NSMutableArray *)tempUploadedRecordArray
{
    if (_tempUploadedRecordArray == nil) {
        _tempUploadedRecordArray = [NSMutableArray array];
    }
    return _tempUploadedRecordArray;
}

#pragma mark - Methods About Managing Uploaded Data
- (void)addUploadedRecord:(NSString*)tableName withFindStr:(NSString *)findStr
{
    if (tableName != nil && ![tableName isEmpty] &&
        findStr != nil && ![findStr isEmpty]) {
        NSMutableDictionary *content = [NSMutableDictionary dictionary];
        [content setObject:tableName forKey:@"tableName"];
        [content setObject:findStr forKey:@"findStr"];
        [self.tempUploadedRecordArray addObject:content];
        NSLog(@"UploadedDataManager: added[ tableName:%@, findStr:%@ ]", tableName, findStr);
    }
}

- (void)writeToDB
{
    NSManagedObjectContext* managedObjectContext = [[AppDelegate App] managedObjectContext];
    NSError* error;
    for(NSDictionary* config in self.tempUploadedRecordArray)
    {
        UploadedRecordList* rec = [UploadedRecordList newUploadedRecord];
        rec.tableName = [config objectForKey:@"tableName"];
        rec.findStr = [config objectForKey:@"findStr"];
        rec.uploadedDate = [NSDate date];
        [managedObjectContext save:&error];
    }
    if (error == nil) {
        self.tempUploadedRecordArray = nil;
    }
}

- (void)asyncDel{
    //    dispatch_queue_t myqueue=dispatch_queue_create("DelOldUploadedData", nil);
    //    dispatch_async(myqueue, ^(void){
    [self getUploadedRecords:10];
    //    });
    //    dispatch_release(myqueue);
}

- (void)getUploadedRecords:(int)count
{
    NSError* error;
    NSManagedObjectContext* managedObjectContext = [[AppDelegate App] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UploadedRecordList" inManagedObjectContext:managedObjectContext];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"uploadedDate < %@", [NSDate dateWithTimeIntervalSinceNow:-secondsPerDay*30]];
    [request setEntity:entity];
    [request setPredicate:predicate];
    request.fetchLimit = count;
    NSArray* fileList = [managedObjectContext executeFetchRequest:request error:&error];
    NSLog(@"UploadedDataManager: %d records to remove.", fileList.count);
    [self removeExpireRecord:fileList];
}

- (void)removeExpireRecord:(NSArray*)fileList
{
    NSManagedObjectContext* managedObjectContext = [[AppDelegate App] managedObjectContext];
    for(UploadedRecordList* rec in fileList){
        if(rec){
            NSEntityDescription *entity = [NSEntityDescription entityForName:rec.tableName inManagedObjectContext:managedObjectContext];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            NSPredicate *predicate=[NSPredicate predicateWithFormat:rec.findStr];
            [request setEntity:entity];
            [request setPredicate:predicate];
            NSArray *result=[managedObjectContext executeFetchRequest:request error:nil];
            if (result && [result count]>0) {
                for (NSManagedObject *obj in result) {
                    [managedObjectContext deleteObject:obj];
                    NSLog(@"UploadedDataManager: removed[ %@ ]", obj);
                }
            }
            [managedObjectContext deleteObject:rec];
        }
    }
    NSError* error;
    [managedObjectContext save:&error];
}

@end
