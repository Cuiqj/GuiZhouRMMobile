//
//  OrgSyncViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-15.
//
//

#import "OrgSyncViewController.h"
#import "AGAlertViewWithProgressbar.h"


@interface OrgSyncViewController ()
@property (nonatomic,retain) NSArray *data;
@property (nonatomic,retain) AGAlertViewWithProgressbar *progressView;
@property (nonatomic,assign) NSInteger parserCount;
@property (nonatomic,assign) NSInteger currentParserCount;
@property (nonatomic,assign) BOOL stillParsing;

- (void)updateProgress:(NSNotification *)noti;
- (void)parserFinished:(NSNotification *)noti;
- (void)getOrgList;
@end

@implementation OrgSyncViewController
@synthesize tableOrgList = _tableOrgList;
@synthesize textServerAddress = _textServerAddress;
@synthesize data = _data;
@synthesize progressView = _progressView;
@synthesize parserCount = _parserCount;
@synthesize currentParserCount = _currentParserCount;
@synthesize dataDownLoader = _dataDownLoader;

- (void)viewDidLoad
{
    self.textServerAddress.text=[[AppDelegate App] serverAddress];
    //载入所有机构信息
    self.data = [OrgInfo allOrgInfo];
    //若本机无机构信息，则从服务器获取
    if (self.data.count == 0) {
        [self getOrgList];
    }
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parserFinished:) name:FINISHNOTINAME object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:@"UpdateProgress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parserFinished:) name:@"ParserFinished" object:nil];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated{
    [self.delegate pushLoginView];
}

- (void)viewDidUnload
{
    [self setData:nil];
    [self setTableOrgList:nil];
    [self setTextServerAddress:nil];
    [self setDataDownLoader:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text=[[self.data objectAtIndex:indexPath.row] valueForKey:@"orgname"];
    cell.detailTextLabel.text=[[self.data objectAtIndex:indexPath.row] valueForKey:@"orgshortname"];
    return cell;
}


- (IBAction)showServerAddress:(UIBarButtonItem *)sender {
    if (self.tableOrgList.frame.origin.y<100) {
        sender.title=@"确定地址";
        [UIView transitionWithView:self.tableOrgList
                          duration:0.3
                           options:UIViewAnimationCurveEaseInOut
                        animations:^{
                            self.tableOrgList.frame = CGRectMake(0, 226, 540, 374);
                        }
                        completion:nil];
        
    } else {
        sender.title=@"设置服务器地址";
        [UIView transitionWithView:self.tableOrgList
                          duration:0.3
                           options:UIViewAnimationCurveEaseInOut
                        animations:^{
                            self.tableOrgList.frame = CGRectMake(0, 44, 540, 556);
                        }
                        completion:^(BOOL finished){
                            if (![self.textServerAddress.text isEqualToString:[[AppDelegate App] serverAddress]]) {
                                NSString *error;
                                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
                                NSString *libraryDirectory = [paths objectAtIndex:0];
                                NSString *plistFileName = @"Settings.plist";
                                NSString *plistPath = [libraryDirectory stringByAppendingPathComponent:plistFileName];
                                NSDictionary *serverSettingsDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: self.textServerAddress.text, [AppDelegate App].fileAddress, nil]
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
                                [AppDelegate App].serverAddress=self.textServerAddress.text;
                            }
                            [self getOrgList];
                            
                        }];
    }
}


- (IBAction)setCurrentOrg:(UIBarButtonItem *)sender {
    NSIndexPath *indexPath=[self.tableOrgList indexPathForSelectedRow];
    if (indexPath) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView=[[AGAlertViewWithProgressbar alloc] initWithTitle:@"同步基础数据" message:@"正在下载，请稍候……" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            [self.progressView show];
        });
        self.parserCount=WORKCOUNT;
        self.currentParserCount=self.parserCount;
        @autoreleasepool {
            NSString *orgID = [[self.data objectAtIndex:indexPath.row] valueForKey:@"myid"];
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
            InitSystype *initSys = [[InitSystype alloc] initWithOrgID:orgID];
            [initSys downLoadSystype];
            WAITFORPARSER
            InitRoadAssetPrice *initRoadasset = [[InitRoadAssetPrice alloc] initWithOrgID:orgID];
            [initRoadasset downLoadRoadAssetPrice];
            WAITFORPARSER
            InitRoadEngrossPrice *initRoadEngross = [[InitRoadEngrossPrice alloc] initWithOrgID:orgID];
            [initRoadEngross downloadRoadEngrossPrice];
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
    } else {
        void(^ShowAlert)(void)=^(void){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"请先选择所属机构，再开始同步基础数据。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }; 
        MAINDISPATCH(ShowAlert);
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
                NSIndexPath *indexPath=[self.tableOrgList indexPathForSelectedRow];
                [[NSUserDefaults standardUserDefaults] setValue:[[self.data objectAtIndex:indexPath.row] valueForKey:@"myid"] forKey:ORGKEY] ;
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.delegate reloadOrgLabel];
                [self dismissModalViewControllerAnimated:YES];
            }
        }
    });
}


- (void)getOrgList {
    NSOperationQueue *myqueue=[[NSOperationQueue alloc] init];
    [myqueue setMaxConcurrentOperationCount:1];
    NSBlockOperation *clearTable=[NSBlockOperation blockOperationWithBlock:^{
        [self setData:nil];
        [self.tableOrgList reloadData];
        [[AppDelegate App] clearEntityForName:@"OrgInfo"];
    }];
    [myqueue addOperation:clearTable];
    if ([WebServiceHandler isServerReachable]) {
        NSBlockOperation *getOrgInfo=[NSBlockOperation blockOperationWithBlock:^{
            WebServiceHandler *web = [[WebServiceHandler alloc] init];
            web.delegate=self;
            [web getOrgInfo];
        }];
        [getOrgInfo addDependency:clearTable];
        [myqueue addOperation:getOrgInfo];
    }
}



