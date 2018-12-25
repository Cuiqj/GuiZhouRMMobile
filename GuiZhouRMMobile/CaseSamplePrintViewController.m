//
//  CaseSamplePrintViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 13-1-5.
//
//

#import "CaseSamplePrintViewController.h"

static NSString * const xmlName = @"CaseSampleTable";
@interface CaseSamplePrintViewController ()
@property (nonatomic, retain) CaseSample *caseSample;
@property (nonatomic, retain) NSMutableArray *data;
@end

@implementation CaseSamplePrintViewController
@synthesize caseID = _caseID;

-(void)viewDidLoad{
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:xmlName];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_SMALL_WIDTH, VIEW_SMALL_HEIGHT);
    self.view.frame = viewFrame;
    if (![self.caseID isEmpty]) {
        self.caseSample = [CaseSample caseSampleForCase:self.caseID];
        if (self.caseSample == nil) {
            self.caseSample = [CaseSample newCaseSampleForCase:self.caseID];
            [self generateDefaultInfo:self.caseSample];
        } 
        [self pageLoadInfo];
    }
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // do something bellow
    
    [super viewWillDisappear:animated];
}

- (void)initControlsInteraction
{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (caseInfo.isuploaded.boolValue) {
        [super initControlsInteraction];
    } else {
        // do nothing
    }
}


- (void)pageLoadInfo{
    self.textname.text = self.caseSample.name;
    self.textlegal_person.text = self.caseSample.legal_person;
    self.textsex.text = self.caseSample.sex;
    self.textage.text = [NSString stringWithFormat:@"%d",self.caseSample.age.intValue];
    self.textphone.text = self.caseSample.phone;
    self.textpostalcode.text = self.caseSample.postalcode;
    self.textaddress.text = self.caseSample.address;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.textdate_sample_start.text = [dateFormatter stringFromDate:self.caseSample.date_sample_start];
    self.textdate_sample_end.text = [dateFormatter stringFromDate:self.caseSample.date_sample_end];
    
    self.textplace.text = self.caseSample.place;
    self.textremark.text = self.caseSample.remark;
    self.texttaking_names.text = self.caseSample.taking_names;
    self.texttaking_company.text = self.caseSample.taking_company;
    self.texttaking_postalcode.text = self.caseSample.taking_postalcode;
    self.textperson_incharge.text = self.caseSample.person_incharge;
    self.texttaking_company_tel.text = self.caseSample.taking_company_tel;
    
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    self.textsend_date.text = [dateFormatter stringFromDate:self.caseSample.send_date];
    self.textcase_sample_reason.text = self.caseSample.case_sample_reason;
    
    self.data = [[CaseSampleDetail caseSampleDetailsForCase:self.caseID] mutableCopy];
}

- (void)pageSaveInfo{
    self.caseSample.name = self.textname.text;
    self.caseSample.legal_person = self.textlegal_person.text;
    self.caseSample.sex = self.textsex.text;
    self.caseSample.age = @(self.textage.text.integerValue);
    self.caseSample.phone = self.textphone.text;
    self.caseSample.postalcode = self.textpostalcode.text;
    self.caseSample.address = self.textaddress.text;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.caseSample.date_sample_start = [dateFormatter dateFromString:self.textdate_sample_start.text];
    self.caseSample.date_sample_end = [dateFormatter dateFromString:self.textdate_sample_end.text];
    self.caseSample.place = self.textplace.text;
    self.caseSample.remark = self.textremark.text;
    self.caseSample.taking_names = self.texttaking_names.text;
    self.caseSample.taking_company = self.texttaking_company.text;
    self.caseSample.taking_postalcode = self.texttaking_postalcode.text;
    self.caseSample.person_incharge = self.textperson_incharge.text;
    self.caseSample.taking_company_tel = self.texttaking_company_tel.text;
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    self.caseSample.send_date = [dateFormatter dateFromString:self.textsend_date.text];
    self.caseSample.case_sample_reason = self.textcase_sample_reason.text;
	[[AppDelegate App] saveContext];
}


