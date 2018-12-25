//
//  LawDocsRightViewController.h
//  GuiZhouRMMobile
//
//  Created by XU SHIWEN on 13-10-23.
//
//

#import <UIKit/UIKit.h>

@interface LawDocsRightViewController : UIViewController

- (void)showTableView:(BOOL)visible;
- (void)showWebView:(BOOL)visible;
- (void)loadTableData:(id)data;
- (void)loadWebData:(NSURL *)url;
@end
