//
//  ForceNoticePrintViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-28.
//
//

#import "ForceNoticePrintViewController.h"
#import "CaseDocuments.h"

static NSString * const xmlName = @"ForceNoticeTable";

@interface ForceNoticePrintViewController ()
@property (nonatomic, retain) ForceNotice *forceNotice;

@end

@implementation ForceNoticePrintViewController

@synthesize caseID = _caseID;
@synthesize forceNotice = _forceNotice;
@synthesize textfact = _textfact;

@synthesize textbasis_law = _textbasis_law;
@synthesize textchange_spot = _textchange_spot;
@synthesize textchange_limit = _textchange_limit;
@synthesize textchange_time = _textchange_time;
@synthesize textchange_action = _textchange_action;

@synthesize textdate_send = _textdate_send;

-(void)viewDidLoad{
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:xmlName];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_SMALL_WIDTH, VIEW_SMALL_HEIGHT);
    self.view.frame = viewFrame;
    if (![self.caseID isEmpty]) {
        self.forceNotice = [ForceNotice forceNoticeForCase:self.caseID];
        if (self.forceNotice == nil) {
            self.forceNotice = [ForceNotice newForceNoticeForCase:self.caseID];
            [self generateDefaultInfo:self.forceNotice];
        }        
        [self pageLoadInfo];
    }
    [super viewDidLoad];
}


- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
}

- (void)initControlsInteraction
{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (caseInfo.isuploaded.boolValue) {
        [super initControlsInteraction];
    } else {
        // do nothing
    }
}

- (void)pageLoadInfo{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    NSString *caseCodeFormat = [caseInfo caseCodeFormat];
    self.labelCaseCode.text = [[NSString alloc] initWithFormat:caseCodeFormat,@"改"];
    self.labelParty.text = caseInfo.citizen_name;
    self.textfact.text = self.forceNotice.fact;

    self.textbasis_law.text = self.forceNotice.basis_law;
    self.textchange_spot.text = self.forceNotice.change_spot;
    self.textchange_limit.text = self.forceNotice.change_limit;
    self.textchange_action.text = self.forceNotice.change_action;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.textdate_send.text = [dateFormatter stringFromDate:self.forceNotice.date_send];
    self.textchange_time.text = [dateFormatter stringFromDate:self.forceNotice.change_time];
    
    if ([self.textchange_time.text isEmpty] || self.textchange_time.text == nil) {
        self.textchange_time.placeholder = [dateFormatter stringFromDate:[NSDate date]];
    }
}

- (void)pageSaveInfo{
    self.forceNotice.fact = self.textfact.text;
    self.forceNotice.basis_law = self.textbasis_law.text;
    self.forceNotice.change_spot = self.textchange_spot.text;
    self.forceNotice.change_limit = self.textchange_limit.text;
    self.forceNotice.change_action = self.textchange_action.text;    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.forceNotice.date_send = [dateFormatter dateFromString:self.textdate_send.text];
    self.forceNotice.change_time = [dateFormatter dateFromString:self.textchange_time.text];
    self.forceNotice.dsrname = self.labelParty.text;
    self.forceNotice.isStop = @(NO);
    NSString *deleteFileName = @"责令停止（改正）违法行为通知书";
    [CaseDocuments deleteDocumentsForCase:self.caseID docName:deleteFileName];
    if (![self.caseID isEmpty]) {
        NSString *fileName=[NSString stringWithFormat:@"CaseDoc/%@/%@-%d.pdf",self.caseID,deleteFileName,0];
        NSArray *arrayPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path=[arrayPaths objectAtIndex:0];
        NSString *pathString = [path stringByAppendingPathComponent:fileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:pathString]) {
            [[NSFileManager defaultManager] removeItemAtPath:pathString error:nil];
        }
    }
	[[AppDelegate App] saveContext];
}

//根据记录，完整默认值信息
- (void)generateDefaultInfo:(ForceNotice *)forceNotice{
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    
    if (forceNotice.date_send==nil) {
        forceNotice.date_send=[NSDate date];
    }
    if (forceNotice.change_time == nil) {
        forceNotice.change_time = [NSDate date];
    }
    if (forceNotice.handle_time == nil) {
        forceNotice.handle_time = [NSDate date];
    }
    
    //默认勘验笔录勘验情况
    CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
    if (caseProveInfo) {
        forceNotice.fact = caseProveInfo.event_desc;
    }
    
    
    forceNotice.dsrname = caseInfo.citizen_name;
    
    //法律依据 下拉框内容从 systype_法律条文 获取
    forceNotice.basis_law = [CaseLaySet getLayYiJuForCase:self.caseID];
    //责令停止的内容
    forceNotice.break_law = [CaseLaySet getLayWeiFanForCase:self.caseID];

    
    OrgInfo *orgInfo = [OrgInfo orgInfoForOrgID:caseInfo.organization_id];
    forceNotice.linkMan=orgInfo.linkman;
    forceNotice.linkTel=orgInfo.telephone;
    forceNotice.linkAddress=orgInfo.address;
    
    [[AppDelegate App] saveContext];
}

- (NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:xmlName];
        [self drawDateTable:xmlName withDataModel:self.forceNotice];
        UIGraphicsEndPDFContext();
        
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

- (void)viewDidUnload {
    [self setLabelParty:nil];
    [self setLabelCaseCode:nil];
    [super viewDidUnload];
}

- (void)generateDefaultAndLoad{
    [self generateDefaultInfo:self.forceNotice];
    [self pageLoadInfo];
}

- (void)deleteCurrentDoc{
    if (![self.caseID isEmpty] && self.forceNotice) {
        [[[AppDelegate App] managedObjectContext] deleteObject:self.forceNotice];
        [[AppDelegate App] saveContext];
        self.forceNotice = nil;
    }
}

@end
