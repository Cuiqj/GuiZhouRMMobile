//
//  RoadAssetPrice.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-23.
//
//

#import "RoadAssetPrice.h"

NSString * const RoadAssetPriceStandardAllStandards = @"所有标准";

@implementation RoadAssetPrice

@dynamic big_type;
@dynamic damage_type;
@dynamic depart_num;
@dynamic name;
@dynamic price;
@dynamic remark;
@dynamic roadasset_id;
@dynamic spec;
@dynamic standard;
@dynamic type;
@dynamic unit_name;


+ (NSArray *)allDistinctPropertiesNamed:(NSString *)propertyName {
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"RoadAssetPrice" inManagedObjectContext:context];
    NSFetchRequest *fecthRequest=[[NSFetchRequest alloc] init];
    [fecthRequest setEntity:entity];
    [fecthRequest setResultType:NSDictionaryResultType];
    [fecthRequest setReturnsDistinctResults:YES];
    [fecthRequest setPropertiesToFetch:@[propertyName]];
    
    NSError *err=nil;
    NSArray *fetchResult = [context executeFetchRequest:fecthRequest error:&err];
    if (err == nil) {
        NSMutableArray *allDistinctProperties = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < fetchResult.count; i++) {
            id propertyValue = fetchResult[i][propertyName];
            if ([propertyValue respondsToSelector:@selector(isEmpty)] &&
                ![propertyValue isEmpty]) {
                [allDistinctProperties addObject:propertyValue];
            }
        }
        return [allDistinctProperties copy];
    } else {
        return nil;
    }
}

+ (NSArray *)roadAssetPricesForStandard:(NSString *)standardName {
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"RoadAssetPrice" inManagedObjectContext:context];
    NSPredicate *predicate = nil;
    if (![standardName isEqualToString:RoadAssetPriceStandardAllStandards]) {
        predicate = [NSPredicate predicateWithFormat:@"standard == %@", standardName];
    }
    NSFetchRequest *fecthRequest=[[NSFetchRequest alloc] init];
    [fecthRequest setEntity:entity];
    [fecthRequest setPredicate:predicate];
    
    NSError *err=nil;
    NSArray *fetchResult = [context executeFetchRequest:fecthRequest error:&err];
    if (err == nil) {
        return fetchResult;
    } else {
        return nil;
    }
}

@end
