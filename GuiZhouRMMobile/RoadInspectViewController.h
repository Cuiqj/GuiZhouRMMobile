//
//  RoadInspectViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InspectionRecordNormal.h"
#import "AddNewInspectRecordViewController.h"
#import "InspectionRecordCell.h"
#import "NewInspectionViewController.h"
#import "InspectionOutViewController.h"
#import "RoadSegmentPickerViewController.h"
#import "DateSelectController.h"
#import "InspectionListViewController.h"

typedef enum {
    kRecord = 0,
    kNormal
} InpectionState;

@interface RoadInspectViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,InspectionHandler,DatetimePickerHandler,RoadSegmentPickerDelegate,UITextFieldDelegate,InspectionListDelegate>

- (IBAction)btnSaveRemark:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet UIView *normalView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *inpsectionSeg;
@property (weak, nonatomic) IBOutlet UILabel *labelInspectionInfo;
@property (weak, nonatomic) IBOutlet UITextView *textViewRemark;
@property (weak, nonatomic) IBOutlet UITableView *tableRecordList;
@property (weak, nonatomic) IBOutlet UILabel *labelRemark;
@property (weak, nonatomic) IBOutlet UITextField *textRoad;
@property (weak, nonatomic) IBOutlet UITextField *textStartKM;
@property (weak, nonatomic) IBOutlet UITextField *textStartM;
@property (weak, nonatomic) IBOutlet UITextField *textEndKm;
@property (weak, nonatomic) IBOutlet UITextField *textEndm;
@property (weak, nonatomic) IBOutlet UITextField *textStartTime;
@property (weak, nonatomic) IBOutlet UITextField *textEndTime;
@property (weak, nonatomic) IBOutlet UIButton *uiButtonAddNew;
@property (weak, nonatomic) IBOutlet UIButton *uiButtonSave;
@property (weak, nonatomic) IBOutlet UIButton *uiButtonDeliver;
- (IBAction)selectRoad:(id)sender;
- (IBAction)btnAddNew:(id)sender;
- (IBAction)segSwitch:(id)sender;
- (IBAction)selectTimeStart:(id)sender;
- (IBAction)selectTimeEnd:(id)sender;
- (IBAction)btnDeliver:(UIButton *)sender;
- (IBAction)btnInpectionList:(id)sender;

- (IBAction)imageSelect:(UIButton *)sender;

@property (nonatomic,retain) NSString *inspectionID;
@property (nonatomic,assign) InpectionState state;

@property (nonatomic,retain) NSString *imageSelectID;
@end
