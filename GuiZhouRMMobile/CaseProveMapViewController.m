//
//  CaseProveMapViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-25.
//
//

#import "CaseProveMapViewController.h"
#import "CaseMap.h"
#import "UIImage+ImageScale.h"

static NSString * const xmlName = @"ProveMapTable";

@interface CaseProveMapViewController ()
@property (nonatomic, retain) CaseProveInfo *caseProveInfo;

- (NSString *)formedEventDescFromCase;
@end

@implementation CaseProveMapViewController
@synthesize caseID = _caseID;
@synthesize caseProveInfo = _caseProveInfo;


-(void)viewDidLoad{
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:xmlName];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_FRAME_WIDTH, VIEW_FRAME_HEIGHT);
    self.view.frame = viewFrame;
    if (![self.caseID isEmpty]) {
        self.caseProveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
        if (self.caseProveInfo == nil) {
            self.caseProveInfo = [CaseProveInfo newDataObject];
            self.caseProveInfo.caseinfo_id = self.caseID;
            [self generateDefaultInfo:self.caseProveInfo];
            [[AppDelegate App] saveContext];
        }
        [self pageLoadInfo];
    }
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    
    
    [super viewWillDisappear:animated];
}

- (void)pageLoadInfo{
    self.labelShortDesc.text = self.caseProveInfo.case_short_desc;
    self.labelProve1.text = self.caseProveInfo.prover1;
    self.labelProve1Duty.text = self.caseProveInfo.prover1_duty;
    self.labelProve2.text = self.caseProveInfo.prover2;
    self.labelProve2Duty.text = self.caseProveInfo.prover2_duty;
    self.labelProvePlace.text = self.caseProveInfo.prover_place;
    self.labelRecorder.text = self.caseProveInfo.recorder;
    self.labelRecorderDuty.text = self.caseProveInfo.recorder_duty;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.labelProveStart.text = [dateFormatter stringFromDate:self.caseProveInfo.start_date_time];
    self.labelProveEnd.text = [dateFormatter stringFromDate:self.caseProveInfo.end_date_time];
    self.labelProve1No.text = self.caseProveInfo.prover1_code;
    self.labelProve2No.text = self.caseProveInfo.prover2_code;
    self.labelRecorderNO.text = self.caseProveInfo.recorder_code;
    self.labelCitizen.text = self.caseProveInfo.citizen_name;
    self.labelAddress.text = self.caseProveInfo.citizen_address;
    CaseMap *caseMap = [CaseMap caseMapForCase:self.caseID];
    if (caseMap) {
        NSString *filePath=caseMap.map_path;
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            UIImage *imageFile = [[UIImage alloc] initWithContentsOfFile:filePath];
            self.mapView.image = imageFile;
        }
    } else {
        self.mapView.image = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLabelShortDesc:nil];
    [self setLabelCitizen:nil];
    [self setLabelAddress:nil];
    [self setLabelProvePlace:nil];
    [self setLabelProveStart:nil];
    [self setLabelProveEnd:nil];
    [self setLabelProve1:nil];
    [self setLabelProve1Duty:nil];
    [self setLabelProve1No:nil];
    [self setLabelProve2:nil];
    [self setLabelProve2:nil];
    [self setLabelProve2Duty:nil];
    [self setLabelProve2No:nil];
    [self setLabelRecorder:nil];
    [self setLabelRecorderDuty:nil];
    [self setLabelRecorderNO:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}

-(NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        UIGraphicsBeginImageContext(self.mapView.frame.size);
        [self.mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *temp = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:xmlName];
        [self drawDateTable:xmlName withDataModel:self.caseProveInfo];
        NSString *xmlString = [self xmlStringFromFile:xmlName];
        TBXML *tbxml = [TBXML newTBXMLWithXMLString:xmlString error:nil];
        TBXMLElement *root = tbxml.rootXMLElement;
        TBXMLElement *dataTable = [TBXML childElementNamed:@"DataTable" parentElement:root];
        if (dataTable) {
            TBXMLElement *rootElement = [TBXML childElementNamed:@"Image" parentElement:dataTable];
            if (rootElement) {
                TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:rootElement];
                if (originInXML) {
                    CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]+prLeftMargin;
                    CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]+prTopMargin;
                    TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:rootElement];
                    if (sizeInXML) {
                        CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue;
                        CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue;
                        CGRect rect = CGRectMake(x, y, width, height);
                        [temp drawInRect:rect];
                    }
                }
            }
        }
        UIGraphicsEndPDFContext();        
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}


