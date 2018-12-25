//
//  UnlimitedUnloadNoticePrintViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-29.
//
//

/* 超限车辆卸载通知书 */


#import "CasePrintViewController.h"
#import	"UnlimitedUnloadNotice.h"

@interface UnlimitedUnloadNoticePrintViewController : CasePrintViewController

@property (weak, nonatomic) IBOutlet UILabel *labelParty;
@property (weak, nonatomic) IBOutlet UILabel *labelCaseCode;

@property (nonatomic, weak) IBOutlet UITextField *textroadName;//单行多文本框    路线名
@property (nonatomic, weak) IBOutlet UITextField *textcarNumber;//单行多文本框    车牌号
@property (nonatomic, weak) IBOutlet UITextField *textzou;//单行多文本框    轴数
@property (nonatomic, weak) IBOutlet UITextField *textgoods;//单行多文本框    运输货物
@property (nonatomic, weak) IBOutlet UITextField *textweight;//单行多文本框    车货总重（吨）
@property (nonatomic, weak) IBOutlet UITextField *textunlimit;//单行多文本框    超限（吨）
@property (nonatomic, weak) IBOutlet UITextField *textunload;//单行多文本框    责令卸载（吨）
@property (nonatomic, weak) IBOutlet UITextField *textsendDate;//单行多文本框    发文日期
@property (nonatomic, weak) IBOutlet UITextField *textlimitDate;//单行多文本框    自行卸载限定日期

- (void)generateDefaultInfo:(UnlimitedUnloadNotice *)unlimitedUnloadNotice;
@end
