//
//  CaseDescListViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CaseDescListViewController.h"
#import "Systype.h"
    
@interface CaseDescListViewController ()
@property (nonatomic,retain) NSArray *data;
@end

@implementation CaseDescListViewController
@synthesize data=_data;
@synthesize popOver=_popOver;
@synthesize delegate=_delegate;
@synthesize caseProcessType = _caseProcessType;
//@synthesize caseID=_caseID;


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    switch (self.caseProcessType) {
        case 120:
            self.data = [Systype typeValueForCodeName:@"案由（处罚）"];
            break;
        case 130:
            self.data = [Systype typeValueForCodeName:@"案由（赔补偿）"];
            break;
        case 140:
            self.data = [Systype typeValueForCodeName:@"案由（强制）"];
            break;
        default:
            break;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.popOver isPopoverVisible]) {
        [self.popOver dismissPopoverAnimated:animated];
    }
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setData:nil];
    [self setPopOver:nil];
    [self setDelegate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
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
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
    /*
    CaseDescString *temp=[self.data objectAtIndex:indexPath.row];
    cell.textLabel.text=temp.caseDesc;
    if (temp.isSelected) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    */
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
    CaseDescString *temp=[self.data objectAtIndex:indexPath.row];
    temp.isSelected=YES;
    */
    [self.delegate setCaseDescDelegate:[self.data objectAtIndex:indexPath.row]];
    [self.popOver dismissPopoverAnimated:YES];
}

/*
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType=UITableViewCellAccessoryNone;
    CaseDescString *temp=[self.data objectAtIndex:indexPath.row];
    temp.isSelected=NO;
}    

- (IBAction)btnCancel:(id)sender {
    [self.popOver dismissPopoverAnimated:YES];
}

- (IBAction)btnConfirm:(id)sender {
    [self.delegate setCaseDescArrayDelegate:self.data];
    [self.popOver dismissPopoverAnimated:YES];
}
*/

@end

