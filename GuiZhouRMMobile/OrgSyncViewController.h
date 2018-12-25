//
//  OrgSyncViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-15.
//
//

#import <UIKit/UIKit.h>
#import "WebServiceHandler.h"
#import "OrgInfo.h"
#import "TBXML.h"
#import "DataDownLoad.h"

@protocol OrgSetDelegate;

@interface OrgSyncViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,WebServiceReturnString,UIAlertViewDelegate>
@property (retain, nonatomic) DataDownLoad *dataDownLoader;
@property (weak, nonatomic) IBOutlet UITableView *tableOrgList;
@property (weak, nonatomic) IBOutlet UITextField *textServerAddress;
@property (weak, nonatomic) id<OrgSetDelegate> delegate;
- (IBAction)showServerAddress:(UIBarButtonItem *)sender;
- (IBAction)setCurrentOrg:(UIBarButtonItem *)sender;

@end

@protocol OrgSetDelegate <NSObject>

- (void)reloadOrgLabel;
- (void)pushLoginView;
@end