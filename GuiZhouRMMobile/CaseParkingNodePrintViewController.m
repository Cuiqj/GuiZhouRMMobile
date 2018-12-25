//
//  CaseParkingNodeViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CaseParkingNodePrintViewController.h"
static NSString * const xmlName = @"ParkingNodeTable";

@interface CaseParkingNodePrintViewController ()
@property (nonatomic, retain) ParkingNode *parkingNode;
- (void)generateDefaultInfo:(ParkingNode *)parkingNode;
@end

@implementation CaseParkingNodePrintViewController
@synthesize caseID = _caseID;
@synthesize parkingNode = _parkingNode;
@synthesize textpark_address = _textpark_address;
@synthesize textdate_start = _textdate_start;
@synthesize textremark = _textremark;
@synthesize textreason = _textreason;
@synthesize textlinkAddress = _textlinkAddress;
@synthesize textlinkMan = _textlinkMan;

@synthesize textcitizen_name = _textcitizen_name;
@synthesize textcitizen_address = _textcitizen_address;
@synthesize textcitizen_tel = _textcitizen_tel;
@synthesize textcitizen_driving_no = _textcitizen_driving_no;
@synthesize textcitizen_car_property = _textcitizen_car_property;
@synthesize textcitizen_automobile_trademark = _textcitizen_automobile_trademark;
@synthesize textcitizen_happen_address = _textcitizen_happen_address;

-(void)viewDidLoad{
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:xmlName];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_SMALL_WIDTH, VIEW_SMALL_HEIGHT);
    self.view.frame = viewFrame;
    if (![self.caseID isEmpty]) {
        self.parkingNode = [ParkingNode parkingNodeForCase:self.caseID];
        if (self.parkingNode) {
            if (self.parkingNode.citizen_name == nil) {
                [self generateDefaultInfo:self.parkingNode];
            }
            [self pageLoadInfo];
        }        
    }
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // do something below
    
    [super viewWillDisappear:animated];
}
- (void)viewDidUnload
{
    [self setLabelCaseCode:nil];
    [self setLinkTel:nil];
    [self setLabelCitizenName:nil];
    [self setLabelHappenDate:nil];
    [self setLabelAutoNumber:nil];
    [self setTextDateSend:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)initControlsInteraction
{
    [super initControlsInteraction];
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (!caseInfo.isuploaded.boolValue) {
        setViewEnabled(self.textlinkAddress, YES);       // 执法机构地址
        setViewEnabled(self.textlinkMan, YES);           // 联系人
        setViewEnabled(self.linkTel, YES);               // 联系电话
        setViewEnabled(self.textDateSend, YES);          // 下达日期
    }
}


- (void)pageLoadInfo{
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    Citizen *citizen = [Citizen citizenForCase:self.caseID];
    
    NSString *caseCodeFormat = [caseInfo caseCodeFormat];
    self.labelCaseCode.text = [[NSString alloc] initWithFormat:caseCodeFormat,@"责停"];
    
    self.textpark_address.text = self.parkingNode.park_address;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.textdate_start.text = [dateFormatter stringFromDate:self.parkingNode.date_start];

    self.labelCitizenName.text = citizen.driver;
    self.labelAutoNumber.text = citizen.automobile_number;
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    self.textDateSend.text = [dateFormatter stringFromDate:self.parkingNode.date_send];
    self.labelHappenDate.text = [dateFormatter stringFromDate:caseInfo.happen_date];
    self.textremark.text = self.parkingNode.remark;

    self.textreason.text = self.parkingNode.reason;
    self.textlinkAddress.text = self.parkingNode.linkAddress;
    self.textlinkMan.text = self.parkingNode.linkMan;
    self.textcitizen_happen_address.text = self.parkingNode.citizen_happen_address;
    self.textcitizen_name.text = self.parkingNode.citizen_name;
    self.textcitizen_address.text = self.parkingNode.citizen_address;
    self.textcitizen_tel.text = self.parkingNode.citizen_tel;
    self.textcitizen_driving_no.text = self.parkingNode.citizen_driving_no;
    self.textcitizen_car_property.text = self.parkingNode.citizen_car_property;
    self.textcitizen_automobile_trademark.text = self.parkingNode.citizen_automobile_trademark;
    self.linkTel.text = self.parkingNode.linkTel;

}

- (void)pageSaveInfo{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.parkingNode.date_start = [dateFormatter dateFromString:self.textdate_start.text];
    
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    self.parkingNode.date_send = [dateFormatter dateFromString:self.textDateSend.text];
    self.parkingNode.park_address = self.textpark_address.text;
    
    self.parkingNode.remark = self.textremark.text;
    self.parkingNode.reason = self.textreason.text;
    self.parkingNode.linkAddress = self.textlinkAddress.text;
    self.parkingNode.linkMan = self.textlinkMan.text;
    self.parkingNode.citizen_name = self.textcitizen_name.text;
    self.parkingNode.citizen_address = self.textcitizen_address.text;
    self.parkingNode.citizen_tel = self.textcitizen_tel.text;
    self.parkingNode.citizen_driving_no = self.textcitizen_driving_no.text;
    self.parkingNode.citizen_car_property = self.textcitizen_car_property.text;
    self.parkingNode.citizen_automobile_trademark = self.textcitizen_automobile_trademark.text;
    self.parkingNode.citizen_happen_address = self.textcitizen_happen_address.text;
    self.parkingNode.linkTel = self.linkTel.text;
	[[AppDelegate App] saveContext];
}

-(NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:xmlName];
        [self drawDateTable:xmlName withDataModel:self.parkingNode];
        UIGraphicsEndPDFContext();
        
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

- (void)generateDefaultInfo:(ParkingNode *)parkingNode{
    Citizen *citizen=[Citizen citizenForCase:self.caseID];
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    if (citizen) {
        parkingNode.citizen_name=citizen.driver;
        parkingNode.citizen_address=citizen.driver_address;
        parkingNode.citizen_tel=citizen.driver_tel;
        parkingNode.citizen_driving_no=citizen.card_no;
        parkingNode.citizen_car_property=citizen.automobile_number;
        parkingNode.citizen_automobile_trademark=[NSString stringWithFormat:@"%@%@",citizen.automobile_trademark?citizen.automobile_trademark:@"" , citizen.automobile_pattern?citizen.automobile_pattern:@""];
    }
    
    //案由 reason
    parkingNode.reason=[caseInfo.casereason stringByReplacingOccurrencesOfString:@"涉嫌" withString:@""];
    //案发地点
    parkingNode.citizen_happen_address=caseInfo.case_address;
    
    OrgInfo *orgInfo = [OrgInfo orgInfoForOrgID:caseInfo.organization_id];
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
    
    parkingNode.linkMan=currentUserName;
    parkingNode.linkTel=orgInfo.telephone;
    //接受处理机关名称及地址
    //parkingNode.linkAddress=[[NSString alloc] initWithFormat:@"%@%@",orgInfo.orgname?orgInfo.orgname:@"",orgInfo.address?orgInfo.address:@""];
    parkingNode.linkAddress=[[NSString alloc] initWithFormat:@"%@", orgInfo.address?orgInfo.address:@""];
    [[AppDelegate App] saveContext];
}

- (void)generateDefaultAndLoad{
    [self generateDefaultInfo:self.parkingNode];
    [self pageLoadInfo];
}

- (BOOL)shouldDocDeleted{
    return NO;
}

- (BOOL)shouldGenereateDefaultDoc{
    if (self.parkingNode) {
        return YES;
    } else
        return NO;
}
@end
