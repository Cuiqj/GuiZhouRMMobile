//
//  CaseSamplePrintViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 13-1-5.
//
//

#import "CasePrintViewController.h"
#import "CaseSample.h"
#import "CaseSampleDetail.h"
#import "SampleDetailEditorViewController.h"
#import "SampleDetailCell.h"

@interface CaseSamplePrintViewController : CasePrintViewController<SampleDetailEditorDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textname;//单行多文本框    被取证人姓名
@property (nonatomic, weak) IBOutlet UITextField *textlegal_person;//单行多文本框    法人代表
@property (nonatomic, weak) IBOutlet UITextField *textsex;//单行多文本框    被取证人性别
@property (nonatomic, weak) IBOutlet UITextField *textage;//单行多文本框    被取证人年龄
@property (nonatomic, weak) IBOutlet UITextField *textphone;//单行多文本框    被取证人电话
@property (nonatomic, weak) IBOutlet UITextField *textpostalcode;//单行多文本框    被取证人邮编
@property (nonatomic, weak) IBOutlet UITextField *textaddress;//单行多文本框    被取证人地址
@property (nonatomic, weak) IBOutlet UITextField *textdate_sample_start;//单行多文本框    取证开始时间
@property (nonatomic, weak) IBOutlet UITextField *textdate_sample_end;//单行多文本框    取证结束时间
@property (nonatomic, weak) IBOutlet UITextField *textplace;//单行多文本框    取证地点
@property (nonatomic, weak) IBOutlet UITextView *textremark;//多行多文本框    备注
@property (nonatomic, weak) IBOutlet UITextField *texttaking_names;//单行多文本框    现场负责人
@property (nonatomic, weak) IBOutlet UITextField *texttaking_company;//单行多文本框    取证单位及地址
@property (nonatomic, weak) IBOutlet UITextField *texttaking_postalcode;//单行多文本框    取证单位邮编
@property (weak, nonatomic) IBOutlet UITableView *tableDetail;
@property (nonatomic, weak) IBOutlet UITextField *textperson_incharge;//单行多文本框    现场负责人
@property (nonatomic, weak) IBOutlet UITextField *texttaking_company_tel;//单行多文本框    取证单位电话
@property (nonatomic, weak) IBOutlet UITextField *textsend_date;//单行多文本框    发布时间
@property (nonatomic, weak) IBOutlet UITextField *textcase_sample_reason;//单行多文本框    案由
- (void)generateDefaultInfo:(CaseSample *)caseSample;
- (IBAction)btnAddNew:(id)sender;

@end
