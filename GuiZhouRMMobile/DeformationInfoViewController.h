//
//  DeformationInfoViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoadAssetCell.h"
#import "DeformInfoBriefViewController.h"
#import "CaseIDHandler.h"
#import "RoadAssetPrice.h"
#import "NormalListSelectController.h"

@interface DeformationInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,CaseIDHandler,NormalListSelectDelegate>
@property (nonatomic,copy) NSString * caseID;
@property (weak, nonatomic) IBOutlet UITableView *roadAssetListView;
@property (weak, nonatomic) IBOutlet UIPickerView *labelPicker;
@property (nonatomic,retain) DeformInfoBriefViewController *deformInfoVC;

@property (weak, nonatomic) IBOutlet UILabel *labelQuantity;
@property (weak, nonatomic) IBOutlet UITextField *textQuantity;
@property (weak, nonatomic) IBOutlet UILabel *labelLength;
@property (weak, nonatomic) IBOutlet UITextField *textLength;
@property (weak, nonatomic) IBOutlet UILabel *labelWidth;
@property (weak, nonatomic) IBOutlet UITextField *textWidth;
@property (weak, nonatomic) IBOutlet UIButton *btnAddDeform;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UITextField *textPrice;
@property (weak, nonatomic) IBOutlet UIView *addNewAssetView;
@property (weak, nonatomic) IBOutlet UITextField *textAssetName;
@property (weak, nonatomic) IBOutlet UITextField *textSpec;
@property (weak, nonatomic) IBOutlet UITextField *textAssetUnit;
@property (weak, nonatomic) IBOutlet UITextField *textAssetPrice;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonSelectPriceStandard;

- (IBAction)textNumberChanged:(id)sender;
- (IBAction)btnAddDeformation:(id)sender;
- (IBAction)btnDismiss:(id)sender;
- (IBAction)selectPriceStandard:(UIBarButtonItem *)sender;

@end
