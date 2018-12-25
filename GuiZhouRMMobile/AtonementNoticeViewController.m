//
//  AtonementNoticeViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-23.
//
//

#import "AtonementNoticeViewController.h"
#import "CaseCountDetail.h"
#import "CaseCount.h"

static NSString * const xmlName = @"AtonementNoticeTable";

@interface AtonementNoticeViewController ()
@property (nonatomic, retain) AtonementNotice *atonementNotice;

- (NSString *)formedEventDescFromCase;
@end

@implementation AtonementNoticeViewController
@synthesize caseID = _caseID;
@synthesize atonementNotice = _atonementNotice;
@synthesize textdate_send = _textdate_send;
@synthesize textcase_desc = _textcase_desc;
@synthesize textwitness = _textwitness;
@synthesize textpay_mode = _textpay_mode;
@synthesize textpay_real = _textpay_real;
@synthesize textlaw_zhan = _textlaw_zhan;
@synthesize textatonementreason = _textatonementreason;
@synthesize textlinkAddress = _textlinkAddress;
@synthesize textlinkMan = _textlinkMan;
@synthesize textlinkTel = _textlinkTel;
@synthesize textfixed_legal = _textfixed_legal;

- (void)viewDidLoad 
{
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:xmlName];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_FRAME_WIDTH, VIEW_FRAME_HEIGHT);
    self.view.frame = viewFrame;
    if (![self.caseID isEmpty]) {
        self.atonementNotice = [AtonementNotice atonementNoticeForCase:self.caseID];
        if (self.atonementNotice == nil) {
            self.atonementNotice = [AtonementNotice newAtonementNoticeForCase:self.caseID];
            [self generateDefaultInfo:self.atonementNotice];
        } 
        [self pageLoadInfo];
    }
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    // do something below
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setLabelCaseCode:nil];
    [self setTextParty:nil];
    [self setTextPartyAddress:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)initControlsInteraction
{
    
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (caseInfo.isuploaded.boolValue) {
        [super initControlsInteraction];
    } else {
        setViewEnabled(self.textParty, NO);
        setViewEnabled(self.textPartyAddress, NO);
        setViewEnabled(self.textatonementreason, NO);
    }
}

- (NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:xmlName];
        [self drawDateTable:xmlName withDataModel:self.atonementNotice];

        UIGraphicsEndPDFContext();
        
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

