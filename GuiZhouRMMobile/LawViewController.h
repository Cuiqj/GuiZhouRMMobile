//
//  LawViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LawViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITableView *tvAttechment;
@property (weak, nonatomic) IBOutlet UITableView *tvMainList;
@property (retain, nonatomic) IBOutlet UIWebView *docview;

@end
