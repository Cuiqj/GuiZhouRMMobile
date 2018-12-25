//
//  AccInfoPickerViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Citizen.h"
#import "Systype.h"
typedef enum {
    kCaseReason = 0,
    kPeccancyType,
    kParkingLocation
} AccInfoPickerState;

@protocol setCaseTextDelegate;

@interface AccInfoPickerViewController : UITableViewController

@property (nonatomic,assign) AccInfoPickerState pickerType;
@property (nonatomic,retain) UIPopoverController *pickerPopover;
@property (nonatomic,weak) id<setCaseTextDelegate> delegate;
@property (nonatomic,weak) NSString *caseID;
@end

@protocol setCaseTextDelegate <NSObject>

-(void)setCaseText:(NSString *)aText;

@end