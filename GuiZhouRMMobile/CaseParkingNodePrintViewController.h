//
//  CaseParkingNodeViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/* 责令停驶通知书 */

#import "CasePrintViewController.h"
#import "ParkingNode.h"

@interface CaseParkingNodePrintViewController : CasePrintViewController

@property (weak, nonatomic) IBOutlet UITextField *textDateSend;

@property (nonatomic, weak) IBOutlet UITextField *textpark_address;//单行多文本框    停车地点
@property (nonatomic, weak) IBOutlet UITextField *textdate_start;//单行多文本框    停车时间

@property (nonatomic, weak) IBOutlet UITextField *textremark;//多行多文本框    备注

@property (nonatomic, weak) IBOutlet UITextField *textreason;//多行多文本框    责令停驶原因
@property (nonatomic, weak) IBOutlet UITextField *textlinkAddress;//单行多文本框    执法机构地址
@property (nonatomic, weak) IBOutlet UITextField *textlinkMan;//单行多文本框    联系人
@property (weak, nonatomic) IBOutlet UITextField *linkTel;

@property (nonatomic, weak) IBOutlet UITextField *textcitizen_name;//单行多文本框    当事人姓名
@property (nonatomic, weak) IBOutlet UITextField *textcitizen_address;//单行多文本框    当事人住址
@property (nonatomic, weak) IBOutlet UITextField *textcitizen_tel;//单行多文本框    当事人联系电话
@property (nonatomic, weak) IBOutlet UITextField *textcitizen_driving_no;//单行多文本框    当事人驾驶证号
@property (nonatomic, weak) IBOutlet UITextField *textcitizen_car_property;//单行多文本框    车牌号或机具名称
@property (nonatomic, weak) IBOutlet UITextField *textcitizen_automobile_trademark;//单行多文本框    厂牌型号
@property (nonatomic, weak) IBOutlet UITextField *textcitizen_happen_address;//单行多文本框    案发地点
@property (weak, nonatomic) IBOutlet UILabel *labelCaseCode;
@property (weak, nonatomic) IBOutlet UILabel *labelCitizenName;
@property (weak, nonatomic) IBOutlet UILabel *labelHappenDate;
@property (weak, nonatomic) IBOutlet UILabel *labelAutoNumber;

@end
