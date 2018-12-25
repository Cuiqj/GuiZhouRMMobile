//
//  CitizenInfoBriefViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CitizenInfoBriefViewController.h"
#import "CaseInfo.h"

@interface CitizenInfoBriefViewController ()
@property (nonatomic,retain) UIPopoverController *autoNumberPicker;
@property (nonatomic,assign) AutoNumberPickerType pickerType;
-(void)pickerPresentForIndex:(AutoNumberPickerType)iIndex fromRect:(CGRect)rect;
@end

@implementation CitizenInfoBriefViewController
@synthesize textAutoNumber = _textAutoNumber;
@synthesize textParty = _textParty;
@synthesize textNexus = _textNexus;
@synthesize textSex = _textSex;
@synthesize textAge = _textAge;
@synthesize textCardNO = _textCardNO;
@synthesize textAddress = _textAddress;
@synthesize textProfession = _textProfession;
@synthesize textTelNumber = _textTelNumber;
@synthesize textPostalCode = _textPostalCode;
@synthesize caseID =_caseID;
@synthesize delegate = _delegate;
@synthesize autoNumberPicker =_autoNumberPicker;
@synthesize pickerType = _pickerType;

- (void)viewDidLoad
{
    self.textNexus.text=@"当事人";
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.autoNumberPicker isPopoverVisible]) {
        [self.autoNumberPicker dismissPopoverAnimated:animated];
    }
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setTextAutoNumber:nil];
    [self setTextParty:nil];
    [self setTextSex:nil];
    [self setTextNexus:nil];
    [self setTextAge:nil];
    [self setTextCardNO:nil];
    [self setTextAddress:nil];
    [self setTextProfession:nil];
    [self setTextTelNumber:nil];
    [self setTextPostalCode:nil];
    [self setSegCitizenFlag:nil];
    [self setTextDriver:nil];
    [self setTextDriverTel:nil];
    [self setTextIdentityCard:nil];
    [self setTextDriverAddress:nil];
    [self setTextCarTradeMark:nil];
    [self setTextCarType:nil];
    [self setUiButtonCopy:nil];
    [self setLabelProfession:nil];
    [self setLabelSex:nil];
    [self setLabelAge:nil];
    [self setLabelPostalCode:nil];
    [self setLabelIdentityCard:nil];
    [self setLableAddress:nil];
    [self setLabelTel:nil];
    [self setLabelLegal:nil];
    [self setTextLegal:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


//点击textField出现软键盘，为防止软键盘遮挡，上移scrollview
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.delegate scrollViewNeedsMove];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 1000) {
        return NO;
    } else {
        return YES;
    }
}

- (IBAction)showPicker:(id)sender{
    switch ([(UITextField *)sender tag]) {
        //弹出与当事人关系选择
        case 1008:
            [self pickerPresentForIndex:kNexus fromRect:[(UITextField*)sender frame]];
            break;
        //弹出车辆品牌选择
        case 1013:
            [self pickerPresentForIndex:kCarTradeMark fromRect:[(UITextField*)sender frame]];
            break;
        //弹出车辆类型选择    
        case 1014:
            [self pickerPresentForIndex:kCarType fromRect:[(UITextField*)sender frame]];
            break;
        //弹出职业选择
        case 1001:
            [self pickerPresentForIndex:kProfession fromRect:[sender frame]];
            break;
        default:
            break;
    }
    
}

- (IBAction)citizenFlagSwitch:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:{
            self.labelTel.text = @"联系电话";
            self.lableAddress.text = @"住址";
        }
            break;
        case 1:{
            self.labelTel.text = @"电话";
            self.lableAddress.text = @"地址";
        }
            break;
        default:
            break;
    }
    BOOL show = sender.selectedSegmentIndex;
    [self.labelProfession setHidden:show];
    [self.textProfession setHidden:show];
    [self.uiButtonCopy setHidden:show];
    [self.labelSex setHidden:show];
    [self.textSex setHidden:show];
    [self.labelAge setHidden:show];
    [self.textAge setHidden:show];
    [self.labelPostalCode setHidden:show];
    [self.textPostalCode setHidden:show];
    [self.labelIdentityCard setHidden:show];
    [self.textIdentityCard setHidden:show];
    
    [self.labelLegal setHidden:!show];
    [self.textLegal setHidden:!show];

}


