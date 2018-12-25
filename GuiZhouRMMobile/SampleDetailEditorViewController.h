//
//  SampleDetailEditorViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 13-1-23.
//
//

#import <UIKit/UIKit.h>
#import "CaseSampleDetail.h"

@protocol SampleDetailEditorDelegate;

@interface SampleDetailEditorViewController : UIViewController

- (IBAction)btnDismiss:(UIBarButtonItem *)sender;
- (IBAction)btnComfirm:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UITextField *textSampleName;
@property (weak, nonatomic) IBOutlet UITextField *textSampleSpec;
@property (weak, nonatomic) IBOutlet UITextField *textSampleQuantity;
@property (weak, nonatomic) IBOutlet UITextField *textSampleRemark;

@property (nonatomic, retain) CaseSampleDetail *sampleDetail;
@property (nonatomic, retain) NSString *caseID;

@property (nonatomic, weak) id<SampleDetailEditorDelegate> delegate;
@end

@protocol SampleDetailEditorDelegate <NSObject>
- (void)reloadDataArray;
@end