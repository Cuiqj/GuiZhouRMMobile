//
//  InspectionOutViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-9-13.
//
//

#import <UIKit/UIKit.h>
//#import "CheckItemDetails.h"
//#import "CheckItems.h"
//#import "TempCheckItem.h"
#import "DateSelectController.h"
#import "InspectionOutCheck.h"
#import "Inspection.h"
#import "InspectionHandler.h"
#import "InspectionRecord.h"

@interface InspectionOutViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textViewDesc;
- (IBAction)btnCancel:(UIBarButtonItem *)sender;
- (IBAction)btnSave:(UIBarButtonItem *)sender;
- (IBAction)btnFormDesc:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *contentView;

@property (weak, nonatomic) IBOutlet UITextField *textWaitness1;
@property (weak, nonatomic) IBOutlet UITextField *textWaitness1Tel;
@property (weak, nonatomic) IBOutlet UITextField *textWaitness1Address;
@property (weak, nonatomic) IBOutlet UITextField *textWaitness2;
@property (weak, nonatomic) IBOutlet UITextField *textWaitness2Tel;
@property (weak, nonatomic) IBOutlet UITextField *textWaitness2Address;

@property (weak, nonatomic) id<InspectionHandler> delegate;

@end
