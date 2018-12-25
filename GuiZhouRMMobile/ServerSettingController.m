//
//  ServerSettingController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ServerSettingController.h"
#import "InspectionUpLoader.h"
#import "RoadWayClosedUpLoader.h"
#import "CaseInfoUpLoader.h"
#import "CaseMapUpLoader.h"
#import "CasePhotosUpLoader.h"
#import "UpdateChecker.h"

//定义本地版本key
static NSString * const bundleVersionKey = @"CFBundleShortVersionString";

//定义重设机构提示窗口tag
static NSInteger const resetOrgAlertTag = 1001;


@interface ServerSettingController()
@property (nonatomic, assign) NSInteger upCount;
@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic, retain) NSArray *upLoadQueue;
@end

@implementation ServerSettingController
@synthesize txtServer=_txtServer;
@synthesize txtFile=_txtFile;
@synthesize uibuttonInit = _uibuttonInit;
@synthesize uibuttonReset = _uibuttonReset;
@synthesize uibuttonUpLoad = _uibuttonUpLoad;
@synthesize uibuttonDowloadXMLTable = _uibuttonDowloadXMLTable;
@synthesize dataDownLoader = _dataDownLoader;
@synthesize upLoadQueue = _upLoadQueue;

- (NSArray *)upLoadQueue{
    if (_upLoadQueue == nil) {
        CaseInfoUpLoader *ciup = [[CaseInfoUpLoader alloc] init];
        RoadWayClosedUpLoader *rup = [[RoadWayClosedUpLoader alloc] init];
        InspectionUpLoader *iupLoader = [[InspectionUpLoader alloc] init];
        CaseMapUpLoader *cmup = [[CaseMapUpLoader alloc] init];
        CasePhotosUpLoader *cpup = [[CasePhotosUpLoader alloc] init];
        _upLoadQueue = @[ciup, rup, iupLoader, cmup, cpup];
    }
    return _upLoadQueue;
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.txtServer.text = [AppDelegate App].serverAddress;
    self.txtFile.text = [AppDelegate App].fileAddress;
    
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *versionNumber = [appInfo valueForKey:bundleVersionKey];
    self.labelVersion.text = [NSString stringWithFormat:@"版本:%@",versionNumber];
    
    //删除无用的案件数据
    [CaseInfo deleteEmptyCaseInfo];
    
    NSString *imagePath=[[NSBundle mainBundle] pathForResource:@"小按钮" ofType:@"png"];
    UIImage *btnImage=[[UIImage imageWithContentsOfFile:imagePath] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.uibuttonInit setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.uibuttonDowloadXMLTable setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.uibuttonUpLoad setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.uibuttonCheckUpdate setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    NSString *importantImagePath=[[NSBundle mainBundle] pathForResource:@"蓝底主按钮" ofType:@"png"];
    UIImage *impotantBtnImage=[[UIImage imageWithContentsOfFile:importantImagePath] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.uibuttonReset setBackgroundImage:impotantBtnImage forState:UIControlStateNormal];
    
    imagePath=[[NSBundle mainBundle] pathForResource:@"服务器参数设置 -bg" ofType:@"png"];
    self.view.layer.contents=(id)[[UIImage imageWithContentsOfFile:imagePath] CGImage];
    
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setTxtServer:nil];
    [self setTxtFile:nil];
    [self setUibuttonInit:nil];
    [self setUibuttonReset:nil];
    [self setUibuttonUpLoad:nil];
    [self setUibuttonDowloadXMLTable:nil];
    [self setDataDownLoader:nil];
    
    [self setLabelVersion:nil];
    [self setUibuttonCheckUpdate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)btnSave:(id)sender {
    NSString *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *plistFileName = @"Settings.plist";
    NSString *plistPath = [libraryDirectory stringByAppendingPathComponent:plistFileName];
    NSDictionary *serverSettingsDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: self.txtServer.text, self.txtFile.text, nil]  
                                                                   forKeys:[NSArray arrayWithObjects: @"server address", @"file address", nil]];
    NSPropertyListFormat format;
    NSString *errorDesc = nil;
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSMutableDictionary *plistDict = [[NSPropertyListSerialization
                                              propertyListFromData:plistXML
                                              mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                              format:&format
                                              errorDescription:&errorDesc] mutableCopy];
    [plistDict setObject:serverSettingsDict forKey:@"Server Settings"];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];  
    
    if ([[NSFileManager defaultManager] isWritableFileAtPath:plistPath]) {
        if(plistData) {
            [plistData writeToFile:plistPath atomically:YES];
        }
    }
    [AppDelegate App].serverAddress=self.txtServer.text;
    [AppDelegate App].fileAddress=self.txtFile.text;
    [self.view endEditing:YES];
}


- (IBAction)btnInitData:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:FINISHNOTINAME object:nil];
    NSString *orgID = [[NSUserDefaults standardUserDefaults] stringForKey:ORGKEY ];
    self.dataDownLoader = [[DataDownLoad alloc] initWithOrgID:orgID];
    [self.dataDownLoader startDownLoad];
}

