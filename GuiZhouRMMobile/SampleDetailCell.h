//
//  SampleDetailCell.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 13-1-23.
//
//

#import <UIKit/UIKit.h>

@interface SampleDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelSampleName;
@property (weak, nonatomic) IBOutlet UILabel *labelSampleSpec;
@property (weak, nonatomic) IBOutlet UILabel *labelSampleQuantity;
@property (weak, nonatomic) IBOutlet UILabel *labelRemark;

@end
