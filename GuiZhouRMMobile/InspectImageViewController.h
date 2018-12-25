//
//  InspectImageViewController.h
//  GuiZhouRMMobile
//
//  Created by luna on 14-1-22.
//
//

#import <UIKit/UIKit.h>
#import "CaseInfo.h"

@interface InspectImageViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;

@property (weak, nonatomic) IBOutlet UILabel *labelPhotoIndex;

@property (weak, nonatomic) IBOutlet UIButton *uiButtonCamera;

@property (weak, nonatomic) IBOutlet UIButton *uiButtonPickFromLibrary;

@property (nonatomic,retain) UIPopoverController *caseInfoPickerpopover;

@property (nonatomic,retain) NSString *caseID;

@property (nonatomic,retain) NSString *photoPath;

- (IBAction)imageLibrary:(UIButton *)sender;

- (IBAction)imagePhoto:(UIButton *)sender;


- (IBAction)imageSave:(id)sender;


- (IBAction)backButton:(UIBarButtonItem *)sender;

@end
