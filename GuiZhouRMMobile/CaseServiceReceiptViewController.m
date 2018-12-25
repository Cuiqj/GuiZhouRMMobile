//
//  CaseServiceReceiptViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-24.
//
//

#import "CaseServiceReceiptViewController.h"
#import "ServiceFileCell.h"

static NSString * const xmlName = @"ServiceReceiptTable";
@interface CaseServiceReceiptViewController ()
@property (nonatomic, retain) NSMutableArray *data;
@property (nonatomic, retain) CaseServiceReceipt *caseServiceReceipt;
@end

@implementation CaseServiceReceiptViewController

- (void)viewDidLoad
{
    [super setCaseID:self.caseID];
    [self LoadPaperSettings:xmlName];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_SMALL_WIDTH, VIEW_SMALL_HEIGHT);
    self.view.frame = viewFrame;
    if (![self.caseID isEmpty]) {
        self.caseServiceReceipt = [CaseServiceReceipt caseServiceReceiptForCase:self.caseID];
        if (self.caseServiceReceipt == nil) {
            self.caseServiceReceipt = [CaseServiceReceipt newCaseServiceReceiptForCase:self.caseID];
            [self generateDefaultInfo:self.caseServiceReceipt];
        }
        [self pageLoadInfo];
    }
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    
    
    [super viewWillDisappear:animated];
}

- (void)pageLoadInfo{
    self.textincepter_name.text = self.caseServiceReceipt.incepter_name;
    self.textservice_company.text = self.caseServiceReceipt.service_company;
    self.textremark.text = self.caseServiceReceipt.remark;
    self.textreason.text = self.caseServiceReceipt.reason;
    self.data = [[CaseServiceFiles caseServiceFilesForCase:self.caseID] mutableCopy];
}

- (void)pageSaveInfo{

    self.caseServiceReceipt.incepter_name = self.textincepter_name.text;
    self.caseServiceReceipt.service_company = self.textservice_company.text;
    self.caseServiceReceipt.remark = self.textremark.text;
    self.caseServiceReceipt.reason = self.textreason.text;

	[[AppDelegate App] saveContext];
}


- (IBAction)btnAddNew:(id)sender {
    ServiceFileEditorViewController *sfeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ServiceFileEditor"];
    sfeVC.delegate = self;
    sfeVC.caseID = self.caseID;
    sfeVC.file = nil;
    sfeVC.modalPresentationStyle = UIModalPresentationFormSheet;
    sfeVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:sfeVC animated:YES];
}

-(void)reloadDataArray{
    self.data = [[CaseServiceFiles caseServiceFilesForCase:self.caseID] mutableCopy];
    [self.tableDetail reloadData];
}


//根据记录，完整默认值信息
- (void)generateDefaultInfo:(CaseServiceReceipt *)caseServiceReceipt{
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    if (caseServiceReceipt.send_date==nil) {
        caseServiceReceipt.send_date=[NSDate date];
    }
    Citizen *citizen = [Citizen citizenForCase:self.caseID];
    if (citizen) {
        //被送达人
        caseServiceReceipt.incepter_name=citizen.party;
        //案由 reason
        if ([citizen.citizen_flag isEqualToString:@"单位"]) {
            caseServiceReceipt.reason=[NSString stringWithFormat:@"%@%@%@",citizen.party,citizen.driver,caseInfo.casereason];
        } else {
            caseServiceReceipt.reason=[NSString stringWithFormat:@"%@%@",citizen.party,caseInfo.casereason];
        }
    }
    OrgInfo *orgInfo = [OrgInfo orgInfoForOrgID:caseInfo.organization_id];
    caseServiceReceipt.service_company=orgInfo.orgname;
    
    if (caseInfo.case_process_type.integerValue == kGuiZhouRMCaseProcessTypePEI) {
        [self generateDefaultServiceFilesForCase:caseInfo];
    }
    
    [[AppDelegate App] saveContext];
    [self reloadDataArray];
}

- (void)generateDefaultServiceFilesForCase:(CaseInfo *)caseInfo
{
    if (caseInfo == nil) {
        return;
    }
    
    //删掉已有送达文书
    NSArray *oldFilesArray = [CaseServiceFiles caseServiceFilesForCase:caseInfo.caseinfo_id];
    for (CaseServiceFiles *oldFile in oldFilesArray) {
        [[[AppDelegate App] managedObjectContext] deleteObject:oldFile];
    }
    
    //默认添加两个送达文书，文书默认送达地点为案发地点
    CaseServiceFiles *defaultFile1 = [CaseServiceFiles newCaseServiceFilesForID:self.caseID];
    CaseServiceFiles *defaultFile2 = [CaseServiceFiles newCaseServiceFilesForID:self.caseID];
    defaultFile1.service_file = @"公路赔（补）偿通知书";
    defaultFile2.service_file = @"公路路产损害赔（补）偿费计算表";
    defaultFile1.send_address = caseInfo.case_address;
    defaultFile2.send_address = caseInfo.case_address;
    defaultFile1.send_way = CaseServiceFilesDefaultSendWay;
    defaultFile2.send_way = CaseServiceFilesDefaultSendWay;
    defaultFile1.remark = [caseInfo caseCodeString];
    defaultFile2.remark = [caseInfo caseCodeString];
}

- (NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:xmlName];
        [self drawDateTable:xmlName withDataModel:self.caseServiceReceipt];
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
                        [self drawSubTable:@"ServiceReceiptSubTable" withDataArray:self.data inRect:rect];
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

- (void)viewDidUnload {
    [self setTableDetail:nil];
    [super viewDidUnload];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ServiceFileCell";
    ServiceFileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CaseServiceFiles *serviceFile = [self.data objectAtIndex:indexPath.row];
    cell.labelFileName.text = serviceFile.service_file;
    cell.labelFileRemark.text = serviceFile.remark;
    cell.labelSendAddress.text = serviceFile.send_address;
    cell.labelSendWay.text = serviceFile.send_way;
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
        CaseCountDetail *caseCountDetail = [self.data objectAtIndex:indexPath.row];
        [[[AppDelegate App] managedObjectContext] deleteObject:caseCountDetail];
        [self.data removeObjectAtIndex:indexPath.row];
        [[AppDelegate App] saveContext];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"toServiceFileEditor" sender:[self.data objectAtIndex:indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toServiceFileEditor"]) {
        ServiceFileEditorViewController *sfeVC = [segue destinationViewController];
        sfeVC.caseID = self.caseID;
        sfeVC.file = sender;
        sfeVC.delegate = self;
    }
}

- (void)generateDefaultAndLoad{
    [self generateDefaultInfo:self.caseServiceReceipt];
    [self pageLoadInfo];
}

- (void)deleteCurrentDoc{
    if (![self.caseID isEmpty] && self.caseServiceReceipt){
        [[[AppDelegate App] managedObjectContext] deleteObject:self.caseServiceReceipt];
        for (CaseServiceFiles *csf in self.data) {
            [[[AppDelegate App] managedObjectContext] deleteObject:csf];
        }
        [[AppDelegate App] saveContext];
        self.caseServiceReceipt = nil;
        [self.data removeAllObjects];
    }
}
@end
