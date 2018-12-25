//
//  CaseProveInfoPrintViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CaseProveInfoPrintViewController.h"
#import "Road.h"
#import "Citizen.h"
#import "CaseDeformation.h"
#import "UserInfo.h"
#import "EmployeeInfo.h"
#import "NormalListSelectController.h"

typedef enum _kUITextFieldTag {
    kUITextFieldTagBase = 0x11,
    kUITextFieldTagProver1,
    kUITextFieldTagProver1Duty,
    kUITextFieldTagProver1Code,
    kUITextFieldTagProver2,
    kUITextFieldTagProver2Duty,
    kUITextFieldTagProver2Code,
    kUITextFieldTagRecorder,
    kUITextFieldTagRecorderDuty,
    kUITextFieldTagRecorderCode
} kUITextFieldTag;

static NSString * const xmlName = @"ProveInfoTable";

@interface CaseProveInfoPrintViewController() <UITextFieldDelegate, NormalListSelectDelegate>
@property (nonatomic, retain) CaseProveInfo *caseProveInfo;
@property (nonatomic, strong) NSArray *employeeNames;
@property (nonatomic, strong) NSArray *employeeDuties;
@property (nonatomic, strong) NSArray *employeeCodes;
- (NSString *)formedEventDescFromCase;
@end

@implementation CaseProveInfoPrintViewController
@synthesize caseID = _caseID;
@synthesize caseProveInfo = _caseProveInfo;
@synthesize textcase_short_desc = _textcase_short_desc;
@synthesize textprover1 = _textprover1;
@synthesize textprover1_duty = _textprover1_duty;
@synthesize textprover2 = _textprover2;
@synthesize textprover2_duty = _textprover2_duty;
@synthesize textprover_place = _textprover_place;
@synthesize textrecorder = _textrecorder;
@synthesize textrecorder_duty = _textrecorder_duty;
@synthesize textinvitee = _textinvitee;
@synthesize textInvitee_org_duty = _textInvitee_org_duty;
@synthesize textorganizer = _textorganizer;
@synthesize textstart_date_time = _textstart_date_time;
@synthesize textend_date_time = _textend_date_time;
@synthesize textparty = _textparty;
@synthesize textparty_sex = _textparty_sex;
@synthesize textparty_age = _textparty_age;
@synthesize textparty_card = _textparty_card;
@synthesize textparty_org_duty = _textparty_org_duty;
@synthesize textparty_tel = _textparty_tel;
@synthesize textevent_desc = _textevent_desc;
@synthesize textprover1_code = _textprover1_code;
@synthesize textprover2_code = _textprover2_code;
@synthesize textrecorder_code = _textrecorder_code;
@synthesize textcitizen_name = _textcitizen_name;
@synthesize textcitizen_sex = _textcitizen_sex;
@synthesize textcitizen_age = _textcitizen_age;
@synthesize textcitizen_no = _textcitizen_no;
@synthesize textcitizen_duty = _textcitizen_duty;
@synthesize textcitizen_address = _textcitizen_address;
@synthesize textcitizen_tel = _textcitizen_tel;


-(void)viewDidLoad{
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:xmlName];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_FRAME_WIDTH, VIEW_FRAME_HEIGHT);
    self.view.frame = viewFrame;
    if (![self.caseID isEmpty]) {
        self.caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        if (self.caseProveInfo == nil) {
            self.caseProveInfo = [CaseProveInfo newDataObject];
            self.caseProveInfo.caseinfo_id = self.caseID;
            [[AppDelegate App] saveContext];
            [self generateDefaultInfo:self.caseProveInfo];            
        }
        [self pageLoadInfo];
    }
    [super viewDidLoad];
    
    //以下语句必须在[super viewDidLoad]之后调用
    //被继承对象的viewDidLoad方法对所有的textfield设置userInteractionEnabled为NO
    //继承对象的viewDidLoad方法再针对特殊的textfield设置userInteractionEnabled为YES
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (caseInfo.isuploaded.boolValue == NO) {
        UIColor *whiteColor = [UIColor whiteColor];
        //勘验（检查）时间
        [self.textstart_date_time setUserInteractionEnabled:YES];
        [self.textend_date_time setUserInteractionEnabled:YES];
        [self.textstart_date_time setBackgroundColor:whiteColor];
        [self.textend_date_time setBackgroundColor:whiteColor];
        //勘验人1
        [self.textprover1 setUserInteractionEnabled:YES];
        [self.textprover1 setBackgroundColor:whiteColor];
        //勘验人2
        [self.textprover2 setUserInteractionEnabled:YES];
        [self.textprover2 setBackgroundColor:whiteColor];
        //记录人
        [self.textrecorder setUserInteractionEnabled:YES];
        [self.textrecorder setBackgroundColor:whiteColor];
    }
    
    self.textprover1.tag = kUITextFieldTagProver1;
    self.textprover1_duty.tag = kUITextFieldTagProver1Duty;
    self.textprover1_code.tag = kUITextFieldTagProver1Code;
    self.textprover2.tag = kUITextFieldTagProver2;
    self.textprover2_duty.tag = kUITextFieldTagProver2Duty;
    self.textprover2_code.tag = kUITextFieldTagProver2Code;
    self.textrecorder.tag = kUITextFieldTagRecorder;
    self.textrecorder_duty.tag = kUITextFieldTagRecorderDuty;
    self.textrecorder_code.tag = kUITextFieldTagRecorderCode;
    
    NSMutableArray *employeeNames = [NSMutableArray array];
    NSMutableArray *employeeDuties = [NSMutableArray array];
    NSMutableArray *employeeCodes = [NSMutableArray array];
    for (EmployeeInfo *employee in [EmployeeInfo allEmployeeInfo]) {
        [employeeNames addObject:employee.name];
        [employeeDuties addObject:[EmployeeInfo orgAndDutyForUserName:employee.name]];
        [employeeCodes addObject:[EmployeeInfo enforceCodeForUserName:employee.name]];
    }
    self.employeeNames = employeeNames;
    self.employeeDuties = employeeDuties;
    self.employeeCodes = employeeCodes;
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
        setViewEnabled(self.textcase_short_desc, NO);    // 案由
    }
}

