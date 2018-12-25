//
//  RoadWayClosedUpLoader.m
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "RoadWayClosedUpLoader.h"

@implementation RoadWayClosedUpLoader
- (void)upLoadProcess{
    NSArray *upLoadArray = [RoadWayClosed uploadArrayOfObject];
    if (upLoadArray.count > 0) {
        RoadWayClosed *obj = [upLoadArray objectAtIndex:0];
        self.uploadObj = obj;
        RoadWayClosedModel *closeInfo = [[RoadWayClosedModel alloc] initWithRoadWayClosed:obj];
        WebUpLoadInit;
        [service upLoadRoadWayCloseeModel:@[ closeInfo ]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:FINISHNOTINAME object:nil];
    }
}

- (void)updateProgress{
    [super updateProgress];
    
    RoadWayClosed *info = (RoadWayClosed *)self.uploadObj;
    info.isuploaded = @(YES);
    [[AppDelegate App] saveContext];
    [self upLoadProcess];
}

@end
