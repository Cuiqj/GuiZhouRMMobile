//
//  AccInfoBriefViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AccInfoBriefViewController.h"
#import "OrgSysType.h"
#import "OrgInfo.h"
#import "UserInfo.h"

typedef enum {
    kStartTime=0,
    kEndTime
} TimeState;

@interface AccInfoBriefViewController ()
@property (nonatomic,retain) UIPopoverController *pickerPopover;
@property (nonatomic,assign) TimeState timeState;
@property (nonatomic,assign) AccInfoPickerState pickerState;
-(void)pickerPresentForState:(AccInfoPickerState)state fromRect:(CGRect)rect;
-(void)saveParkingNodeForCase:(NSString *)caseID;
@end

@implementation AccInfoBriefViewController

@synthesize caseID =_caseID;
@synthesize textreason =_textreason;
@synthesize textCaseType = _textCaseType;
@synthesize labelParkingLocation = _labelParkingLocation;
@synthesize textParkingLocation = _textParkingLocation;
@synthesize labelStartTime = _labelStartTime;
@synthesize textStartTime = _textStartTime;
@synthesize labelEndTime = _labelEndTime;
@synthesize textEndTime = _textEndTime;
@synthesize swithIsParking = _swithIsParking;
@synthesize delegate=_delegate;
@synthesize pickerPopover=_pickerPopover;
@synthesize timeState=_timeState;
@synthesize pickerState = _pickerState;



- (void)viewDidLoad
{
    [self.swithIsParking setOn:NO];
    [self parkingChanged:self.swithIsParking];
    self.textParkingLocation.placeholder = [OrgSysType typeValueForCodeName:@"停车地点"].count>0 ? [[OrgSysType typeValueForCodeName:@"停车地点"] objectAtIndex:0] : @"";
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:animated];
    }
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setLabelParkingLocation:nil];
    [self setTextParkingLocation:nil];
    [self setSwithIsParking:nil];
    [self setTextCaseType:nil];
    [self setLabelStartTime:nil];
    [self setTextStartTime:nil];
    [self setTextEndTime:nil];
    [self setLabelEndTime:nil];
    [self setTextCaseFromInspection:nil];
    [self setTextCaseFromParty:nil];
    [self setTextCaseFromInformer:nil];
    [self setTextCaseFromOther:nil];
    [self setTextCaseFromDepartment:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

//弹窗
-(void)pickerPresentForState:(AccInfoPickerState)state fromRect:(CGRect)rect{
    if ((state == self.pickerState) && ([self.pickerPopover isPopoverVisible])) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        self.pickerState = state;
        AccInfoPickerViewController *acPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"AccInfoPicker"];
        acPicker.pickerType=state;
        acPicker.delegate=self;
        acPicker.caseID=self.caseID;
        _pickerPopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
        [_pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        acPicker.pickerPopover=_pickerPopover;
    }
}

//选择案发原因
- (IBAction)selectCaseReason:(id)sender {
    [self pickerPresentForState:kCaseReason fromRect:[(UITextField*)sender frame]];
}

//选择违章类型
- (IBAction)selectCaseType:(id)sender {
    [self pickerPresentForState:kPeccancyType fromRect:[(UITextField*)sender frame]];
}


//选择起止时间
- (IBAction)selectTime:(id)sender {
    DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
    datePicker.delegate=self;
    datePicker.pickerType=1;
    if ([sender tag]==12) {
        [datePicker showdate:self.textStartTime.text];
        self.timeState=kStartTime;
    } else if ([sender tag]==13) {
        [datePicker showdate:self.textEndTime.text];
        self.timeState=kEndTime;
    }
    self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
    [self.pickerPopover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    datePicker.dateselectPopover=self.pickerPopover;
}

- (IBAction)selectParkingLocation:(id)sender {
    [self pickerPresentForState:kParkingLocation fromRect:[sender frame]];
}

-(void)setDate:(NSString *)date{
    if (self.timeState==kStartTime) {
        self.textStartTime.text=date;
        if ([self.textEndTime.text isEmpty]) {
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSDateComponents *components = [[NSDateComponents alloc] init];
            [components setDay:7];
            NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDate *endDate=[calendar dateByAddingComponents:components toDate:[dateFormatter dateFromString:date] options:0];
            self.textEndTime.text=[dateFormatter stringFromDate:endDate];
        }
    } else {
        self.textEndTime.text=date;
    }
}

//是否停驶
- (IBAction)parkingChanged:(UISwitch *)sender {
    CGFloat alpha=sender.isOn?1.0:0.0;
    [UIView transitionWithView:self.view 
                      duration:0.3
                       options:UIViewAnimationOptionCurveEaseInOut 
                    animations:^{
                        self.labelParkingLocation.alpha=alpha;
                        self.textParkingLocation.alpha=alpha;
                        self.textStartTime.alpha=alpha;
                        self.textEndTime.alpha=alpha;
                        self.labelEndTime.alpha=alpha;
                        self.labelStartTime.alpha=alpha;
                    } 
                    completion:nil];
}

//delegate，将选择文字显示
-(void)setCaseText:(NSString *)aText{
    switch (self.pickerState) {
        case kCaseReason:
            self.textreason.text=aText;
            break;
        case kParkingLocation:
            self.textParkingLocation.text=aText;
            break;
        case kPeccancyType:
            self.textCaseType.text=aText;
            break;
        default:
            break;
    }
}

//将当前页面显示数据保存至该caseID下
-(void)saveDataForCase:(NSString *)caseID{
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:caseID];
    caseInfo.case_reason=_textreason.text;
    caseInfo.peccancy_type=_textCaseType.text;
    caseInfo.case_from_party = self.textCaseFromParty.text;
    caseInfo.case_from_inform = self.textCaseFromInformer.text;
    caseInfo.case_from_department = self.textCaseFromDepartment.text;
    caseInfo.case_from_other = self.textCaseFromOther.text;
    caseInfo.case_from_inspection = self.textCaseFromInspection.text;
    [self saveParkingNodeForCase:caseID];
    [[AppDelegate App] saveContext];
}