//根据案件记录，完整勘验信息
- (void)generateDefaultInfo:(CaseProveInfo *)caseProveInfo{
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    if (caseProveInfo.start_date_time==nil) {
        caseProveInfo.start_date_time=[NSDate date];
    }
    if (caseProveInfo.end_date_time==nil) {
        caseProveInfo.end_date_time=[NSDate date];
    }
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
    NSArray *inspectorArray = [[NSUserDefaults standardUserDefaults] objectForKey:INSPECTORARRAYKEY];
    if (inspectorArray.count < 1) {
        caseProveInfo.prover1 = currentUserName;
        caseProveInfo.prover1_duty = [EmployeeInfo orgAndDutyForUserName:caseProveInfo.prover1];
        caseProveInfo.prover1_code = [EmployeeInfo enforceCodeForUserName:caseProveInfo.prover1];
    } else if (inspectorArray.count == 1){
        caseProveInfo.prover1 = [inspectorArray objectAtIndex:0];
        caseProveInfo.prover1_duty = [EmployeeInfo orgAndDutyForUserName:caseProveInfo.prover1];
        caseProveInfo.prover1_code = [EmployeeInfo enforceCodeForUserName:caseProveInfo.prover1];
    } else {
        caseProveInfo.prover1 = [inspectorArray objectAtIndex:0];
        caseProveInfo.prover2 = [inspectorArray objectAtIndex:1];
        caseProveInfo.prover1_duty = [EmployeeInfo orgAndDutyForUserName:caseProveInfo.prover1];
        caseProveInfo.prover1_code = [EmployeeInfo enforceCodeForUserName:caseProveInfo.prover1];
        caseProveInfo.prover2_duty = [EmployeeInfo orgAndDutyForUserName:caseProveInfo.prover2];
        caseProveInfo.prover2_code = [EmployeeInfo enforceCodeForUserName:caseProveInfo.prover2];
    }
    caseProveInfo.recorder = currentUserName;
    caseProveInfo.recorder_duty = [EmployeeInfo orgAndDutyForUserName:caseProveInfo.recorder];
    caseProveInfo.recorder_code = [EmployeeInfo enforceCodeForUserName:caseProveInfo.recorder];
    caseProveInfo.organizer = caseInfo.weather;
    caseProveInfo.prover_place = caseInfo.case_address;
    Citizen *citizen = [Citizen citizenForCase:self.caseID];
    if (citizen) {
        caseProveInfo.case_short_desc = [citizen.party stringByAppendingString:caseInfo.casereason];
        caseProveInfo.citizen_name=citizen.party;
	    caseProveInfo.citizen_sex=citizen.sex;
	    caseProveInfo.citizen_age=citizen.age;
	    caseProveInfo.citizen_no=citizen.identity_card;
	    //单位及职务
	    caseProveInfo.citizen_duty=[NSString stringWithFormat:@"%@ %@",citizen.org_name?citizen.org_name:@"",citizen.profession?citizen.profession:@""];
	    caseProveInfo.citizen_address=citizen.address;
	    caseProveInfo.citizen_tel=citizen.tel_number;
    }
    caseProveInfo.event_desc = [self formedEventDescFromCase];
    [[AppDelegate App] saveContext];
}


- (NSString *)formedEventDescFromCase{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    CaseProveInfo *proveInfo = [CaseProveInfo proveInfoForCase:self.caseID];
    NSDate *proveDate;
    if (proveInfo.start_date_time) {
        proveDate = proveInfo.start_date_time;
    } else {
        proveDate = [NSDate date];
    }
    NSString *caseDescString=@"";
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    NSString *happenDate=[dateFormatter stringFromDate:proveDate];
    
    Citizen *citizen = [Citizen citizenForCase:self.caseID];
    if (citizen) {
        NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
        NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
        NSArray *inspectorArray = [[NSUserDefaults standardUserDefaults] objectForKey:INSPECTORARRAYKEY];
        NSString *proverString;
        if (inspectorArray.count < 1) {
            proverString = currentUserName;
        } else if (inspectorArray.count == 1){
            proverString = [inspectorArray objectAtIndex:0];
        } else {
            proverString = [[NSString alloc] initWithFormat:@"%@、%@",[inspectorArray objectAtIndex:0],[inspectorArray objectAtIndex:1]];
        }
        NSString *citizenString;
        if ([citizen.citizen_flag isEqualToString:@"单位"]) {
            citizenString = [[NSString alloc] initWithFormat:@"%@%@",citizen.party,citizen.driver];
        } else {
            citizenString = [[NSString alloc] initWithFormat:@"当事人%@",citizen.party];
        }
        caseDescString = [caseDescString stringByAppendingFormat:@"%@，%@与案件调查人员%@就%@进行了现场勘验、检查。结果如下：",happenDate,citizenString,proverString,[citizen.party stringByAppendingString:caseInfo.casereason]];
        NSArray *deformArray=[CaseDeformation allDeformationsForCase:self.caseID];
        if (deformArray.count>0) {
            NSString *deformsString=@"";
            for (CaseDeformation *deform in deformArray) {
                NSString *roadSizeString=[deform.rasset_size stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if ([roadSizeString isEmpty]) {
                    roadSizeString=@"";
                } else {
                    roadSizeString=[NSString stringWithFormat:@"（%@）",roadSizeString];
                }
                NSString *remarkString=[deform.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if ([remarkString isEmpty]) {
                    remarkString=@"";
                } else {
                    remarkString=[NSString stringWithFormat:@"（%@）",remarkString];
                }
                NSString *quantity=[[NSString alloc] initWithFormat:@"%.2f",deform.quantity.floatValue];
                NSCharacterSet *zeroSet=[NSCharacterSet characterSetWithCharactersInString:@".0"];
                quantity=[quantity stringByTrimmingTrailingCharactersInSet:zeroSet];
                deformsString=[deformsString stringByAppendingFormat:@"、%@%@%@%@%@",deform.roadasset_name,roadSizeString,quantity,deform.unit,remarkString];
            }
            NSCharacterSet *charSet=[NSCharacterSet characterSetWithCharactersInString:@"、"];
            deformsString=[deformsString stringByTrimmingCharactersInSet:charSet];
            double summary=[[deformArray valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
            NSNumber *sumNum = @(summary);
            NSString *numString = [sumNum numberConvertToChineseCapitalNumberString];
            numString = [NSString stringWithFormat:@"%@（￥%.2f元）",numString,summary];
            caseDescString=[caseDescString stringByAppendingFormat:@"损害路产%@，损害公路路产价值%@",deformsString,numString];
        } else {
            caseDescString=[caseDescString stringByAppendingString:@"没有路产损害。"];
        }
    }
    return caseDescString;
}

- (BOOL)shouldGenereateDefaultDoc{
    return NO;
}

- (BOOL)shouldDocDeleted{
    return NO;
}
@end
