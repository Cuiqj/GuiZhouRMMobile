//
//  CaseDeformation.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-7.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CaseDeformation : NSManagedObject

@property (nonatomic, retain) NSString * assetId;
@property (nonatomic, retain) NSString * casedeformation_id;
@property (nonatomic, retain) NSString * caseinfo_id;
@property (nonatomic, retain) NSString * citizen_name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * rasset_size;
@property (nonatomic, retain) NSString * remark;
@property (nonatomic, retain) NSString * roadasset_name;
@property (nonatomic, retain) NSNumber * total_price;
@property (nonatomic, retain) NSString * unit;
@property (nonatomic, retain) NSString * depart_num;

+ (NSArray *)allDeformationsForCase:(NSString *)caseID;
+ (double)deformSumPriceForCase:(NSString *)caseID;
@end
