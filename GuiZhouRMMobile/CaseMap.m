//
//  CaseMap.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-4.
//
//

#import "CaseMap.h"


@implementation CaseMap

@dynamic case_code;
@dynamic caseinfo_id;
@dynamic citizen_party;
@dynamic map_path;
@dynamic map_item;
@dynamic isuploaded;

+ (CaseMap *)caseMapForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
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

+ (void)upDateMapInfoForCase:(NSString *)caseID{
    CaseMap *caseMap = [CaseMap caseMapForCase:caseID];
    if (caseMap) {
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
        caseMap.case_code = codeString;
        caseMap.citizen_party = caseInfo.citizen_name;
        [[AppDelegate App] saveContext];
    }
}

#pragma mark - UploadDataProtocol
- (NSString *)dataPredicateString
{
    return [NSString stringWithFormat:@"caseinfo_id == %@", self.caseinfo_id];
}

@end
