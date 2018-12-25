//
//  PunishDecisionViewController.h
//  GuiZhouRMMobile
//
//  Created by Sniper One on 13-1-3.
//
//

/* 行政处罚决定书 */

#import "CasePrintViewController.h"
#import "PunishDecision.h"
#import "CaseLawBreaking.h"

static NSString * const Punish_Immeddiately_String = @"当场";
static NSString * const Punish_In15Days_String = @"15日内";


@interface PunishDecisionViewController : CasePrintViewController

@property (weak, nonatomic) IBOutlet UILabel *labelCitizen;

@property (weak, nonatomic) IBOutlet UILabel *labelCasecode;
@property (weak, nonatomic) IBOutlet UITextField *textsend_date;

@property (nonatomic, weak) IBOutlet UITextField *textorganization;//单行多文本框    交款银行
@property (nonatomic, weak) IBOutlet UITextField *textaccount_number;//单行多文本框    账号

@property (nonatomic, weak) IBOutlet UITextView *textcase_desc;//多行多文本框    违法事实及依据
@property (nonatomic, weak) IBOutlet UITextView *textlaw_disobey;//多行多文本框    违反法律条文
@property (nonatomic, weak) IBOutlet UITextView *textlaw_gist;//多行多文本框    依据法律条文

@property (nonatomic, weak) IBOutlet UITextField *textpunish_decision;//多行多文本框    处罚决定

@property (nonatomic, weak) IBOutlet UITextField *textwitness;//单行多文本框    证据材料
@property (nonatomic, weak) IBOutlet UITextField *textpunish_other;//单行多文本框    其它处罚方式

@property (nonatomic, weak) IBOutlet UITextField *textpunishreason;//单行多文本框    案由（处罚决定）

- (void)generateDefaultInfo:(PunishDecision *)punishDecision;
@end
