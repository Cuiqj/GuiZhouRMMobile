//
//  AccInfoBriefViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CaseInfo.h"

#import "CaseIDHandler.h"
#import "CaseProveInfo.h"
#import "AccInfoPickerViewController.h"
#import "ParkingNode.h"
#import "DateSelectController.h"

@interface AccInfoBriefViewController : UIViewController<UITextFieldDelegate,setCaseTextDelegate,DatetimePickerHandler>

@property (nonatomic,copy) NSString * caseID;

@property (nonatomic, weak) IBOutlet UITextField *textreason;
@property (weak, nonatomic) IBOutlet UITextField *textCaseType;
@property (weak, nonatomic) IBOutlet UILabel *labelParkingLocation;
@property (weak, nonatomic) IBOutlet UITextField *textParkingLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelStartTime;
@property (weak, nonatomic) IBOutlet UITextField *textStartTime;
@property (weak, nonatomic) IBOutlet UILabel *labelEndTime;
@property (weak, nonatomic) IBOutlet UITextField *textEndTime;
@property (weak, nonatomic) IBOutlet UISwitch *swithIsParking;
@property (weak, nonatomic) IBOutlet UITextField *textCaseFromInspection;
@property (weak, nonatomic) IBOutlet UITextField *textCaseFromParty;
@property (weak, nonatomic) IBOutlet UITextField *textCaseFromInformer;
@property (weak, nonatomic) IBOutlet UITextField *textCaseFromOther;
@property (weak, nonatomic) IBOutlet UITextField *textCaseFromDepartment;

@property (nonatomic,weak) id<CaseIDHandler> delegate;

- (IBAction)selectCaseReason:(id)sender;
- (IBAction)selectCaseType:(id)sender;
- (IBAction)selectTime:(id)sender;
- (IBAction)selectParkingLocation:(id)sender;

- (IBAction)parkingChanged:(UISwitch *)sender;
- (void)saveDataForCase:(NSString *)caseID;
- (void)loadDataForCase:(NSString *)caseID;
- (void)newDataForCase:(NSString *)caseID;
@end