- (void)pageLoadInfo{
    self.textcase_short_desc.text = self.caseProveInfo.case_short_desc;
    self.textprover1.text = self.caseProveInfo.prover1;
    self.textprover1_duty.text = self.caseProveInfo.prover1_duty;
    self.textprover2.text = self.caseProveInfo.prover2;
    self.textprover2_duty.text = self.caseProveInfo.prover2_duty;
    self.textprover_place.text = self.caseProveInfo.prover_place;
    self.textrecorder.text = self.caseProveInfo.recorder;
    self.textrecorder_duty.text = self.caseProveInfo.recorder_duty;
    self.textinvitee.text = self.caseProveInfo.invitee;
    self.textInvitee_org_duty.text = self.caseProveInfo.invitee_org_duty;
    self.textorganizer.text = self.caseProveInfo.organizer;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.textstart_date_time.text = [dateFormatter stringFromDate:self.caseProveInfo.start_date_time];
    self.textend_date_time.text = [dateFormatter stringFromDate:self.caseProveInfo.end_date_time];
    self.textparty.text = self.caseProveInfo.party;
    self.textparty_sex.text = self.caseProveInfo.party_sex;
    if (self.caseProveInfo.party_age && self.caseProveInfo.party_age.intValue >0) {
        self.textparty_age.text = [NSString stringWithFormat:@"%d",self.caseProveInfo.party_age.intValue];
    }
    self.textparty_card.text = self.caseProveInfo.party_card;
    self.textparty_org_duty.text = self.caseProveInfo.party_org_duty;
    self.textparty_tel.text = self.caseProveInfo.party_tel;
    self.textevent_desc.text = self.caseProveInfo.event_desc;
    self.textprover1_code.text = self.caseProveInfo.prover1_code;
    self.textprover2_code.text = self.caseProveInfo.prover2_code;
    self.textrecorder_code.text = self.caseProveInfo.recorder_code;
    self.textcitizen_name.text = self.caseProveInfo.citizen_name;
    self.textcitizen_sex.text = self.caseProveInfo.citizen_sex;
    self.textcitizen_age.text = [NSString stringWithFormat:@"%d",self.caseProveInfo.citizen_age.intValue];
    self.textcitizen_no.text = self.caseProveInfo.citizen_no;
    self.textcitizen_duty.text = self.caseProveInfo.citizen_duty;
    self.textcitizen_address.text = self.caseProveInfo.citizen_address;
    self.textcitizen_tel.text = self.caseProveInfo.citizen_tel;
}

