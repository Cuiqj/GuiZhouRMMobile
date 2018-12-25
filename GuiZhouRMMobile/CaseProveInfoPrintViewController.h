//
//  CaseProveInfoPrintViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CasePrintViewController.h"
#import	"CaseProveInfo.h"

@interface CaseProveInfoPrintViewController : CasePrintViewController

@property (nonatomic, weak) IBOutlet UITextField *textcase_short_desc;//单行多文本框    案由
@property (nonatomic, weak) IBOutlet UITextField *textprover1;//单行多文本框    勘查人1
@property (nonatomic, weak) IBOutlet UITextField *textprover1_duty;//单行多文本框    单位及职务
@property (nonatomic, weak) IBOutlet UITextField *textprover2;//单行多文本框    勘查人2
@property (nonatomic, weak) IBOutlet UITextField *textprover2_duty;//单行多文本框    单位及职务
@property (nonatomic, weak) IBOutlet UITextField *textprover_place;//单行多文本框    勘验场所
@property (nonatomic, weak) IBOutlet UITextField *textrecorder;//单行多文本框    勘察记录人
@property (nonatomic, weak) IBOutlet UITextField *textrecorder_duty;//单行多文本框    单位及职务
@property (nonatomic, weak) IBOutlet UITextField *textinvitee;//单行多文本框    被邀请人
@property (nonatomic, weak) IBOutlet UITextField *textInvitee_org_duty;//单行多文本框    被邀请人单位及职务
@property (nonatomic, weak) IBOutlet UITextField *textorganizer;//单行多文本框    天气

@property (nonatomic, weak) IBOutlet UITextField *textstart_date_time;//单行多文本框    勘验开始时间
@property (nonatomic, weak) IBOutlet UITextField *textend_date_time;//单行多文本框    勘验结束时间
@property (nonatomic, weak) IBOutlet UITextField *textparty;//单行多文本框    当事人（代理人）
@property (nonatomic, weak) IBOutlet UITextField *textparty_sex;//单行多文本框    性别
@property (nonatomic, weak) IBOutlet UITextField *textparty_age;//单行多文本框    年龄
@property (nonatomic, weak) IBOutlet UITextField *textparty_card;//单行多文本框    身份证号
@property (nonatomic, weak) IBOutlet UITextField *textparty_org_duty;//单行多文本框    单位及职务
@property (nonatomic, weak) IBOutlet UITextField *textparty_tel;//单行多文本框    联系电话
@property (nonatomic, weak) IBOutlet UITextView *textevent_desc;//多行多文本框    事件简况及现场描述

@property (nonatomic, weak) IBOutlet UITextField *textprover1_code;//单行多文本框    执法证号1
@property (nonatomic, weak) IBOutlet UITextField *textprover2_code;//单行多文本框    执法证号2
@property (nonatomic, weak) IBOutlet UITextField *textrecorder_code;//单行多文本框    执法证号（记录人）
@property (nonatomic, weak) IBOutlet UITextField *textcitizen_name;//单行多文本框    当事人
@property (nonatomic, weak) IBOutlet UITextField *textcitizen_sex;//单行多文本框    性别
@property (nonatomic, weak) IBOutlet UITextField *textcitizen_age;//单行多文本框    年龄
@property (nonatomic, weak) IBOutlet UITextField *textcitizen_no;//单行多文本框    身份证号
@property (nonatomic, weak) IBOutlet UITextField *textcitizen_duty;//单行多文本框    单位及职务
@property (nonatomic, weak) IBOutlet UITextField *textcitizen_address;//单行多文本框    住址
@property (nonatomic, weak) IBOutlet UITextField *textcitizen_tel;//单行多文本框    联系电话

- (IBAction)reFormEvetDesc:(UIButton *)sender;

- (void)generateDefaultInfo:(CaseProveInfo *)caseProveInfo;

@end