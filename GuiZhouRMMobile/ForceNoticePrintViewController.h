//
//  ForceNoticePrintViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-28.
//
//

/* 责令改正通知书 */

#import "CasePrintViewController.h"
#import "ForceNotice.h"
@interface ForceNoticePrintViewController : CasePrintViewController

@property (weak, nonatomic) IBOutlet UILabel *labelParty;
@property (weak, nonatomic) IBOutlet UILabel *labelCaseCode;
@property (nonatomic, weak) IBOutlet UITextView *textfact;//多行多文本框    违法事实

@property (nonatomic, weak) IBOutlet UITextView *textbasis_law;//多行多文本框    依据法律
@property (nonatomic, weak) IBOutlet UITextField *textchange_spot;//单行多文本框    第几项需立刻改正
@property (nonatomic, weak) IBOutlet UITextField *textchange_limit;//单行多文本框    第几项需限期改正
@property (nonatomic, weak) IBOutlet UITextField *textchange_time;//单行多文本框    改正期限
@property (nonatomic, weak) IBOutlet UITextView *textchange_action;//多行多文本框    改正内容和要求

@property (nonatomic, weak) IBOutlet UITextField *textdate_send;//单行多文本框    发文日期

- (void)generateDefaultInfo:(ForceNotice *)forceNotice;

@end
