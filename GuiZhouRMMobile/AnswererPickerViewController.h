//
//  AnswererPickerViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const TitleForNewInquire = @"新增被询问人";

@protocol setAnswererDelegate;

@interface AnswererPickerViewController : UITableViewController
@property (nonatomic,weak) id<setAnswererDelegate> delegate;
//@property (nonatomic,copy) NSString *caseID;
@property (nonatomic,weak) UIPopoverController *pickerPopover;
@property (nonatomic,assign) NSInteger pickerType;
@end

@protocol setAnswererDelegate <NSObject>

-(void)setAnswererDelegate:(NSString *)aText;

@optional
-(void)setNexusDelegate:(NSString *)aText;
-(NSString *)getCaseIDDelegate;
-(void)setAnswerSentence:(NSString *)answerSentence;
-(void)setAnswerSentenceUseMuban:(NSString *)answerSentence;
@end