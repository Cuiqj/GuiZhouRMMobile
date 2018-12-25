//
//  PaintRemarkTextViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-7-10.
//  Copyright (c) 2012年 中交宇科 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaintHeader.h"

@interface PaintRemarkTextViewController : UIViewController<UITextViewDelegate>
- (IBAction)btnBack:(id)sender;
- (IBAction)btnSave:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (nonatomic,copy) NSString *caseID;
@end
