//
//  Inspection.m
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-28.
//
//

#import "Inspection.h"


@implementation Inspection

@dynamic carcode;
@dynamic classe;
@dynamic date_inspection;
@dynamic delivertext;
@dynamic duty_leader;
@dynamic inspection_description;
@dynamic inspection_id;
@dynamic inspection_line;
@dynamic inspection_milimetres;
@dynamic inspection_place;
@dynamic inspectionor_name;
@dynamic isdeliver;
@dynamic organization_id;
@dynamic recorder_name;
@dynamic remark;
@dynamic time_end;
@dynamic time_start;
@dynamic weather;
@dynamic orgname;
@dynamic jianzheng_name1;
@dynamic jianzheng_address1;
@dynamic jianzheng_tel1;
@dynamic jianzheng_name2;
@dynamic jianzheng_address2;
@dynamic jianzheng_tel2;
@dynamic roadsegment_ids;
@dynamic isuploaded;
@dynamic isusual;
@dynamic record_date;

+ (NSArray *)inspectionForID:(NSString *)inspectionID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSString *currentOrg=[[NSUserDefaults standardUserDefaults] stringForKey:ORGKEY];
    if (![inspectionID isEmpty]) {
        [fetchRequest setPredicate:[NSPredicate  predicateWithFormat:@"inspection_id == %@ && organization_id == %@",inspectionID,currentOrg]];
    } else {
        [fetchRequest setPredicate:[NSPredicate  predicateWithFormat:@"isdeliver.boolValue == YES && organization_id == %@",currentOrg]];
    }
    return [context executeFetchRequest:fetchRequest error:nil];
}

+ (void)deleteInspectionForID:(NSString *)inspectionID{
    void(^deleteInfoForEntity)(NSString *) = ^(NSString *entityName){
        NSManagedObjectContext *context = [[AppDelegate App] managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        [request setPredicate:[NSPredicate predicateWithFormat:@"inspection_id == %@",inspectionID]];
        NSArray *fetchResult=[context executeFetchRequest:request error:nil];
        if (fetchResult.count>0) {
            for (NSManagedObject *tableInfo in fetchResult) {
                [context deleteObject:tableInfo];
            }
        }
        [[AppDelegate App] saveContext];
    };
    NSArray *tableArray = @[ @"Inspection", @"InspectionRecord", @"InspectionRecordNormal"];
    for (NSString *entityName in tableArray) {
        deleteInfoForEntity(entityName);
    }
}

#pragma mark - UploadDataProtocol
- (NSString *)dataPredicateString
{
    return [NSString stringWithFormat:@"inspection_id == %@", self.inspection_id];
}

@end
