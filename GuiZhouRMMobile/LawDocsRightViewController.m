//
//  LawDocsRightViewController.m
//  GuiZhouRMMobile
//
//  Created by XU SHIWEN on 13-10-23.
//
//

#import "LawDocsRightViewController.h"
#import "MCTableScrollContainer.h"

@interface LawDocsRightViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) MCTableScrollContainer *mcTable;
@property (nonatomic, strong) NSArray *gridDataSource;
@property (nonatomic, strong) NSArray *gridHeaders;

@end

@implementation LawDocsRightViewController

#pragma mark - Controller Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSArray *colWidths = [NSArray arrayWithObjects:@(200),@(200),@(50),@(100),@(70),@(100), nil];
    self.mcTable = [[MCTableScrollContainer alloc] initWithFrame:self.view.bounds andColumnWidthes:colWidths];
    [self.mcTable setDataSource:(id<MCTableDataSource>)self];
    [self.mcTable setStyleDelegate:(id<MCTableStyleDelegate>)self];
    [self.mcTable setHidden:YES];
    [self.mcTable setShowTableHeader:YES];
    [self.view addSubview:self.mcTable];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.webView setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    [self.webView setDelegate:self];
    [self.view addSubview:self.webView];
    [self.webView setHidden:YES];
    
    self.gridHeaders = [NSArray arrayWithObjects:@"类别", @"名称", @"单价", @"规格", @"单位", @"备注", nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.webView setDelegate:nil];
    [super viewWillDisappear:YES];
}

- (void)viewDidUnload
{
    [self setMcTable:nil];
    [self setWebView:nil];
}

#pragma mark - MCTableDataSource

- (NSString*)cellValueAtIndexPath:(NSIndexPath*)indexPath forColumn:(NSInteger)column
{
	return self.gridDataSource[indexPath.row][column];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
	return self.gridDataSource.count;
}

- (NSString*)reuseIdentifierForCellAtIndexPath:(NSIndexPath*)indexPath {
	return @"PriceStandardTable";
}

- (NSString*)titleForColumn:(NSInteger)column
{
	return [self.gridHeaders objectAtIndex:column];
}

- (NSInteger)heightForTableHeader {
	return 20;
}

#pragma mark - MCTableStyleDelegate

- (void)willDisplayLabel:(UILabel*)label atIndexPath:(NSIndexPath*)indexPath inColumn:(NSInteger)column
{
	[label setFont:[UIFont systemFontOfSize:14]];
	[label setBackgroundColor:[UIColor clearColor]];
    if (column == 0) {
        [label setTextAlignment:UITextAlignmentLeft];
    }
    switch (column) {
        case 2:
        case 4:        
            [label setTextAlignment:UITextAlignmentCenter];
            break;
        default:
            [label setTextAlignment:UITextAlignmentLeft];
            break;
    }
    
	if (indexPath.row %2 == 0) {
        [label setBackgroundColor:[UIColor cyanColor]];
    }
}

- (void)willDisplayDelimiter:(UIView*)delimiter atIndexPath:(NSIndexPath*)indexPath inColumn:(NSInteger)column
{
	if (column == 0) {
		[delimiter setBackgroundColor:[UIColor redColor]];
	}
}

- (void)willDisplayCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
	[cell setBackgroundView:nil];
	if (indexPath.row == 0) {
		UIView *backgroundView = [[UIView alloc] initWithFrame:cell.frame];
		[backgroundView setBackgroundColor:[UIColor cyanColor]];
		[cell setBackgroundView:backgroundView];
	}
}

- (void)willDisplayHeaderLabel:(UILabel*)label inColumn:(NSInteger)column
{
    [label setBackgroundColor:[UIColor colorWithRed:26/255.0 green:107/255.0 blue:147/255.0 alpha:1.0]];
	[label setTextColor:[UIColor whiteColor]];
}

- (void)willDisplayHeaderDelimiter:(UIView*)delimiter inColumn:(NSInteger)column
{
	[delimiter setBackgroundColor:[UIColor lightGrayColor]];
	if (column == 0) {
		[delimiter setBackgroundColor:[UIColor redColor]];
	}
}

- (void)willDisplayHeader:(UIView *)headerView
{
	
}

#pragma mark - Subview Manage

- (void)showTableView:(BOOL)visible
{
    if (self.mcTable.hidden == visible) {
        [self.mcTable setHidden:!visible];
    }
}

- (void)showWebView:(BOOL)visible
{
    if (self.webView.hidden == visible) {
        [self.webView setHidden:!visible];
    }
}

#pragma mark - Data Manage

- (void)loadTableData:(id)data
{
    self.gridDataSource = data;
    [self.mcTable reloadData];
}

- (void)loadWebData:(NSURL *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

@end