- (IBAction)btnUpLoadData:(id)sender {
    [self.view endEditing:YES];
    [self btnSave:nil];
    NSString *inspectionID=[[NSUserDefaults standardUserDefaults] valueForKey:INSPECTIONKEY];
    if (![inspectionID isEmpty] && inspectionID!=nil) {
        void(^ShowAlert)(void)=^(void){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"当前还有未完成的巡查，请先交班再上传业务数据。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        };
        MAINDISPATCH(ShowAlert);
    } else {
        if ([WebServiceHandler isServerReachable]) {            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:FINISHNOTINAME object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upLoadError:) name:ERRORNOTI object:nil];
                [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
                self.alert = [[UIAlertView alloc] initWithTitle:@"上传业务数据" message:@"正在上传业务数据，\n请稍候……" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.alert show];
                });
                self.upCount = 5;
                [[self.upLoadQueue objectAtIndex:self.upLoadQueue.count - self.upCount] performSelector:@selector(startUpLoad)];
            });
        } 
    }
}

- (void)upLoadError :(NSNotification*)aNotification {
    self.upCount = 0;
    NSString *errorMessage = [aNotification.userInfo objectForKey:@"message"];
    
    if (errorMessage == nil || [errorMessage isEmpty]) {
        errorMessage = @"上传数据出现错误！\n请检查网络是否连接或案件信息是否完整。";
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.alert != nil) {
            [self.alert dismissWithClickedButtonIndex:0 animated:NO];
        }
        self.alert = [[UIAlertView alloc] initWithTitle:@"上传数据出现错误！" message:errorMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [self.alert show];
    });

    self.upLoadQueue = nil;

}

- (void)updateProgress:(NSNotification *)notification{
    // 下载基础数据完成情况
    if ([notification.object isKindOfClass:[DataDownLoad class]]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"下载完成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        });
    } else {
    // 上传业务数据完成情况
        self.upCount -= 1;
        if (self.upCount <= 0) {
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.alert != nil) {
                    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
                }
                
                self.alert = [[UIAlertView alloc] initWithTitle:@"上传业务数据" message:@"业务数据上传完成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [self.alert show];
            });
            
            
            self.upLoadQueue = nil;
        } else {
            [[self.upLoadQueue objectAtIndex:self.upLoadQueue.count - self.upCount] performSelector:@selector(startUpLoad)];
        }
    }
}

 
- (void)hideAlert{
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
    [self setAlert:nil];
}

- (IBAction)btnDownLoadXMLTable:(id)sender {
    if ([WebServiceHandler isServerReachable]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libraryDirectory = [paths objectAtIndex:0];
        NSString *plistFileName = @"Settings.plist";
        NSString *plistPath = [libraryDirectory stringByAppendingPathComponent:plistFileName];
        NSPropertyListFormat format;
        NSString *errorDesc;
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSDictionary *settings = (NSDictionary *)[NSPropertyListSerialization
                                                  propertyListFromData:plistXML
                                                  mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                  format:&format
                                                  errorDescription:&errorDesc];
        NSDictionary *tables = [settings objectForKey:@"FileToTableMapping"];
        NSArray *fileArray = [tables allValues];
        @autoreleasepool {
            self.alert = [[UIAlertView alloc] initWithTitle:@"下载文书格式" message:@"下载文书配置中，请稍候……" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            NSInteger currentFile = 0;
            [self.alert show];
            for (NSString *xmlName in fileArray) {
                NSString *urlString=[AppDelegate App].fileAddress;
                urlString=[urlString stringByAppendingFormat:@"%@.xml",xmlName];
                NSURL *url=[NSURL URLWithString:urlString];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                
                NSURLResponse *response;
                NSError *error;
                NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if ([httpResponse statusCode]==200) {
                    NSString *docXMLSettingFileName=[xmlName stringByAppendingString:@".xml"];
                    NSString *docXMLSettingFilePath=[libraryDirectory stringByAppendingPathComponent:docXMLSettingFileName];
                    [[NSFileManager defaultManager] removeItemAtPath:docXMLSettingFilePath error:nil];
                    [data writeToFile:docXMLSettingFilePath atomically:YES];
                    currentFile += 1;
                    NSString *message = [[NSString alloc] initWithFormat:@"%@文件已下载，请稍候……。",xmlName];
                    [self.alert setMessage:message];
                } else {
                    NSString *message = [[NSString alloc] initWithFormat:@"无法从服务器获取%@格式文件，请确认服务器上该文件是否存在。",xmlName];
                    [self.alert setMessage:message];
                }
            }
            [self.alert setMessage:@"文书格式下载完成。"];
            [self performSelector:@selector(hideAlert) withObject:nil afterDelay:2];
        }
    }
}

- (IBAction)btnResetCurrentOrg:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告！" message:@"重设机构将清除本程序内当前机构信息，并联网下载新机构的基础数据。\n若无法连接服务器，将导致本程序缺少基础数据无法正常运行，是否确定更改当前机构？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil ];
    alert.tag = resetOrgAlertTag;
    [alert show];
}


- (IBAction)btnCheckUpdate:(id)sender {
    [[UpdateChecker sharedInstance] checkUpdate];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case resetOrgAlertTag:
        {
            if (buttonIndex == 1) {
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:ORGKEY ];
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:USERKEY];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
            break;
        default:
            break;
    }
}

@end
