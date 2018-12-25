//
//  InspectionUpLoader.m
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "InspectionUpLoader.h"

@implementation InspectionUpLoader

- (void)upLoadProcess{
    NSArray *upLoadArray = [Inspection uploadArrayOfObject];
    if (upLoadArray.count > 0) {
        Inspection *obj = [upLoadArray objectAtIndex:0];
        self.uploadObj = obj;
        InspectionNewModel *inspectionNewModel = [[InspectionNewModel alloc] initWithInspection:obj];
        NSArray *recordArray = [InspectionRecord recordsForInspection:obj.inspection_id];
        NSArray *normalArray = [InspectionRecordNormal normalsForInspection:obj.inspection_id];
            
        NSMutableArray *recordModelArray = [[NSMutableArray alloc] initWithCapacity:1];
        NSMutableArray *normalModelArray = [[NSMutableArray alloc] initWithCapacity:1];
        for (InspectionRecord *record in recordArray) {
            InspectionRecordModel *recordModel = [[InspectionRecordModel alloc] initWithInspectionRecord:record];
            [recordModelArray addObject:recordModel];
        }
        for (InspectionRecordNormal *normal in normalArray) {
            InspectionRecordNormalModel *normalModel = [[InspectionRecordNormalModel alloc] initWithInspectionRecordNormal:normal];
            [normalModelArray addObject:normalModel];
        }
        WebUpLoadInit;
        [service upLoadInspection:inspectionNewModel InspectionRecord:recordModelArray InspectionRecordNormal:normalModelArray];
    } else {
         [[NSNotificationCenter defaultCenter] postNotificationName:FINISHNOTINAME object:nil];
    }
}

- (void)updateProgress{
    [super updateProgress];
    
    Inspection *inspection = (Inspection *)self.uploadObj;
    inspection.isuploaded = @(YES);
    [[AppDelegate App] saveContext];
    [self upLoadProcess];
}
@end
