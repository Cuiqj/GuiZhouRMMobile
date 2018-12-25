//
//  DynamicInfoViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DynamicInfoViewController.h"
#import "RoadWayClosed.h"
#import "RoadWayCloseCell.h"
#import "Road.h"
#import "UserInfo.h"
#import "EmployeeInfo.h"
#import "OrgInfo.h"
#import "RoadWayClosedModel.h"

#import "TBXML.h"

typedef enum {
    kStartTime=0,
    kEndTime
} TimeState;

@interface DynamicInfoViewController ()
@property (retain, nonatomic) NSMutableArray *closeList;
@property (retain, nonatomic) UIPopoverController *pickerPopover;
@property (copy, nonatomic) NSString *closeID;
@property (copy, nonatomic) NSString *roadSegmentID;
@property (assign, nonatomic) TimeState timeState;
@property (assign, nonatomic) BOOL scrollNeedsMove;
//生成封闭原因
- (void)formCloseReason;
- (void)pickerPresentPickerState:(RoadClosePickerState)state fromRect:(CGRect)rect;
- (void)setCreator:(NSString *)userID;

-(void)keyboardWillShow:(NSNotification *)aNotification;
-(void)keyboardWillHide:(NSNotification *)aNotification;

@end

@implementation DynamicInfoViewController
@synthesize uiBtnSave;
@synthesize uiBtnPromulgate;
@synthesize tableCloseList;
@synthesize textTitle;
@synthesize textSegmentID;
@synthesize textSide;
@synthesize textStartKM;
@synthesize textStartM;
@synthesize textEndKM;
@synthesize textEndM;
@synthesize textTimeStart;
@synthesize textTimeEnd;
@synthesize textCreator;
@synthesize textCompany;
@synthesize textDuty;
@synthesize textTele;
@synthesize textClosedWay;
@synthesize textImportance;
@synthesize textViewCloseReason;
@synthesize scrollContent;
@synthesize closeList;
@synthesize pickerState;
@synthesize pickerPopover;
@synthesize closeID = _closeID;
@synthesize roadSegmentID = _roadSegmentID;

- (NSString *)closeID{
    if (_closeID==nil) {
        _closeID=@"";
    }
    return _closeID;
}

- (void)viewDidLoad
{
    self.closeList=[[RoadWayClosed roadWayCloseInfoForID:@""] mutableCopy];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.scrollNeedsMove=YES;
    self.scrollContent.showsVerticalScrollIndicator=NO;
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    [self setCreator:currentUserID];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setTableCloseList:nil];
    [self setTextTitle:nil];
    [self setTextSegmentID:nil];
    [self setTextSide:nil];
    [self setTextStartKM:nil];
    [self setTextStartM:nil];
    [self setTextEndKM:nil];
    [self setTextEndM:nil];
    [self setTextTimeStart:nil];
    [self setTextTimeEnd:nil];
    [self setTextCreator:nil];
    [self setTextCompany:nil];
    [self setTextDuty:nil];
    [self setTextTele:nil];
    [self setTextClosedWay:nil];
    [self setTextImportance:nil];
    [self setPickerPopover:nil];
	[self setTextViewCloseReason:nil];
    [self setCloseID:nil];
    [self setRoadSegmentID:nil];
    [self setScrollContent:nil];
    [self setUiBtnSave:nil];
    [self setUiBtnPromulgate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.closeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RoadWayCloseCell";
    RoadWayCloseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    RoadWayClosed *closeInfo=[self.closeList objectAtIndex:indexPath.row];
    cell.textLabel.text=closeInfo.title;
    cell.textLabel.backgroundColor=[UIColor clearColor];
    NSString *local = [Road roadNameFromID:closeInfo.roadsegment_id];
    NSNumberFormatter *numFormatter=[[NSNumberFormatter alloc] init];
    [numFormatter setPositiveFormat:@"000"];
    NSInteger stationStartM=closeInfo.station_start.integerValue%1000;
    NSString *stationStartKMString=[NSString stringWithFormat:@"%d", closeInfo.station_start.integerValue/1000];
    NSString *stationStartMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationStartM]];
    NSString *stationString;
    if (closeInfo.station_end.integerValue == 0 || closeInfo.station_end.integerValue == closeInfo.station_start.integerValue  ) {
        stationString=[NSString stringWithFormat:@"%@公里+%@米处",stationStartKMString,stationStartMString];
    } else {
        NSInteger stationEndM=closeInfo.station_end.integerValue%1000;
        NSString *stationEndKMString=[NSString stringWithFormat:@"%d",closeInfo.station_end.integerValue/1000];
        NSString *stationEndMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationEndM]];
        stationString=[NSString stringWithFormat:@"%@公里+%@米至%@公里+%@米处",stationStartKMString,stationStartMString,stationEndKMString,stationEndMString ];
    } 
    local = [local stringByAppendingFormat:@"  封闭%@",closeInfo.closed_roadway];
    local = [local stringByAppendingFormat:@"  %@",stationString];
    cell.detailTextLabel.text=local;
    if ([closeInfo.inportant isEqualToString:@"重要"]) {
        [cell.textLabel setTextColor:[UIColor redColor]];
        [cell.detailTextLabel setTextColor:[UIColor redColor]];
    } else {
        [cell.textLabel setTextColor:[UIColor blackColor]];
        [cell.detailTextLabel setTextColor:[UIColor blackColor]];
    }
    if (closeInfo.isuploaded.boolValue) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}


 // Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
    // Return NO if you do not want the specified item to be editable.
     return YES;
 }

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

 // Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         // Delete the row from the data source
         id obj=[self.closeList objectAtIndex:indexPath.row];
