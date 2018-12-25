//
//  Cities.h
//  GuiZhouRMMobile
//
//  Created by Danny Liu on 12-4-24.
//  Copyright (c) 2012年 SNDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Cities : NSManagedObject

@property (nonatomic, retain) NSString * citycode;
@property (nonatomic, retain) NSString * cityname;
@property (nonatomic, retain) NSString * provinceid;

@end
