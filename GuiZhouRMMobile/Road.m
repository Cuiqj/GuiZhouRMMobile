//
//  Road.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-18.
//
//

#import "Road.h"


@implementation Road

@dynamic code;
@dynamic delflag;
@dynamic road_id;
@dynamic name;
@dynamic place_end;
@dynamic place_start;
@dynamic remark;
@dynamic station_start;
@dynamic station_end;

//根据道路ID返回名称
+ (NSString *)roadNameFromID:(NSString *)roadID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"road_id == %@",roadID]];
    NSArray *temp=[context executeFetchRequest:fetchRequest error:nil];
    if (temp.count>0) {
        id obj=[temp objectAtIndex:0];
//        NSString *code = [[NSString alloc] initWithFormat:@"%@线",[obj valueForKey:@"code"]];
        return [obj name];
    } else {
        return @"";
    }
}

//返回所有的道路数据
+ (NSArray *)allRoads{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:nil];
    return [context executeFetchRequest:fetchRequest error:nil];
}

@end
