//
//  InspectionOutViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-9-13.
//
//

#define Inspection_Normal_Description @"所巡查路段未发现违反公路法律法规的行为和影响公路安全畅通的情况"

#import "InspectionOutViewController.h"

@interface InspectionOutViewController ()
@property (nonatomic,retain) UIPopoverController *pickerPopover;
//- (NSString *)resultTextFromPickerView:(UIPickerView *)pickerView selectedRow:(NSInteger)row inComponent:(NSInteger)component;

- (NSString *)formedDescString;
@end

@implementation InspectionOutViewController
@synthesize textViewDesc;
@synthesize pickerPopover;
@synthesize contentView;
@synthesize textWaitness1;
@synthesize textWaitness1Tel;
@synthesize textWaitness1Address;
@synthesize textWaitness2;
@synthesize textWaitness2Tel;
@synthesize textWaitness2Address;
@synthesize delegate;


- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.textViewDesc.text = [self formedDescString];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:animated];
    }
    
    [super viewWillDisappear:animated];
}

//软键盘隐藏，恢复左下scrollview位置
- (void)keyboardWillHide:(NSNotification *)aNotification{
    [self.contentView setContentSize:self.contentView.frame.size];
}

//软键盘出现，上移scrollview至左上，防止编辑界面被阻挡
- (void)keyboardWillShow:(NSNotification *)aNotification{
    [self.contentView setContentSize:CGSizeMake(self.contentView.frame.size.width,self.contentView.frame.size.height+200)];
}

