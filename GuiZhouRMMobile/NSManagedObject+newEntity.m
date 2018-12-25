//
//  NSManagedObject+newEntity.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-3.
//
//

#import "NSManagedObject+newEntity.h"

@implementation NSManagedObject (newEntity)
+ (id)newDataObject{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    id obj = [[NSClassFromString(NSStringFromClass([self class])) alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    return obj;
}
@end
