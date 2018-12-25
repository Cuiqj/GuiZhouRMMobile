//
//  NSManagedObject+_NeedUpLoad_.m
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "NSManagedObject+_NeedUpLoad_.h"

@implementation NSManagedObject (_NeedUpLoad_)

+ (NSArray *)uploadArrayOfObject{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate  predicateWithFormat:@"isuploaded.boolValue == NO"]];
    return [context executeFetchRequest:fetchRequest error:nil];
}

@end