//         if ([obj isuploaded].boolValue) {
//             UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"删除失败" message:@"已上传信息，不能直接删除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
//             [alert show];
//         } else {
             NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
             if ([self.closeID isEqualToString:[obj roadwayclosed_id]]) {
                 [self performSelector:@selector(btnAddNew:)];
             }
             self.closeID=@"";
             [context deleteObject:obj];
             [self.closeList removeObject:obj];
             [[AppDelegate App] saveContext];
             [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//         }
     }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RoadWayClosed *closeInfo=[self.closeList objectAtIndex:indexPath.row];
    self.closeID=closeInfo.roadwayclosed_id;
    self.textImportance.text=closeInfo.inportant;
    self.textTitle.text=closeInfo.title;
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
    self.textTimeStart.text=[formatter stringFromDate:closeInfo.time_start];
    self.textTimeEnd.text=[formatter stringFromDate:closeInfo.time_end];
    self.roadSegmentID=closeInfo.roadsegment_id;
    self.textSegmentID.text=[Road roadNameFromID:self.roadSegmentID];
    self.textStartKM.text=[NSString stringWithFormat:@"%d",closeInfo.station_start.integerValue/1000];
    self.textStartM.text=[NSString stringWithFormat:@"%d",closeInfo.station_start.integerValue%1000];
    self.textEndKM.text=[NSString stringWithFormat:@"%d",closeInfo.station_end.integerValue/1000];
    self.textEndM.text=[NSString stringWithFormat:@"%d",closeInfo.station_end.integerValue%1000];
    self.textViewCloseReason.text=closeInfo.closed_reason;
    self.textClosedWay.text=closeInfo.closed_roadway;
    self.textSide.text=closeInfo.fix;
    self.textCompany.text=closeInfo.it_company;
    self.textCreator.text=closeInfo.creator;
    self.textDuty.text=closeInfo.it_duty;
    self.textTele.text=closeInfo.it_telephone;
    if (closeInfo.isuploaded.boolValue) {
        [self.uiBtnPromulgate setEnabled:NO];
        [self.uiBtnPromulgate setAlpha:0.6];
        [self.uiBtnSave setEnabled:NO];
        [self.uiBtnSave setAlpha:0.6];
    } else {
        [self.uiBtnPromulgate setEnabled:YES];
        [self.uiBtnPromulgate setAlpha:1.0];
        [self.uiBtnSave setEnabled:YES];
        [self.uiBtnSave setAlpha:1.0];
    }
}


- (IBAction)btnAddNew:(UIButton *)sender {
    for (UITextField *textField in [self.scrollContent subviews]) {
        if ([textField isKindOfClass:[UITextField class]]) {
            textField.text=@"";
        }
    }
    self.textViewCloseReason.text=@"";
    self.closeID=@"";
    self.roadSegmentID=@""; 
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    [self setCreator:currentUserID];
    [self.uiBtnPromulgate setEnabled:YES];
    [self.uiBtnPromulgate setAlpha:1.0];
    [self.uiBtnSave setEnabled:YES];
    [self.uiBtnSave setAlpha:1.0];
    [self.tableCloseList deselectRowAtIndexPath:[self.tableCloseList indexPathForSelectedRow] animated:YES];
}

