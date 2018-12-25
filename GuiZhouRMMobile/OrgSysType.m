//
//  OrgSysType.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-18.
//
//

#import "OrgSysType.h"


@implementation OrgSysType

@dynamic code_name;
@dynamic type_value;
@dynamic remark;

+ (NSArray *)typeValueForCodeName:(NSString *)codeName{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"code_name == %@",codeName]];
    NSMutableArray *tempArray=[[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    tempArray=[[tempArray valueForKeyPath:@"type_value"] mutableCopy];
    [tempArray removeObject:[NSNull null]];
    return [NSArray arrayWithArray:tempArray];
}
@end
