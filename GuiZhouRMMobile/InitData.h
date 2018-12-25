//
//  InitData.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-19.
//
//

#define WebServiceInit WebServiceHandler *service=[[WebServiceHandler alloc]init];\
                       service.currentOrgID=self.currentOrgID;\
                       service.delegate=self


#import <Foundation/Foundation.h>
#import "WebServiceHandler.h"
#import "TBXML.h"


extern NSString * const DownLoadErrorMessage;

@interface InitData : NSObject<WebServiceReturnString>
@property (nonatomic,retain) NSString *currentOrgID;
- (id)initWithOrgID:(NSString *)orgID;
- (void)xmlParser:(NSString *)webString;
@end
