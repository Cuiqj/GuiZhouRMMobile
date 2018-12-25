//
//  CaseServiceReceiptViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-24.
//
//

#import "CasePrintViewController.h"
#import "CaseServiceFiles.h"
#import "CaseServiceReceipt.h"
#import "ServiceFileEditorViewController.h"

@interface CaseServiceReceiptViewController : CasePrintViewController<ServiceFileEditorDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textincepter_name;//单行多文本框    受送达人
@property (nonatomic, weak) IBOutlet UITextField *textservice_company;//单行多文本框    送达单位

@property (nonatomic, weak) IBOutlet UITextView *textremark;//多行多文本框    备注
@property (nonatomic, weak) IBOutlet UITextField *textreason;//单行多文本框   案由
@property (weak, nonatomic) IBOutlet UITableView *tableDetail;

- (IBAction)btnAddNew:(id)sender;
- (void)generateDefaultInfo:(CaseServiceReceipt *)caseServiceFiles;
@end
