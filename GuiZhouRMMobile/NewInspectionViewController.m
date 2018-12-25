//
//  NewInspectionViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-9-5.
//
//

#import "NewInspectionViewController.h"
#import "OrgInfo.h"
#import "Road.h"
#import "UserInfo.h"

@interface NewInspectionViewController ()
@property (nonatomic,retain) UIPopoverController *pickerPopover;


//标识符，用于判断当前用户弹窗输入框是记录人或者巡查人
@property (nonatomic,assign) BOOL isRecorder;

@end

@implementation NewInspectionViewController

@synthesize textRecorder;
@synthesize viewPath;
@synthesize viewInspectorName;

@synthesize textDate;
@synthesize textAutoNumber;
@synthesize textWeather;
@synthesize delegate;
@synthesize pickerState;
@synthesize pickerPopover;
@synthesize isRecorder;

- (void)viewDidLoad
{
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
    self.textRecorder.text = currentUserName;
    NSArray *inspectorArray = [[NSUserDefaults standardUserDefaults] objectForKey:INSPECTORARRAYKEY];
    if (inspectorArray.count < 1) {
        self.viewInspectorName.text = currentUserName;
    } else {
        NSString *inspectorName = @"";
        for (NSString *name in inspectorArray) {
            if ([inspectorName isEmpty]) {
                inspectorName = name;
            } else {
                inspectorName = [inspectorName stringByAppendingFormat:@"、%@",name];
            }
            self.viewInspectorName.text = inspectorName;
        }
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString=[dateFormatter stringFromDate:[NSDate date]];
    self.textDate.text=dateString;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
//    [self setInputView:nil];
//    [self setTableCheckItems:nil];
//    [self setPickerCheckItemDetails:nil];
//    [self setTextDetail:nil];
    [self setTextDate:nil];
    [self setTextAutoNumber:nil];
    [self setTextWeather:nil];
//    [self setTextWorkShift:nil];
    [self setDelegate:nil];
    [self setPickerPopover:nil];
//    [self setTextViewDeliverText:nil];
    [self setTextRecorder:nil];
    [self setViewPath:nil];
    [self setViewInspectorName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


#pragma mark - IBActions
- (IBAction)btnAddInspector:(UIButton *)sender {
    [self pickerPresentPickerState:kUser fromRect:sender.frame];
    self.isRecorder = NO;
}

- (IBAction)btnAddRoad:(UIButton *)sender {
    [self pickerPresentPickerState:kRoad fromRect:sender.frame];
}

- (IBAction)btnCancel:(UIBarButtonItem *)sender {
    [self.delegate popBackToMainView];
    [self dismissModalViewControllerAnimated:NO];    
}

- (IBAction)btnSave:(UIBarButtonItem *)sender {
    BOOL isBlank=NO;
    for (UITextField *textField in self.view.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            if ([textField.text isEmpty]) {
                isBlank=YES;
            }
        }
    }
    if (!isBlank) {
        NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"Inspection" inManagedObjectContext:context];
        Inspection *newInspection=[[Inspection alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        NSString *newInspectionID=[NSString randomID];
        newInspection.inspection_id=newInspectionID;
        [[NSUserDefaults standardUserDefaults] setValue:newInspectionID forKey:INSPECTIONKEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        [formatter setLocale:[NSLocale currentLocale]];
        newInspection.date_inspection=[formatter dateFromString:self.textDate.text];
        newInspection.weather=self.textWeather.text;
        newInspection.carcode=self.textAutoNumber.text;
        newInspection.recorder_name = self.textRecorder.text;
        newInspection.inspectionor_name = self.viewInspectorName.text;
        newInspection.isdeliver=@(NO);
        NSString *currentOrg=[[NSUserDefaults standardUserDefaults] stringForKey:ORGKEY];
        newInspection.organization_id = currentOrg;
        NSString *currentOrgName = [[OrgInfo orgInfoForOrgID:currentOrg] valueForKey:@"orgname"];
        newInspection.orgname = currentOrgName;
        newInspection.inspection_line = self.viewPath.text;
        NSArray *roadTemp = [self.viewPath.text componentsSeparatedByString:@","];
        NSString *roadIDs = @"";
        for (NSString *temp in roadTemp) {
            NSManagedObjectContext *context = [[AppDelegate App] managedObjectContext];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Road" inManagedObjectContext:context];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@",temp]];
            if ([context countForFetchRequest:fetchRequest error:nil]>0) {
                Road *roadInfo = [[context executeFetchRequest:fetchRequest error:nil] objectAtIndex:0];
                if ([roadIDs isEmpty]) {
                    roadIDs = roadInfo.road_id;
                } else {
                    roadIDs = [roadIDs stringByAppendingFormat:@",%@", roadInfo.road_id];
                }
            }
        }
        newInspection.roadsegment_ids = roadIDs;
        [[AppDelegate App] saveContext];
        [self.delegate setInspectionDelegate:newInspectionID];
        [self dismissModalViewControllerAnimated:YES];        
    }
}


- (IBAction)textTouch:(UITextField *)sender {
    switch (sender.tag) {
        case 100:{
            //时间选择
            if ([self.pickerPopover isPopoverVisible]) {
                [self.pickerPopover dismissPopoverAnimated:YES];
            } else {
                DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
                datePicker.delegate=self;
                datePicker.pickerType=0;
                [datePicker showdate:self.textDate.text];
                self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
                [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                datePicker.dateselectPopover=self.pickerPopover;
            }
        }
            break;
        case 101:
            [self pickerPresentPickerState:kWeatherPicker fromRect:sender.frame];
            break;
        case 102:
            [self pickerPresentPickerState:kAutoNumber fromRect:sender.frame];
            break;
        case 104:{
            [self pickerPresentPickerState:kUser fromRect:sender.frame];
            self.isRecorder = YES;
        }
            break;
        default:
            break;
    }    
}

#pragma mark - InspectionPicker Delegate
- (void)setCheckText:(NSString *)checkText{
    switch (pickerState) {
        case kAutoNumber:
            self.textAutoNumber.text=checkText;
            break;
        case kWeatherPicker:
            self.textWeather.text=checkText;
            break;
        case kRoad:{
            if ([self.viewPath.text isEmpty]) {
                self.viewPath.text = checkText;
            } else {
                self.viewPath.text = [self.viewPath.text stringByAppendingFormat:@",%@",checkText];
            }
        }
            break;
        case kUser:{
            if (self.isRecorder) {
                self.textRecorder.text = checkText;
            } else {
                if ([self.viewInspectorName.text isEmpty]) {
                    self.viewInspectorName.text = checkText;
                } else {
                    self.viewInspectorName.text = [self.viewInspectorName.text stringByAppendingFormat:@"、%@",checkText];
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)setDate:(NSString *)date{    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *temp=[dateFormatter dateFromString:date];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString=[dateFormatter stringFromDate:temp];
    self.textDate.text=dateString;
}

//弹窗
- (void)pickerPresentPickerState:(InspectionCheckState)state fromRect:(CGRect)rect{
    if ((state==self.pickerState) && ([self.pickerPopover isPopoverVisible])) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        self.pickerState=state;
        InspectionCheckPickerViewController *icPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"InspectionCheckPicker"];
        icPicker.pickerState=state;
        icPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(160, 200)];
        [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        icPicker.pickerPopover=self.pickerPopover;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}


@end
