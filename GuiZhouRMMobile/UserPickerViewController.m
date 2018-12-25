//
//  UserPickerViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-9-24.
//
//

#import "UserPickerViewController.h"
#import "UserInfo.h"
#import "EmployeeInfo.h"

@interface UserPickerViewController ()
@property (nonatomic,retain) NSArray *data;
@end

@implementation UserPickerViewController


- (void)viewWillAppear:(BOOL)animated{
    switch (self.pickerState) {
        case kUser:
            self.data = [UserInfo allUserInfo];
            break;
        default:
            self.data = [EmployeeInfo allEmployeeInfo];
            break;
    }

}

- (void)viewDidUnload
{
    [self setData:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    switch (self.pickerState) {
        case kUser:
            cell.textLabel.text=[[self.data objectAtIndex:indexPath.row] valueForKey:@"username"];
            break;
        default:
            cell.textLabel.text = [[self.data objectAtIndex:indexPath.row] valueForKey:@"name"];
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *userName;
    NSString *userID;
    switch (self.pickerState) {
        case kUser:{
            userName = [[self.data objectAtIndex:indexPath.row] valueForKey:@"username"];
            userID = [[self.data objectAtIndex:indexPath.row] valueForKey:@"myid"];
        }
            break;
        default:{
            userName = [[self.data objectAtIndex:indexPath.row] valueForKey:@"name"];
            userID = [[self.data objectAtIndex:indexPath.row] valueForKey:@"employee_id"];
        }
            break;
    }
    [self.delegate setUser:userName andUserID:userID];
    [self.pickerPopover dismissPopoverAnimated:YES];
}

@end
