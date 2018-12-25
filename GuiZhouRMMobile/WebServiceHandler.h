//
//  WebServiceHandler.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UpLoadModelHeader.h"
#import <Foundation/Foundation.h>

@protocol WebServiceReturnString;

@interface WebServiceHandler : NSObject;
@property (nonatomic,retain) id<WebServiceReturnString> delegate;
@property (nonatomic,retain) NSString *currentOrgID;

- (void)getOrgInfo;
- (void)getUserInfo;
- (void)getIconModels;
- (void)getEmployeeInfo;
- (void)getRoad;
- (void)getRoadassetPriceModel;
- (void)getRoadEngrossPriceModel;
- (void)getSystypeList;
- (void)getOrgSysTypeList;
- (void)getCheckType;
- (void)getCheckReason;
- (void)getCheckStatus;
- (void)getCheckHandle;
- (void)getCaselaySet;

- (void)upLoadRoadWayCloseeModel:(NSArray *)roadWayClosedArray;
- (void)upLoadInspection:(InspectionNewModel *)inspectionNewModel
        InspectionRecord:(NSArray *)recordModels
  InspectionRecordNormal:(NSArray *)normalModels;

- (void)upLoadCaseInfoProjectModel:(ProjectModel *)project
                       ParkingNode:(ParkingNodeModel *)parkingNode
                           Citizen:(CitizenModel *)citizen
                     CaseProveInfo:(CaseProveInfoModel *)caseProveInfo
                          CaseInfo:(CaseInfoModel *)caseInfo
                    PunishDecision:(PunishDecisionModel *)punishDecision
                   AtonementNotice:(AtonementNoticeModel *)atonementNotice
                   CaseLawbreaking:(CaseLawbreakingModel *)caseLawbreaking
                       ForceNotice:(ForceNotice *)forceNotice
             UnlimitedUnloadNotice:(UnlimitedUnloadNoticeModel *)unlimitedUnloadNotice
                         CaseCount:(CaseCountModel *)caseCount
             CaseCountDetailsArray:(NSArray *)countDetailsArray
                CaseServiceReceipt:(CaseServiceReceiptModel *)caseServiceReceipt
             CaseServiceFilesArray:(NSArray *)serviceFilesArray
                   CaseSampleArray:(NSArray *)sampleArray
             CaseSampleDetailArray:(NSArray *)sampleDetailsArray
                  CaseInquireArray:(NSArray *)inquireArray
              CaseDeformationArray:(NSArray *)deformationArray;

- (void)uploadCaseProveMap:(NSString *)caseCode
                   citizen:(NSString *)party
                   mapPath:(NSString *)imagePath;

- (void)uploadAttechmentFiles:(NSString *)caseCode
                      citizen:(NSString *)party
                  photoString:(NSString *)photo
                    photoName:(NSString *)name;

-(void)getPermitData:(NSString *)permitNo
           startDate:(NSString *)startdate
             endDate:(NSString *)enddate
         permitOrgId:(NSString *)orgId;
-(void)getPermitAppInfo:(NSString *)permit_no;
-(void)getPermitUnlimitInfo:(NSString *)permit_no;
-(void)getPermitAdvInfo:(NSString *)permit_no;
-(void)getPermitAuditListInfo:(NSString *)permit_no;
-(void)getPermitattechmentListInfo:(NSString *)permit_no;


//测试网络连通性
+ (BOOL)isServerReachable;
@end

@protocol WebServiceReturnString <NSObject>

@optional
- (void)getWebServiceReturnString:(NSString *)webString forWebService:(NSString *)serviceName;
- (void)requestTimeOut;
- (void)requestUnkownError;

@end