- (IBAction)btnSave:(UIButton *)sender {
    if ([self.textViewCloseReason.text isEmpty]) {
        [self formCloseReason];
    }
    if ([self.textTitle.text isEmpty]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"标题为空，无法保存" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alert show];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            RoadWayClosed *closeInfo;
            if ([self.closeID isEmpty]) {
                self.closeID=[NSString randomID];
                NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
                NSEntityDescription *entity=[NSEntityDescription entityForName:@"RoadWayClosed" inManagedObjectContext:context];
                closeInfo=[[RoadWayClosed alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
                closeInfo.isuploaded=@(NO);
                closeInfo.put_flag = @"新增";
                closeInfo.record_date = [NSDate date];
            } else {
                closeInfo=[[RoadWayClosed roadWayCloseInfoForID:self.closeID] objectAtIndex:0];
            }
            closeInfo.roadwayclosed_id=self.closeID;
            closeInfo.inportant=self.textImportance.text;
            closeInfo.title=self.textTitle.text;
            NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
            [formatter setLocale:[NSLocale currentLocale]];
            [formatter setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
            closeInfo.time_start=[formatter dateFromString:self.textTimeStart.text];
            closeInfo.time_end=[formatter dateFromString:self.textTimeEnd.text];
            closeInfo.roadsegment_id=self.roadSegmentID;
            closeInfo.station_start=@(self.textStartKM.text.integerValue*1000+self.textStartM.text.integerValue);
            closeInfo.station_end=@(self.textEndKM.text.integerValue*1000+self.textEndM.text.integerValue);
            closeInfo.closed_reason=self.textViewCloseReason.text;
            if (self.textClosedWay.text.integerValue>0){
                closeInfo.closed_roadway=[[NSString alloc] initWithFormat:@"%d车道",self.textClosedWay.text.integerValue];
            } else {
                closeInfo.closed_roadway=self.textClosedWay.text;
            }
            closeInfo.fix=self.textSide.text;
            closeInfo.it_company=self.textCompany.text;
            closeInfo.it_duty=self.textDuty.text;
            closeInfo.it_telephone=self.textTele.text;
            closeInfo.creator=self.textCreator.text;
            NSString *currentOrgID=[[NSUserDefaults standardUserDefaults] stringForKey:ORGKEY];
            closeInfo.org_id=currentOrgID;
            [[AppDelegate App] saveContext];
            self.closeList=self.closeList=[[RoadWayClosed roadWayCloseInfoForID:@""] mutableCopy];
        });
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.tableCloseList reloadData];
        });
    }
}

- (IBAction)btnPromulgate:(UIButton *)sender {
    NSIndexPath *index=[self.tableCloseList indexPathForSelectedRow];
    if (index!=nil) {
        //上传选中的道路封闭信息
        if ([WebServiceHandler isServerReachable]) {
            WebServiceHandler *web = [[WebServiceHandler alloc] init];
            web.delegate = self;
            RoadWayClosedModel *closeInfo = [[RoadWayClosedModel alloc] initWithRoadWayClosed:[self.closeList objectAtIndex:index.row]];
            [web upLoadRoadWayCloseeModel:@[ closeInfo ]];
        }
    }
}

