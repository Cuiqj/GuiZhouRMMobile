//
//  RoadWayClosed.m
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "RoadWayClosed.h"


@implementation RoadWayClosed

@dynamic closed_reason;
@dynamic closed_result;
@dynamic closed_roadway;
@dynamic creator;
@dynamic fix;
@dynamic inportant;
@dynamic isuploaded;
@dynamic it_company;
@dynamic it_duty;
@dynamic it_telephone;
@dynamic maintainplan_id;
@dynamic org_id;
@dynamic promulgate;
@dynamic put_flag;
@dynamic remark;
@dynamic roadsegment_id;
@dynamic roadwayclosed_id;
@dynamic station_end;
@dynamic station_start;
@dynamic time_end;
@dynamic time_start;
@dynamic title;
@dynamic type;
@dynamic record_date;

+ (NSArray *)roadWayCloseInfoForID:(NSString *)roadWayCloseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSString *currentOrgID=[[NSUserDefaults standardUserDefaults] stringForKey:ORGKEY];
    if ([roadWayCloseID isEmpty]) {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"org_id == %@",currentOrgID]];
    } else {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"roadwayclosed_id == %@ && org_id == %@",roadWayCloseID,currentOrgID]];
    }
    return [context executeFetchRequest:fetchRequest error:nil];
}

#pragma mark - UploadDataProtocol
- (NSString *)dataPredicateString
{
    return [NSString stringWithFormat:@"roadwayclosed_id == %@", self.roadwayclosed_id];
}

@end
