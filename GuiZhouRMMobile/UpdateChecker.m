//
//  UpdateChecker.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 13-3-4.
//
//

#import "UpdateChecker.h"
#import "WebServiceHandler.h"

//定义本地版本key
static NSString * const bundleVersionKey = @"CFBundleShortVersionString";

//定义版本检查的txt地址
static NSString * const updateTXTAddress = @"/mobile/ipa/Version.txt";

//定义更新版本信息key
static NSString * const versionKey = @"Version";

//定义版本更新内容key
static NSString * const updateContentKey = @"What's new";

//定义更新页面地址
static NSString * const ipaUpdateURLString = @"/ipa.html";



@implementation UpdateChecker

+(UpdateChecker *)sharedInstance{
    static dispatch_once_t pred = 0;
    __strong static id sharedObject = nil;
    dispatch_once(&pred, ^{
        sharedObject = [[self alloc] init]; // or some other init method
    });
    return sharedObject;
}

- (void)checkUpdate{
    if ([WebServiceHandler isServerReachable]) {
        NSString *urlString = [[[AppDelegate App] serverAddress] stringByAppendingString:updateTXTAddress];
        NSURL *updateURL = [[NSURL alloc] initWithString:urlString];
        NSURLRequest *checkUpdateRequest = [[NSURLRequest alloc] initWithURL:updateURL];
        NSOperationQueue *queue=[NSOperationQueue mainQueue];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        NSDate *checkDate = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:checkDate forKey:UPDATECHECKDATEKEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [NSURLConnection sendAsynchronousRequest:checkUpdateRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            BOOL checkUpdateFailed = YES;
            if (data.length > 0 && error == nil) {
                NSDictionary *updateInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:nil];
                if (updateInfo) {
                    NSString * newVersion = [updateInfo objectForKey:versionKey];
                    if (newVersion) {
                        checkUpdateFailed = NO;
                        NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
                        NSString *currentVersion = [appInfo valueForKey:bundleVersionKey];
                        if ([currentVersion compare:newVersion options:NSNumericSearch] == NSOrderedAscending) {
                            //显示更新提示
                            NSString *message = [[NSString alloc] initWithFormat:@"有新版本%@，更新内容如下：\n%@",newVersion,[updateInfo objectForKey:updateContentKey]];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"前往更新", nil ];
                            [alert show];
                        } else {
                            //当前为最新
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"当前已是最新版本，无需更新。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                    }
                }
            }
            if (checkUpdateFailed) {
                //无法获取更新信息
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"获取最新版本信息出错，\n暂时无法更新。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSURL *updateURL = [NSURL URLWithString:[[AppDelegate App].serverAddress stringByAppendingString:ipaUpdateURLString]];
        [[UIApplication sharedApplication] openURL:updateURL];
    }
}
@end
