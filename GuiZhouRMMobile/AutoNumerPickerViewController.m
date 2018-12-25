//
//  AutoNumerPickerViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AutoNumerPickerViewController.h"
#import "Systype.h"
#import "Citizen.h"

@interface AutoNumerPickerViewController ()
@property (nonatomic,retain) NSArray *data;
@end

@implementation AutoNumerPickerViewController
@synthesize data=_data;
@synthesize delegate=_delegate;
@synthesize caseID=_caseID;
@synthesize popOver=_popOver;
@synthesize pickerType=_pickerType;

-(void)viewWillAppear:(BOOL)animated{
    switch (self.pickerType) {
        case kCarType:
            self.data=[Systype typeValueForCodeName:@"车型"];
            break;
        case kNexus:
            self.data=[Systype typeValueForCodeName:@"与当事人关系"];
            break;
        case kCarTradeMark:
            self.data=[Systype typeValueForCodeName:@"车辆品牌"];
            break;
        case kProfession:
            self.data = [Systype typeValueForCodeName:@"当事人职务"];
            break;
        default:
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setDelegate:nil];
    [self setPopOver:nil];
    [self setCaseID:nil];
    [self setData:nil];
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
    if (cell == nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text=[self.data objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [self.delegate setAutoNumberText:cell.textLabel.text];
    [self.popOver dismissPopoverAnimated:YES];
}

@end
