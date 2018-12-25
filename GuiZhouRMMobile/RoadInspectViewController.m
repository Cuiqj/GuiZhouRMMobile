//
//  RoadInspectViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RoadInspectViewController.h"
#import "Road.h"
#import "InspectImageViewController.h"

@interface RoadInspectViewController ()
@property (nonatomic,retain) NSMutableArray *data;
@property (nonatomic,retain) NSString *roadID;
@property (nonatomic,assign) BOOL isStartTime;
@property (nonatomic,retain) UIPopoverController *pickerPopover;
//判断当前显示的巡查是否是正在进行的巡查
@property (nonatomic,assign) BOOL isCurrentInspection;
@property (nonatomic) BOOL isCurrentInspectionUploaded;
- (void)loadInspectionInfo;
@end

@implementation RoadInspectViewController
@synthesize recordView = _recordView;
@synthesize normalView = _normalView;
@synthesize inpsectionSeg = _inpsectionSeg;
@synthesize labelInspectionInfo = _labelInspectionInfo;
@synthesize textViewRemark = _textViewRemark;
@synthesize tableRecordList = _tableRecordList;
@synthesize labelRemark = _labelRemark;
@synthesize textRoad = _textRoad;
@synthesize textStartKM = _textStartKM;
@synthesize textStartM = _textStartM;
@synthesize textEndKm = _textEndKm;
@synthesize textEndm = _textEndm;
@synthesize textStartTime = _textStartTime;
@synthesize textEndTime = _textEndTime;
@synthesize uiButtonAddNew = _uiButtonAddNew;
@synthesize uiButtonSave = _uiButtonSave;
@synthesize uiButtonDeliver = _uiButtonDeliver;
@synthesize inspectionID = _inspectionID;
@synthesize state = _state;
@synthesize pickerPopover = _pickerPopover;
@synthesize isCurrentInspection = _isCurrentInspection;
@synthesize imageSelectID = _imageSelectID;


- (BOOL)isCurrentInspectionUploaded {
    _isCurrentInspectionUploaded = NO;
    if (![self.inspectionID isEmpty]) {
        NSArray *inspections = [Inspection inspectionForID:self.inspectionID];
        if (inspections.count > 0) {
            Inspection *inspection = [inspections objectAtIndex:0];
            _isCurrentInspectionUploaded = inspection.isuploaded.boolValue;
        }
    }
    return _isCurrentInspectionUploaded;
}

- (void)viewDidLoad
{

    self.recordView.layer.cornerRadius=4;
    self.recordView.layer.masksToBounds=YES;
    self.state = kNormal;
    UIFont *segFont = [UIFont boldSystemFontOfSize:14.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:segFont
                                                           forKey:UITextAttributeFont];
    [self.inpsectionSeg setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    self.inspectionID=[[NSUserDefaults standardUserDefaults] valueForKey:INSPECTIONKEY];
    self.isCurrentInspection = YES;
    if ([self.inspectionID isEmpty] || self.inspectionID==nil) {
        [self performSegueWithIdentifier:@"toNewInspection" sender:nil];
    } else {
        [self loadInspectionInfo];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:animated];
    }
    
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setTextViewRemark:nil];
    [self setTableRecordList:nil];
    [self setLabelRemark:nil];
    [self setLabelInspectionInfo:nil];
    [self setInpsectionSeg:nil];
    [self setRecordView:nil];
    [self setNormalView:nil];
    [self setTextRoad:nil];
    [self setTextStartKM:nil];
    [self setTextStartM:nil];
    [self setTextEndKm:nil];
    [self setTextEndm:nil];
    [self setTextStartTime:nil];
    [self setTextEndTime:nil];
    [self setPickerPopover:nil];
    [self setUiButtonAddNew:nil];
    [self setUiButtonSave:nil];
    [self setUiButtonDeliver:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSString *segueIdentifer=[segue identifier];
    if ([segueIdentifer isEqualToString:@"toAddNewInspectionRecord"]) {
        AddNewInspectRecordViewController *newRCVC=segue.destinationViewController;
        newRCVC.inspectionID=self.inspectionID;
        newRCVC.delegate=self;        
    } else if ([segueIdentifer isEqualToString:@"toNewInspection"]) {
        NewInspectionViewController *niVC=[segue destinationViewController];
        niVC.delegate=self;
    } else if ([segueIdentifer isEqualToString:@"toInspectionOut"]) {
        InspectionOutViewController *ioVC=[segue destinationViewController];
        ioVC.delegate=self;
    } else if ([segueIdentifer isEqualToString:@"toInspectImage"])
    {
        InspectImageViewController * imageVC= [segue destinationViewController];
        
        imageVC.caseID = self.imageSelectID;
    }
}


