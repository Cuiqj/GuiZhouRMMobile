//
//  UserPickerViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-9-24.
//
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

typedef enum {
    kUser = 0,
    kEmployee
}UserPickerState;

@protocol UserPickerDelegate;

@interface UserPickerViewController : UITableViewController
@property (nonatomic,assign) UserPickerState pickerState;
@property (nonatomic,weak) id<UserPickerDelegate> delegate;
@property (nonatomic,weak) UIPopoverController *pickerPopover;
@end

@protocol UserPickerDelegate <NSObject>

-(void)setUser:(NSString *)name andUserID:(NSString *)userID;

@end