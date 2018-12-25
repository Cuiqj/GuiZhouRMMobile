//
//  InquireAskSentence.h
//  GuiZhouRMMobile
//
//  Created by Sniper X on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface InquireAskSentence : NSManagedObject

@property (nonatomic, retain) NSString * index;
@property (nonatomic, retain) NSString * sentence;
@property (nonatomic, retain) NSString * ask_id;

@end
