//
//  CaseCountDetail.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-28.
//
//

#import "CaseCountDetail.h"


@implementation CaseCountDetail

@dynamic caseinfo_id;
@dynamic roadasset_name;
@dynamic rasset_size;
@dynamic depart_num;
@dynamic price;
@dynamic quantity;
@dynamic remark;
@dynamic total_price;
@dynamic unit;
@dynamic assetId;


+ (NSArray *)allCaseCountDetailsForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@",caseID];
    fetchRequest.predicate=predicate;
    return [context executeFetchRequest:fetchRequest error:nil];
}

+ (double)countSumPriceForCase:(NSString *)caseID{
    NSArray *deforms = [CaseCountDetail allCaseCountDetailsForCase:caseID];
    return [[deforms valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
}

+ (void)copyAllCaseDeformationsToCaseCountDetailsForCase:(NSString *)caseID{
    NSArray *deforms = [CaseDeformation allDeformationsForCase:caseID];
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    for (CaseDeformation *deform in deforms) {
        CaseCountDetail *detail = [[CaseCountDetail alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        detail.caseinfo_id = deform.caseinfo_id;
        detail.rasset_size = deform.rasset_size;
        detail.roadasset_name = deform.roadasset_name;
        detail.depart_num = deform.depart_num;
        detail.price = deform.price;
        detail.quantity = deform.quantity;
        detail.remark = deform.remark;
        detail.total_price = deform.total_price;
        detail.unit = deform.unit;
        detail.assetId = deform.assetId;
        [[AppDelegate App] saveContext];
    }
}

+ (void)deleteAllCaseCountDetailsForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id == %@",caseID];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entity];
    NSArray *temp=[context executeFetchRequest:fetchRequest error:nil];
    for (NSManagedObject *obj in temp) {
        [context deleteObject:obj];
    }
    [[AppDelegate App] saveContext];
}
@end
