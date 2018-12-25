//
//  RoadSegmentPickerViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-9-19.
//
//

#import <UIKit/UIKit.h>
#import "Road.h"

typedef enum {
    kRoadSegment = 0,
    kRoadSide,
    kRoadPlace
} RoadSegmentPickerState;

@protocol RoadSegmentPickerDelegate;

@interface RoadSegmentPickerViewController : UITableViewController
@property (assign, nonatomic) RoadSegmentPickerState pickerState;
@property (weak, nonatomic) UIPopoverController *pickerPopover;
@property (weak, nonatomic) id<RoadSegmentPickerDelegate> delegate;

@end

@protocol RoadSegmentPickerDelegate <NSObject>
- (void)setRoad:(NSString *)aRoadID roadName:(NSString *)roadName;

@optional
- (void)setRoadPlace:(NSString *)place;
- (void)setRoadSide:(NSString *)side;

@end