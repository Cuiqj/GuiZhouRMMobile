//
//  InquireInfoBriefViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InquireInfoViewController.h"
#import "AnswererPickerViewController.h"
#import "CaseIDHandler.h"

@interface InquireInfoBriefViewController : UIViewController<UITextFieldDelegate,setAnswererDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textNexus;
@property (weak, nonatomic) IBOutlet UITextField *textParty;
@property (weak, nonatomic) IBOutlet UITextView *inquireTextView;

@property (weak, nonatomic) id<CaseIDHandler> delegate;

@property (nonatomic,copy) NSString *caseID;
@property (nonatomic,copy) NSString *inquireID;

-(void)newDataForCase:(NSString *)caseID;
-(IBAction)textTouched:(id)sender;

-(void)loadInquireInfoForCase:(NSString *)caseID forInquire:(NSString *)inquireID;
@end
