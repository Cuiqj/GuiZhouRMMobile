//
//  CaseInfoPickerViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CaseInfoPickerViewController.h"

@interface CaseInfoPickerViewController ()
@property (retain,nonatomic) NSArray *data;
@end

@implementation CaseInfoPickerViewController
@synthesize pickerType=_pickerType;
@synthesize pickerPopover=_pickerPopover;
@synthesize data=_data;
@synthesize delegate=_delegate;

- (void)viewDidLoad
{
    switch (_pickerType) {
        case 0:
            self.data=[Systype typeValueForCodeName:@"天气"];
            break;
        /*
        case 1:
            self.data=[Systype typeValueForCodeName:@"车型"];
            break;
        case 2:
            self.data=@[@"轻微",@"一般",@"严重",@"损毁"];
            break;
        */ 
        case 3:
            self.data=@[@"赔案",@"罚案",@"罚案（当场处罚）",@"强制"];
            break;
        default:
            break;
    }
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setData:nil];
    [self setPickerPopover:nil];
    [self setDelegate:nil];
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
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text=[_data objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *myCell=[tableView cellForRowAtIndexPath:indexPath];
    switch (self.pickerType) {
        case 0:
            [self.delegate setWeather:myCell.textLabel.text];
            break;
            /*
        case 1:
            [self.delegate setAuotMobilePattern:myCell.textLabel.text];
            break;
        case 2:
            [self.delegate setBadDesc:myCell.textLabel.text];
            break;
            */ 
        case 3:
            [self.delegate setCaseType:myCell.textLabel.text];
            break;
        default:
            break;
    }
    [self.pickerPopover dismissPopoverAnimated:YES];
}

@end
