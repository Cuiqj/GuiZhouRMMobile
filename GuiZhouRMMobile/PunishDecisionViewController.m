//
//  PunishDecisionViewController.m
//  GuiZhouRMMobile
//
//  Created by Sniper One on 13-1-3.
//
//

#import "PunishDecisionViewController.h"
#import "OrgSysType.h"

static NSString * const xmlName = @"PunishDecisionTable";

@interface PunishDecisionViewController ()
@property (nonatomic, retain) PunishDecision *punishDecision;
@end

@implementation PunishDecisionViewController

@synthesize caseID = _caseID;
@synthesize punishDecision = _punishDecision;
@synthesize labelCitizen = _labelCitizen;
@synthesize labelCasecode = _labelCasecode;
@synthesize textsend_date = _textsend_date;
@synthesize textorganization = _textorganization;
@synthesize textaccount_number = _textaccount_number;
@synthesize textcase_desc = _textcase_desc;
@synthesize textlaw_disobey = _textlaw_disobey;
@synthesize textlaw_gist = _textlaw_gist;

@synthesize textpunish_decision = _textpunish_decision;
@synthesize textwitness = _textwitness;
@synthesize textpunish_other = _textpunish_other;

@synthesize textpunishreason = _textpunishreason;


-(void)viewDidLoad{
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:xmlName];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_SMALL_WIDTH, VIEW_SMALL_HEIGHT);
    self.view.frame = viewFrame;
    if (![self.caseID isEmpty]) {
        self.punishDecision = [PunishDecision punishDecisionForCase:self.caseID];
        if (self.punishDecision == nil) {
            self.punishDecision = [PunishDecision newPunishDecisionForCase:self.caseID];
            [self generateDefaultInfo:self.punishDecision];
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
        setViewEnabled(self.textpunish_other, NO);
        setViewEnabled(self.textpunishreason, NO);
    }
}

- (void)pageLoadInfo{
    self.textorganization.text = self.punishDecision.organization;
    self.textaccount_number.text = self.punishDecision.account_number;
    
    Citizen *citizen = [Citizen citizenForCase:self.caseID];
    if (citizen) {
        self.labelCitizen.text = citizen.party;
    }
    
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    NSString *caseCodeFormat = [caseInfo caseCodeFormat];
    self.labelCasecode.text = [[NSString alloc] initWithFormat:caseCodeFormat,@"罚"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.textsend_date.text = [dateFormatter stringFromDate:self.punishDecision.send_date];

    self.textcase_desc.text = self.punishDecision.case_desc;
    self.textlaw_disobey.text = self.punishDecision.law_disobey;
    self.textlaw_gist.text = self.punishDecision.law_gist;

    self.textpunish_decision.text = self.punishDecision.punish_decision;
    self.textwitness.text = self.punishDecision.witness;
    self.textpunish_other.text = self.punishDecision.punish_other;

    self.textpunishreason.text = self.punishDecision.punishreason;

}

- (void)pageSaveInfo{

    self.punishDecision.organization = self.textorganization.text;
    self.punishDecision.account_number = self.textaccount_number.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.punishDecision.send_date = [dateFormatter dateFromString:self.textsend_date.text];
    
    self.punishDecision.case_desc = self.textcase_desc.text;
    self.punishDecision.law_disobey = self.textlaw_disobey.text;
    self.punishDecision.law_gist = self.textlaw_gist.text;

    self.punishDecision.punish_decision = self.textpunish_decision.text;


    self.punishDecision.citizen_id = self.labelCitizen.text;
    self.punishDecision.immediately = Punish_In15Days_String;
    self.punishDecision.witness = self.textwitness.text;
    self.punishDecision.punish_other = self.textpunish_other.text;
    self.punishDecision.punishreason = self.textpunishreason.text;
	[[AppDelegate App] saveContext];
}

//根据记录，完整默认值信息
- (void)generateDefaultInfo:(PunishDecision *)punishDecision{
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    if (punishDecision.send_date==nil) {
        punishDecision.send_date=[NSDate date];
    }
    
    Citizen *citizen = [Citizen citizenForCase:self.caseID];
    if (citizen) {
        punishDecision.citizen_id=citizen.party;
        punishDecision.punish_other=citizen.address;
        punishDecision.punish_decision=[NSString stringWithFormat:@"%@罚款  元的处罚决定",citizen.party];
    }
    
    //违法事实 默认值为 勘验笔录的案件描述
    CaseLawBreaking *caseLawBreaking = [CaseLawBreaking caseLawBreakingForCase:self.caseID];
    if (caseLawBreaking) {
        punishDecision.case_desc = caseLawBreaking.fact;
        punishDecision.punish_decision = caseLawBreaking.punish_mode;
        punishDecision.law_disobey = caseLawBreaking.law_disobey;
        punishDecision.law_gist = caseLawBreaking.law_gist;
        
        punishDecision.punishreason = [caseLawBreaking.lawbreakingreason stringByReplacingOccurrencesOfString:@"涉嫌" withString:@""];
    } else {
        CaseProveInfo *caseproveinfo=[CaseProveInfo proveInfoForCase:self.caseID];
        if (caseproveinfo) {
            punishDecision.case_desc=caseproveinfo.event_desc;
        }
        //违反法律条文 下拉框内容从 systype_法律条文 获取
        punishDecision.law_disobey=[CaseLaySet getLayWeiFanForCase:self.caseID];
        //依据法律条文 下拉框内容从 systype_法律条文 获取
        punishDecision.law_gist=[CaseLaySet getLayYiJuForCase:self.caseID];
        //案由 reason   不带“涉嫌”
        punishDecision.punishreason = [caseInfo.casereason stringByReplacingOccurrencesOfString:@"涉嫌" withString:@""];
    }

    punishDecision.witness=@"勘查笔录、询问笔录、现场勘验草图、现场照片";
    
    NSArray *deformArray=[CaseDeformation allDeformationsForCase:self.caseID];
    double summary=[[deformArray valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
    
    punishDecision.punish_sum=@(summary);
    //交款地点 从orgsystype中获取code_name='交款地点' and org_id=当前机构id
    punishDecision.organization = [[OrgSysType typeValueForCodeName:@"交款地点"] lastObject];
    //银行账号 从orgsystype中获取code_name='银行帐号' and org_id=当前机构id
    punishDecision.account_number = [[OrgSysType typeValueForCodeName:@"银行帐号"] lastObject];

    //以下为当场处罚：
    //罚款履行方式  systype_罚款履行方式
    punishDecision.immediately = Punish_In15Days_String;
    
    
    [[AppDelegate App] saveContext];
}

- (NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:xmlName];
        [self drawDateTable:xmlName withDataModel:self.punishDecision];
        UIGraphicsEndPDFContext();
        
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

- (void)viewDidUnload {
    [self setLabelCasecode:nil];
    [self setLabelCitizen:nil];
    [self setTextsend_date:nil];
    [super viewDidUnload];
}

- (void)generateDefaultAndLoad{
    [self generateDefaultInfo:self.punishDecision];
    [self pageLoadInfo];
}

- (void)deleteCurrentDoc{
    if (![self.caseID isEmpty] && self.punishDecision) {
        [[[AppDelegate App] managedObjectContext] deleteObject:self.punishDecision];
        [[AppDelegate App] saveContext];
        self.punishDecision = nil;
    }
}
@end
