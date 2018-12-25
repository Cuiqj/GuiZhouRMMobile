//
//  SampleDetailEditorViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 13-1-23.
//
//

#import "SampleDetailEditorViewController.h"

@interface SampleDetailEditorViewController ()

@end

@implementation SampleDetailEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)viewWillAppear:(BOOL)animated{
    if (self.sampleDetail) {
        self.textSampleName.text = self.sampleDetail.name;
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"###.###"];
        self.textSampleQuantity.text = [numberFormatter stringFromNumber:self.sampleDetail.quantity];
        self.textSampleSpec.text = self.sampleDetail.spec;
        self.textSampleRemark.text = self.sampleDetail.remark;
    }
}


- (IBAction)btnDismiss:(UIBarButtonItem *)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btnComfirm:(UIBarButtonItem *)sender {
    if (self.textSampleName.text != nil && ![self.textSampleName.text isEmpty]) {
        if (self.sampleDetail == nil) {
            self.sampleDetail = [CaseSampleDetail newCaseSampleDetailForID:self.caseID];
        }
        self.sampleDetail.name = self.textSampleName.text;
        self.sampleDetail.quantity = @(self.textSampleQuantity.text.floatValue);
        self.sampleDetail.spec = self.textSampleSpec.text;
        self.sampleDetail.remark = self.textSampleRemark.text;
        
        [[AppDelegate App] saveContext];
        [self.delegate reloadDataArray];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setCaseID:nil];
    [self setSampleDetail:nil];
    [self setTextSampleName:nil];
    [self setTextSampleSpec:nil];
    [self setTextSampleQuantity:nil];
    [self setTextSampleRemark:nil];
    [super viewDidUnload];
}

@end