#pragma mark - TableView delegate & datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifer=@"InspectionRecordCell";
    InspectionRecordCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    if (self.state == kRecord) {
        InspectionRecord *record=[self.data objectAtIndex:indexPath.row];
        cell.labelRemark.text=record.remark;
        NSNumberFormatter *numberFormatter=[[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"000"];
        NSInteger stationStartM=record.station.integerValue%1000;
        NSString *stationStartKMString=[NSString stringWithFormat:@"%d", record.station.integerValue/1000];
        NSString *stationStartMString=[numberFormatter stringFromNumber:[NSNumber numberWithInteger:stationStartM]];
        NSString *stationString=[NSString stringWithFormat:@"%@公里+%@米处",stationStartKMString,stationStartMString];
        cell.labelStation.hidden = NO;
        cell.labelStation.text=stationString;
        cell.imageButton.tag = indexPath.row+1000;
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"HH时mm分"];
        cell.labelTime.text=[dateFormatter stringFromDate:record.start_time];
    } else {
        InspectionRecordNormal *normal = [self.data objectAtIndex:indexPath.row];
        NSNumberFormatter *numberFormatter=[[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"000"];
        NSInteger stationStartM=normal.start_station.integerValue%1000;
        NSString *stationStartKMString=[NSString stringWithFormat:@"%d", normal.start_station.integerValue/1000];
        NSString *stationStartMString=[numberFormatter stringFromNumber:[NSNumber numberWithInteger:stationStartM]];
        NSString *stationStartString=[NSString stringWithFormat:@"%@公里+%@米",stationStartKMString,stationStartMString];
        NSInteger stationEndM=normal.end_station.integerValue%1000;
        NSString *stationEndKMString=[NSString stringWithFormat:@"%d", normal.end_station.integerValue/1000];
        NSString *stationEndMString=[numberFormatter stringFromNumber:[NSNumber numberWithInteger:stationEndM]];
        NSString *stationEndString=[NSString stringWithFormat:@"%@公里+%@米",stationEndKMString,stationEndMString];
        NSString *remark = [NSString stringWithFormat:@"%@%@至%@",normal.roadsegment_name,stationStartString,stationEndString];
        cell.labelRemark.text = remark;
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"HH时mm分"];        
        cell.labelTime.text=[NSString stringWithFormat:@"%@至%@",[dateFormatter stringFromDate:normal.start_time],[dateFormatter stringFromDate:normal.end_time]];
        cell.labelStation.text = @"";
        cell.labelStation.hidden = YES;
    }
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //return UITableViewCellEditingStyleDelete;
    if (self.isCurrentInspectionUploaded) {
        // 已上传巡查禁用删除列表
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    id obj=[self.data objectAtIndex:indexPath.row];
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    [context deleteObject:obj];
    [self.data removeObjectAtIndex:indexPath.row];
    [[AppDelegate App] saveContext];
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [tableView endUpdates];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.state == kRecord) {
        InspectionRecord *record=[self.data objectAtIndex:indexPath.row];
       
        self.textViewRemark.text=record.remark;
    } else {
        InspectionRecordNormal *normal = [self.data objectAtIndex:indexPath.row];
        self.textRoad.text = normal.roadsegment_name;
        self.roadID = normal.roadsegment_id;
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        self.textStartTime.text = [dateFormatter stringFromDate:normal.start_time];
        self.textEndTime.text = [dateFormatter stringFromDate:normal.end_time];
        self.textStartKM.text = [NSString stringWithFormat:@"%d",normal.start_station.integerValue/1000];
        self.textStartM.text = [NSString stringWithFormat:@"%d",normal.start_station.integerValue%1000];
        self.textEndKm.text = [NSString stringWithFormat:@"%d",normal.end_station.integerValue/1000];
        self.textEndm.text = [NSString stringWithFormat:@"%d",normal.end_station.integerValue%1000];
    }
}

