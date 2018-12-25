//
//  AccInfoPickerViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AccInfoPickerViewController.h"
#import "OrgSysType.h"
#define CELL_CONTENT_WIDTH 200.0f
#define CELL_CONTENT_MARGIN 10.0f
#define FONT_SIZE 17.0f

@interface AccInfoPickerViewController ()
@property (nonatomic,retain) NSArray *data;
@property (nonatomic,weak) UITableView *citizenList;
@end

@implementation AccInfoPickerViewController
@synthesize pickerType=_pickerType;
@synthesize data=_data;
@synthesize pickerPopover=_pickerPopover;
@synthesize delegate=_delegate;
@synthesize caseID=_caseID;
@synthesize citizenList=_citizenList;

-(void)viewWillAppear:(BOOL)animated{
    switch (self.pickerType) {
        case kCaseReason:
            //事故原因
            self.data=[Systype typeValueForCodeName:@"事故原因"];
            break;
        case kPeccancyType:
            //事故类型
            self.data=[Systype typeValueForCodeName:@"违章类型"];
            break;
        case kParkingLocation:
            self.data = [OrgSysType typeValueForCodeName:@"停车地点"];
            break;
        default:
            break;
    }
}

- (void)viewDidUnload
{
    [self setData:nil];
    [self setPickerPopover:nil];
    [self setDelegate:nil];
    [self setCaseID:nil];
    [super viewDidUnload];
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
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.textLabel setLineBreakMode:UILineBreakModeWordWrap];
    [cell.textLabel setNumberOfLines:0];
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_SIZE];
    [cell.textLabel setFont:font];
    cell.textLabel.text=[self.data objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *text = [self.data objectAtIndex:indexPath.row];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = MAX(size.height, 44.0f);
    return height;
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.pickerType==3) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    } else {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.delegate setCaseText:cell.textLabel.text];
        [self.pickerPopover dismissPopoverAnimated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.pickerType==3) {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
}

@end
