//
//  CaseCountPrintViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 13-1-4.
//
//

#import "CaseCountPrintViewController.h"
#import "AtonementNotice.h"


static NSString * const xmlName = @"CaseCountTable";

@interface CaseCountPrintViewController ()
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) CaseCount *caseCount;
@property (nonatomic, retain) AtonementNotice *atonementNotice;
@end

@implementation CaseCountPrintViewController
@synthesize caseID = _caseID;
@synthesize data = _data;
@synthesize caseCount = _caseCount;
@synthesize atonementNotice;

-(void)viewDidLoad{
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:xmlName];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_SMALL_WIDTH, VIEW_SMALL_HEIGHT);
    self.view.frame = viewFrame;
    if (![self.caseID isEmpty]) {
        self.caseCount = [CaseCount caseCountForCase:self.caseID];
        if (self.caseCount == nil) {
            self.caseCount = [CaseCount newCaseCountForCase:self.caseID];
            [self generateDefaultInfo:self.caseCount];
        }
        if (self.atonementNotice == nil) {
            self.atonementNotice = [AtonementNotice atonementNoticeForCase:self.caseID];
            NSLog(@"atone.law_zhan = %@",self.atonementNotice.law_zhan);
        }
        [self pageLoadInfo];
    }
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // do something below
    
    [super viewWillDisappear:animated];
}

- (void)initControlsInteraction
{
    [super initControlsInteraction];
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (!caseInfo.isuploaded.boolValue) {
        setViewEnabled(self.textCaseCountSendDate, YES);
    }
}