- (void)pageSaveInfo{
    self.caseProveInfo.case_short_desc = self.textcase_short_desc.text;
    self.caseProveInfo.prover1 = self.textprover1.text;
    self.caseProveInfo.prover1_duty = self.textprover1_duty.text;
    self.caseProveInfo.prover2 = self.textprover2.text;
    self.caseProveInfo.prover2_duty = self.textprover2_duty.text;
    self.caseProveInfo.prover_place = self.textprover_place.text;
    self.caseProveInfo.recorder = self.textrecorder.text;
    self.caseProveInfo.recorder_duty = self.textrecorder_duty.text;
    self.caseProveInfo.invitee = self.textinvitee.text;
    self.caseProveInfo.invitee_org_duty = self.textInvitee_org_duty.text;
    self.caseProveInfo.organizer = self.textorganizer.text;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.caseProveInfo.start_date_time = [dateFormatter dateFromString:self.textstart_date_time.text];
    self.caseProveInfo.end_date_time = [dateFormatter dateFromString:self.textend_date_time.text];
    self.caseProveInfo.party = self.textparty.text;
    self.caseProveInfo.party_sex = self.textparty_sex.text;
    self.caseProveInfo.party_age = @(self.textparty_age.text.integerValue);
    self.caseProveInfo.party_card = self.textparty_card.text;
    self.caseProveInfo.party_org_duty = self.textparty_org_duty.text;
    self.caseProveInfo.party_tel = self.textparty_tel.text;
    self.caseProveInfo.event_desc = self.textevent_desc.text;
    self.caseProveInfo.prover1_code = self.textprover1_code.text;
    self.caseProveInfo.prover2_code = self.textprover2_code.text;
    self.caseProveInfo.recorder_code = self.textrecorder_code.text;
    self.caseProveInfo.citizen_name = self.textcitizen_name.text;
    self.caseProveInfo.citizen_sex = self.textcitizen_sex.text;
    self.caseProveInfo.citizen_age = @(self.textcitizen_age.text.integerValue);
    self.caseProveInfo.citizen_no = self.textcitizen_no.text;
    self.caseProveInfo.citizen_duty = self.textcitizen_duty.text;
    self.caseProveInfo.citizen_address = self.textcitizen_address.text;
    self.caseProveInfo.citizen_tel = self.textcitizen_tel.text;
	[[AppDelegate App] saveContext];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:xmlName];
        [self drawDateTable:xmlName withDataModel:self.caseProveInfo];
        UIGraphicsEndPDFContext();
        
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}


//根据案件记录，完整勘验信息
- (void)generateDefaultInfo:(CaseProveInfo *)caseProveInfo{
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    if (caseProveInfo.start_date_time==nil) {
        caseProveInfo.start_date_time=[NSDate date];
    }
    if (caseProveInfo.end_date_time==nil) {
        caseProveInfo.end_date_time=[NSDate date];
    }
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
    NSArray *inspectorArray = [[NSUserDefaults standardUserDefaults] objectForKey:INSPECTORARRAYKEY];
    if (inspectorArray.count < 1) {
        caseProveInfo.prover1 = currentUserName;
        caseProveInfo.prover1_duty = [EmployeeInfo orgAndDutyForUserName:caseProveInfo.prover1];
        caseProveInfo.prover1_code = [EmployeeInfo enforceCodeForUserName:caseProveInfo.prover1];
    } else if (inspectorArray.count == 1){
        caseProveInfo.prover1 = [inspectorArray objectAtIndex:0];
        caseProveInfo.prover1_duty = [EmployeeInfo orgAndDutyForUserName:caseProveInfo.prover1];
        caseProveInfo.prover1_code = [EmployeeInfo enforceCodeForUserName:caseProveInfo.prover1];
    } else {
        caseProveInfo.prover1 = [inspectorArray objectAtIndex:0];
        caseProveInfo.prover2 = [inspectorArray objectAtIndex:1];
        caseProveInfo.prover1_duty = [EmployeeInfo orgAndDutyForUserName:caseProveInfo.prover1];
        caseProveInfo.prover1_code = [EmployeeInfo enforceCodeForUserName:caseProveInfo.prover1];
        caseProveInfo.prover2_duty = [EmployeeInfo orgAndDutyForUserName:caseProveInfo.prover2];
        caseProveInfo.prover2_code = [EmployeeInfo enforceCodeForUserName:caseProveInfo.prover2];
    }
    caseProveInfo.recorder = currentUserName;
    caseProveInfo.recorder_duty = [EmployeeInfo orgAndDutyForUserName:caseProveInfo.recorder];
    caseProveInfo.recorder_code = [EmployeeInfo enforceCodeForUserName:caseProveInfo.recorder];
    caseProveInfo.organizer = caseInfo.weather;
    caseProveInfo.prover_place = caseInfo.case_address;
    caseProveInfo.case_short_desc = [caseInfo.citizen_name stringByAppendingString:caseInfo.casereason];
    caseProveInfo.citizen_name = caseInfo.citizen_name;
    Citizen *citizen = [Citizen citizenForCase:self.caseID];
    if (citizen) {
	    caseProveInfo.citizen_sex=citizen.sex;
	    caseProveInfo.citizen_age=citizen.age;
	    caseProveInfo.citizen_no=citizen.identity_card;
	    //单位及职务
	    caseProveInfo.citizen_duty=[NSString stringWithFormat:@"%@ %@",citizen.org_name?citizen.org_name:@"",citizen.profession?citizen.profession:@""];
	    caseProveInfo.citizen_address=citizen.address;
	    caseProveInfo.citizen_tel=citizen.tel_number;
    }
    caseProveInfo.event_desc = [self formedEventDescFromCase];
    [[AppDelegate App] saveContext];    
}


