//
//  IllegalActNoticePrintViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-29.
//
//

#import "IllegalActNoticePrintViewController.h"

static NSString * const xmlName = @"IllegalActTable";
@interface IllegalActNoticePrintViewController ()
@property (nonatomic, retain) CaseLawBreaking *caseLawBreaking;

@end

@implementation IllegalActNoticePrintViewController

@synthesize caseID = _caseID;
@synthesize caseLawBreaking = _caseLawBreaking;


@synthesize textdate_send = _textdate_send;
@synthesize textlinkman = _textlinkman;

@synthesize textfact = _textfact;
@synthesize textpunish_mode = _textpunish_mode;

@synthesize textlink_phone = _textlink_phone;
@synthesize textlink_addr = _textlink_addr;
@synthesize textlaw_disobey = _textlaw_disobey;
@synthesize textlaw_gist = _textlaw_gist;
@synthesize textlawbreakingreason = _textlawbreakingreason;

-(void)viewDidLoad{
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:xmlName];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_SMALL_WIDTH, VIEW_SMALL_HEIGHT);
    self.view.frame = viewFrame;
    if (![self.caseID isEmpty]) {
        self.caseLawBreaking = [CaseLawBreaking caseLawBreakingForCase:self.caseID];
        if (self.caseLawBreaking == nil) {
            self.caseLawBreaking = [CaseLawBreaking newCaseLawBreakingForCase:self.caseID];
            [self generateDefaultInfo:self.caseLawBreaking];
        }
        [self pageLoadInfo];
    }
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // do something below
    
    
    [super viewWillDisappear:animated];
}

- (void)initControlsInteraction
{
    [super initControlsInteraction];
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (!caseInfo.isuploaded.boolValue) {
        setViewEnabled(self.textlink_addr, YES);
        setViewEnabled(self.textlinkman, YES);
        setViewEnabled(self.textlink_phone, YES);
        setViewEnabled(self.textdate_send, YES);
    }
}

- (void)pageLoadInfo{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    NSString *caseCodeFormat = [caseInfo caseCodeFormat];
    self.labelCaseCode.text = [[NSString alloc] initWithFormat:caseCodeFormat,@"罚"];
    self.labelParty.text = caseInfo.citizen_name;
    

    self.textlinkman.text = self.caseLawBreaking.linkman;

    self.textfact.text = self.caseLawBreaking.fact;
    self.textpunish_mode.text = self.caseLawBreaking.punish_mode;

    self.textlink_phone.text = self.caseLawBreaking.link_phone;
    self.textlink_addr.text = self.caseLawBreaking.link_addr;
    self.textlaw_disobey.text = self.caseLawBreaking.law_disobey;
    self.textlaw_gist.text = self.caseLawBreaking.law_gist;
    if ([self.caseLawBreaking.flag_StatePlea isEqualToString:@"是"]) {
        [self.segFlag_StatePlea setSelectedSegmentIndex:0];
    } else {
        [self.segFlag_StatePlea setSelectedSegmentIndex:1];
    }
    if ([self.caseLawBreaking.flag_Listen isEqualToString:@"是"]) {
        [self.segFlag_Listen setSelectedSegmentIndex:0];
    } else {
        [self.segFlag_Listen setSelectedSegmentIndex:1];
    }

    self.textlawbreakingreason.text = self.caseLawBreaking.lawbreakingreason;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.textdate_send.text = [dateFormatter stringFromDate:self.caseLawBreaking.date_send];
}

- (void)pageSaveInfo{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.caseLawBreaking.date_send = [dateFormatter dateFromString:self.textdate_send.text];

    self.caseLawBreaking.linkman = self.textlinkman.text;

    self.caseLawBreaking.fact = self.textfact.text;
    self.caseLawBreaking.punish_mode = self.textpunish_mode.text;


    self.caseLawBreaking.link_phone = self.textlink_phone.text;
    self.caseLawBreaking.link_addr = self.textlink_addr.text;
    self.caseLawBreaking.law_disobey = self.textlaw_disobey.text;
    self.caseLawBreaking.law_gist = self.textlaw_gist.text;
    
    if (self.segFlag_Listen.selectedSegmentIndex == 0) {
        self.caseLawBreaking.flag_Listen = @"是";
    } else {
        self.caseLawBreaking.flag_Listen = @"否";
    }
    if (self.segFlag_StatePlea.selectedSegmentIndex == 0) {
        self.caseLawBreaking.flag_StatePlea = @"是";
    } else {
        self.caseLawBreaking.flag_StatePlea = @"否";
    }
    self.caseLawBreaking.lawbreakingreason = self.textlawbreakingreason.text;
	[[AppDelegate App] saveContext];
}

//根据记录，完整默认值信息
- (void)generateDefaultInfo:(CaseLawBreaking *)caseLawBreaking{
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    if (caseLawBreaking.date_send==nil) {
        caseLawBreaking.date_send=[NSDate date];
    }
    
    Citizen *citizen=[Citizen citizenForCase:self.caseID];
    if (citizen) {
        caseLawBreaking.punish_mode=[NSString stringWithFormat:@"%@罚款  元的处罚决定",citizen.party];
        if ([citizen.citizen_flag isEqualToString:@"单位"]) {
            caseLawBreaking.lawbreakingreason=[NSString stringWithFormat:@"%@%@%@",citizen.party,citizen.driver,caseInfo.casereason];
        } else {
            caseLawBreaking.lawbreakingreason=[NSString stringWithFormat:@"%@%@",citizen.party,caseInfo.casereason];
        }
    }
    
    //违法事实，默认勘验笔录勘验情况
    CaseProveInfo *caseproveinfo=[CaseProveInfo proveInfoForCase:self.caseID];
    if (caseproveinfo) {
        caseLawBreaking.fact=caseproveinfo.event_desc;
    }
    
    
    //违反法律  下拉框内容从 systype_法律条文 获取
    NSString *lawBreakString = [CaseLaySet getLayWeiFanForCase:self.caseID];
    caseLawBreaking.law_disobey = [lawBreakString stringByTrimmingLeadingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"违反了"]];
    //法律依据  下拉框内容从 systype_法律条文 获取
    NSString *lawBaseString = [CaseLaySet getLayYiJuForCase:self.caseID];
    caseLawBreaking.law_gist = [lawBaseString stringByTrimmingLeadingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"依据"]];
    caseLawBreaking.flag_StatePlea=@"是";
    caseLawBreaking.flag_Listen=@"是";
    
    OrgInfo *orgInfo = [OrgInfo orgInfoForOrgID:caseInfo.organization_id];
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
    caseLawBreaking.linkman = currentUserName;
    caseLawBreaking.link_phone=orgInfo.telephone;
    caseLawBreaking.link_addr=orgInfo.address;
    
    [[AppDelegate App] saveContext];
}

- (NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:xmlName];
        [self drawDateTable:xmlName withDataModel:self.caseLawBreaking];
        UIGraphicsEndPDFContext();
        
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

- (void)viewDidUnload {
    [self setLabelParty:nil];
    [self setLabelCaseCode:nil];
    [self setSegFlag_StatePlea:nil];
    [self setSegFlag_Listen:nil];
    [super viewDidUnload];
}

- (void)generateDefaultAndLoad{
    [self generateDefaultInfo:self.caseLawBreaking];
    [self pageLoadInfo];
}

- (void)deleteCurrentDoc{
    if (![self.caseID isEmpty] && self.caseLawBreaking) {
        [[[AppDelegate App] managedObjectContext] deleteObject:self.caseLawBreaking];
        [[AppDelegate App] saveContext];
        self.caseLawBreaking = nil;
    }
}
@end