//弹窗
-(void)pickerPresentForIndex:(AutoNumberPickerType)iIndex fromRect:(CGRect)rect{
    if (([self.autoNumberPicker isPopoverVisible]) && (self.pickerType==iIndex)) {
        [self.autoNumberPicker dismissPopoverAnimated:YES];
    } else {
        self.pickerType=iIndex;
        AutoNumerPickerViewController *pickerVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AutoNumberPicker"];
        pickerVC.delegate=self;
        pickerVC.caseID=_caseID;
        pickerVC.pickerType=iIndex;
        self.autoNumberPicker=[[UIPopoverController alloc] initWithContentViewController:pickerVC];
        self.autoNumberPicker.popoverContentSize=CGSizeMake(150, 220);
        [self.autoNumberPicker presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        pickerVC.popOver=self.autoNumberPicker;
    }
}

//显示所选车号
-(void)setAutoNumberText:(NSString *)aAuotNumber{
    switch (self.pickerType) {
        case kProfession:
            self.textProfession.text = aAuotNumber;
            break;
        case kNexus:
            self.textNexus.text = aAuotNumber;
            break;
        case kCarType:
            self.textCarType.text = aAuotNumber;
            break;
        case kCarTradeMark:
            self.textCarTradeMark.text = aAuotNumber;
            break;
        default:
            break;
    }
}


- (IBAction)copyPartyToDriver:(id)sender {
    self.textDriver.text = self.textParty.text;
    self.textNexus.text = @"当事人";
    self.textDriverTel.text = self.textTelNumber.text;
    self.textCardNO.text = self.textIdentityCard.text;
    self.textDriverAddress.text = self.textAddress.text;
}

-(void)saveCitizenInfoForCase:(NSString *)caseID{
    self.caseID=caseID;
    if ([self.textParty.text isEmpty]) {
        self.textParty.text = [self.delegate getCitizenNameDelegate];
    }
    if (![self.textParty.text isEmpty]) {
        Citizen *citizen=[Citizen citizenForCase:caseID];
        if (citizen==nil){
            citizen = [Citizen newDataObject];
            citizen.caseinfo_id=caseID;
        }
        citizen.party=self.textParty.text;
        switch (self.segCitizenFlag.selectedSegmentIndex) {
            case 0:{
                citizen.citizen_flag = @"个人";
                citizen.age=@(self.textAge.text.integerValue);
                citizen.profession=self.textProfession.text;
                citizen.postalcode=self.textPostalCode.text;
                citizen.identity_card = self.textIdentityCard.text;
                switch (self.textSex.selectedSegmentIndex) {
                    case 0:
                        citizen.sex=@"男";
                        break;
                    case 1:
                        citizen.sex=@"女";
                        break;
                    default:
                        break;
                }
            }
                break;
            case 1:{
                citizen.citizen_flag = @"单位";
                citizen.legal_spokesman = self.textLegal.text;
            }
                break;
            default:
                break;
        }

        citizen.address=self.textAddress.text;       
        citizen.tel_number=self.textTelNumber.text;
        
        citizen.driver = self.textDriver.text;
        citizen.driver_relation = self.textNexus.text;
        citizen.driver_tel = self.textDriverTel.text;
        citizen.driver_address = self.textDriverAddress.text;
        citizen.card_no = self.textCardNO.text;
        
        citizen.automobile_number = self.textAutoNumber.text;
        citizen.automobile_pattern = self.textCarType.text;
        citizen.automobile_trademark = self.textCarTradeMark.text;
        [[AppDelegate App] saveContext];
    }
}

-(void)loadCitizenInfoForCase:(NSString *)caseID{
    for (UITextField *text in [self.view subviews]) {
        if ([text isKindOfClass:[UITextField class]]) {
            text.text=@"";
        }
    }
    self.caseID=caseID;
    self.textSex.selectedSegmentIndex=0;
    Citizen *citizen=[Citizen citizenForCase:caseID];
    if (citizen){
        self.textParty.text=citizen.party;
        if ([citizen.citizen_flag isEqualToString:@"单位"]) {
            self.segCitizenFlag.selectedSegmentIndex = 1;
            self.textLegal.text = citizen.legal_spokesman;
        } else if ([citizen.citizen_flag isEqualToString:@"个人"]){
            self.segCitizenFlag.selectedSegmentIndex = 0;
            if([citizen.sex isEqualToString:@"男"]){
                self.textSex.selectedSegmentIndex=0;
            } else if ([citizen.sex isEqualToString:@"女"]) {
                self.textSex.selectedSegmentIndex=1;
            }
            self.textAge.text=(citizen.age.integerValue==0)?@"":[NSString stringWithFormat:@"%d",citizen.age.integerValue];
            self.textProfession.text=citizen.profession;
            self.textTelNumber.text=citizen.tel_number;
            self.textPostalCode.text=citizen.postalcode;
            self.textIdentityCard.text = citizen.identity_card;

        }
        [self citizenFlagSwitch:self.segCitizenFlag];
        
        self.textAddress.text = citizen.address;
        self.textTelNumber.text = citizen.tel_number;
        
        self.textDriver.text = citizen.driver;
        self.textNexus.text = citizen.driver_relation;
        self.textDriverTel.text = citizen.driver_tel;
        self.textDriverAddress.text = citizen.driver_address;
        self.textCardNO.text=citizen.card_no;
        
        self.textAutoNumber.text = citizen.automobile_number;
        self.textCarType.text = citizen.automobile_pattern;
        self.textCarTradeMark.text = citizen.automobile_trademark;
    } else {
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:caseID];
        if (caseInfo) {
            self.textParty.text = caseInfo.citizen_name;
        } else {
            self.textParty.text = [self.delegate getCitizenNameDelegate];
        }
    }
        
}

-(void)newDataForCase:(NSString *)caseID{
    self.caseID=caseID;
    for (UITextField *text in [self.view subviews]) {
        if ([text isKindOfClass:[UITextField class]]) {
            text.text=@"";
        }
    }
    self.textParty.text = [self.delegate getCitizenNameDelegate];
    self.textNexus.text = @"当事人";
}

@end