- (void)pageLoadInfo{
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    Citizen *citizen = [Citizen citizenForCase:self.caseID];
    if (citizen) {
        self.textParty.text = citizen.party;
        self.textPartyAddress.text = citizen.address;
    }
    
    NSString *caseCodeFormat = [caseInfo caseCodeFormat];
    self.labelCaseCode.text = [[NSString alloc] initWithFormat:caseCodeFormat,@"赔"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.textdate_send.text = [dateFormatter stringFromDate:self.atonementNotice.date_send];
    
    self.textcase_desc.text = self.atonementNotice.case_desc;
    self.textwitness.text = self.atonementNotice.witness;

    self.textpay_mode.text = self.atonementNotice.pay_mode;

    self.textpay_real.text = [NSString stringWithFormat:@"%.2f",self.atonementNotice.pay_real.floatValue];
    self.textlaw_zhan.text = self.atonementNotice.law_zhan;

    self.textatonementreason.text = self.atonementNotice.atonementreason;
    self.textlinkAddress.text = self.atonementNotice.linkAddress;
    self.textlinkMan.text = self.atonementNotice.linkMan;
    self.textlinkTel.text = self.atonementNotice.linkTel;

    self.textfixed_legal.text = self.atonementNotice.fixed_legal;

}

- (void)pageSaveInfo{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.atonementNotice.date_send = [dateFormatter dateFromString:self.textdate_send.text];
    self.atonementNotice.case_desc = self.textcase_desc.text;
    self.atonementNotice.witness = self.textwitness.text;

    self.atonementNotice.pay_mode = self.textpay_mode.text;

    self.atonementNotice.pay_real = @(self.textpay_real.text.floatValue);
    
    self.atonementNotice.law_zhan = self.textlaw_zhan.text;

    self.atonementNotice.atonementreason = self.textatonementreason.text;
    self.atonementNotice.linkAddress = self.textlinkAddress.text;
    self.atonementNotice.linkMan = self.textlinkMan.text;
    self.atonementNotice.linkTel = self.textlinkTel.text;

    self.atonementNotice.fixed_legal = self.textfixed_legal.text;

	[[AppDelegate App] saveContext];
}



//根据记录，完整默认值信息
- (void)generateDefaultInfo:(AtonementNotice *)atonementNotice{
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    if (atonementNotice.date_send==nil) {
        atonementNotice.date_send=[NSDate date];
    }
    if (atonementNotice.caseDeformationSendDate==nil) {
        atonementNotice.caseDeformationSendDate=[NSDate date];
    }
    atonementNotice.case_desc=[self formedEventDescFromCase];
    
    atonementNotice.witness=@"《询问笔录》、《勘验（检查）笔录》、《现场勘查平面示意图》、《现场照片》";
    
    NSArray *deformArray=[CaseCountDetail allCaseCountDetailsForCase:self.caseID];
    double summary=[[deformArray valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
    NSNumber *sumNum = @(summary);
    NSString *numString = [sumNum numberConvertToChineseCapitalNumberString];
    
    atonementNotice.pay_mode = numString;
    
    atonementNotice.pay_real = sumNum;
    
    atonementNotice.law_pei = @"第一（一）8项；第 一（四）6、14（2）";
    
    if (deformArray.count > 0) {
        NSString *deformTemp = @"";
        for (CaseDeformation *deform in deformArray) {
            NSString *depart_num = deform.depart_num;
            if (depart_num && ![depart_num isEmpty]) {
                deformTemp = [deformTemp stringByAppendingFormat:@"%@、",depart_num];
            }
        }
        deformTemp = [deformTemp stringByTrimmingTrailingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"、"]];
        atonementNotice.law_zhan = [[NSString alloc] initWithFormat:@"《贵州省公路路产损害赔（补）偿收费项目及标准》%@",deformTemp];
    }
    
    atonementNotice.fixed_legal=@"《贵州省公路路政管理条例》第三十八条";
    OrgInfo *orgInfo = [OrgInfo orgInfoForOrgID:caseInfo.organization_id];
    atonementNotice.linkAddress=orgInfo.address;
    atonementNotice.linkMan=orgInfo.linkman;
    atonementNotice.linkTel=orgInfo.telephone;
    //案由
    Citizen *citizen=[Citizen citizenForCase:self.caseID];
    if (citizen) {
        NSString *citizenString;
        if ([citizen.citizen_flag isEqualToString:@"单位"]) {
            citizenString = [[NSString alloc] initWithFormat:@"%@%@",citizen.party,citizen.driver];
        } else {
            citizenString = [[NSString alloc] initWithFormat:@"%@",citizen.party];
        }
        CaseCount *caseCount = [CaseCount caseCountForCase:self.caseID];
        if (caseCount) {
            atonementNotice.atonementreason = [NSString stringWithFormat:@"%@%@",citizenString,caseCount.caseCountReason];
        } else {
            atonementNotice.atonementreason=[NSString stringWithFormat:@"%@%@",citizenString,[caseInfo.casereason stringByReplacingOccurrencesOfString:@"涉嫌" withString:@""]];
        }
    }
    [[AppDelegate App] saveContext];
}

- (NSString *)formedEventDescFromCase{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    NSString *caseDescString=@"";
    
    //获取赔补偿通知书组话
    NSString *roadName=[Road roadNameFromID:caseInfo.roadsegment_id];

    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    NSString *happenDate=[dateFormatter stringFromDate:caseInfo.happen_date];
    
    NSNumberFormatter *numFormatter=[[NSNumberFormatter alloc] init];
    [numFormatter setPositiveFormat:@"000"];
    NSInteger stationStartM=caseInfo.station_start.integerValue%1000;
    NSString *stationStartKMString=[NSString stringWithFormat:@"%d", caseInfo.station_start.integerValue/1000];
    NSString *stationStartMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationStartM]];
    NSString *stationString;
    if (caseInfo.station_end.integerValue == 0 || caseInfo.station_end.integerValue == caseInfo.station_start.integerValue  ) {
        stationString=[NSString stringWithFormat:@"%@+%@公里处",stationStartKMString,stationStartMString];
    } else {
        NSInteger stationEndM=caseInfo.station_end.integerValue%1000;
        NSString *stationEndKMString=[NSString stringWithFormat:@"%d",caseInfo.station_end.integerValue/1000];
        NSString *stationEndMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationEndM]];
        stationString=[NSString stringWithFormat:@"%@+%@公里至%@+%@公里处",stationStartKMString,stationStartMString,stationEndKMString,stationEndMString ];
    }
    
    Citizen *citizen = [Citizen citizenForCase:self.caseID];
    if (citizen) {
        NSString *citizenString;
        if ([citizen.citizen_flag isEqualToString:@"单位"]) {
            citizenString = [[NSString alloc] initWithFormat:@"%@%@",citizen.party,citizen.driver];
        } else {
            citizenString = [[NSString alloc] initWithFormat:@"当事人%@",citizen.party];
        }
        caseDescString=[caseDescString stringByAppendingFormat:@"%@于%@，驾驶车牌号为%@的%@途径%@%@%@时，在公路%@由于%@发生交通事故，",citizenString,happenDate,citizen.automobile_number?citizen.automobile_number:@" ",citizen.automobile_pattern?citizen.automobile_pattern:@" ",roadName,caseInfo.side,stationString,caseInfo.place,caseInfo.case_reason?caseInfo.case_reason:@" "];
        NSArray *deformArray=[CaseDeformation allDeformationsForCase:self.caseID];
        if (deformArray.count>0) {
            NSString *deformsString=@"";
            for (CaseDeformation *deform in deformArray) {
                NSString *roadSizeString=[deform.rasset_size stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if ([roadSizeString isEmpty]) {
                    roadSizeString=@"";
                } else {
                    roadSizeString=[NSString stringWithFormat:@"（%@）",roadSizeString];
                }
                NSString *remarkString=[deform.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if ([remarkString isEmpty]) {
                    remarkString=@"";
                } else {
                    remarkString=[NSString stringWithFormat:@"（%@）",remarkString];
                }
                NSString *quantity=[[NSString alloc] initWithFormat:@"%.2f",deform.quantity.floatValue];
                NSCharacterSet *zeroSet=[NSCharacterSet characterSetWithCharactersInString:@".0"];
                quantity=[quantity stringByTrimmingTrailingCharactersInSet:zeroSet];
                deformsString=[deformsString stringByAppendingFormat:@"、%@%@%@%@%@",deform.roadasset_name,roadSizeString,quantity,deform.unit,remarkString];
            }
            NSCharacterSet *charSet=[NSCharacterSet characterSetWithCharactersInString:@"、"];
            deformsString=[deformsString stringByTrimmingCharactersInSet:charSet];
            double summary=[[deformArray valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
            NSNumber *sumNum = @(summary);
            NSString *numString = [sumNum numberConvertToChineseCapitalNumberString];
            numString = [NSString stringWithFormat:@"%@（￥%.2f元）",numString,summary];
            caseDescString=[caseDescString stringByAppendingFormat:@"造成%@被损害，损害的公路路产价值为%@",deformsString,numString];
        } else {
            caseDescString=[caseDescString stringByAppendingString:@"没有路产损害。"];
        }
    }
    return caseDescString;
}

- (IBAction)btnFormEventDesc:(id)sender {
    [self pageSaveInfo];
    self.textcase_desc.text = [self formedEventDescFromCase];
}

- (void)generateDefaultAndLoad{
    [self generateDefaultInfo:self.atonementNotice];
    [self pageLoadInfo];
}

- (void)deleteCurrentDoc{
    if (![self.caseID isEmpty] && self.atonementNotice) {
        [[[AppDelegate App] managedObjectContext] deleteObject:self.atonementNotice];
        [[AppDelegate App] saveContext];
        self.atonementNotice = nil;
    }
}
@end
