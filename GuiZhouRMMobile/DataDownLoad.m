//
//  DataDownLoad.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-22.
//
//

#import "DataDownLoad.h"
#import "AGAlertViewWithProgressbar.h"


@interface DataDownLoad()
@property (nonatomic,retain) AGAlertViewWithProgressbar *progressView;
@property (nonatomic,assign) NSInteger parserCount;
@property (nonatomic,assign) NSInteger currentParserCount;
@property (nonatomic,assign) BOOL stillParsing;

- (void)updateProgress:(NSNotification *)noti;
- (void)parserFinished:(NSNotification *)noti;
@end

@implementation DataDownLoad
@synthesize currentOrgID = _currentOrgID;
@synthesize progressView = _progressView;
@synthesize parserCount = _parserCount;
@synthesize currentParserCount = _currentParserCount;
@synthesize stillParsing = _stillParsing;

- (id)initWithOrgID:(NSString *)orgID{
    self = [super init];
    if (self) {
        self.currentOrgID = orgID;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:@"UpdateProgress" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parserFinished:) name:@"ParserFinished" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadError:) name:@"DownloadError" object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setCurrentOrgID:nil];
    [self setProgressView:nil];
}

- (void)startDownLoad{
    if ([WebServiceHandler isServerReachable]) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        self.progressView=[[AGAlertViewWithProgressbar alloc] initWithTitle:@"同步基础数据" message:@"正在下载，请稍候……" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [self.progressView show];
        self.parserCount=WORKCOUNT;
        self.currentParserCount=self.parserCount;
        @autoreleasepool {
            NSString *orgID = self.currentOrgID;
            InitUser *initUser=[[InitUser alloc] initWithOrgID:orgID];
            [initUser downLoadUserInfo];
            WAITFORPARSER
            InitEmployee *initEmp=[[InitEmployee alloc] initWithOrgID:orgID];
            [initEmp downLoadEmployeeInfo];
            WAITFORPARSER
            InitIconModel *initIcon=[[InitIconModel alloc] initWithOrgID:orgID];
            [initIcon downLoadIconModels];
            WAITFORPARSER
            InitRoad *initRoad = [[InitRoad alloc] initWithOrgID:orgID];
            [initRoad downLoadRoadModel];
            WAITFORPARSER
            InitRoadAssetPrice *initRoadasset = [[InitRoadAssetPrice alloc] initWithOrgID:orgID];
            [initRoadasset downLoadRoadAssetPrice];
            WAITFORPARSER
            InitRoadEngrossPrice *initRoadEngrossPrice = [[InitRoadEngrossPrice alloc] initWithOrgID:orgID];
            [initRoadEngrossPrice downloadRoadEngrossPrice];
            WAITFORPARSER
            InitSystype *initSys = [[InitSystype alloc] initWithOrgID:orgID];
            [initSys downLoadSystype];
            WAITFORPARSER
            InitOrgSystype *initOrgSys = [[InitOrgSystype alloc] initWithOrgID:orgID];
            [initOrgSys downLoadOrgSystype];
            WAITFORPARSER
            InitCheckStatus *initCheckStatus = [[InitCheckStatus alloc] initWithOrgID:orgID];
            [initCheckStatus downLoadCheckStatus];
            WAITFORPARSER
            InitCheckHandle *initCheckHandle = [[InitCheckHandle alloc] initWithOrgID:orgID];
            [initCheckHandle downLoadCheckHandle];
            WAITFORPARSER
            InitCheckReason *initCheckReason = [[InitCheckReason alloc] initWithOrgID:orgID];
            [initCheckReason downLoadCheckReason];
            WAITFORPARSER
            InitCheckType *initCheckType = [[InitCheckType alloc] initWithOrgID:orgID];
            [initCheckType downLoadCheckType];
            WAITFORPARSER
            InitCaselaySet *initCaselaySet = [[InitCaselaySet alloc] initWithOrgID:orgID];
            [initCaselaySet downLoadCaselaySet];
            WAITFORPARSER
        }
    }
}

- (void)updateProgress:(NSNotification *)noti{
    if ([self.progressView isVisible]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *service=[[noti userInfo] valueForKey:@"service"];
            service=[[NSString alloc] initWithFormat:@"正在下载%@,请稍候……",service];
            [self.progressView setMessage:service];
        });
    }
}

- (void)parserFinished:(NSNotification *)noti{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.progressView isVisible]) {
            NSString *service=[[noti userInfo] valueForKey:@"service"];
            service=[[NSString alloc] initWithFormat:@"%@下载完成,请稍候……",service];
            self.currentParserCount=self.currentParserCount-1;
            [self.progressView setMessage:service];
            [self.progressView setProgress:(int)(((float)(-self.currentParserCount+self.parserCount)/(float)self.parserCount)*100.0)];
            
            self.stillParsing = NO;
            if (self.currentParserCount==0) {
                [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
                [self.progressView hide];
                [[NSNotificationCenter defaultCenter] postNotificationName:FINISHNOTINAME object:self];
            }
        }
    });
}

//- (void)downloadError:(NSNotification *)noti
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if ([self.progressView isVisible]) {
//            self.stillParsing = NO;
//            [self.progressView hide];
//            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
//        } else {
//            NSString *message = [noti.userInfo objectForKey:@"message"];
//            [[[UIAlertView alloc] initWithTitle:@"获取基础数据出错" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
//        }
//    });
//}

@end
