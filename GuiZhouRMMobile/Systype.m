//
//  Systype.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-9-10.
//
//

#import "Systype.h"


@implementation Systype

@dynamic sys_code;
@dynamic code_name;
@dynamic type_value;
@dynamic type_code;

+ (NSArray *)typeValueForCodeName:(NSString *)codeName{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    if ([codeName isEqualToString:@"询问笔录模板"]) {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"code_name == %@",codeName]];
        NSMutableArray *tempArray=[[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
        tempArray=[[tempArray valueForKeyPath:@"type_code"] mutableCopy];
        [tempArray removeObject:[NSNull null]];
        return [NSArray arrayWithArray:tempArray];
    }else if ([codeName isEqualToString:@"询问笔录模板回答"]) {
        codeName = [codeName stringByReplacingOccurrencesOfString:@"回答" withString:@""];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"code_name == %@",codeName]];
        NSMutableArray *tempArray=[[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
        tempArray=[[tempArray valueForKeyPath:@"type_value"] mutableCopy];
        [tempArray removeObject:[NSNull null]];
        return [NSArray arrayWithArray:tempArray];
    }
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"code_name == %@",codeName]];
    NSMutableArray *tempArray=[[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    tempArray=[[tempArray valueForKeyPath:@"type_value"] mutableCopy];
    [tempArray removeObject:[NSNull null]];
    [tempArray sortUsingComparator:^NSComparisonResult(id a, id b) {
        return [a localizedCompare:b];
    }];
    return [NSArray arrayWithArray:tempArray];
}

@end
