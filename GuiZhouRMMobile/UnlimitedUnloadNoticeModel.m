//
//  UnlimitedUnloadNoticeModel.m
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-17.
//
//
#import "UnlimitedUnloadNoticeModel.h"

@implementation UnlimitedUnloadNoticeModel

- (id)initWithUnlimitedUnloadNotice:(UnlimitedUnloadNotice *)unlimitedUnloadNotice{
    self = [super init];
    if (self && unlimitedUnloadNotice) {
        self.roadName = unlimitedUnloadNotice.roadName;
        self.carNumber = unlimitedUnloadNotice.carNumber;
        self.zou = unlimitedUnloadNotice.zou.stringValue;
        self.goods = unlimitedUnloadNotice.goods;
        self.weight = unlimitedUnloadNotice.weight.stringValue;
        self.unlimit = unlimitedUnloadNotice.unlimit.stringValue;
        self.unload = unlimitedUnloadNotice.unload.stringValue;
        self.sendDate = [self.dateFormatter stringFromDate:unlimitedUnloadNotice.sendDate];
        self.limitDate = [self.dateFormatter stringFromDate:unlimitedUnloadNotice.limitDate];
        self.dsrname = unlimitedUnloadNotice.dsrname;
        self.ah = unlimitedUnloadNotice.ah;
    } else {
        return nil;
    }
    return self;
}

@end
