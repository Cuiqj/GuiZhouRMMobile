//
//  DataUpLoader.h
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import <Foundation/Foundation.h>
#import "WebServiceHandler.h"
#import "TBXML.h"
#import "NSManagedObject+_NeedUpLoad_.h"
#import "DataDownLoad.h"
#import "AGAlertViewWithProgressbar.h"
#import "UploadDataProtocol.h"

#define ERRORNOTI @"UpLoadError"

#define WebUpLoadInit WebServiceHandler *service=[[WebServiceHandler alloc]init];\
                      service.delegate=self

@interface DataUpLoader : NSObject<WebServiceReturnString>
//@property (nonatomic,assign) BOOL stillUpLoading;
@property (nonatomic,retain) id<UploadDataProtocol> uploadObj;

- (void)startUpLoad;
- (void)upLoadProcess;
- (void)updateProgress;

@end