- (void)viewDidUnload
{
    [self setPickerPopover:nil];
    [self setDelegate:nil];
    [self setTextViewDesc:nil];
    [self setContentView:nil];
    [self setTextWaitness1:nil];
    [self setTextWaitness1Tel:nil];
    [self setTextWaitness1Address:nil];
    [self setTextWaitness2:nil];
    [self setTextWaitness2Tel:nil];
    [self setTextWaitness2Address:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

/*
#pragma mark - tableview delegate & datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifer=@"CheckItemCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    id obj=[self.itemArray objectAtIndex:indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *checkItemID=[[self.itemArray objectAtIndex:indexPath.row] valueForKey:@"itemID"];
    self.detailArray=[CheckItemDetails detailsForItem:checkItemID];
    if ([self.inputView isHidden]) {
        [UIView beginAnimations:@"inputViewShow" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        [self.inputView setHidden:NO];
        [self.inputView setAlpha:1.0];
        [self.view bringSubviewToFront:self.inputView];
        CGFloat height=self.inputView.frame.origin.y-self.tableCheckItems.frame.origin.y-5;
        CGRect newRect=self.tableCheckItems.frame;
        newRect.size.height=height;
        [self.tableCheckItems setFrame:newRect];
        [UIView commitAnimations];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    self.textDetail.text=[tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text;
    [self.pickerCheckItemDetails reloadAllComponents];
    [self.pickerCheckItemDetails selectRow:0 inComponent:0 animated:NO];
    self.textDetail.text=[self resultTextFromPickerView:self.pickerCheckItemDetails selectedRow:0 inComponent:0];
}

#pragma mark - pickerview delegate & datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return self.detailArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    id obj=[self.detailArray objectAtIndex:row];
    return [obj caption];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.textDetail.text=[self resultTextFromPickerView:pickerView selectedRow:row inComponent:component];
}
*/
 
#pragma mark - IBActions
- (IBAction)btnCancel:(UIBarButtonItem *)sender {
    if (self.delegate) {
        [self.delegate addObserverToKeyBoard];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btnSave:(UIBarButtonItem *)sender {
    NSString *inspectionID=[[NSUserDefaults standardUserDefaults] valueForKey:INSPECTIONKEY];
    NSArray *temp=[Inspection inspectionForID:inspectionID];
    if (temp.count>0) {
        Inspection *inspection=[temp objectAtIndex:0];
        inspection.isdeliver=@(YES);
        inspection.inspection_description = self.textViewDesc.text;
        inspection.jianzheng_address1 = self.textWaitness1Address.text;
        inspection.jianzheng_address2 = self.textWaitness2Address.text;
        inspection.jianzheng_name1 = self.textWaitness1.text;
        inspection.jianzheng_name2 = self.textWaitness2.text;
        inspection.jianzheng_tel1 = self.textWaitness1Tel.text;
        inspection.jianzheng_tel2 = self.textWaitness2Tel.text;
        inspection.isuploaded = @(NO);
        NSInteger recordsCount = [InspectionRecord recordsCountForInspection:inspectionID];
        if (recordsCount > 0) {
            inspection.isusual = @"否";
        } else {
            inspection.isusual = @"是";
        }
        inspection.record_date = [NSDate date];
        [[AppDelegate App] saveContext];
    }
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:INSPECTIONKEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (self.delegate) {
        [self.delegate popBackToMainView];
        [self dismissModalViewControllerAnimated:NO];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)btnFormDesc:(id)sender {
    self.textViewDesc.text = [self formedDescString];
}

- (NSString *)formedDescString{
    NSString *description = @"";
    NSString *inspectionID=[[NSUserDefaults standardUserDefaults] valueForKey:INSPECTIONKEY];
    NSArray *recordArray=[InspectionRecord recordsForInspection:inspectionID];
    for (int i=0; i<recordArray.count; i++) {
        InspectionRecord *record=[recordArray objectAtIndex:i];
        description=[description stringByAppendingFormat:@"\n%d、%@",i+1,record.remark];
    }
    description=[description stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
    if ([description isEmpty]) {
        description = Inspection_Normal_Description;
    }
    return description;
}
/*
- (IBAction)btnOK:(UIBarButtonItem *)sender {
    NSIndexPath *index=[self.tableCheckItems indexPathForSelectedRow];
    TempCheckItem *item=[self.itemArray objectAtIndex:index.row];
    item.checkResult=self.textDetail.text;
    [self.tableCheckItems beginUpdates];
    [self.tableCheckItems reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableCheckItems endUpdates];
    [self.tableCheckItems selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (IBAction)btnDismiss:(UIBarButtonItem *)sender {
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        [self.inputView setAlpha:0.0];
                        [self.view sendSubviewToBack:self.inputView];
                        CGRect newRect=self.tableCheckItems.frame;
                        newRect.size.height=440;
                        [self.tableCheckItems setFrame:newRect];
                    }
                    completion:^(BOOL finished){
                        [self.inputView setHidden:YES];
                    }];
}

 
- (IBAction)textTouch:(UITextField *)sender {
    //时间选择
    if ([self.pickerPopover isPopoverVisible]) {
        [self.pickerPopover dismissPopoverAnimated:YES];
    } else {
        DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
        datePicker.delegate=self;
        datePicker.pickerType=1;
        self.pickerPopover=[[UIPopoverController alloc] initWithContentViewController:datePicker];
        [self.pickerPopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        datePicker.dateselectPopover=self.pickerPopover;
    }
}


- (NSString *)resultTextFromPickerView:(UIPickerView *)pickerView selectedRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *resultText=[pickerView.delegate pickerView:pickerView titleForRow:row forComponent:component];
    if (resultText.integerValue>0) {
        NSString *temp=self.textDetail.text;
        NSCharacterSet *leftCharSet=[NSCharacterSet characterSetWithCharactersInString:@"（("];
        NSRange range=[temp rangeOfCharacterFromSet:leftCharSet options:NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) {
            NSInteger index=range.location+1;
            NSString *header=[temp substringToIndex:index];
            NSCharacterSet *rightCharSet=[NSCharacterSet characterSetWithCharactersInString:@")）"];
            range=[temp rangeOfCharacterFromSet:rightCharSet];
            NSString *tail;
            if (range.location != NSNotFound) {
                tail=[temp substringFromIndex:range.location];
            } else {
                tail=[temp substringFromIndex:index];
            }
            resultText=[NSString stringWithFormat:@"%@%d%@",header,resultText.integerValue,tail];
        }
    }
    return resultText;
}


- (void)setDate:(NSString *)date{
    self.textEndDate.text=date;
}
*/
 
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}
@end
