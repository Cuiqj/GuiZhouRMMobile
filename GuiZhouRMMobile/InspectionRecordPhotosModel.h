//
//  InspectionRecordPhotosModel.h
//  GuiZhouRMMobile
//
//  Created by luna on 14-1-23.
//
//

#import <Foundation/Foundation.h>

@interface InspectionRecordPhotosModel : NSObject
@property (nonatomic, retain) NSString * inspection_id;
@property (nonatomic, retain) NSNumber * parent_id;

@property (nonatomic, retain) NSString * sketch;//图片文件名
@property (nonatomic, retain) NSString * description;//图片说明

@property (nonatomic, retain) NSString * uploadName;//上传人
@property (nonatomic, retain) NSString * shootName;//拍摄人
@property (nonatomic, retain) NSDate * uploadTime;  //上传时间
@property (nonatomic, retain) NSDate * shootTime;//拍摄时间
@property (nonatomic, retain) NSNumber * num;//序号

+(NSArray *)casePhotosForCase:(NSString *)caseID;

@end