- (IBAction)textTouch:(UITextField *)sender {
    switch (sender.tag) {
        case 1:
            [self roadSegmentPickerPresentPickerState:kRoadSegment fromRect:[self.view convertRect:sender.frame fromView:self.scrollContent]];
            break;
        case 2:
            [self roadSegmentPickerPresentPickerState:kRoadSide fromRect:[self.view convertRect:sender.frame fromView:self.scrollContent]];
            break;
        case 7:{
            //时间选择
            if ([self.pickerPopover isPopoverVisible]) {
                [self.pickerPopover dismissPopoverAnimated:YES];
            } else {
                DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
                datePicker.delegate=self;
                datePicker.pickerType=1;
                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                [dateFormatter setLocale:[NSLocale currentLocale]];
                [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
                NSDate *temp=[dateFormatter dateFromString:self.textTimeStart.text];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                [datePicker showdate:[dateFormatter stringFromDate:temp]];
                self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
                [self.pickerPopover presentPopoverFromRect:[self.view convertRect:sender.frame fromView:self.scrollContent] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                datePicker.dateselectPopover=self.pickerPopover;
            }
            self.timeState=kStartTime;
        }
            break;
        case 8:{
            if ([self.pickerPopover isPopoverVisible]) {
                [self.pickerPopover dismissPopoverAnimated:YES];
            } else {
                DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
                datePicker.delegate=self;
                datePicker.pickerType=1;
                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                [dateFormatter setLocale:[NSLocale currentLocale]];
                [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
                NSDate *temp=[dateFormatter dateFromString:self.textTimeEnd.text];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                [datePicker showdate:[dateFormatter stringFromDate:temp]];
                self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
                [self.pickerPopover presentPopoverFromRect:[self.view convertRect:sender.frame fromView:self.scrollContent] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                datePicker.dateselectPopover=self.pickerPopover;
            }
            self.timeState=kEndTime;
        }
            break;
        case 9:{
            if ([self.pickerPopover isPopoverVisible]) {
                [self.pickerPopover dismissPopoverAnimated:YES];
            } else {
                UserPickerViewController *acPicker=[[UserPickerViewController alloc] init];
                acPicker.delegate=self;
                acPicker.pickerState = kEmployee;
                self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
                [self.pickerPopover setPopoverContentSize:CGSizeMake(140, 220)];
                [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.scrollContent permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                acPicker.pickerPopover=self.pickerPopover;
            }
        }
            break;
        case 13:
            [self pickerPresentPickerState:kCloseRoadSelect fromRect:[self.view convertRect:sender.frame fromView:self.scrollContent]];
            break;
        case 14:
            [self pickerPresentPickerState:kTypeSelect fromRect:[self.view convertRect:sender.frame fromView:self.scrollContent]];
            break;
        case 15:
            [self pickerPresentPickerState:kImportanceSelect fromRect:[self.view convertRect:sender.frame fromView:self.scrollContent]];
            break;
        default:
            break;
    }
}

- (IBAction)btnFormReason:(UIButton *)sender {
    [self formCloseReason];
}

//弹窗
- (void)pickerPresentPickerState:(RoadClosePickerState)state fromRect:(CGRect)rect{
    if ((state==self.pickerState) && ([self.pickerPopover isPopoverVisible])) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        self.pickerState=state;
        RoadClosePickerViewController *icPicker=[[RoadClosePickerViewController alloc] initWithStyle:UITableViewStylePlain];
        icPicker.tableView.frame=CGRectMake(0, 0, 150, 243);
        icPicker.pickerState=state;
        icPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(150, 243)];
        [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        icPicker.pickerPopover=self.pickerPopover;
    }
}


#pragma mark - delegate
- (void)setText:(NSString *)aText{
    switch (self.pickerState) {
        case kCloseRoadSelect:
            self.textClosedWay.text=aText;
            break;
        case kImportanceSelect:
            self.textImportance.text=aText;
            break;
        default:
            break;
    }
}

- (void)setDate:(NSString *)date{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *temp=[dateFormatter dateFromString:date];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH时mm分"];
    NSString *dateString=[dateFormatter stringFromDate:temp];
    switch (self.timeState) {
        case kStartTime:
            self.textTimeStart.text=dateString;
            break;
        case kEndTime:
            self.textTimeEnd.text=dateString;
            break;
        default:
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag>=11) {
        self.scrollNeedsMove=YES;
        
    } else {
        self.scrollNeedsMove=NO;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.scrollNeedsMove=YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==8 || textField.tag==7) {
        return NO;
    } else {
        return YES;
    }
}

-(void)formCloseReason{
    self.textStartKM.text=[[NSString alloc] initWithFormat:@"%d",self.textStartKM.text.integerValue];
    self.textEndKM.text=[[NSString alloc] initWithFormat:@"%d",self.textEndKM.text.integerValue];
    self.textStartM.text=[[NSString alloc] initWithFormat:@"%d",self.textStartM.text.integerValue];
    self.textEndM.text=[[NSString alloc] initWithFormat:@"%d",self.textEndM.text.integerValue];
    NSNumberFormatter *numFormatter=[[NSNumberFormatter alloc] init];
    [numFormatter setPositiveFormat:@"000"];
    NSString *stationStartMString=[numFormatter stringFromNumber:@(self.textStartM.text.integerValue)];
    NSString *stationString;
    if (self.textEndM.text.integerValue == 0 && self.textEndKM.text.integerValue==0  ) {
        stationString=[NSString stringWithFormat:@"%@公里+%@米",self.textStartKM.text,stationStartMString];
    } else {
        NSString *stationEndMString=[numFormatter stringFromNumber:@(self.textEndM.text.integerValue)];
        stationString=[NSString stringWithFormat:@"%@公里+%@米至%@公里+%@米",self.textStartKM.text,stationStartMString,self.textEndKM.text,stationEndMString ];
    }
    if (![self.textTimeStart.text isEmpty] && ![self.textTimeEnd.text isEmpty]) {
        if (self.textClosedWay.text.integerValue>0) {
            self.textViewCloseReason.text=[[NSString alloc] initWithFormat:@"因需要在%@至%@时间段封闭%@%@%@%d车道",self.textTimeStart.text,self.textTimeEnd.text,self.textSegmentID.text,self.textSide.text,stationString,self.textClosedWay.text.integerValue];
        } else {
            self.textViewCloseReason.text=[[NSString alloc] initWithFormat:@"因需要在%@至%@时间段封闭%@%@%@%@",self.textTimeStart.text,self.textTimeEnd.text,self.textSegmentID.text,self.textSide.text,stationString,self.textClosedWay.text];
        }
    }
}

//键盘出现和消失时，变动ScrollContent的contentSize;
-(void)keyboardWillShow:(NSNotification *)aNotification{
    if (self.scrollNeedsMove) {
        NSDictionary* userInfo = [aNotification userInfo];
        CGRect keyboardEndFrame;
        [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
        CGSize contentSize=self.scrollContent.frame.size;
        contentSize.height=contentSize.height+keyboardEndFrame.size.width-80;
        self.scrollContent.contentSize=contentSize;
        for ( id view in self.scrollContent.subviews) {
            if ([view isFirstResponder]) {
                if ([view tag] >= 16) {
                    [self.scrollContent setContentOffset:CGPointMake(0, [view frame].origin.y-80) animated:YES];
                } else {
                    [self.scrollContent setContentOffset:CGPointMake(0, [view frame].origin.y-20) animated:YES];
                }
                break;
            }
        }
    }
}

-(void)keyboardWillHide:(NSNotification *)aNotification{
    self.scrollContent.contentSize=self.scrollContent.frame.size;
    [self.scrollContent scrollRectToVisible:self.scrollContent.bounds animated:YES];
    if (self.pickerPopover != nil && [self.pickerPopover isPopoverVisible]){
        [self.pickerPopover dismissPopoverAnimated:YES];
    }
}

//路段选择弹窗
- (void)roadSegmentPickerPresentPickerState:(RoadSegmentPickerState)state fromRect:(CGRect)rect{
    if ((state==self.roadSegmentPickerState) && ([self.pickerPopover isPopoverVisible])) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        self.roadSegmentPickerState=state;
        RoadSegmentPickerViewController *icPicker=[[RoadSegmentPickerViewController alloc] initWithStyle:UITableViewStylePlain];
        icPicker.tableView.frame=CGRectMake(0, 0, 150, 243);
        icPicker.pickerState=state;
        icPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(150, 243)];
        [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        icPicker.pickerPopover=self.pickerPopover;
    }
}

- (void)setRoad:(NSString *)aRoadID roadName:(NSString *)roadName{
    self.roadSegmentID=aRoadID;
    self.textSegmentID.text=roadName;
}

- (void)setRoadSide:(NSString *)side{
    self.textSide.text=side;
}

- (void)setCreator:(NSString *)userID{
    EmployeeInfo *employee = [EmployeeInfo EmployeeInfoForID:userID];
    self.textCreator.text=employee.name;
    self.textTele.text=employee.telephone;
    self.textDuty.text=employee.duty;
    self.textCompany.text=[[OrgInfo orgInfoForOrgID:employee.organization_id] valueForKey:@"orgname"];
}


- (void)getWebServiceReturnString:(NSString *)webString forWebService:(NSString *)serviceName{
    NSIndexPath *index=[self.tableCloseList indexPathForSelectedRow];
    BOOL success = NO;
    TBXML *xml = [TBXML newTBXMLWithXMLString:webString error:nil];
    TBXMLElement *root = [xml rootXMLElement];
    TBXMLElement *r1 = root->firstChild;
    TBXMLElement *r2 = r1->firstChild;
    TBXMLElement *r3 = r2->firstChild;
    if (r3) {
        NSString *outString = [TBXML textForElement:r3];
        if (outString.boolValue) {
            success = YES;
        }
    }
    if (success) {
        [[self.closeList objectAtIndex:index.row] setIsuploaded:@(YES)];
        [[AppDelegate App] saveContext];
        [self.tableCloseList beginUpdates];
        [self.tableCloseList reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationMiddle];
        [self.tableCloseList endUpdates];
    } else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"上传当前道路信息出错！ " delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [alert show];
    }
}

- (void)setUser:(NSString *)name andUserID:(NSString *)userID{
    [self setCreator:userID];
}
@end
