//
//  CaseInquirePrinterViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-8-9.
//  Copyright (c) 2012年 中交宇科 . All rights reserved.
//

#import "CasePrintViewController.h"
#import "CaseInquire.h"

@interface CaseInquirePrinterViewController : CasePrintViewController

@property (nonatomic, weak) IBOutlet UITextField *textdate_inquired_start;//单行多文本框    开始询问时间
@property (nonatomic, weak) IBOutlet UITextField *textdate_inquired_end;//单行多文本框    结束询问时间
@property (nonatomic, weak) IBOutlet UITextField *textinquired_times;//单行多文本框    询问次数
@property (nonatomic, weak) IBOutlet UITextField *textlocality;//单行多文本框    地点
@property (nonatomic, weak) IBOutlet UITextField *textinquirer_name;//单行多文本框    询问人
@property (nonatomic, weak) IBOutlet UITextField *textinquirer_name2;//单行多文本框    询问人2
@property (nonatomic, weak) IBOutlet UITextField *textrecorder_name;//单行多文本框    记录人
@property (nonatomic, weak) IBOutlet UITextField *textanswerer_name;//单行多文本框    被询问人
@property (nonatomic, weak) IBOutlet UITextField *textrelation;//单行多文本框    与案件关系
@property (nonatomic, weak) IBOutlet UITextField *textsex;//单行多文本框    被询问人性别
@property (nonatomic, weak) IBOutlet UITextField *textage;//单行多文本框    被询问人年龄
@property (nonatomic, weak) IBOutlet UITextField *textid_card;//单行多文本框    身份证
@property (nonatomic, weak) IBOutlet UITextField *textcompany_duty;//单行多文本框    被询问人工作单位及职务
@property (nonatomic, weak) IBOutlet UITextField *textphone;//单行多文本框    被询问人电话
@property (nonatomic, weak) IBOutlet UITextField *textpostalcode;//单行多文本框    被询问人邮编
@property (nonatomic, weak) IBOutlet UITextField *textaddress;//单行多文本框    被询问人地址
@property (nonatomic, weak) IBOutlet UITextView *textinquiry_note;//多行多文本框    询问笔录
@property (nonatomic, weak) IBOutlet UITextView *textremark;//多行多文本框    备注
@property (nonatomic, weak) IBOutlet UITextField *textedu_level;//单行多文本框    文化程度
@property (nonatomic, weak) IBOutlet UITextField *textinquirer1_no;//单行多文本框    询问人1的执法证号
@property (nonatomic, weak) IBOutlet UITextField *textinquirer2_no;//单行多文本框    询问人2的执法证号
@property (nonatomic, weak) IBOutlet UITextField *textrecorder_no;//单行多文本框    记录人的执法证号
@property (nonatomic, weak) IBOutlet UITextField *textinquirer_org;//单行多文本框    询问人单位
@property (weak, nonatomic) IBOutlet UITextField *textInquireNames;
@property (weak, nonatomic) IBOutlet UITextField *textInquireNos;
@end
