//
//  RoadEngrossPrice.h
//  GuiZhouRMMobile
//
//  Created by XU SHIWEN on 13-10-25.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RoadEngrossPrice : NSManagedObject

@property (nonatomic, retain) NSString * roadengrossprice_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * spec;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSString * unit_name;
@property (nonatomic, retain) NSString * remark;

+ (NSArray *)allInstances;

@end