- (NSString *)formedEventDescFromCase{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
    NSDate *proveDate;
    if (proveInfo.start_date_time) {
        proveDate = proveInfo.start_date_time;
    } else {
        proveDate = [NSDate date];
    }
    NSString *caseDescString=@"";
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    NSString *happenDate=[dateFormatter stringFromDate:proveDate];
     
    Citizen *citizen = [Citizen citizenForCase:self.caseID];
    if (citizen) {
        NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
        NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
        NSArray *inspectorArray = [[NSUserDefaults standardUserDefaults] objectForKey:INSPECTORARRAYKEY];
        NSString *proverString;
        if (inspectorArray.count < 1) {
            proverString = currentUserName;
        } else if (inspectorArray.count == 1){
            proverString = [inspectorArray objectAtIndex:0];
        } else {
            proverString = [[NSString alloc] initWithFormat:@"%@、%@",[inspectorArray objectAtIndex:0],[inspectorArray objectAtIndex:1]];
        }
        NSString *citizenString;
        if ([citizen.citizen_flag isEqualToString:@"单位"]) {
            citizenString = [[NSString alloc] initWithFormat:@"%@%@",citizen.party,citizen.driver];
        } else {
            citizenString = [[NSString alloc] initWithFormat:@"当事人%@",citizen.party];
        }
        caseDescString = [caseDescString stringByAppendingFormat:@"%@，%@与案件调查人员%@就%@进行了现场勘验、检查。结果如下：",happenDate,citizenString,proverString,[citizen.party stringByAppendingString:caseInfo.casereason]];
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
            //caseDescString=[caseDescString stringByAppendingFormat:@"损害路产%@，损害公路路产价值%@",deformsString,numString];
            caseDescString=[caseDescString stringByAppendingFormat:@"损害路产%@。",deformsString];
        } else {
            caseDescString=[caseDescString stringByAppendingString:@"没有路产损害。"];
        }
    }
    return caseDescString;
}


- (IBAction)reFormEvetDesc:(UIButton *)sender {
    [self pageSaveInfo];
    self.textevent_desc.text = [self formedEventDescFromCase];
}


- (void)generateDefaultAndLoad{
    [self generateDefaultInfo:self.caseProveInfo];
    [self pageLoadInfo];
}

- (BOOL)shouldDocDeleted{
    return NO;
}


#pragma mark - Delegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case kUITextFieldTagProver1:
        case kUITextFieldTagProver2:
        case kUITextFieldTagRecorder:
            [super presentPopverFrom:textField withDataSource:self.employeeNames];
            return NO;
            break;
        default:
        break;
    }
    return YES;
}

- (void)listSelect:(NormalListSelectController *)listSelectController selectedIndexPath:(NSIndexPath *)tableIndexPath
{
    if (self.popoverIndex == kUITextFieldTagProver1) {
        self.textprover1.text = [self.employeeNames objectAtIndex:tableIndexPath.row];
        self.textprover1_duty.text = [self.employeeDuties objectAtIndex:tableIndexPath.row];
        self.textprover1_code.text = [self.employeeCodes objectAtIndex:tableIndexPath.row];
    } else if (self.popoverIndex == kUITextFieldTagProver2) {
        self.textprover2.text = [self.employeeNames objectAtIndex:tableIndexPath.row];
        self.textprover2_duty.text = [self.employeeDuties objectAtIndex:tableIndexPath.row];
        self.textprover2_code.text = [self.employeeCodes objectAtIndex:tableIndexPath.row];
    } else if (self.popoverIndex == kUITextFieldTagRecorder) {
        self.textrecorder.text = [self.employeeNames objectAtIndex:tableIndexPath.row];
        self.textrecorder_duty.text = [self.employeeDuties objectAtIndex:tableIndexPath.row];
        self.textrecorder_code.text = [self.employeeCodes objectAtIndex:tableIndexPath.row];
    }
    [self dismissPopoverAnimated:YES];
}
-(NSURL *)toFormedPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawDateTable:xmlName withDataModel:self.caseProveInfo];
        UIGraphicsEndPDFContext();
        
        return [NSURL fileURLWithPath:formatFilePath];
    } else {
        return nil;
    }
}

@end
