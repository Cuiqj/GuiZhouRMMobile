//
//  RoadEngrossPrice.m
//  GuiZhouRMMobile
//
//  Created by XU SHIWEN on 13-10-25.
//
//

#import "RoadEngrossPrice.h"


@implementation RoadEngrossPrice

@dynamic roadengrossprice_id;
@dynamic name;
@dynamic spec;
@dynamic type;
@dynamic price;
@dynamic unit_name;
@dynamic remark;

- (NSString *)description
{
    return [NSString stringWithFormat:@"\n{id: %@,\n name: %@,\n spec: %@,\n type: %@,\n price: %@,\n unit_name: %@,\n remark: %@\n}",
            self.roadengrossprice_id,
            self.name,
            self.spec,
            self.type,
            self.price.stringValue,
            self.unit_name,
            self.remark];
}

+ (NSArray *)allInstances
{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:nil];
    return [context executeFetchRequest:fetchRequest error:nil];
}

@end
