//
//  DataUpLoader.m
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "DataUpLoader.h"
#import "UploadedRecordList.h"
#import "UploadedDataManager.h"

@interface DataUpLoader()
@property (nonatomic, strong) UploadedDataManager *uploadedDataManager;
@end

@implementation DataUpLoader

- (UploadedDataManager *)uploadedDataManager
{
    if (_uploadedDataManager == nil) {
        _uploadedDataManager = [[UploadedDataManager alloc] init];
    }
    return _uploadedDataManager;
}


- (void)startUpLoad{
    [self upLoadProcess];
}

- (void)upLoadProcess{};

- (void)updateProgress{
    NSString *tableName = NSStringFromClass([self.uploadObj class]);
    NSString *findStr = [self.uploadObj dataPredicateString];
    [self.uploadedDataManager addUploadedRecord:tableName withFindStr:findStr];
    [self.uploadedDataManager writeToDB];
}

- (void)getWebServiceReturnString:(NSString *)webString forWebService:(NSString *)serviceName{
    BOOL success = NO;
    TBXML *xml = [TBXML newTBXMLWithXMLString:webString error:nil];
    TBXMLElement *root = [xml rootXMLElement];
    TBXMLElement *r1 = root->firstChild;
    TBXMLElement *r2 = r1->firstChild;
    TBXMLElement *r3 = r2->firstChild;
    if (r3) {
        NSString *outString = [TBXML textForElement:r3];
        if (outString.boolValue) {
            success = YES;
        }
    }
    if (success) {
        [self updateProgress];
    } else {
        NSDictionary *postInfo = [NSDictionary dictionaryWithObject:@"上传数据出现错误：请检查案件信息是否完整" forKey:@"message"];
        [[NSNotificationCenter defaultCenter] postNotificationName:ERRORNOTI object:nil userInfo:postInfo];
    }
}

- (void)requestTimeOut{
    NSDictionary *postInfo = [NSDictionary dictionaryWithObject:@"上传数据出现错误：请求超时" forKey:@"message"];
    [[NSNotificationCenter defaultCenter] postNotificationName:ERRORNOTI object:nil userInfo:postInfo];
}

- (void)requestUnkownError{
    NSDictionary *postInfo = [NSDictionary dictionaryWithObject:@"上传数据出现错误：未知请求错误" forKey:@"message"];
    [[NSNotificationCenter defaultCenter] postNotificationName:ERRORNOTI object:nil userInfo:postInfo];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setUploadObj:nil];
}



@end
