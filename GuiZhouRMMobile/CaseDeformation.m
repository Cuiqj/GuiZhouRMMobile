//
//  CaseDeformation.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-7.
//
//

#import "CaseDeformation.h"


@implementation CaseDeformation

@dynamic assetId;
@dynamic casedeformation_id;
@dynamic caseinfo_id;
@dynamic citizen_name;
@dynamic price;
@dynamic quantity;
@dynamic rasset_size;
@dynamic remark;
@dynamic roadasset_name;
@dynamic total_price;
@dynamic unit;
@dynamic depart_num;

+ (NSArray *)allDeformationsForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@",caseID];
    fetchRequest.predicate=predicate;
    return [context executeFetchRequest:fetchRequest error:nil];
}

+ (double)deformSumPriceForCase:(NSString *)caseID{
    NSArray *deforms = [CaseDeformation allDeformationsForCase:caseID];
    return [[deforms valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
}

@end
