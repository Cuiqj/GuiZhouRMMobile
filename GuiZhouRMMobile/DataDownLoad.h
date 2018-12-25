//
//  DataDownLoad.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-22.
//
//

#import <Foundation/Foundation.h>

#import "InitRoad.h"
#import "InitEmployee.h"
#import "InitUser.h"
#import "InitIconModel.h"
#import "InitRoadAssetPrice.h"
#import "InitRoadEngrossPrice.h"
#import "InitSystype.h"
#import "InitInspectionCheck.h"
#import "InitCaselaySet.h"


#define WORKCOUNT 13
#define FINISHNOTINAME @"WorkFinished"

#define WAITFORPARSER   self.stillParsing = YES;\
                        while (self.stillParsing) {\
                            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];\
                        }



@interface DataDownLoad : NSObject

@property (nonatomic, retain) NSString *currentOrgID;

- (id)initWithOrgID:(NSString *)orgID;
- (void)startDownLoad;
@end
