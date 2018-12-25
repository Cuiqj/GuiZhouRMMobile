//
//  ServiceFileEditorViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 13-1-21.
//
//

#import "ServiceFileEditorViewController.h"
#import "NormalListSelectController.h"

typedef enum _kTextFieldTag {
    kTextFieldTagFileName = 0x10,
    kTextFieldTagRemark,
    kTextFieldTagSendAddress,
    kTextFieldTagSendWay
} kTextFieldTag;

@interface ServiceFileEditorViewController () <NormalListSelectDelegate, UITextFieldDelegate>
@property (nonatomic, strong) NSArray *fileNamesArray;
@property (nonatomic, strong) UIPopoverController *myPopover;
@property (nonatomic) kTextFieldTag popoverIndex;
@end

@implementation ServiceFileEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.textFileName.tag = kTextFieldTagFileName;
    self.textRemark.tag = kTextFieldTagRemark;
    self.textSendAddress.tag = kTextFieldTagSendAddress;
    self.textSendWay.tag = kTextFieldTagSendWay;
    self.popoverIndex = 0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)viewWillAppear:(BOOL)animated{
    if (self.file) {
        self.textFileName.text = [self.file service_file];
        self.textRemark.text = [self.file remark];
        self.textSendAddress.text = [self.file send_address];
        self.textSendWay.text = [self.file send_way];
    } else {
        self.textSendAddress.text = @"";
        self.textSendWay.text = CaseServiceFilesDefaultSendWay;
        if (self.caseID != nil && ![self.caseID isEmpty]) {
            CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
            if (caseInfo != nil) {
                self.textSendAddress.text = caseInfo.case_address;
                self.textRemark.text = [caseInfo caseCodeString];
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.myPopover isPopoverVisible]) {
        [self.myPopover dismissPopoverAnimated:animated];
    }
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
    [self setTextFileName:nil];
    [self setTextRemark:nil];
    [self setTextSendAddress:nil];
    [self setTextSendWay:nil];
    [self setCaseID:nil];
    [self setFile:nil];
    [super viewDidUnload];
}

#pragma mark - Private Methods

- (void)presentPopoverListFrom:(UITextField *)textField
{
    NormalListSelectController *listSelect = nil;
    if (self.popoverIndex == 0) {
        listSelect = [self.storyboard instantiateViewControllerWithIdentifier:@"NormalListSelectController"];
        listSelect.delegate = self;
        listSelect.dataSource = self.fileNamesArray;
        self.myPopover = [[UIPopoverController alloc] initWithContentViewController:listSelect];
    } else {
        if (self.popoverIndex != textField.tag) {
            listSelect = [self.storyboard instantiateViewControllerWithIdentifier:@"NormalListSelectController"];
            listSelect.delegate = self;
            listSelect.dataSource = self.fileNamesArray;
            [self.myPopover setContentViewController:listSelect];
        }
    }
    
    if (self.popoverIndex == textField.tag) {
        if ([self.myPopover isPopoverVisible]) {
            [self.myPopover dismissPopoverAnimated:YES];
        } else {
            [self.myPopover presentPopoverFromRect:textField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            self.popoverIndex = textField.tag;
        }
    } else {
        [self.myPopover presentPopoverFromRect:textField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        self.popoverIndex = textField.tag;
    }
}

#pragma mark - IBAction Methods

- (IBAction)btnDismiss:(UIBarButtonItem *)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btnComfirm:(UIBarButtonItem *)sender {
    if (self.textFileName.text != nil && ![self.textFileName.text isEmpty]) {
        if (self.file == nil) {
            self.file = [CaseServiceFiles newCaseServiceFilesForID:self.caseID];
        }
        self.file.send_address = self.textSendAddress.text;
        self.file.remark = self.textRemark.text;
        self.file.send_way = self.textSendWay.text;
        self.file.service_file = self.textFileName.text;
        [[AppDelegate App] saveContext];
        [self.delegate reloadDataArray];
    }
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)textField_TouchDown:(UITextField *)sender
{
    if (sender.tag == kTextFieldTagFileName) {
        [self presentPopoverListFrom:sender];
    }
}

#pragma mark - Accessor Methods

- (NSArray *)fileNamesArray
{
    if (_fileNamesArray == nil) {
        if (self.caseID != nil && !self.caseID.isEmpty) {
            CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
            kGuiZhouRMCaseProcessType processType = caseInfo.case_process_type.integerValue;
            BOOL yesOrNoType = caseInfo.yesornotype.boolValue;
            _fileNamesArray = [CaseServiceFiles serviceFilesForProcessType:processType andYesOrNoType:yesOrNoType];
        } else {
            _fileNamesArray = @[];
        }
    }
    return _fileNamesArray;
}

#pragma mark - Delegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == kTextFieldTagFileName) {
        return NO;
    }
    
    return YES;
}

- (void)listSelect:(NormalListSelectController *)listSelectController selectedIndexPath:(NSIndexPath *)tableIndexPath
{
    self.textFileName.text = [self.fileNamesArray objectAtIndex:tableIndexPath.row];
    [self.myPopover dismissPopoverAnimated:YES];
}

@end










