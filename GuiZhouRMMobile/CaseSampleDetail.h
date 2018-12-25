//
//  CaseSampleDetail.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-27.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CaseSampleDetail : NSManagedObject

@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * description_text;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * object_address;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * spec;
@property (nonatomic, retain) NSString * unit;
//读取案号对应的记录
+(NSArray *)caseSampleDetailsForCase:(NSString *)caseID;
+ (CaseSampleDetail *)newCaseSampleDetailForID:(NSString *)caseID;
@end