//根据记录，完整默认值信息
- (void)generateDefaultInfo:(CaseSample *)caseSample{
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    if (caseSample.date_sample_start==nil) {
        caseSample.date_sample_start=[NSDate date];
    }
    if (caseSample.date_sample_end==nil) {
        caseSample.date_sample_end=[NSDate date];
    }
    if (caseSample.send_date==nil) {
        caseSample.send_date=[NSDate date];
    }
    
    
    //默认案发地点
    caseSample.place=caseInfo.case_address;
    //取证机构名称
    OrgInfo *orgInfo = [OrgInfo orgInfoForOrgID:caseInfo.organization_id];
    caseSample.taking_company=orgInfo.orgname;
    caseSample.taking_company_tel=orgInfo.telephone;    
    
    Citizen *citizen = [Citizen citizenForCase:self.caseID];
    if (citizen) {
        caseSample.name=citizen.party;
        //法定代表人或负责人
        if ([citizen.citizen_flag isEqualToString:@"单位"]) {
            caseSample.legal_person=citizen.legal_spokesman;
        }
        caseSample.address=citizen.address;
        caseSample.phone=citizen.tel_number;
    }   
    [[AppDelegate App] saveContext];
}

- (IBAction)btnAddNew:(id)sender {
    SampleDetailEditorViewController *sdeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SampleDetailEditor"];
    sdeVC.delegate = self;
    sdeVC.caseID = self.caseID;
    sdeVC.sampleDetail = nil;
    sdeVC.modalPresentationStyle = UIModalPresentationFormSheet;
    sdeVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:sdeVC animated:YES];
}

-(void)reloadDataArray{
    self.data = [[CaseSampleDetail caseSampleDetailsForCase:self.caseID] mutableCopy];
    [self.tableDetail reloadData];
}

- (NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:xmlName];
        [self drawDateTable:xmlName withDataModel:self.caseSample];
        NSString *xmlString = [self xmlStringFromFile:xmlName];
        TBXML *tbxml = [TBXML newTBXMLWithXMLString:xmlString error:nil];
        TBXMLElement *root = tbxml.rootXMLElement;
        TBXMLElement *dataTable = [TBXML childElementNamed:@"DataTable" parentElement:root];
        if (dataTable) {
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
                        [self drawSubTable:@"CaseSampleSubTable" withDataArray:self.data inRect:rect];
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"SampleDetailCell";
    SampleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CaseSampleDetail *caseSampleDetail = [self.data objectAtIndex:indexPath.row];
    cell.labelRemark.text = caseSampleDetail.remark;
    cell.labelSampleName.text = caseSampleDetail.name;
    cell.labelSampleSpec.text = caseSampleDetail.spec;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###.###"];
    cell.labelSampleQuantity.text = [numberFormatter stringFromNumber:caseSampleDetail.quantity];
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CaseSampleDetail *caseSampleDetail = [self.data objectAtIndex:indexPath.row];
        [[[AppDelegate App] managedObjectContext] deleteObject:caseSampleDetail];
        [self.data removeObjectAtIndex:indexPath.row];
        [[AppDelegate App] saveContext];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"toSampleDetailEditor" sender:[self.data objectAtIndex:indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toSampleDetailEditor"]) {
        SampleDetailEditorViewController *sdeVC = [segue destinationViewController];
        sdeVC.caseID = self.caseID;
        sdeVC.sampleDetail = sender;
        sdeVC.delegate = self;
    }
}
 
- (void)viewDidUnload {
    [self setTableDetail:nil];
    [super viewDidUnload];
}

- (void)generateDefaultAndLoad{
    [self generateDefaultInfo:self.caseSample];
    [self pageLoadInfo];
}

- (void)deleteCurrentDoc{
    if (![self.caseID isEmpty] && self.caseSample){
        [[[AppDelegate App] managedObjectContext] deleteObject:self.caseSample];
        for (CaseSampleDetail *csd in self.data) {
            [[[AppDelegate App] managedObjectContext] deleteObject:csd];
        }
        [[AppDelegate App] saveContext];
        self.caseSample = nil;
        [self.data removeAllObjects];
    }
}
@end
