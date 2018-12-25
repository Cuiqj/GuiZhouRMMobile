//
//  CasePhoto.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-4.
//
//

#import "CasePhoto.h"
#import "CaseInfo.h"
#import "OrgInfo.h"

@implementation CasePhoto

@dynamic caseinfo_id;
@dynamic photo_name;
@dynamic isuploaded;
@dynamic case_code;
@dynamic citizen_party;

+ (NSArray *)casePhotosForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CasePhoto" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id == %@",caseID];
    fetchRequest.predicate=predicate;
    return [context executeFetchRequest:fetchRequest error:nil];
}

+ (void)upDatePhotoInfoForCase:(NSString *)caseID{
    NSArray *photoArray = [CasePhoto casePhotosForCase:caseID];
    for (CasePhoto *casePhoto in photoArray) {
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:caseID];
        NSString *codeString = @"";
        switch (caseInfo.case_process_type.integerValue) {
            case 120:
                codeString = @"罚";
                break;
            case 130:
                codeString = @"赔";
                break;
            case 140:
                codeString = @"强";
                break;
            default:
                break;
        }        
        NSString *caseCodeFormat = [caseInfo caseCodeFormat];
        codeString = [[NSString alloc] initWithFormat:caseCodeFormat,codeString];
        casePhoto.case_code = codeString;
        casePhoto.citizen_party = caseInfo.citizen_name;

        [[AppDelegate App] saveContext];
    }
}

+ (void)deletePhotoForCase:(NSString *)caseID photoName:(NSString *)photoName{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CasePhoto" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id == %@ && photo_name == %@",caseID,photoName];
    fetchRequest.predicate=predicate;
    NSArray *temp = [context executeFetchRequest:fetchRequest error:nil];
    for (NSManagedObject *obj in temp) {
        [context deleteObject:obj];
    }
    [[AppDelegate App] saveContext];
}

#pragma mark - UploadDataProtocol
- (NSString *)dataPredicateString
{
    return [NSString stringWithFormat:@"caseinfo_id == %@", self.caseinfo_id];
}

@end
