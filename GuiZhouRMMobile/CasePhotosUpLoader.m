//
//  CasePhotosUpLoader.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-4.
//
//

#import "CasePhotosUpLoader.h"
#import "GTMDefines.h"
#import "GTMStringEncoding.h"
#import "CaseInfo.h"

@implementation CasePhotosUpLoader
- (void)upLoadProcess{
    NSArray *upLoadArray = [CasePhoto uploadArrayOfObject];
    if (upLoadArray.count > 0) {
        CasePhoto *obj = [upLoadArray objectAtIndex:0];
        self.uploadObj = obj;
        NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath=[pathArray objectAtIndex:0];
        NSString *photoPath=[NSString stringWithFormat:@"CasePhoto/%@",obj.caseinfo_id];
        photoPath = [documentPath stringByAppendingPathComponent:photoPath];
        photoPath = [photoPath stringByAppendingPathComponent:obj.photo_name];
        NSData *imageData = [[NSData alloc] initWithContentsOfFile:photoPath];
        GTMStringEncoding *encoding = [GTMStringEncoding rfc4648Base64StringEncoding];
        NSString *imageString = [encoding encode:imageData];
        NSString *imageName = [[NSString alloc] initWithFormat:@"现场照片%@",obj.photo_name];        
        WebUpLoadInit;
        [service uploadAttechmentFiles:obj.case_code citizen:obj.citizen_party photoString:imageString photoName:imageName];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:FINISHNOTINAME object:nil];
    }
}

- (void)updateProgress{
    [super updateProgress];
    
    CasePhoto *info = (CasePhoto *)self.uploadObj;
    info.isuploaded = @(YES);
    [[AppDelegate App] saveContext];
    [self upLoadProcess];
}
@end
