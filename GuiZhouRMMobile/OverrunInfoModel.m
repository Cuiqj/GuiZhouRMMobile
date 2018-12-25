//
//  OverrunInfoModel.m
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-25.
//
//
#import "OverrunInfoModel.h"

@implementation OverrunInfoModel

- (id)initWithOverrunInfo:(UnlimitedUnloadNoticeModel *)unlimitedUnloadNoticeModel{
    self = [super init];
    if (self && unlimitedUnloadNoticeModel) {
        self.goods_name = unlimitedUnloadNoticeModel.goods;
        self.carsallweight = unlimitedUnloadNoticeModel.weight;
        self.overlimit = unlimitedUnloadNoticeModel.unlimit;
        self.roadid = unlimitedUnloadNoticeModel.roadName;
        self.zhoushu = unlimitedUnloadNoticeModel.zou;
        self.hezai = [NSString stringWithFormat:@"%.2f",unlimitedUnloadNoticeModel.weight.floatValue - unlimitedUnloadNoticeModel.unlimit.floatValue];
        self.send_date = unlimitedUnloadNoticeModel.sendDate;
    } else {
        return nil;
    }
    return self;
}

@end
