//
//  CaseLaySet.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-4.
//
//

#import "CaseLaySet.h"
#import "CaseInfo.h"


@implementation CaseLaySet

@dynamic case_reson;
@dynamic yiju;
@dynamic weifan;
@dynamic casetype;


// 案件法律依据
+ (NSString *) getLayYiJuForCase:(NSString *)caseID{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:caseID];
    NSString *result = @"";
    NSString *case_reason = caseInfo.casereason;
    if ([case_reason isEmpty]) {
        return result;
    } else {
        case_reason = [case_reason stringByReplacingOccurrencesOfString:@"涉嫌" withString:@""];
        case_reason = [case_reason stringByTrimmingTrailingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"案"]];
        case_reason = [[NSString alloc] initWithFormat:@"；%@；",case_reason];

        NSManagedObjectContext *context = [[AppDelegate App] managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        NSPredicate *predicate = nil;
        
        
        NSString *caseType;
        switch (caseInfo.case_process_type.integerValue) {
            case 120:
                caseType = @"案由（处罚）";
                break;
            case 130:
                caseType = @"案由（赔补偿）";
                break;
            case 140:
                caseType = @"案由（强制）";
                break;
            default:
                break;
        }
        predicate = [NSPredicate predicateWithFormat:@"casetype == %@",caseType];
        
        [fetchRequest setPredicate:predicate];
        NSArray *layArray = [context executeFetchRequest:fetchRequest error:nil];
        if (layArray.count > 0) {
            for (CaseLaySet *laySet in layArray) {
                NSString *lay_reason = laySet.case_reson;
                lay_reason = [[NSString alloc] initWithFormat:@"；%@；",lay_reason];
                // 匹配成功
                if ([case_reason rangeOfString:lay_reason].location != NSNotFound) {
                    result = [result stringByAppendingFormat:@"%@、",laySet.yiju];
                }
            }
        }
        if (![result isEmpty]) {
            result = [result stringByTrimmingTrailingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"、"]];
        }
        return result;
    }
}

// 案件违反法律
+ (NSString *) getLayWeiFanForCase:(NSString *)caseID{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:caseID];
    NSString *result = @"";
    NSString *case_reason = caseInfo.casereason;

    if ([case_reason isEmpty]) {
        return result;
    } else {
        case_reason = [case_reason stringByReplacingOccurrencesOfString:@"涉嫌" withString:@""];
        case_reason = [case_reason stringByTrimmingTrailingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"案"]];
        case_reason = [[NSString alloc] initWithFormat:@"；%@；",case_reason];
        
        NSManagedObjectContext *context = [[AppDelegate App] managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        NSPredicate *predicate = nil;
        
        
         NSString *caseType;
         switch (caseInfo.case_process_type.integerValue) {
         case 120:
         caseType = @"案由（处罚）";
         break;
         case 130:
         caseType = @"案由（赔补偿）";
         break;
         case 140:
         caseType = @"案由（强制）";
         break;
         default:
         break;
         }
         predicate = [NSPredicate predicateWithFormat:@"casetype == %@",caseType];
        
        
        [fetchRequest setPredicate:predicate];
        NSArray *layArray = [context executeFetchRequest:fetchRequest error:nil];
        if (layArray.count > 0) {
            for (CaseLaySet *laySet in layArray) {
                NSString *lay_reason = laySet.case_reson;
                lay_reason = [[NSString alloc] initWithFormat:@"；%@；",lay_reason];
                // 匹配成功
                if ([case_reason rangeOfString:lay_reason].location != NSNotFound) {
                    result = [result stringByAppendingFormat:@"%@、",laySet.weifan];
                }
            }
        }

        if (![result isEmpty]) {
            result = [result stringByTrimmingTrailingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"、"]];
        }
        return result;
    }
}
@end
