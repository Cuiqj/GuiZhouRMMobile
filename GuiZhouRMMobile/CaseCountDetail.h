//
//  CaseCountDetail.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-28.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "CaseDeformation.h"


@interface CaseCountDetail : NSManagedObject

@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * roadasset_name;
@property (nonatomic, retain) NSString * rasset_size;
@property (nonatomic, retain) NSString * depart_num;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSNumber * total_price;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSString * assetId;

+ (NSArray *)allCaseCountDetailsForCase:(NSString *)caseID;
+ (double)countSumPriceForCase:(NSString *)caseID;
+ (void)copyAllCaseDeformationsToCaseCountDetailsForCase:(NSString *)caseID;
+ (void)deleteAllCaseCountDetailsForCase:(NSString *)caseID;
@end
