//
//  CaseServiceFilesModel.m
//  GuiZhouRMMobile
//
//  Created by auto_ipad on 2013-01-17.
//
//
#import "CaseServiceFilesModel.h"

@implementation CaseServiceFilesModel

- (id)initWithCaseServiceFiles:(CaseServiceFiles *)caseServiceFiles{
    self = [super init];
    if (self && caseServiceFiles) {
        self.service_file = caseServiceFiles.service_file;
        self.servicer_name = caseServiceFiles.servicer_name;
        self.servicer_name2 = caseServiceFiles.servicer_name2;
        self.receipt_date = [self.dateFormatter stringFromDate:caseServiceFiles.receipt_date];
        self.receipter_name = caseServiceFiles.receipter_name;
        self.send_address = caseServiceFiles.send_address;
        self.send_way = caseServiceFiles.send_way;
        self.remark = caseServiceFiles.remark;
        self.reason = caseServiceFiles.reason;
    } else {
        return nil;
    }
    return self;
}

@end