#pragma mark - InspectionHandler

- (void)reloadRecordData{
    if (self.state == kRecord) {
        self.data=[[InspectionRecord recordsForInspection:self.inspectionID] mutableCopy];
        [self.normalView setHidden:YES];
        [self.view sendSubviewToBack:self.normalView];
    } else {
        self.data=[[InspectionRecordNormal normalsForInspection:self.inspectionID] mutableCopy];
        [self.normalView setHidden:NO];
        [self.view bringSubviewToFront:self.normalView];
    }
    [self.tableRecordList reloadData];
}

- (void)setInspectionDelegate:(NSString *)aInspectionID{
    self.inspectionID=aInspectionID;
    [self loadInspectionInfo];
}

- (void)popBackToMainView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)addObserverToKeyBoard{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - own methods
//软键盘隐藏，恢复左下scrollview位置
- (void)keyboardWillHide:(NSNotification *)aNotification{
    if (self.pickerPopover != nil && [self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    }
    
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];

    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];

    if (self.state == kRecord) {
        CGRect newFrame = self.textViewRemark.frame;
        newFrame.origin.y=415;
        newFrame.size.height = 192;
        //    CGFloat offset=self.textViewRemark.frame.origin.y-newFrame.origin.y;
        self.textViewRemark.frame = newFrame;
    }  else {
        CGRect newFrame = self.normalView.frame;
        newFrame.origin.y = 425;
        self.normalView.frame = newFrame;
    }
    [self saveRemark];
    [UIView commitAnimations];
}

//软键盘出现，上移scrollview至左上，防止编辑界面被阻挡
- (void)keyboardWillShow:(NSNotification *)aNotification{
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];

    if (self.state == kRecord) {
        CGRect newFrame = self.textViewRemark.frame;
        newFrame.origin.y=86;
        newFrame.size.height = self.view.frame.size.height - (self.recordView.frame.origin.y + newFrame.origin.y) - keyboardEndFrame.size.width-5;
        self.textViewRemark.frame = newFrame;
    } else {
        CGRect newFrame = self.normalView.frame;
        newFrame.origin.y = 130;
        self.normalView.frame = newFrame;
    }
    [UIView commitAnimations];
}


