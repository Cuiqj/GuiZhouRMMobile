//
//  CaseMapUpLoader.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-4.
//
//

#import "CaseMapUpLoader.h"
#import "CaseMap.h"

@implementation CaseMapUpLoader

- (void)upLoadProcess{
    NSArray *upLoadArray = [CaseMap uploadArrayOfObject];
    if (upLoadArray.count > 0) {
        CaseMap *obj = [upLoadArray objectAtIndex:0];
        self.uploadObj = obj;
        WebUpLoadInit;
        [service uploadCaseProveMap:obj.case_code citizen:obj.citizen_party mapPath:obj.map_path];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:FINISHNOTINAME object:nil];
    }
}

- (void)updateProgress{
    [super updateProgress];
    
    CaseMap *info = (CaseMap *)self.uploadObj;
    info.isuploaded = @(YES);
    [[AppDelegate App] saveContext];
    [self upLoadProcess];
}
@end
