//
//  CitizenInfoBriefViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CaseIDHandler.h"
#import "AutoNumerPickerViewController.h"
#import "Citizen.h"

@interface CitizenInfoBriefViewController : UIViewController<UITextFieldDelegate,AutoNumberPickerDelegate>
- (IBAction)showPicker:(id)sender;
- (IBAction)citizenFlagSwitch:(UISegmentedControl *)sender;
@property (weak, nonatomic) IBOutlet UITextField *textAutoNumber;
@property (weak, nonatomic) IBOutlet UITextField *textParty;
@property (weak, nonatomic) IBOutlet UITextField *textNexus;
@property (weak, nonatomic) IBOutlet UISegmentedControl *textSex;
@property (weak, nonatomic) IBOutlet UITextField *textAge;
@property (weak, nonatomic) IBOutlet UITextField *textDriver;
@property (weak, nonatomic) IBOutlet UITextField *textLegal;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segCitizenFlag;
@property (weak, nonatomic) IBOutlet UITextField *textCardNO;
@property (weak, nonatomic) IBOutlet UITextField *textAddress;
@property (weak, nonatomic) IBOutlet UITextField *textDriverTel;
@property (weak, nonatomic) IBOutlet UITextField *textIdentityCard;
@property (weak, nonatomic) IBOutlet UITextField *textDriverAddress;

@property (weak, nonatomic) IBOutlet UITextField *textProfession;
@property (weak, nonatomic) IBOutlet UITextField *textTelNumber;
@property (weak, nonatomic) IBOutlet UITextField *textPostalCode;
@property (weak, nonatomic) IBOutlet UITextField *textCarTradeMark;
@property (weak, nonatomic) IBOutlet UITextField *textCarType;

@property (nonatomic,copy) NSString * caseID;
@property (nonatomic,weak) id<CaseIDHandler> delegate;

@property (weak, nonatomic) IBOutlet UILabel *labelProfession;
@property (weak, nonatomic) IBOutlet UILabel *labelSex;
@property (weak, nonatomic) IBOutlet UIButton *uiButtonCopy;
@property (weak, nonatomic) IBOutlet UILabel *labelAge;
@property (weak, nonatomic) IBOutlet UILabel *labelPostalCode;
@property (weak, nonatomic) IBOutlet UILabel *labelIdentityCard;
@property (weak, nonatomic) IBOutlet UILabel *lableAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelTel;
@property (weak, nonatomic) IBOutlet UILabel *labelLegal;
- (IBAction)copyPartyToDriver:(id)sender;

-(void)saveCitizenInfoForCase:(NSString *)caseID;
-(void)loadCitizenInfoForCase:(NSString *)caseID;
-(void)newDataForCase:(NSString *)caseID;
@end