- (IBAction)btnSaveRemark:(UIButton *)sender {
    if (self.state == kRecord) {
        [self saveRemark];
    } else {
        self.textStartKM.text = [[NSString alloc] initWithFormat:@"%d",self.textStartKM.text.integerValue];
        self.textStartM.text = [[NSString alloc] initWithFormat:@"%d",self.textStartM.text.integerValue];
        self.textEndKm.text = [[NSString alloc] initWithFormat:@"%d",self.textEndKm.text.integerValue];
        self.textEndm.text = [[NSString alloc] initWithFormat:@"%d",self.textEndm.text.integerValue];
        BOOL textEmpty = NO;
        for (UITextField *textField in self.normalView.subviews) {
            if ([textField isKindOfClass:[UITextField class]]) {
                if ([textField.text isEmpty] || textField.text == nil) {
                    textEmpty = YES;
                }
            }
        }
        if (textEmpty) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"保存出错" message:@"路线信息不能为空，请完善。" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            if (![self.roadID isEmpty]) {
                NSIndexPath *index = [self.tableRecordList indexPathForSelectedRow];
                InspectionRecordNormal *newInfo;
                if (index==nil) {
                    NSManagedObjectContext *context = [[AppDelegate App] managedObjectContext];
                    NSEntityDescription *entity = [NSEntityDescription entityForName:@"InspectionRecordNormal" inManagedObjectContext:context];
                    newInfo = [[InspectionRecordNormal alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
                    [self.data addObject:newInfo];
                } else {
                    newInfo = [self.data objectAtIndex:index.row];
                }
                newInfo.roadsegment_id = self.roadID;
                newInfo.roadsegment_name = [Road roadNameFromID:self.roadID];
                newInfo.start_station = @(self.textStartKM.text.integerValue*1000+self.textStartM.text.integerValue);
                newInfo.end_station = @(self.textEndKm.text.integerValue*1000+self.textEndm.text.integerValue);
                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                [dateFormatter setLocale:[NSLocale currentLocale]];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                newInfo.end_time = [dateFormatter dateFromString:self.textEndTime.text];
                newInfo.start_time = [dateFormatter dateFromString:self.textStartTime.text];
                newInfo.inspection_id = self.inspectionID;
                [[AppDelegate App] saveContext];
            }
            [self reloadRecordData];
        }
    }    
    [self.view endEditing:YES];
}

- (void)saveRemark{
    if (![self.textViewRemark.text isEmpty]) {
        NSIndexPath *indexPath=[self.tableRecordList indexPathForSelectedRow];
        if (indexPath!=nil) {
            InspectionRecord *record=[self.data objectAtIndex:indexPath.row];
            record.remark=self.textViewRemark.text;
            [[AppDelegate App] saveContext];
            [self.tableRecordList beginUpdates];
            [self.tableRecordList reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            [self.tableRecordList endUpdates];
        }
    }
}

- (void)loadInspectionInfo{
    NSArray *temp=[Inspection inspectionForID:self.inspectionID];
    Inspection *inspection = nil;
    if (temp.count>0) {
        inspection=[temp objectAtIndex:0];
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        self.labelInspectionInfo.text=[[NSString alloc] initWithFormat:@"%@   %@   巡查车辆:%@   巡查人:%@   记录人:%@",[formatter stringFromDate:inspection.date_inspection],inspection.weather,inspection.carcode,inspection.inspectionor_name,inspection.recorder_name];
    }
    
    if (self.isCurrentInspectionUploaded) {
        //禁止修改巡查描述
        [self.textViewRemark setUserInteractionEnabled:NO];
    } else {
        [self.textViewRemark setUserInteractionEnabled:YES];
    }
    
    UIColor *disableBGColor = [UIColor colorWithRed:BGCOLOR_DISABLECOLOR_RED green:BGCOLOR_DISABLECOLOR_GREEN blue:BGCOLOR_DISABLECOLOR_BLUE alpha:BGCOLOR_DISABLECOLOR_ALPHA];
    
    for (UITextField *textField in self.normalView.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            textField.text = @"";
            if (self.isCurrentInspectionUploaded) {
                [textField setUserInteractionEnabled:NO];
                [textField setBackgroundColor:disableBGColor];
            } else {
                [textField setUserInteractionEnabled:YES];
                [textField setBackgroundColor:[UIColor whiteColor]];
            }
        }
    }
    self.roadID = @"";
    NSIndexPath *index = [self.tableRecordList indexPathForSelectedRow];
    if (index) {
        [self.tableRecordList deselectRowAtIndexPath:index animated:YES];
    }
    
    self.textViewRemark.text = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self reloadRecordData];
}


- (IBAction)selectRoad:(id)sender {
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        RoadSegmentPickerViewController *icPicker=[[RoadSegmentPickerViewController alloc] initWithStyle:UITableViewStylePlain];
        icPicker.tableView.frame=CGRectMake(0, 0, 150, 243);
        icPicker.pickerState=kRoadSegment;
        icPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(150, 243)];
        CGRect rect = [self.view convertRect:[sender frame] fromView:self.normalView];
        [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        icPicker.pickerPopover=self.pickerPopover;
    }
}

- (IBAction)btnAddNew:(id)sender {
    if (self.state == kRecord) {
        [self performSegueWithIdentifier:@"toAddNewInspectionRecord" sender:nil];
    } else {
        for (UITextField *textField in self.normalView.subviews) {
            if ([textField isKindOfClass:[UITextField class]]) {
                textField.text = @"";
            }
        }
        self.roadID = @"";
        NSIndexPath *index = [self.tableRecordList indexPathForSelectedRow];
        if (index) {
            [self.tableRecordList deselectRowAtIndexPath:index animated:YES];
        }
    }
}

