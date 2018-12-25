//
//  InquireInfoBriefViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InquireInfoBriefViewController.h"

@interface InquireInfoBriefViewController (){
    NSInteger nexusOrParty;
}
-(void)pickerPresentForIndex:(NSInteger )iIndex fromRect:(CGRect)rect;
@property (nonatomic,retain) UIPopoverController *pickerPopOver;
@end

@implementation InquireInfoBriefViewController
@synthesize textNexus = _textNexus;
@synthesize textParty = _textParty;
@synthesize inquireTextView = _inquireTextView;
@synthesize caseID=_caseID;
@synthesize pickerPopOver=_pickerPopOver;
@synthesize inquireID = _inquireID;
@synthesize delegate = _delegate;

- (void)viewDidLoad
{   
    self.inquireID = @"";
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.pickerPopOver isPopoverVisible]) {
        [self.pickerPopOver dismissPopoverAnimated:animated];
    }
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setTextNexus:nil];
    [self setTextParty:nil];
    [self setInquireTextView:nil];
    [self setInquireID:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

-(void)loadInquireInfoForCase:(NSString *)caseID forInquire:(NSString *)inquireID{
    CaseInquire *caseInquire;
    if (![inquireID isEmpty]) {
        caseInquire = [CaseInquire inquirerForCase:caseID ForID:inquireID];
    } else {
        NSArray *temp = [CaseInquire allInquireForCase:caseID];
        if (temp.count > 0) {
            caseInquire = [temp objectAtIndex:0];
        }
    }
    if (caseInquire) {
        self.inquireTextView.text=caseInquire.inquiry_note;
        self.textParty.text=caseInquire.answerer_name;
        self.textNexus.text=caseInquire.relation;
        self.inquireID = caseInquire.myid;
    } else {
        self.inquireTextView.text = @"";
        self.textParty.text = @"";
        self.textNexus.text = @"当事人";
    }
}

-(void)newDataForCase:(NSString *)caseID{
    self.caseID=caseID;
    self.textNexus.text=@"";
    self.textParty.text=@"";
    self.inquireTextView.text=@"";
    self.inquireID = @"";
}

-(IBAction)textTouched:(id)sender{
    if ([(UITextField *)sender tag]==1001){
        [self pickerPresentForIndex:1 fromRect:[(UITextField *)sender frame]];
    }   
}

-(void)pickerPresentForIndex:(NSInteger )pickerType fromRect:(CGRect)rect{
    if (([_pickerPopOver isPopoverVisible]) && (nexusOrParty==pickerType)) {
        [_pickerPopOver dismissPopoverAnimated:YES];
    } else {
        nexusOrParty=pickerType;
        AnswererPickerViewController *pickerVC=[[AnswererPickerViewController alloc] initWithStyle:UITableViewStylePlain];
        pickerVC.tableView.frame=CGRectMake(0, 0, 140, 176);
        pickerVC.pickerType=pickerType;
        pickerVC.delegate=self;
        _pickerPopOver=[[UIPopoverController alloc] initWithContentViewController:pickerVC];
        _pickerPopOver.popoverContentSize=CGSizeMake(140, 176);
        [_pickerPopOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        pickerVC.pickerPopover=_pickerPopOver;
    }
}

//delegate，返回caseID
-(NSString *)getCaseIDDelegate{
    return self.caseID;
}

//delegate，设置被询问人名称
-(void)setAnswererDelegate:(NSString *)aText{
    if ([aText isEqualToString:TitleForNewInquire]) {
        self.inquireID = @"";
        [self.delegate pushInquireEditor];
    } else {
        [self loadInquireInfoForCase:self.caseID forInquire:aText];
    }
}

-(NSInteger)getNexusOrParty{
    return nexusOrParty;
}

@end
