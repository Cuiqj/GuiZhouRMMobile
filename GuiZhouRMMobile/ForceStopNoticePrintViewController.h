//
//  ForceStopNoticePrintViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-29.
//
//


/* 责令停止（改正）违法行为通知书 */

#import "CasePrintViewController.h"
#import "ForceNotice.h"
@interface ForceStopNoticePrintViewController : CasePrintViewController

@property (weak, nonatomic) IBOutlet UILabel *labelParty;
@property (weak, nonatomic) IBOutlet UILabel *labelCaseCode;
@property (nonatomic, weak) IBOutlet UITextView *textfact;//多行多文本框    违法事实
@property (nonatomic, weak) IBOutlet UITextView *textbreak_law;//多行多文本框    违反法律
@property (nonatomic, weak) IBOutlet UITextField *texthandle_time;

@property (nonatomic, weak) IBOutlet UITextField *textlinkAddress;//单行多文本框    执法机构地址
@property (nonatomic, weak) IBOutlet UITextField *textlinkMan;//单行多文本框    联系人
@property (nonatomic, weak) IBOutlet UITextField *textlinkTel;//单行多文本框    联系电话
@property (nonatomic, weak) IBOutlet UITextField *textdate_send;//单行多文本框    发文日期

- (void)generateDefaultInfo:(ForceNotice *)forceNotice;

@end
