//
//  AtonementNoticeViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-23.
//
//

/* 赔补偿通知书 */

#import "CasePrintViewController.h"
#import	"AtonementNotice.h"

@interface AtonementNoticeViewController : CasePrintViewController

- (IBAction)btnFormEventDesc:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textParty;
@property (weak, nonatomic) IBOutlet UITextField *textPartyAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelCaseCode;
@property (nonatomic, weak) IBOutlet UITextField *textdate_send;//单行多文本框    下达日期

@property (nonatomic, weak) IBOutlet UITextView *textcase_desc;//多行多文本框    案件详细信息
@property (nonatomic, weak) IBOutlet UITextField *textwitness;//多行多文本框    所附证据
@property (nonatomic, weak) IBOutlet UITextField *textpay_mode;//单行多文本框    赔补偿人民币大写

@property (nonatomic, weak) IBOutlet UITextField *textpay_real;//单行多文本框    赔补偿人民币小写
@property (nonatomic, weak) IBOutlet UITextView *textlaw_zhan;//单行多文本框    占（利）用标准第几项

@property (nonatomic, weak) IBOutlet UITextField *textatonementreason;//单行多文本框    案由（赔补偿）
@property (nonatomic, weak) IBOutlet UITextField *textlinkAddress;//单行多文本框    许可单位地址
@property (nonatomic, weak) IBOutlet UITextField *textlinkMan;//单行多文本框    联系人
@property (nonatomic, weak) IBOutlet UITextField *textlinkTel;//单行多文本框    联系电话

@property (nonatomic, weak) IBOutlet UITextField *textfixed_legal;//单行多文本框

- (void)generateDefaultInfo:(AtonementNotice *)atonementNotice;

@end
