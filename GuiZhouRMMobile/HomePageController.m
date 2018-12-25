//
//  HomePageController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HomePageController.h"
#import "OrgInfo.h"
#import "UserInfo.h"
#import "UpdateChecker.h"
#import "LawDocsViewController.h"

//定义自动更新检查间隔天数
#define updateCheckOffsetDays 30

@interface HomePageController ()
- (void) loadOrgLabel;
- (void) loadUserLabel;
@property (nonatomic,retain) UIPopoverController *popover;
@end

@implementation HomePageController
@synthesize labelOrgShortName;
@synthesize labelCurrentUser;
@synthesize popover;

- (void) loadOrgLabel {
    NSString *currentOrg=[[NSUserDefaults standardUserDefaults] stringForKey:ORGKEY];
    if (currentOrg==nil) {
        currentOrg = @"";
    }
    self.labelOrgShortName.text=[[OrgInfo orgInfoForOrgID:currentOrg] valueForKey:@"orgshortname"];
}

- (void) loadUserLabel {
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
    if (currentUserName==nil) {
        currentUserName = @"";
    }
    self.labelCurrentUser.text=[[NSString alloc] initWithFormat:@"操作员：%@",currentUserName];
}

//监测是否设置当前机构，否则弹出机构选择菜单
- (void)viewDidAppear:(BOOL)animated{
    [self loadOrgLabel];
    [self loadUserLabel];
    NSString *currentOrg=[[NSUserDefaults standardUserDefaults] stringForKey:ORGKEY];
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    if (currentOrg == nil || [currentOrg isEmpty]) {
        OrgSyncViewController *osVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OrgSyncVC"];
        osVC.modalPresentationStyle = UIModalPresentationFormSheet;
        osVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        osVC.delegate=self;
        [self presentModalViewController:osVC animated:YES];
        return;
    } else {
        if (currentUserID == nil || [currentUserID isEmpty]) {
            [self performSegueWithIdentifier:@"toLogin" sender:nil];
            return;
        }        
    }
    
    NSDate *lastUpdateCheckDate = [[NSUserDefaults standardUserDefaults] objectForKey:UPDATECHECKDATEKEY];
    if (lastUpdateCheckDate == nil) {
        NSDate *checkDate = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:checkDate forKey:UPDATECHECKDATEKEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        /*
         //自动更新检查测试用代码
         NSString *date = @"2013-04-06 19:34";
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         [formatter setLocale:[NSLocale currentLocale]];
         [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
         NSDate *today = [formatter dateFromString:date];
        //*/
        
        NSDate *today = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setDay:updateCheckOffsetDays];
        NSDate *nextUpdateCheckDate = [gregorian dateByAddingComponents:offsetComponents toDate:lastUpdateCheckDate options:0];
        if ([today compare:nextUpdateCheckDate] == NSOrderedDescending) {
            [[UpdateChecker sharedInstance] checkUpdate];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"toLogin"]) {
        LoginViewController *lvc=[segue destinationViewController];
        lvc.delegate=self;
    } else if ([[segue identifier] isEqualToString:@"toLogoutView"]){
        LogoutViewController *lvc=[segue destinationViewController];
        lvc.delegate=self;
        self.popover = [(UIStoryboardPopoverSegue *) segue popoverController];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.popover isPopoverVisible]) {
        [self.popover dismissPopoverAnimated:animated];
    }
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
    [self setLabelOrgShortName:nil];
    [self setLabelCurrentUser:nil];
    [self setPopover:nil];
    [super viewDidUnload];
}

- (void)reloadOrgLabel{
    [self loadOrgLabel];
}

- (void)reloadUserLabel{
    [self loadUserLabel];
}

- (void)pushLoginView{
    [self performSegueWithIdentifier:@"toLogin" sender:nil];
}

- (IBAction)btnLogOut:(UIBarButtonItem *)sender {
    if ([self.popover isPopoverVisible]) {
        [self.popover dismissPopoverAnimated:YES];
    } else {
        [self performSegueWithIdentifier:@"toLogoutView" sender:nil];
    }
}

- (IBAction)touchToLawDocs:(id)sender
{
    LawDocsViewController *lawVc = [[LawDocsViewController alloc] initWithNibName:@"LawDocsViewController" bundle:nil];
    [self.navigationController pushViewController:lawVc animated:YES];
}


- (void)logOut{
    [self.popover dismissPopoverAnimated:YES];
    NSString *inspectionID=[[NSUserDefaults standardUserDefaults] valueForKey:INSPECTIONKEY];
    if (![inspectionID isEmpty] && inspectionID!=nil) {
        void(^ShowAlert)(void)=^(void){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"当前还有未完成的巡查，请先交班再切换用户。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        };
        MAINDISPATCH(ShowAlert);
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:USERKEY];
        [self loadUserLabel];
        [self performSegueWithIdentifier:@"toLogin" sender:nil];
    }
}

- (void)inspectionDeliver{
    [self.popover dismissPopoverAnimated:YES];
    NSString *inspectionID=[[NSUserDefaults standardUserDefaults] valueForKey:INSPECTIONKEY];
    if ([inspectionID isEmpty] || inspectionID == nil) {
        void(^ShowAlert)(void)=^(void){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"没有正在进行的巡查，无法交班。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        };
        MAINDISPATCH(ShowAlert);
    } else {
        [self performSegueWithIdentifier:@"toInspectionOutFromMain" sender:nil];
    }
}
@end