- (void)pageLoadInfo{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    Citizen *citizen = [Citizen citizenForCase:self.caseID];
    if (citizen) {
        self.labelParty.text = citizen.party;
        self.labelAutoNumber.text = citizen.automobile_number;
        self.labelAutoPattern.text = citizen.automobile_pattern;
        self.labelTele.text = citizen.tel_number;
    }
    self.labelCaseAddress.text = caseInfo.case_address;
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.labelHappenTime.text = [dateFormatter stringFromDate:caseInfo.happen_date];
    self.textCaseCountSendDate.text = [dateFormatter stringFromDate:self.caseCount.caseCountSendDate];
    
    self.textRemark.text = self.atonementNotice.law_zhan;
    self.textBigNumber.text = self.caseCount.case_citizen_info;
    self.textCaseCountReason.text = self.caseCount.caseCountReason;
    
    self.data = [[CaseCountDetail allCaseCountDetailsForCase:self.caseID] mutableCopy];
    [self.tableCaseCountDetail reloadData];
    double summary=[[self.data valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
    self.labelPayReal.text = [NSString stringWithFormat:@"%.2f",summary];
}

- (void)pageSaveInfo{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.caseCount.caseCountSendDate = [dateFormatter dateFromString:self.textCaseCountSendDate.text];
    self.caseCount.caseCountRemark = self.textRemark.text;
    self.caseCount.caseCountReason = self.textCaseCountReason.text;
    self.caseCount.case_citizen_info = self.textBigNumber.text;
	[[AppDelegate App] saveContext];
}


//根据记录，完整默认值信息
- (void)generateDefaultInfo:(CaseCount *)caseCount{
    if (caseCount.caseCountSendDate==nil) {
        caseCount.caseCountSendDate=[NSDate date];
    }
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    caseCount.caseCountReason = [caseInfo.casereason stringByReplacingOccurrencesOfString:@"涉嫌" withString:@""];
    [CaseCountDetail deleteAllCaseCountDetailsForCase:self.caseID];
    [CaseCountDetail copyAllCaseDeformationsToCaseCountDetailsForCase:self.caseID];
    
    NSArray *deformArray=[CaseCountDetail allCaseCountDetailsForCase:self.caseID];
    double summary=[[deformArray valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
    NSNumber *sumNum = @(summary);
    NSString *numString = [sumNum numberConvertToChineseCapitalNumberString];
    caseCount.case_citizen_info = numString;
    [[AppDelegate App] saveContext];
}



- (NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        NSArray *(^drawFromXMLSettingFile)(NSString *, NSArray *) = ^(NSString *xmlFile, NSArray *dataArray){
            [self drawStaticTable:xmlFile];
            [self drawDateTable:xmlFile withDataModel:self.caseCount];
            NSString *xmlString = [self xmlStringFromFile:xmlFile];
            TBXML *tbxml = [TBXML newTBXMLWithXMLString:xmlString error:nil];
            TBXMLElement *root = tbxml.rootXMLElement;
            TBXMLElement *dataTable = [TBXML childElementNamed:@"DataTable" parentElement:root];
            NSArray *leftArray = dataArray;
            if (dataTable) {
                TBXMLElement *rootElement = [TBXML childElementNamed:@"TotalPrice" parentElement:dataTable];
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
                            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                            [formatter setPositiveFormat:@"#,##0.00"];
                            TBXMLElement *formatterElement=[TBXML childElementNamed:@"mode" parentElement:rootElement];
                            if (formatterElement) {
                                [formatter setPositiveFormat:[TBXML textForElement:formatterElement]];
                            }
                            double summary=[[self.data valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
                            NSString *totalPriceString = [formatter stringFromNumber:@(summary)];
                            UITextAlignment alignment = UITextAlignmentCenter;
                            TBXMLElement *alignmentInXML = [TBXML childElementNamed:@"alignment" parentElement:rootElement];
                            if (alignmentInXML) {
                                NSString *alignmentString = [TBXML textForElement:alignmentInXML];
                                alignmentString = [alignmentString lowercaseString];
                                if (![alignmentString isEmpty]) {
                                    if ([alignmentString isEqualToString:@"center"]) {
                                        alignment = UITextAlignmentCenter;
                                    } else if ([alignmentString isEqualToString:@"right"]){
                                        alignment = UITextAlignmentRight;
                                    }
                                }
                            }
                            CGFloat fontSize = 12;
                            TBXMLElement *fontSizeInXML=[TBXML childElementNamed:@"fontSize" parentElement:rootElement];
                            if (fontSizeInXML) {
                                fontSize=[[TBXML textForElement:fontSizeInXML] floatValue];
                            }
                            UIFont *font = [UIFont fontWithName:FONT_FangSong size:fontSize];
                            [totalPriceString alignWithVerticalCenterDrawInRect:rect withFont:font horizontalAlignment:alignment];
                        }
                    }
                }
                TBXMLElement *subTable = [TBXML childElementNamed:@"SubTable" parentElement:dataTable];
                if (subTable) {
                    TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:subTable];
                    if (originInXML) {
                        CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]+prLeftMargin;
                        CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]+prTopMargin;
                        TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:subTable];
                        if (sizeInXML) {
                            CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue;
                            CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue;
                            CGRect rect = CGRectMake(x, y, width, height);
                            leftArray = [self drawSubTable:@"CaseCountSubTable" withDataArray:dataArray inRect:rect];
                        }
                    }
                }
            }
            return leftArray;
        };
        NSArray *leftArray = [NSArray arrayWithArray:self.data];
        while (leftArray.count > 0) {
            UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
            if (leftArray.count == self.data.count) {
                leftArray = drawFromXMLSettingFile(xmlName, leftArray);
            } else {
                leftArray = drawFromXMLSettingFile(@"CaseCountTable2", leftArray);
            }
        }
        
        
        UIGraphicsEndPDFContext();
        
        return [NSURL fileURLWithPath:filePath];
    } else {
        return nil;
    }
}

- (void)viewDidUnload {
    [self setLabelHappenTime:nil];
    [self setLabelCaseAddress:nil];
    [self setLabelParty:nil];
    [self setLabelTele:nil];
    [self setLabelAutoPattern:nil];
    [self setLabelAutoNumber:nil];
    [self setTableCaseCountDetail:nil];
    [self setTextBigNumber:nil];
    [self setLabelPayReal:nil];
    [self setTextRemark:nil];
    [self setTextCaseCountSendDate:nil];
    [self setTextCaseCountReason:nil];
    [super viewDidUnload];
}

