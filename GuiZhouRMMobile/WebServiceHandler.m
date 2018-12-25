//
//  WebServiceHandler.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WebServiceHandler.h"
#import "RoadWayClosedModel.h"
#import "InspectionRecordModel.h"
#import "InspectionRecordNormalModel.h"
#import "GTMDefines.h"
#import "GTMStringEncoding.h"

static NSString *PASSWORD=@"Adam9999_xinlu";

@interface WebServiceHandler()
-(void)executeWebService:(NSString *)serviceName
             serviceParm:(NSString *)parms;

//@property (nonatomic, retain) NSMutableData *webData;
@end

@implementation WebServiceHandler
@synthesize delegate = _delegate;
//@synthesize webData = _webData;

//测试网络连通性
+ (BOOL)isServerReachable{
    NSURL *url1 = [NSURL URLWithString:[[AppDelegate App] serverAddress]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url1 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: nil];
    if (response == nil) {
        void(^ShowAlert)(void)=^(void){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"连接错误" message:@"无法连接到服务器，请检查网络连接。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        };
        MAINDISPATCH(ShowAlert);
        return NO;
    }
    return YES;
}

- (NSString *)currentOrgID{
    if (_currentOrgID == nil || [_currentOrgID isEmpty]) {
        _currentOrgID = [[NSUserDefaults standardUserDefaults] stringForKey:ORGKEY];
    }
    if (_currentOrgID == nil) {
        return @"";
    } else {
        return _currentOrgID;
    }
}

#pragma mark - getData

//获得所有组织机构信息
- (void)getOrgInfo{
    NSString *soapMessage=[NSString stringWithFormat:@"<web:getOrgList>\n"
                           "<web:in0>%@</web:in0>\n"
                           "</web:getOrgList>\n",PASSWORD];
    [self executeWebService:@"getOrgList" serviceParm:soapMessage];
   
}

//获得用户信息
- (void)getUserInfo{
    NSString *soapMessage=[NSString stringWithFormat:@"<web:getUserInfoList>\n"
                           "<web:in0>%@</web:in0>\n"
                           "<web:in1>%@</web:in1>\n"
                           "</web:getUserInfoList>\n",PASSWORD,self.currentOrgID];
    [self executeWebService:@"getUserInfo" serviceParm:soapMessage];
}

//获得当前机构所有道路信息
- (void)getRoad{
    NSString *soapMessage=[NSString stringWithFormat:@"<web:getRoadModel>\n"
                           "<web:in0>%@</web:in0>\n"
                           "<web:in1>%@</web:in1>\n"
                           "</web:getRoadModel>\n",PASSWORD,self.currentOrgID];
    [self executeWebService:@"getRoadModel" serviceParm:soapMessage];
}

//得到所有图标模型信息
- (void)getIconModels{
    NSString *soapMessage=[NSString stringWithFormat:@"<web:getIconModel>\n"
                           "<web:in0>%@</web:in0>\n"
                           "<web:in1>%@</web:in1>\n"
                           "</web:getIconModel>\n",PASSWORD,self.currentOrgID];
    [self executeWebService:@"getIconModel" serviceParm:soapMessage];
}

//得到员工信息
- (void)getEmployeeInfo{
    NSString *soapMessage=[NSString stringWithFormat:@"<web:getEmployeeInfoList>\n"
                           "<web:in0>%@</web:in0>\n"
                           "<web:in1>%@</web:in1>\n"
                           "</web:getEmployeeInfoList>\n",PASSWORD,self.currentOrgID];
    [self executeWebService:@"getEmployeeInfoList" serviceParm:soapMessage];
}

//得到所有路产损坏赔偿标准
- (void)getRoadassetPriceModel{
    NSString *soapMessage=[NSString stringWithFormat:@"<web:getRoadassetPriceModel>\n"
                           "<web:in0>%@</web:in0>\n"
                           "<web:in1>%@</web:in1>\n"
                           "</web:getRoadassetPriceModel>\n",PASSWORD,self.currentOrgID];
    [self executeWebService:@"getRoadassetPriceModel" serviceParm:soapMessage];
}

// 获取占利用标准
- (void)getRoadEngrossPriceModel
{
    NSString *soapMessage=[NSString stringWithFormat:@"<web:getRoadEngrossPriceModel>\n"
                           "<web:in0>%@</web:in0>\n"
                           "<web:in1>%@</web:in1>\n"
                           "</web:getRoadEngrossPriceModel>\n",PASSWORD,self.currentOrgID];
    [self executeWebService:@"getRoadEngrossPriceModel" serviceParm:soapMessage];
}

//得到所有选择列表信息
- (void)getSystypeList{
    NSString *soapMessage=[NSString stringWithFormat:@"<web:getSystypeList>\n"
                           "<web:in0>%@</web:in0>\n"
                           "<web:in1>%@</web:in1>\n"
                           "</web:getSystypeList>\n",PASSWORD,self.currentOrgID];
    [self executeWebService:@"getSystypeList" serviceParm:soapMessage];
}

//得到所有机构对应选择列表信息
- (void)getOrgSysTypeList{
    NSString *soapMessage=[NSString stringWithFormat:@"<web:getOrgSysTypeList>\n"
                           "<web:in0>%@</web:in0>\n"
                           "<web:in1>%@</web:in1>\n"
                           "</web:getOrgSysTypeList>\n",PASSWORD,self.currentOrgID];
    [self executeWebService:@"getOrgSysTypeList" serviceParm:soapMessage];
}


- (void)getCheckType{
    NSString *soapMessage=[NSString stringWithFormat:@"<web:getCheckTypeModel>\n"
                           "<web:in0>%@</web:in0>\n"
                           "<web:in1>%@</web:in1>\n"
                           "</web:getCheckTypeModel>\n",PASSWORD,self.currentOrgID];
    [self executeWebService:@"getCheckTypeModel" serviceParm:soapMessage];
}

- (void)getCheckReason{
    NSString *soapMessage=[NSString stringWithFormat:@"<web:getReasonModel>\n"
                           "<web:in0>%@</web:in0>\n"
                           "<web:in1>%@</web:in1>\n"
                           "</web:getReasonModel>\n",PASSWORD,self.currentOrgID];
    [self executeWebService:@"getReasonModel" serviceParm:soapMessage];
}

- (void)getCheckHandle{
    NSString *soapMessage=[NSString stringWithFormat:@"<web:getHandelModel>\n"
                           "<web:in0>%@</web:in0>\n"
                           "<web:in1>%@</web:in1>\n"
                           "</web:getHandelModel>\n",PASSWORD,self.currentOrgID];
    [self executeWebService:@"getHandelModel" serviceParm:soapMessage];
}

- (void)getCheckStatus{
    NSString *soapMessage=[NSString stringWithFormat:@"<web:getStatusModel>\n"
                           "<web:in0>%@</web:in0>\n"
                           "<web:in1>%@</web:in1>\n"
                           "</web:getStatusModel>\n",PASSWORD,self.currentOrgID];
    [self executeWebService:@"getStatusModel" serviceParm:soapMessage];
}


- (void)getCaselaySet{
    NSString *soapMessage=[NSString stringWithFormat:@"<web:getCaselaysetModel>\n"
                           "<web:in0>%@</web:in0>\n"
                           "</web:getCaselaysetModel>\n",PASSWORD];
    [self executeWebService:@"getCaselaysetModel" serviceParm:soapMessage];
}
/*
 *******************************
 获取许可信息，暂时功能屏蔽
 *******************************
*/
-(void)getPermitData:(NSString *)permitNo
           startDate:(NSString *)startdate
             endDate:(NSString *)enddate
         permitOrgId:(NSString *)orgId{
    //得到许可列表
    NSString *soapMessage=[NSString stringWithFormat:@"<web:getPermitList>\n"
                           "<web:in0>%@</web:in0>\n"
                           "<web:in1>%@</web:in1>\n"
                           "<web:in2>%@</web:in2>\n"
                           "<web:in3>%@</web:in3>\n"
                           "</web:getPermitList>\n",orgId,startdate,enddate,permitNo];
    [self executeWebService:@"getPermitList" serviceParm:soapMessage];
}

-(void)getPermitAppInfo:(NSString *)permit_no{
    //得到许可信息
    NSString *soapMessage=[NSString stringWithFormat:@"<web:getPermitInfo_app>\n"
                           "<web:in0>%@</web:in0>\n"
                           "</web:getPermitInfo_app>\n",permit_no];
    [self executeWebService:@"getPermitInfo_app" serviceParm:soapMessage];
    
}
-(void)getPermitUnlimitInfo:(NSString *)permit_no{
    //得到超限许可信息
    NSString *soapMessage=[NSString stringWithFormat:@"<web:getPermitInfo_unl>\n"
                           "<web:in0>%@</web:in0>\n"
                           "</web:getPermitInfo_unl>\n",permit_no];
    [self executeWebService:@"getPermitInfo_unl" serviceParm:soapMessage];
}
-(void)getPermitAdvInfo:(NSString *)permit_no{
    //得到广告许可信息
    NSString *soapMessage=[NSString stringWithFormat:@"<web:getPermitInfo_adv>\n"
                           "<web:in0>%@</web:in0>\n"
                           "</web:getPermitInfo_adv>\n",permit_no];
    [self executeWebService:@"getPermitInfo_adv" serviceParm:soapMessage];
}
-(void)getPermitAuditListInfo:(NSString *)permit_no{
    //得到许可审批信息
    NSString *soapMessage=[NSString stringWithFormat:@"<web:getPermitAuditList>\n"
                           "<web:in0>%@</web:in0>\n"
                           "</web:getPermitAuditList>\n",permit_no];
    [self executeWebService:@"getPermitAuditList" serviceParm:soapMessage];
}
-(void)getPermitattechmentListInfo:(NSString *)permit_no{
    //得到许可附件信息
    NSString *soapMessage=[NSString stringWithFormat:@"<web:getPermitAttach>\n"
                           "<web:in0>%@</web:in0>\n"
                           "</web:getPermitAttach>\n",permit_no];
    [self executeWebService:@"getPermitAttach" serviceParm:soapMessage];
}



#pragma mark - UpLoad
- (void)upLoadRoadWayCloseeModel:(NSArray *)roadWayClosedArray{
    NSString *roadWayModelString=@"";
    for (RoadWayClosedModel *model in roadWayClosedArray) {
        roadWayModelString=[roadWayModelString stringByAppendingString:[model XMLStringFromObjectWithPrefix:@"per"]];
    }
    NSString *soapMessage=[NSString stringWithFormat:@"<web:uploadRoadwayClose>\n"
                           "<web:in0>%@</web:in0>\n"
                           "<web:in1>%@</web:in1>\n"
                           "<web:in2>%@</web:in2>\n"
                           "</web:uploadRoadwayClose>\n",PASSWORD,self.currentOrgID,roadWayModelString];
    NSLog(@"uploadRoadwayClose (soapMessage):");
    NSLog(@"%@", soapMessage);
    [self executeWebService:@"uploadRoadwayClose" serviceParm:soapMessage];
}

- (void)upLoadInspection:(InspectionNewModel *)inspectionNewModel InspectionRecord:(NSArray *)recordModels InspectionRecordNormal:(NSArray *)normalModels{
    NSString *inspectionModelString = [inspectionNewModel XMLStringWithOutModelNameFromObjectWithPrefix:@"mod"];
    NSString *recordString = @"";
    for (InspectionRecordModel *record in recordModels) {
        recordString = [recordString stringByAppendingString:[record XMLStringFromObjectWithPrefix:@"mod1"]];
    }
    NSString *normalString = @"";
    for (InspectionRecordNormalModel *normal in normalModels) {
        normalString = [normalString stringByAppendingString:[normal XMLStringFromObjectWithPrefix:@"mod"]];
    }
    NSString *soapMessage=[NSString stringWithFormat:@"<web:UploadInspection>\n"
                           "<web:in0>%@</web:in0>\n"
                           "<web:in1>%@</web:in1>\n"
                           "<web:in2>%@</web:in2>\n"
                           "<web:in3>%@</web:in3>\n"
                           "</web:UploadInspection>\n",PASSWORD,inspectionModelString,recordString,normalString];
    NSLog(@"UploadInspection (soapMessage):");
    NSLog(@"%@", soapMessage);
    [self executeWebService:@"UploadInspection" serviceParm:soapMessage];
}


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
              CaseDeformationArray:(NSArray *)deformationArray{
    
        NSString *processType = project.process_id;
        NSString *yesOrNoType = [[[CaseInfo caseInfoForID:caseInfo.myid] yesornotype] stringValue];
        
        NSString *(^formedXMLElementForObj)(id, NSString *, NSInteger) = ^(id obj, NSString *objPrefix, NSInteger webSequenceNum){
            NSString *formedString = @"";
            if (obj) {
                if ([obj isKindOfClass:[UpDataModel class]]) {
                    formedString = [obj XMLStringWithOutModelNameFromObjectWithPrefix:objPrefix];
                } else if ([obj isKindOfClass:[NSArray class]]) {
                    if ([obj count] > 0) {
                        for (id childObj in obj) {
                            formedString = [formedString stringByAppendingString:[childObj XMLStringFromObjectWithPrefix:objPrefix]];
                        }
                    }
                }
            }
            NSString *webSeqString = [[NSString alloc] initWithFormat:@"web:in%d",webSequenceNum];
            NSString *finalString = [formedString serializedXMLElementStringWithElementName:webSeqString];
            return finalString;
        };
        
        NSString *projectString = formedXMLElementForObj(project, @"proj", 4);
        NSString *parkingString = formedXMLElementForObj(parkingNode, @"per", 5);
        NSString *citizenString = formedXMLElementForObj(citizen, @"per", 6);
        NSString *proveInfoString = formedXMLElementForObj(caseProveInfo, @"per", 7);
        NSString *caseInfoString = formedXMLElementForObj(caseInfo, @"per", 8);
        NSString *punishDecisionString = formedXMLElementForObj(punishDecision, @"per",9);
        NSString *inquiryString = formedXMLElementForObj(inquireArray, @"per", 11);
        NSString *atonemenNoticeString = formedXMLElementForObj(atonementNotice, @"per", 12);
        NSString *deformString = formedXMLElementForObj(deformationArray, @"per", 13);
        NSString *caseSampleString = formedXMLElementForObj(sampleArray, @"per", 14);
        NSString *serviceReciptString = formedXMLElementForObj(caseServiceReceipt, @"per", 17);
        NSString *lawbreakingString = formedXMLElementForObj(caseLawbreaking, @"per", 18);
        NSString *serviceFileString = formedXMLElementForObj(serviceFilesArray, @"per", 19);
        NSString *forceNoticeString;
        NSString *forceStopNoticeString;
        if (forceNotice) {
            ForceNoticeModel *fnModel = [[ForceNoticeModel alloc] initWithForceNotice:forceNotice];
            if (forceNotice.isStop.boolValue) {
                forceStopNoticeString = formedXMLElementForObj(fnModel, @"per", 21);
                forceNoticeString = @"<web:in20 xsi:nil=\"true\" />";
            } else {
                forceStopNoticeString = @"<web:in21 xsi:nil=\"true\" />";
                forceNoticeString = formedXMLElementForObj(fnModel, @"per", 20);
            }
        } else {
            forceNoticeString = @"<web:in20 xsi:nil=\"true\" />";
            forceStopNoticeString = @"<web:in21 xsi:nil=\"true\" />";
        }
        
        NSString *sampleDetailString = formedXMLElementForObj(sampleDetailsArray, @"per", 22);
        NSString *unlimitedUnloadString = formedXMLElementForObj(unlimitedUnloadNotice, @"per", 23);
        NSString *caseCountString = formedXMLElementForObj(caseCount, @"per", 24);
        NSString *caseCountDetailsString = formedXMLElementForObj(countDetailsArray, @"per", 25);
        
        OverrunInfoModel *oriModel = [[OverrunInfoModel alloc] initWithOverrunInfo:unlimitedUnloadNotice];
        NSString *overRunInfoString = formedXMLElementForObj(oriModel, @"per", 16);
        
        NSString *soapMessage=[NSString stringWithFormat:@"<web:UploadCaseInfoForIPad>\n"
                               "<web:in0>%@</web:in0>\n"
                               "<web:in1>%@</web:in1>\n"
                               "<web:in2>%@</web:in2>\n"
                               "<web:in3>%@</web:in3>\n"
                               "%@\n"  //---------------4
                               "%@\n"  //---------------5
                               "%@\n"  //---------------6
                               "%@\n"  //---------------7
                               "%@\n"  //---------------8
                               "%@\n"  //---------------9
                               "<web:in10 xsi:nil=\"true\" />\n"  //---------------10
                               "%@\n"  //---------------11
                               "%@\n"  //---------------12
                               "%@\n"  //---------------13
                               "%@\n"  //---------------14
                               "<web:in15 xsi:nil=\"true\" />\n"  //---------------15
                               "%@\n"  //---------------16
                               "%@\n"  //---------------17
                               "%@\n"  //---------------18
                               "%@\n"  //---------------19
                               "%@\n"  //---------------20
                               "%@\n"  //---------------21
                               "%@\n"  //---------------22
                               "%@\n"  //---------------23
                               "%@\n"  //---------------24
                               "%@\n"  //---------------25
                               "</web:UploadCaseInfoForIPad>\n",
                               PASSWORD,  //------------0
                               self.currentOrgID, //----1
                               processType,  //---------2
                               yesOrNoType,  //3
                               projectString,//4
                               parkingString,//5
                               citizenString,//6
                               proveInfoString,//7
                               caseInfoString,//8
                               punishDecisionString,//9
                               inquiryString,//11
                               atonemenNoticeString,//12
                               deformString,//13
                               caseSampleString,//14
                               overRunInfoString,//16
                               serviceReciptString,//17
                               lawbreakingString,//18
                               serviceFileString,//19
                               forceNoticeString,//20
                               forceStopNoticeString,//21
                               sampleDetailString,//22
                               unlimitedUnloadString,//23
                               caseCountString,//24
                               caseCountDetailsString//25
                               ];
    NSLog(@"UploadCaseInfoForIPad (soapMessage):");
    NSLog(@"%@", soapMessage);
        [self executeWebService:@"UploadCaseInfoForIPad" serviceParm:soapMessage];
}

- (void)uploadCaseProveMap:(NSString *)caseCode
                   citizen:(NSString *)party
                   mapPath:(NSString *)imagePath{
    NSData *imageData = [[NSData alloc] initWithContentsOfFile:imagePath];
    GTMStringEncoding *encoding = [GTMStringEncoding rfc4648Base64StringEncoding];
    NSString *imageString = [encoding encode:imageData];
    NSString *soapMessage = [NSString stringWithFormat:@"<web:UploadCaseProveMap>\n"
                             "<web:in0>%@</web:in0>\n"
                             "<web:in1>%@</web:in1>\n"
                             "<web:in2>%@</web:in2>\n"
                             "<web:in3>%@</web:in3>\n"
                             "</web:UploadCaseProveMap>\n",PASSWORD,caseCode,party,imageString
                             ];
    NSLog(@"UploadCaseProveMap (soapMessage):");
    NSLog(@"%@", soapMessage);
    [self executeWebService:@"UploadCaseProveMap" serviceParm:soapMessage];
}

- (void)uploadAttechmentFiles:(NSString *)caseCode
                      citizen:(NSString *)party
                  photoString:(NSString *)photo
                    photoName:(NSString *)name{
    if (![photo isEmpty]) {
        NSString *soapMessage = [NSString stringWithFormat:@"<web:UploadAttechmentFiles>\n"
                                        "<web:in0>%@</web:in0>\n"
                                        "<web:in1>%@</web:in1>\n"
                                        "<web:in2>%@</web:in2>\n"
                                        "<web:in3>%@</web:in3>\n"
                                        " <web:in4>%@</web:in4>"
                                        "</web:UploadAttechmentFiles>\n",PASSWORD,caseCode,party,photo,name
                                        ];
        NSLog(@"UploadAttechmentFiles (soapMessage):");
        NSLog(@"%@", soapMessage);
        [self executeWebService:@"UploadAttechmentFiles" serviceParm:soapMessage];
    }
}

-(void)executeWebService:(NSString *)serviceName
             serviceParm:(NSString *)parms{
    //web service request
    NSString *soapMessage=[NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"\n"
                            "xmlns:web=\"http://webserv.ifreeway.com\"\n"
                            "xmlns:proj=\"http://project.workflow.common.ifreeway.com\"\n"
                            "xmlns:per=\"http://permit.irmsgd.ifreeway.com\"\n"
                            "xmlns:mod=\"http://model.newinspection.inspection.irmsgd.ifreeway.com\"\n"
                            "xmlns:mod1=\"http://model.inspectionrecord.inspection.irmsgd.ifreeway.com\"\n"
                            "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n"
                            "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n"
                            "<soapenv:Body>\n"
                            "%@"
                            "</soapenv:Body>\n"
                            "</soapenv:Envelope>",parms];
    NSString *urlString=[[[AppDelegate App] serverAddress] stringByAppendingString:@"/services/PdaUpload"];
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:url];
    [theRequest setTimeoutInterval:240];
    NSString *msgLength=[NSString stringWithFormat:@"%d",[soapMessage length]];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: [NSString stringWithFormat:@"http://webserv.ifreeway.com/%@",serviceName] forHTTPHeaderField:@"SOAPAction"];
    
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:enc]];
    NSOperationQueue *queue=[NSOperationQueue mainQueue];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:theRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (data.length > 0 && error == nil) {
            NSString *theXML = [[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            [self.delegate getWebServiceReturnString:theXML forWebService:serviceName];
        } else if (error != nil && error.code == NSURLErrorTimedOut) {
            [self.delegate requestTimeOut];
        } else if (error != nil) {
            [self.delegate requestUnkownError];
        }
    }];
}

- (void)dealloc{
    [self setDelegate:nil];
}

@end
