//
//  PunishDecisionSpotPrintViewController.h
//  GuiZhouRMMobile
//
//  Created by Sniper One on 13-1-3.
//
//

/* 行政当场处罚决定书 */

#import "CasePrintViewController.h"
#import "PunishDecisionViewController.h"

@interface PunishDecisionSpotPrintViewController : CasePrintViewController
@property (weak, nonatomic) IBOutlet UILabel *labelSingleParty;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segSex;
@property (weak, nonatomic) IBOutlet UILabel *labelIDNo;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelProfession;
@property (weak, nonatomic) IBOutlet UILabel *labelOrgParty;
@property (weak, nonatomic) IBOutlet UILabel *labellegalMan;
@property (weak, nonatomic) IBOutlet UILabel *labelOrgAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelOrgTel;

@property (weak, nonatomic) IBOutlet UILabel *labelCasecode;
@property (weak, nonatomic) IBOutlet UITextField *textsend_date;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segPunishImme;

@property (nonatomic, weak) IBOutlet UITextField *textorganization;//单行多文本框    交款银行
@property (nonatomic, weak) IBOutlet UITextField *textaccount_number;//单行多文本框    账号

@property (nonatomic, weak) IBOutlet UITextView *textcase_desc;//多行多文本框    违法事实及依据
@property (nonatomic, weak) IBOutlet UITextView *textlaw_disobey;//多行多文本框    违反法律条文
@property (nonatomic, weak) IBOutlet UITextView *textlaw_gist;//多行多文本框    依据法律条文

@property (nonatomic, weak) IBOutlet UITextField *textpunish_decision;//多行多文本框    处罚决定

@property (nonatomic, weak) IBOutlet UITextField *textwitness;//单行多文本框    证据材料

- (void)generateDefaultInfo:(PunishDecision *)punishDecision;
@end
