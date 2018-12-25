//
//  UpdateChecker.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 13-3-4.
//
//

#define UPDATECHECKDATEKEY @"UpdateCheckDate"

#import <Foundation/Foundation.h>

@interface UpdateChecker : NSObject<UIAlertViewDelegate>

+ (UpdateChecker *)sharedInstance;

- (void)checkUpdate;
@end
 