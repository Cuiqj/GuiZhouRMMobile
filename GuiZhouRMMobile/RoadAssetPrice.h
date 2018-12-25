//
//  RoadAssetPrice.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-23.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const RoadAssetPriceStandardAllStandards;

@interface RoadAssetPrice : NSManagedObject

@property (nonatomic, retain) NSString * big_type;
@property (nonatomic, retain) NSString * damage_type;
@property (nonatomic, retain) NSString * depart_num;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * roadasset_id;
@property (nonatomic, retain) NSString * spec;
@property (nonatomic, retain) NSString * standard;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * unit_name;

+ (NSArray *)allDistinctPropertiesNamed:(NSString *)propertyName;
+ (NSArray *)roadAssetPricesForStandard:(NSString *)standardName;


@end
