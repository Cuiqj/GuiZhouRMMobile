//
//  CaseInfoUpLoader.m
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "CaseInfoUpLoader.h"

@implementation CaseInfoUpLoader
- (void)upLoadProcess{
    NSArray *upLoadArray = [CaseInfo uploadArrayOfObject];
    if (upLoadArray.count > 0) {
        CaseInfo *obj = [upLoadArray objectAtIndex:0];
        self.uploadObj = obj;
        CaseInfoModel *caseInfoModel = [[CaseInfoModel alloc] initWithCaseInfo:obj];
        
        ProjectModel *projectModel = [[ProjectModel alloc] initWithCaseInfo:obj];
        
        Citizen *citizen = [Citizen citizenForCase:obj.caseinfo_id];
        if (citizen == nil) {
            NSDictionary *postInfo = [NSDictionary dictionaryWithObject:@"请检查当事人信息是否完整。" forKey:@"message"];
            [[NSNotificationCenter defaultCenter] postNotificationName:ERRORNOTI object:self userInfo:postInfo];
            return;
        }
        
        CitizenModel *citizenModel = [[CitizenModel alloc] initWithCitizen:citizen];
        
        NSArray *caseInquireArray = [CaseInquire allInquireForCase:obj.caseinfo_id];
        NSMutableArray *caseInquireModelArray = [[NSMutableArray alloc] initWithCapacity:caseInquireArray.count];
        for (CaseInquire *inquire in caseInquireArray) {
            CaseInquireModel *inquireModel = [[CaseInquireModel alloc] initWithCaseInquire:inquire];
            [caseInquireModelArray addObject:inquireModel];
        }
        
        CaseProveInfo *caseProveInfo = [CaseProveInfo proveInfoForCase:obj.caseinfo_id];
        if (caseProveInfo == nil) {
            NSDictionary *postInfo = [NSDictionary dictionaryWithObject:@"请检查勘验笔录信息是否完整。" forKey:@"message"];
            [[NSNotificationCenter defaultCenter] postNotificationName:ERRORNOTI object:self userInfo:postInfo];
            return;
        }
        
        CaseProveInfoModel *caseProveInfoModel = [[CaseProveInfoModel alloc] initWithCaseProveInfo:caseProveInfo];
        
        ParkingNode *parkingNode = [ParkingNode parkingNodeForCase:obj.caseinfo_id];
        ParkingNodeModel *parkingModel = [[ParkingNodeModel alloc] initWithParkingNode:parkingNode];
        
        NSArray *caseDeformationArray = [CaseDeformation allDeformationsForCase:obj.caseinfo_id];
        NSMutableArray *caseDeformationModelArray = [[NSMutableArray alloc] initWithCapacity:caseDeformationArray.count];
        for (CaseDeformation *caseDeformation in caseDeformationArray) {
            CaseDeformationModel *caseDeformationModel = [[CaseDeformationModel alloc] initWithCaseDeformation:caseDeformation];
            [caseDeformationModelArray addObject:caseDeformationModel];
        }
        
        PunishDecision *pd = [PunishDecision punishDecisionForCase:obj.caseinfo_id];
        PunishDecisionModel *pdModel = [[PunishDecisionModel alloc] initWithPunishDecision:pd];
        
        AtonementNotice *an = [AtonementNotice atonementNoticeForCase:obj.caseinfo_id];
        AtonementNoticeModel *anModel = [[AtonementNoticeModel alloc] initWithAtonementNotice:an];
        
        CaseLawBreaking *clb = [CaseLawBreaking caseLawBreakingForCase:obj.caseinfo_id];
        CaseLawbreakingModel *clbModel = [[CaseLawbreakingModel alloc] initWithCaseLawbreaking:clb];
        
        ForceNotice *fn = [ForceNotice forceNoticeForCase:obj.caseinfo_id];
        
        UnlimitedUnloadNotice *uun = [UnlimitedUnloadNotice unlimitedUnloadNoticeForCase:obj.caseinfo_id];
        UnlimitedUnloadNoticeModel *uunModel = [[UnlimitedUnloadNoticeModel alloc] initWithUnlimitedUnloadNotice:uun];
        
        CaseCount *cc = [CaseCount caseCountForCase:obj.caseinfo_id];
        CaseCountModel *ccModel = [[CaseCountModel alloc] initWithCaseCount:cc];
        
        NSArray *caseCountDetailArray = [CaseCountDetail allCaseCountDetailsForCase:obj.caseinfo_id];
        NSMutableArray *ccdModelArray = [[NSMutableArray alloc] initWithCapacity:caseCountDetailArray.count];
        for (CaseCountDetail *detail in caseCountDetailArray) {
            CaseCountDetailModel *ccdModel = [[CaseCountDetailModel alloc] initWithCaseCountDetail:detail];
            [ccdModelArray addObject:ccdModel];
        }
        
        CaseServiceReceipt *csr = [CaseServiceReceipt caseServiceReceiptForCase:obj.caseinfo_id];
        CaseServiceReceiptModel *csrModel = [[CaseServiceReceiptModel alloc] initWithCaseServiceReceipt:csr];
        
        NSArray *csfArray = [CaseServiceFiles caseServiceFilesForCase:obj.caseinfo_id];
        NSMutableArray *csfModelArray = [[NSMutableArray alloc] initWithCapacity:csfArray.count];
        for (CaseServiceFiles *file in csfArray) {
            CaseServiceFilesModel *csfModel = [[CaseServiceFilesModel alloc] initWithCaseServiceFiles:file];
            [csfModelArray addObject:csfModel];
        }
        
        CaseSample *cs = [CaseSample caseSampleForCase:obj.caseinfo_id];
        CaseSampleModel *csModel = [[CaseSampleModel alloc] initWithCaseSample:cs];
        NSArray *csArray = csModel? @[csModel]: nil;
        
        NSArray *csdArray = [CaseSampleDetail caseSampleDetailsForCase:obj.caseinfo_id];
        NSMutableArray *csdModelArray = [[NSMutableArray alloc] initWithCapacity:csdArray.count];
        for (CaseSampleDetail *csd in csdArray) {
            CaseSampleDetailModel *csdModel = [[CaseSampleDetailModel alloc] initWithCaseSampleDetail:csd];
            [csdModelArray addObject:csdModel];
        }
        
        WebUpLoadInit;
        [service upLoadCaseInfoProjectModel:projectModel
                                ParkingNode:parkingModel
                                    Citizen:citizenModel
                              CaseProveInfo:caseProveInfoModel
                                   CaseInfo:caseInfoModel
                             PunishDecision:pdModel
                            AtonementNotice:anModel
                            CaseLawbreaking:clbModel
                                ForceNotice:fn
                      UnlimitedUnloadNotice:uunModel
                                  CaseCount:ccModel
                      CaseCountDetailsArray:ccdModelArray
                         CaseServiceReceipt:csrModel
                      CaseServiceFilesArray:csfModelArray
                            CaseSampleArray:csArray
                      CaseSampleDetailArray:csdModelArray
                           CaseInquireArray:caseInquireModelArray
                       CaseDeformationArray:caseDeformationModelArray];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:FINISHNOTINAME object:nil];
    }
}

- (void)updateProgress{
    [super updateProgress];
    
    CaseInfo *caseInfo = (CaseInfo *)self.uploadObj;
    caseInfo.isuploaded = @(YES);
    [[AppDelegate App] saveContext];
    [self upLoadProcess];
}

@end
