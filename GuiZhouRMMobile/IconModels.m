//
//  IconModels.m
//  GuiZhouRMMobile
//
//  Created by Danny Liu on 12-4-4.
//  Copyright (c) 2012年 SNDA. All rights reserved.
//

#import "IconModels.h"
#import "IconItems.h"
#import "IconTexts.h"


@implementation IconModels

@dynamic iconangle;
@dynamic iconheight;
@dynamic iconid;
@dynamic iconleft;
@dynamic iconname;
@dynamic icontop;
@dynamic icontype;
@dynamic iconwidth;
@dynamic items;
@dynamic texts;
@dynamic itemsxml;


+ (IconModels *)iconModelforID:(NSString *)iconid{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate  predicateWithFormat:@"iconid == %@",iconid]];
    return [[context executeFetchRequest:fetchRequest error:nil] objectAtIndex:0];
}
@end