-(void)reloadDataArray{
    self.data = [[CaseCountDetail allCaseCountDetailsForCase:self.caseID] mutableCopy];
    [self.tableCaseCountDetail reloadData];
    double summary=[[self.data valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
    self.labelPayReal.text = [NSString stringWithFormat:@"%.2f",summary];
    NSNumber *sumNum = @(summary);
    NSString *numString = [sumNum numberConvertToChineseCapitalNumberString];
    self.textBigNumber.text = numString;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CaseCountDetailCell";
    CaseCountDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CaseCountDetail *caseCountDetail = [self.data objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.labelAssetName.text = caseCountDetail.roadasset_name;
    cell.labelAssetSize.text = caseCountDetail.rasset_size;
    cell.labelAssetUnit.text = caseCountDetail.unit;
    cell.labelPrice.text = [NSString stringWithFormat:@"%.2f元",caseCountDetail.price.floatValue];
    if ([caseCountDetail.unit rangeOfString:@"米"].location != NSNotFound) {
        cell.labelQunatity.text=[NSString stringWithFormat:@"%.2f",caseCountDetail.quantity.doubleValue];
    } else {
        cell.labelQunatity.text=[NSString stringWithFormat:@"%d",caseCountDetail.quantity.integerValue];
    }
    cell.labelTotalPrice.text = [NSString stringWithFormat:@"%.2f元",caseCountDetail.total_price.floatValue];
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
 
//删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CaseCountDetail *caseCountDetail = [self.data objectAtIndex:indexPath.row];
        [[[AppDelegate App] managedObjectContext] deleteObject:caseCountDetail];
        [self.data removeObjectAtIndex:indexPath.row];
        [[AppDelegate App] saveContext];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        double summary=[[self.data valueForKeyPath:@"@sum.total_price.doubleValue"] doubleValue];
        self.labelPayReal.text = [NSString stringWithFormat:@"%.2f",summary];
        NSNumber *sumNum = @(summary);
        NSString *numString = [sumNum numberConvertToChineseCapitalNumberString];
        self.textBigNumber.text = numString;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"toCaseCountDetailEditor" sender:[self.data objectAtIndex:indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toCaseCountDetailEditor"]) {
        CaseCountDetailEditorViewController *ccdeVC = [segue destinationViewController];
        ccdeVC.caseID = self.caseID;
        ccdeVC.countDetail = sender;
        ccdeVC.delegate = self;
    }
}

- (IBAction)btnReImportDeformations:(UIButton *)sender {
    [CaseCountDetail deleteAllCaseCountDetailsForCase:self.caseID];
    [CaseCountDetail copyAllCaseDeformationsToCaseCountDetailsForCase:self.caseID];
    [self reloadDataArray];
}

- (void)generateDefaultAndLoad{
    [self generateDefaultInfo:self.caseCount];
    [self pageLoadInfo];
}

- (void)deleteCurrentDoc{
    if (![self.caseID isEmpty] && self.caseCount){
        [[[AppDelegate App] managedObjectContext] deleteObject:self.caseCount];
        for (CaseCountDetail *ccd in self.data) {
            [[[AppDelegate App] managedObjectContext] deleteObject:ccd];
        }
        [[AppDelegate App] saveContext];
        self.caseCount = nil;
        [self.data removeAllObjects];
    }
}
- (NSURL *)toFormedPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
        Citizen *citizen = [Citizen citizenForCitizenName:nil nexus:@"当事人" case:self.caseID];
        [self drawDateTable:xmlName withDataModel:caseInfo];
        [self drawDateTable:xmlName withDataModel:citizen];
        [self drawDateTable:xmlName withDataModel:self.caseCount];
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:formatFilePath];
    } else {
        return nil;
    }
}
@end
