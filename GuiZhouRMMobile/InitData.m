//
//  InitData.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-19.
//
//

#import "InitData.h"

NSString * const DownLoadErrorMessage = @"服务器数据获取异常。";

@implementation InitData
@synthesize currentOrgID = _currentOrgID;

- (id)initWithOrgID:(NSString *)orgID{
    self=[super init];
    if (self) {
        self.currentOrgID=orgID;
    }
    return self;
}

- (void)getWebServiceReturnString:(NSString *)webString forWebService:(NSString *)serviceName{
    serviceName=[serviceName stringByReplacingOccurrencesOfString:@"get" withString:@""];
    NSDictionary *userInfo=@{ @"service" : serviceName };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateProgress" object:nil userInfo:userInfo];
    [self xmlParser:webString];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ParserFinished" object:nil userInfo:userInfo];
}


- (void)xmlParser:(NSString *)webString{}; 

@end
