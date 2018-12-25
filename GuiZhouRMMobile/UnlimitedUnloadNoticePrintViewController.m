//
//  UnlimitedUnloadNoticePrintViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-29.
//
//

#import "UnlimitedUnloadNoticePrintViewController.h"

static NSString * const xmlName = @"UnlimitedUnloadTable";
@interface UnlimitedUnloadNoticePrintViewController ()
@property (nonatomic, retain) UnlimitedUnloadNotice *unlimitedUnloadNotice;
@end

@implementation UnlimitedUnloadNoticePrintViewController
@synthesize caseID = _caseID;
@synthesize unlimitedUnloadNotice = _unlimitedUnloadNotice;
@synthesize textroadName = _textroadName;
@synthesize textcarNumber = _textcarNumber;
@synthesize textzou = _textzou;
@synthesize textgoods = _textgoods;
@synthesize textweight = _textweight;
@synthesize textunlimit = _textunlimit;
@synthesize textunload = _textunload;
@synthesize textsendDate = _textsendDate;
@synthesize textlimitDate = _textlimitDate;


-(void)viewDidLoad{
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:xmlName];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_SMALL_WIDTH, VIEW_SMALL_HEIGHT);
    self.view.frame = viewFrame;
    if (![self.caseID isEmpty]) {
        self.unlimitedUnloadNotice = [UnlimitedUnloadNotice unlimitedUnloadNoticeForCase:self.caseID];
        if (self.unlimitedUnloadNotice == nil) {
            self.unlimitedUnloadNotice = [UnlimitedUnloadNotice newUnlimitedUnloadNoticeForCase:self.caseID];
            [self generateDefaultInfo:self.unlimitedUnloadNotice];
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
        setViewEnabled(self.textroadName, NO);
        setViewEnabled(self.textcarNumber, NO);
    }
}

- (void)pageLoadInfo{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    NSString *caseCodeFormat = [caseInfo caseCodeFormat];
    self.labelCaseCode.text = [[NSString alloc] initWithFormat:caseCodeFormat,@"卸"];
    self.labelParty.text = caseInfo.citizen_name;
    self.textroadName.text = self.unlimitedUnloadNotice.roadName;
    self.textcarNumber.text = self.unlimitedUnloadNotice.carNumber;
    self.textzou.text = [NSString stringWithFormat:@"%d",self.unlimitedUnloadNotice.zou.intValue];
    self.textgoods.text = self.unlimitedUnloadNotice.goods;
    self.textweight.text = [NSString stringWithFormat:@"%d",self.unlimitedUnloadNotice.weight.intValue];
    self.textunlimit.text = [NSString stringWithFormat:@"%d",self.unlimitedUnloadNotice.unlimit.intValue];
    self.textunload.text = [NSString stringWithFormat:@"%d",self.unlimitedUnloadNotice.unload.intValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.textsendDate.text = [dateFormatter stringFromDate:self.unlimitedUnloadNotice.sendDate];
    self.textlimitDate.text = [dateFormatter stringFromDate:self.unlimitedUnloadNotice.limitDate];
}

- (void)pageSaveInfo{
    self.unlimitedUnloadNotice.roadName = self.textroadName.text;
    self.unlimitedUnloadNotice.carNumber = self.textcarNumber.text;
    self.unlimitedUnloadNotice.zou = @(self.textzou.text.integerValue);
    self.unlimitedUnloadNotice.goods = self.textgoods.text;
    self.unlimitedUnloadNotice.weight = @(self.textweight.text.floatValue);
    self.unlimitedUnloadNotice.unlimit = @(self.textunlimit.text.floatValue);
    self.unlimitedUnloadNotice.unload = @(self.textunload.text.floatValue);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.unlimitedUnloadNotice.sendDate = [dateFormatter dateFromString:self.textsendDate.text];
    self.unlimitedUnloadNotice.limitDate = [dateFormatter dateFromString:self.textlimitDate.text];
    self.unlimitedUnloadNotice.dsrname = self.labelParty.text;
	[[AppDelegate App] saveContext];
}

//根据记录，完整默认值信息
- (void)generateDefaultInfo:(UnlimitedUnloadNotice *)unlimitedUnloadNotice{
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    if (unlimitedUnloadNotice.sendDate==nil) {
        unlimitedUnloadNotice.sendDate=[NSDate date];
    }
    if (unlimitedUnloadNotice.limitDate==nil) {
        unlimitedUnloadNotice.limitDate=[NSDate date];
    }
    
    Citizen *citizen=[Citizen citizenForCase:self.caseID];
    if (citizen) {
        unlimitedUnloadNotice.dsrname=citizen.party;
        unlimitedUnloadNotice.carNumber=citizen.automobile_number;
    }
    
    NSString *codeString = @"";
    switch (caseInfo.case_process_type.integerValue) {
        case 120:{
            codeString = @"罚";
        }
            break;
        case 130:{
            codeString = @"赔";
        }
            break;
        case 140:{
            codeString = @"强";
        }
            break;
        default:
            break;
    }
    NSString *caseCodeFormat = [caseInfo caseCodeFormat];
    codeString = [[NSString alloc] initWithFormat:caseCodeFormat,codeString];
    unlimitedUnloadNotice.ah=codeString;
    //案发地点
    unlimitedUnloadNotice.roadName=caseInfo.case_address;
    
    
    [[AppDelegate App] saveContext];
}


- (NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:xmlName];
        [self drawDateTable:xmlName withDataModel:self.unlimitedUnloadNotice];
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
    [self generateDefaultInfo:self.unlimitedUnloadNotice];
    [self pageLoadInfo];
}

- (void)deleteCurrentDoc{
    if (![self.caseID isEmpty] && self.unlimitedUnloadNotice) {
        [[[AppDelegate App] managedObjectContext] deleteObject:self.unlimitedUnloadNotice];
        [[AppDelegate App] saveContext];
        self.unlimitedUnloadNotice = nil;
    }
}
@end
