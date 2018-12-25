//
//  ForceNoticeModel.m
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-17.
//
//
#import "ForceNoticeModel.h"

@implementation ForceNoticeModel

- (id)initWithForceNotice:(ForceNotice *)forcenotice{
    self = [super init];
    if (self && forcenotice) {
        self.fact = forcenotice.fact;
        self.break_law = forcenotice.break_law;
        self.basis_law = forcenotice.basis_law;
        self.change_spot = forcenotice.change_spot;
        self.change_limit = forcenotice.change_limit;
        self.change_time = [self.dateFormatter stringFromDate:forcenotice.change_time];
        self.change_action = forcenotice.change_action;
        self.handle_time = [self.dateFormatter stringFromDate:forcenotice.handle_time];
        self.date_send = [self.dateFormatter stringFromDate:forcenotice.date_send];
        self.linkAddress = forcenotice.linkAddress;
        self.linkMan = forcenotice.linkMan;
        self.linkTel = forcenotice.linkTel;
        self.dsrname = forcenotice.dsrname;
    } else {
        return nil;
    }
    return self;
}

@end
