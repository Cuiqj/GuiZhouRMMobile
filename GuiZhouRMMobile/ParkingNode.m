//
//  ParkingNode.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-18.
//
//

#import "ParkingNode.h"


@implementation ParkingNode
@dynamic belong_org;
@dynamic citizen_address;
@dynamic citizen_automobile_trademark;
@dynamic citizen_car_property;
@dynamic citizen_driving_no;
@dynamic citizen_happen_address;
@dynamic citizen_name;
@dynamic citizen_tel;
@dynamic code;
@dynamic date_end;
@dynamic date_send;
@dynamic date_start;
@dynamic deal_org;
@dynamic deal_org_address;
@dynamic deal_org_linkman;
@dynamic deal_org_tel;
@dynamic caseinfo_id;
@dynamic linkAddress;
@dynamic linkMan;
@dynamic linkTel;
@dynamic park_address;
@dynamic reason;
@dynamic reject_reason_date;
@dynamic remark;
@dynamic parkno;
@dynamic yearno;
@dynamic time_stop;
@dynamic unlimited_law_items;
@dynamic unlimited_law_main;


+ (ParkingNode *)parkingNodeForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    fetchRequest.entity=entity;
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@",caseID];
    fetchRequest.predicate=predicate;
    if ([context countForFetchRequest:fetchRequest error:nil]>0) {
        return [[context executeFetchRequest:fetchRequest error:nil] lastObject];;
    } else {
        return nil;
    }
}

+ (void)deleteAllParkingNodeForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"ParkingNode" inManagedObjectContext:context];
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