- (void)getWebServiceReturnString:(NSString *)webString forWebService:(NSString *)serviceName{
    void(^OrgInfoParser)(void)=(^(void){
        NSError *error;
        TBXML *tbxml=[TBXML newTBXMLWithXMLString:webString error:&error];
        TBXMLElement *root=tbxml.rootXMLElement;
        TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
        
        TBXMLElement *r1=[TBXML childElementNamed:@"getOrgListResponse" parentElement:rf];
        TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
        
        TBXMLElement *author=[TBXML childElementNamed:@"ns1:OrgInfoModel" parentElement:r2];
        while (author) {
            @autoreleasepool {
                TBXMLElement *orgid=[TBXML childElementNamed:@"id" parentElement:author];
                if (orgid!=nil){
                    NSString *orgid_string=[TBXML textForElement:orgid];
                    
                    TBXMLElement *belongtoOrgCode=[TBXML childElementNamed:@"belongtoOrgCode" parentElement:author];
                    NSString *belongtoOrgCode_string=[TBXML textForElement:belongtoOrgCode];
                    
                    TBXMLElement *orgName=[TBXML childElementNamed:@"orgName" parentElement:author];
                    NSString *orgName_string=[TBXML textForElement:orgName];
                    
                    TBXMLElement *orgShortName=[TBXML childElementNamed:@"orgShortName" parentElement:author];
                    NSString *orgShortName_string=[TBXML textForElement:orgShortName];
                    
                    TBXMLElement *orderdesc=[TBXML childElementNamed:@"orderdesc" parentElement:author];
                    NSString *orderdesc_string=[TBXML textForElement:orderdesc];
                    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
                    NSEntityDescription *entity=[NSEntityDescription entityForName:@"OrgInfo" inManagedObjectContext:context];
                    OrgInfo *newOrgInfo=[[OrgInfo alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
                    newOrgInfo.myid=orgid_string;
                    newOrgInfo.belongtoid=belongtoOrgCode_string;
                    newOrgInfo.orgname=orgName_string;
                    newOrgInfo.orgshortname=orgShortName_string;
                    newOrgInfo.orderdesc=orderdesc_string;
                    TBXMLElement *address=[TBXML childElementNamed:@"address" parentElement:author];
                    newOrgInfo.address=[TBXML textForElement:address];
                    TBXMLElement *defaultuserid=[TBXML childElementNamed:@"defaultuserid" parentElement:author];
                    newOrgInfo.defaultuserid=[TBXML textForElement:defaultuserid];
                    TBXMLElement *faxNumber=[TBXML childElementNamed:@"faxNumber" parentElement:author];
                    newOrgInfo.faxnumber=[TBXML textForElement:faxNumber];
                    TBXMLElement *file_pre=[TBXML childElementNamed:@"file_pre" parentElement:author];
                    newOrgInfo.file_pre=[TBXML textForElement:file_pre];
                    TBXMLElement *org_jc=[TBXML childElementNamed:@"org_jc" parentElement:author];
                    newOrgInfo.org_jc=[TBXML textForElement:org_jc];
                    TBXMLElement *postcode=[TBXML childElementNamed:@"postcode" parentElement:author];
                    newOrgInfo.postcode=[TBXML textForElement:postcode];
                    TBXMLElement *orgtype=[TBXML childElementNamed:@"org_tpye" parentElement:author];
                    newOrgInfo.orgtype=[TBXML textForElement:orgtype];
                    TBXMLElement *telephone=[TBXML childElementNamed:@"telephone" parentElement:author];
                    newOrgInfo.telephone=[TBXML textForElement:telephone];
                    TBXMLElement *linkMan=[TBXML childElementNamed:@"linkman" parentElement:author];
                    newOrgInfo.linkman=[TBXML textForElement:linkMan];
                    TBXMLElement *principal=[TBXML childElementNamed:@"principal" parentElement:author];
                    newOrgInfo.principal=[TBXML textForElement:principal];
                    TBXMLElement *jzFlag=[TBXML childElementNamed:@"jzFlag" parentElement:author];
                    newOrgInfo.jzFlag=[TBXML textForElement:jzFlag];
                    [[AppDelegate App] saveContext];
                }
            }
            author=author->nextSibling;
        }
    });
    NSBlockOperation *parser=[NSBlockOperation blockOperationWithBlock:OrgInfoParser];
    NSOperationQueue *myqueue=[[NSOperationQueue alloc] init];
    [myqueue setMaxConcurrentOperationCount:1];
    [myqueue addOperation:parser];
    NSBlockOperation *reloadData=[NSBlockOperation blockOperationWithBlock:^{
        NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
        NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"OrgInfo" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:nil];
        self.data=[context executeFetchRequest:fetchRequest error:nil];
        self.data=[self.data sortedArrayUsingComparator:^(id obj1, id obj2) {
            if ([[obj1 valueForKey:@"orderdesc"] integerValue] > [[obj2 valueForKey:@"orderdesc"] integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([[obj1 valueForKey:@"orderdesc"] integerValue] < [[obj2 valueForKey:@"orderdesc"] integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableOrgList reloadData];
        });
    }];
    [reloadData addDependency:parser];
    [myqueue addOperation:reloadData];
}


@end
