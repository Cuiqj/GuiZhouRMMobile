//
//  IllegalActNoticePrintViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-29.
//
//

/* 违法行为通知书 */

#import "CasePrintViewController.h"
#import "CaseLawBreaking.h"

@interface IllegalActNoticePrintViewController : CasePrintViewController

@property (weak, nonatomic) IBOutlet UILabel *labelParty;
@property (weak, nonatomic) IBOutlet UILabel *labelCaseCode;


@property (nonatomic, weak) IBOutlet UITextField *textdate_send;//单行多文本框    下达日期
@property (nonatomic, weak) IBOutlet UITextField *textlinkman;//单行多文本框    联系人

@property (nonatomic, weak) IBOutlet UITextView *textfact;//多行多文本框    违法事实
@property (nonatomic, weak) IBOutlet UITextView *textpunish_mode;//多行多文本框    处罚方式

@property (nonatomic, weak) IBOutlet UITextField *textlink_phone;//单行多文本框    处罚机关联系电话
@property (nonatomic, weak) IBOutlet UITextField *textlink_addr;//单行多文本框    处罚机关联系地址
@property (nonatomic, weak) IBOutlet UITextView *textlaw_disobey;//单行多文本框    违反法律
@property (nonatomic, weak) IBOutlet UITextView *textlaw_gist;//单行多文本框    依据法律

@property (nonatomic, weak) IBOutlet UITextField  *textlawbreakingreason;//单行多文本框    案由
@property (weak, nonatomic) IBOutlet UISegmentedControl *segFlag_StatePlea;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segFlag_Listen;
- (void)generateDefaultInfo:(CaseLawBreaking *)caseLawBreaking;
@end