//点击textField出现软键盘，为防止软键盘遮挡，上移scrollview
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.delegate scrollViewNeedsMove];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==12 || textField.tag==13) {
        return NO;
    } else {
        return YES;
    }
}

//根据caseID载入相应案件数据
-(void)loadDataForCase:(NSString *)caseID{
    self.caseID=caseID;
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:caseID];
    self.textreason.text=caseInfo.case_reason;
    self.textCaseType.text=caseInfo.peccancy_type;
    self.textCaseFromDepartment.text = caseInfo.case_from_department;
    self.textCaseFromInformer.text = caseInfo.case_from_inform;
    self.textCaseFromInspection.text = caseInfo.case_from_inspection;
    self.textCaseFromOther.text = caseInfo.case_from_other;
    self.textCaseFromParty.text = caseInfo.case_from_party;
    [self loadParkingNodeForCase:caseID];
}


-(void)newDataForCase:(NSString *)caseID{
    self.caseID=caseID;
    for (UITextField *text in [self.view subviews]) {
        if ([text isKindOfClass:[UITextField class]]) {
            text.text=@"";
        }
    }
    [self.swithIsParking setOn:NO];
    [self parkingChanged:self.swithIsParking];
}

-(void)saveParkingNodeForCase:(NSString *)caseID{
    if (self.swithIsParking.isOn) {
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:caseID];
        if (caseInfo && ![caseInfo.citizen_name isEmpty]) {
            if ([self.textParkingLocation.text isEmpty]) {
                self.textParkingLocation.text=self.textParkingLocation.placeholder;
            }
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            if ([self.textStartTime.text isEmpty]) {
                self.textStartTime.text=[dateFormatter stringFromDate:[NSDate date]];
            }
            if ([self.textEndTime.text isEmpty]) {
                NSDateComponents *components = [[NSDateComponents alloc] init];
                [components setDay:7];
                NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDate *endDate=[calendar dateByAddingComponents:components toDate:[dateFormatter dateFromString:self.textStartTime.text] options:0];
                self.textEndTime.text=[dateFormatter stringFromDate:endDate];
            }
            ParkingNode *parkingNode = [ParkingNode parkingNodeForCase:caseID];
            if (parkingNode == nil) {
                parkingNode = [ParkingNode newDataObject];
                parkingNode.caseinfo_id = caseID;
                parkingNode.date_send = [NSDate date];
            }
            parkingNode.park_address = self.textParkingLocation.text;
            parkingNode.date_end = [dateFormatter dateFromString:self.textEndTime.text];
            parkingNode.date_start = [dateFormatter dateFromString:self.textStartTime.text];
            [[AppDelegate App] saveContext];
        }
    } else {
        [ParkingNode deleteAllParkingNodeForCase:caseID];
    }
}

-(void)loadParkingNodeForCase:(NSString *)caseID{
    if (![caseID isEmpty]) {
        ParkingNode *parkingNode = [ParkingNode parkingNodeForCase:caseID];
        if (parkingNode) {
            [self.swithIsParking setOn:YES];
            [self parkingChanged:self.swithIsParking];
            self.textParkingLocation.text=parkingNode.park_address;
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            self.textStartTime.text=[dateFormatter stringFromDate:parkingNode.date_start];
            self.textEndTime.text=[dateFormatter stringFromDate:parkingNode.date_end];
        } else {
            [self.swithIsParking setOn:NO];
            [self parkingChanged:self.swithIsParking];
        }
    } else {
        [self.swithIsParking setOn:NO];
        [self parkingChanged:self.swithIsParking];
    }
}

@end
