//
//  LawDocsViewController.h
//  GuiZhouRMMobile
//
//  Created by XU SHIWEN on 13-10-23.
//
//

#import <UIKit/UIKit.h>

@interface LawDocsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *leftTopView;
@property (weak, nonatomic) IBOutlet UIView *leftBottomView;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@end


@class RoadAssetPrice;

@interface PriceStandard: NSObject

@property (nonatomic, strong) NSString *big_type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *spec;
@property (nonatomic, strong) NSString *unit_name;
@property (nonatomic, strong) NSString *remark;

+ (PriceStandard *)priceStandardFromCoreDataObject:(RoadAssetPrice *)cdObject;

@end
