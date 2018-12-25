//
//  CaseInfo.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-11-6.
//
//

#import "CaseInfo.h"
#import "OrgInfo.h"

@implementation CaseInfo

@dynamic badcar_sum;
@dynamic badwound_sum;
@dynamic case_address;
@dynamic case_mark2;
@dynamic case_mark3;
@dynamic case_process_type;
@dynamic case_reason;
@dynamic case_style;
@dynamic case_type;
@dynamic caseinfo_id;
@dynamic casereason;
@dynamic death_sum;
@dynamic fleshwound_sum;
@dynamic happen_date;
@dynamic isuploaded;
@dynamic organization_id;
@dynamic place;
@dynamic roadsegment_id;
@dynamic side;
@dynamic station_end;
@dynamic station_start;
@dynamic weather;
@dynamic yesornotype;
@dynamic record_date;
@dynamic citizen_name;
@dynamic badcar_type;
@dynamic peccancy_type;
@dynamic case_from;
@dynamic case_from_inspection;
@dynamic case_from_party;
@dynamic case_from_inform;
@dynamic case_from_department;
@dynamic case_from_other;
@dynamic initialuser;
@dynamic file_pre;

//读取案号对应的案件信息记录
+(CaseInfo *)caseInfoForID:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseInfo" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@",caseID];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    NSArray *fetchResult=[context executeFetchRequest:fetchRequest error:nil];
    if (fetchResult.count>0) {
        return [fetchResult objectAtIndex:0];
    } else {
        return nil;
    }
}

//删除对应案号的信息记录
+ (void)deleteCaseInfoForID:(NSString *)caseID{
    //根据案号删除对应表数据
    void(^deleteInfoForEntity)(NSString *) = ^(NSString *entityName){
        NSManagedObjectContext *context = [[AppDelegate App] managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        [request setPredicate:[NSPredicate predicateWithFormat:@"caseinfo_id == %@",caseID]];
        NSArray *fetchResult=[context executeFetchRequest:request error:nil];
        if (fetchResult.count>0) {
            for (NSManagedObject *tableInfo in fetchResult) {
                [context deleteObject:tableInfo];
            }
        }
        [[AppDelegate App] saveContext];
    };
    NSArray *tableArray = @[ @"CaseInfo", @"CaseProveInfo", @"Citizen", @"CaseDeformation", @"CaseInquire", @"ParkingNode", @"CaseDocuments", @"CasePhoto", @"CaseMap", @"AtonementNotice"];
    for (NSString *entityName in tableArray) {
        deleteInfoForEntity(entityName);
    }
    
    //根据案号删除对应文件夹
    NSFileManager *manager=[NSFileManager defaultManager];
    NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath=[pathArray objectAtIndex:0];
    NSString *photoPath=[NSString stringWithFormat:@"CasePhoto/%@",caseID];
    photoPath=[documentPath stringByAppendingPathComponent:photoPath];
    if ([manager fileExistsAtPath:photoPath]) {
        [manager removeItemAtPath:photoPath error:nil];
    }
    NSString *docPath=[NSString stringWithFormat:@"CaseDoc/%@",caseID];
    docPath=[documentPath stringByAppendingPathComponent:docPath];
    if ([manager fileExistsAtPath:docPath]) {
        [manager removeItemAtPath:docPath error:nil];
    }
    NSString *mapPath=[NSString stringWithFormat:@"CaseMap/%@",caseID];
    mapPath=[documentPath stringByAppendingPathComponent:mapPath];
    if ([manager fileExistsAtPath:mapPath]) {
        [manager removeItemAtPath:mapPath error:nil];
    }
}

//删除无用的空记录
+ (void)deleteEmptyCaseInfo{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseInfo" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"case_mark2 == nil || case_mark3 == nil"];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    NSArray *fetchResult=[context executeFetchRequest:fetchRequest error:nil];
    for (id obj in fetchResult) {
        [context deleteObject:obj];
    }
    [context save:nil];
}

+ (NSInteger)maxCaseMark3{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseInfo" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"organization_id == %@",[[NSUserDefaults standardUserDefaults] stringForKey:ORGKEY]]];
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"case_mark3"];
    NSExpression *maxCaseMark3Expression = [NSExpression expressionForFunction:@"max:"
                                                                  arguments:[NSArray arrayWithObject:keyPathExpression]];
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"maxCase_mark3"];
    [expressionDescription setExpression:maxCaseMark3Expression];
    [expressionDescription setExpressionResultType:NSInteger32AttributeType];
    [request setPropertiesToFetch:@[expressionDescription]];
    [request setResultType:NSDictionaryResultType];
    NSArray *objects = [context executeFetchRequest:request error:nil];
    if (objects.count > 0) {
        return [[[objects objectAtIndex:0] valueForKey:@"maxCase_mark3"] integerValue];
    } else {
        return 0;
    }
}

- (NSString *)caseCodeFormat{
    NSString *filePre = self.file_pre ? [self.file_pre copy]:@"";
    filePre = [filePre stringByAppendingString:@"%@"];
    filePre = [filePre stringByAppendingFormat:@"[%@]%@号",self.case_mark2,self.case_mark3];
    return filePre;
}

- (NSString *)caseCodeString
{
    NSString *processTypeString = nil;
    if (self.case_process_type.integerValue == kGuiZhouRMCaseProcessTypePEI) {
         processTypeString = @"赔";
    } else if (self.case_process_type.integerValue == kGuiZhouRMCaseProcessTypeFA) {
        processTypeString = @"罚";
    } else if (self.case_process_type.integerValue == kGuiZhouRMCaseProcessTypeQIANG) {
        processTypeString = @"强";
    }
    return [NSString stringWithFormat:@"%@%@[%@]%@号",
            self.file_pre,
            processTypeString,
            self.case_mark2,
            self.case_mark3];
}

#pragma mark - UploadDataProtocol

- (NSString *)dataPredicateString
{
    return [NSString stringWithFormat:@"caseinfo_id == %@", self.caseinfo_id];
}

@end
