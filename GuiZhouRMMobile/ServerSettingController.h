//
//  ServerSettingController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataDownLoad.h"

@interface ServerSettingController : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelVersion;
@property (weak, nonatomic) IBOutlet UITextField *txtServer;
@property (weak, nonatomic) IBOutlet UITextField *txtFile;
@property (weak, nonatomic) IBOutlet UIButton *uibuttonInit;
@property (weak, nonatomic) IBOutlet UIButton *uibuttonReset;
@property (weak, nonatomic) IBOutlet UIButton *uibuttonUpLoad;
@property (weak, nonatomic) IBOutlet UIButton *uibuttonCheckUpdate;
@property (weak, nonatomic) IBOutlet UIButton *uibuttonDowloadXMLTable;
- (IBAction)btnSave:(id)sender;
- (IBAction)btnInitData:(id)sender;
- (IBAction)btnUpLoadData:(id)sender;
- (IBAction)btnDownLoadXMLTable:(id)sender;
- (IBAction)btnResetCurrentOrg:(id)sender;
- (IBAction)btnCheckUpdate:(id)sender;

@property (retain, nonatomic) DataDownLoad *dataDownLoader;
@end
