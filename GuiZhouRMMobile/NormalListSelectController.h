//
//  NormalListSelectController.h
//  GuiZhouRMMobile
//
//  Created by XU SHIWEN on 13-8-7.
//
//

#import <UIKit/UIKit.h>

@protocol NormalListSelectDelegate;

@interface NormalListSelectController : UITableViewController
@property (nonatomic,weak) id<NormalListSelectDelegate> delegate;
@property (nonatomic,strong) NSArray *dataSource;
@end

@protocol NormalListSelectDelegate <NSObject>
@optional
- (void)listSelect:(NormalListSelectController *)listSelectController selectedIndexPath:(NSIndexPath *)tableIndexPath;
@end