- (IBAction)segSwitch:(id)sender {
    [self.view endEditing:YES];
    if (self.inpsectionSeg.selectedSegmentIndex == 0) {
        self.state = kNormal;
    } else {
        self.state = kRecord;
    }
    [self reloadRecordData];
}

- (IBAction)selectTimeStart:(id)sender {
    self.isStartTime = YES;
    DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
    datePicker.delegate=self;
    datePicker.pickerType=1;
    [datePicker showdate:self.textStartTime.text];
    self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
    CGRect rect = [self.view convertRect:[sender frame] fromView:self.normalView];
    [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    datePicker.dateselectPopover=self.pickerPopover;
}

- (IBAction)selectTimeEnd:(id)sender {
    self.isStartTime = NO;
    DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
    datePicker.delegate=self;
    datePicker.pickerType=1;
    [datePicker showdate:self.textEndTime.text];
    self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
    CGRect rect = [self.view convertRect:[sender frame] fromView:self.normalView];
    [self.pickerPopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    datePicker.dateselectPopover=self.pickerPopover;
}

- (IBAction)btnDeliver:(UIButton *)sender {
    if (self.isCurrentInspection) {
        [self performSegueWithIdentifier:@"toInspectionOut" sender:nil];
    } else {
        self.isCurrentInspection = YES;
        [UIView transitionWithView:self.view
                          duration:0.3
                           options:UIViewAnimationCurveLinear
                        animations:^{
                            CGRect rect = self.uiButtonDeliver.frame;
                            rect.size.width = 72;
                            [self.uiButtonDeliver setFrame:rect];
                            [sender setTitle:@"交班" forState:UIControlStateNormal];
                            [self.uiButtonAddNew setAlpha:1.0];
                            [self.uiButtonSave setAlpha:1.0];
                        }
                        completion:^(BOOL finish){
                            [self.uiButtonSave setEnabled:YES];
                            [self.uiButtonAddNew setEnabled:YES];
                        }];
        self.inspectionID=[[NSUserDefaults standardUserDefaults] valueForKey:INSPECTIONKEY];
        [self loadInspectionInfo];
    }
}

- (IBAction)btnInpectionList:(id)sender {
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        InspectionListViewController *acPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"InspectionList"];
        acPicker.delegate=self;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];
        [self.pickerPopover setPopoverContentSize:CGSizeMake(270, 352)];
        [self.pickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        acPicker.popover=self.pickerPopover;
    }
}

- (IBAction)imageSelect:(UIButton *)sender {
    
    self.imageSelectID = [NSString stringWithFormat:@"%d",sender.tag];
    
    [self performSegueWithIdentifier:@"toInspectImage" sender:nil];
}

- (void)setRoad:(NSString *)aRoadID roadName:(NSString *)roadName{
    self.roadID = aRoadID;
    self.textRoad.text = roadName;
}

- (void)setDate:(NSString *)date{
    if (self.isStartTime) {
        self.textStartTime.text = date;
    } else {
        self.textEndTime.text = date;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

- (void)setCurrentInspection:(NSString *)inspectionID{
    [UIView transitionWithView:self.view
                      duration:0.3
                       options:UIViewAnimationCurveLinear
                    animations:^{
                        CGRect rect = self.uiButtonDeliver.frame;
                        rect.size.width = 126;
                        [self.uiButtonDeliver setFrame:rect];
                        [self.uiButtonDeliver setTitle:@"返回当前巡查" forState:UIControlStateNormal];
                        [self.uiButtonAddNew setAlpha:0.0];
                        [self.uiButtonSave setAlpha:0.0];
                    }
                    completion:^(BOOL finish){
                        [self.uiButtonSave setEnabled:NO];
                        [self.uiButtonAddNew setEnabled:NO];
                    }];
    self.isCurrentInspection = NO;
    self.inspectionID = inspectionID;
    [self loadInspectionInfo];
}

@end
