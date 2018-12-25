//
//  LawDocsViewController.m
//  GuiZhouRMMobile
//
//  Created by XU SHIWEN on 13-10-23.
//
//

#import "LawDocsViewController.h"
#import "RATreeView.h"
#import "RATreeView+TableViewDelegate.h"
#import "LawDocsRightViewController.h"
#import "RoadAssetPrice.h"
#import "RoadEngrossPrice.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


typedef enum _TreeNodeTag {
    TreeNodeTagSectionOneTitle = 1,
    TreeNodeTagSectionTwoTitle,
    TreeNodeTagLawsAndRules,
    TreeNodeTagStateLaws,
    TreeNodeTagMOTLaws,
    TreeNodeTagGZLaws,
    TreeNodeTagPayStandards,
    TreeNodeTagUsingStandards
} TreeNodeTag;



#pragma mark - PriceStandard
@implementation PriceStandard

+ (PriceStandard *)priceStandardFromCoreDataObject:(RoadAssetPrice *)cdObject
{
    PriceStandard *standard = [[PriceStandard alloc] init];
    if (standard) {
        standard.big_type = cdObject.big_type;
        standard.name = cdObject.name;
        standard.price = cdObject.price.stringValue;
        standard.spec = cdObject.spec;
        standard.unit_name = cdObject.unit_name;
        standard.remark = cdObject.remark;
    }
    return standard;
}

@end


#pragma mark - RADataObject

@interface RADataObject : NSObject

@property (nonatomic) int tag;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *children;

- (id)initWithName:(NSString *)name children:(NSArray *)array tag:(TreeNodeTag)tag;
+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children tag:(TreeNodeTag)tag;

@end


@implementation RADataObject

- (id)initWithName:(NSString *)name children:(NSArray *)children tag:(TreeNodeTag)tag
{
    self = [super init];
    if (self) {
        self.children = children;
        self.name = name;
        self.tag = tag;
    }
    return self;
}

+ (id)dataObjectWithName:(NSString *)name children:(NSArray *)children tag:(TreeNodeTag)tag
{
    return [[self alloc] initWithName:name children:children tag:tag];
}

@end



#pragma mark - LawDocsViewController

@interface LawDocsViewController () <RATreeViewDataSource, RATreeViewDelegate>

@property (nonatomic, strong) NSArray *data1;
@property (nonatomic, strong) NSArray *data2;

@property (nonatomic, strong) NSArray *menuData;
@property (nonatomic, strong) NSArray *stateLawsData;
@property (nonatomic, strong) NSArray *motLawsData;
@property (nonatomic, strong) NSArray *gzLawsData;
@property (nonatomic, strong) NSArray *payStandardsData;

@property (nonatomic, strong) RATreeView *treeViewTop;
@property (nonatomic, strong) id expandedNode;

@property (nonatomic, strong) RATreeView *treeViewBottom;

@property (nonatomic, strong) LawDocsRightViewController *rightViewController;

- (void)updateSectionTwoWithTag:(TreeNodeTag)tag;

@end

@implementation LawDocsViewController

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
    self.title = @"法律法规";
    self.treeViewTop = [[RATreeView alloc] initWithFrame:self.leftTopView.bounds style:RATreeViewStylePlain];
    [self.treeViewTop setDataSource:self];
    [self.treeViewTop setDelegate:self];
    [self.treeViewTop setSeparatorStyle:RATreeViewCellSeparatorStyleSingleLine];
    [self.leftTopView addSubview:self.treeViewTop];
    
    self.treeViewBottom = [[RATreeView alloc] initWithFrame:self.leftBottomView.bounds style:RATreeViewStylePlain];
    [self.treeViewBottom setDataSource:self];
    [self.treeViewBottom setDelegate:self];
    [self.treeViewBottom setAllowsSelection:YES];
    [self.treeViewBottom setSeparatorStyle:RATreeViewCellSeparatorStyleSingleLine];
    [self.leftBottomView addSubview:self.treeViewBottom];
    
    self.rightViewController = [[LawDocsRightViewController alloc] initWithNibName:@"LawDocsRightViewController" bundle:nil];
    [self.rightView addSubview:self.rightViewController.view];
    
    
    RADataObject *stateLaws = [RADataObject dataObjectWithName:@"国家法律法规" children:nil tag:TreeNodeTagStateLaws];
    RADataObject *motLaws = [RADataObject dataObjectWithName:@"交通部法律法规" children:nil tag:TreeNodeTagMOTLaws];
    RADataObject *guizhouLaws = [RADataObject dataObjectWithName:@"贵州省规定" children:nil tag:TreeNodeTagGZLaws];
    RADataObject *lawsAndRules = [RADataObject dataObjectWithName:@"法律法规" children:[NSArray arrayWithObjects:stateLaws, motLaws, guizhouLaws, nil] tag:TreeNodeTagLawsAndRules];
    RADataObject *payStandards = [RADataObject dataObjectWithName:@"赔补偿标准" children:nil tag:TreeNodeTagPayStandards];
    RADataObject *usingStandards = [RADataObject dataObjectWithName:@"占利用标准" children:nil tag:TreeNodeTagUsingStandards];
    self.menuData = [NSArray arrayWithObjects: lawsAndRules, payStandards, usingStandards, nil];
    self.data1 = self.menuData;
    
    RADataObject *stateLaws1 = [RADataObject dataObjectWithName:@"中华人民共和国公路法" children:nil tag:TreeNodeTagStateLaws];
    RADataObject *stateLaws2 = [RADataObject dataObjectWithName:@"中华人民共和国道路交通安全法" children:nil tag:TreeNodeTagStateLaws];
    RADataObject *stateLaws3 = [RADataObject dataObjectWithName:@"公路安全保护条例" children:nil tag:TreeNodeTagStateLaws];
    self.stateLawsData = [NSArray arrayWithObjects: stateLaws1, stateLaws2, stateLaws3, nil];
    
    RADataObject *motLaws1 = [RADataObject dataObjectWithName:@"路政管理规定" children:nil tag:TreeNodeTagMOTLaws];
    RADataObject *motLaws2 = [RADataObject dataObjectWithName:@"超限运输车辆行驶公路管理规定" children:nil tag:TreeNodeTagMOTLaws];
    RADataObject *motLaws3 = [RADataObject dataObjectWithName:@"关于在全国开展车辆超限超载治理工作的实施方案" children:nil tag:TreeNodeTagMOTLaws];
    self.motLawsData = [NSArray arrayWithObjects: motLaws1, motLaws2, motLaws3, nil];
    
    RADataObject *gzLaws1 = [RADataObject dataObjectWithName:@"贵州省公路路政管理条例" children:nil tag:TreeNodeTagGZLaws];
    self.gzLawsData = [NSArray arrayWithObjects:gzLaws1, nil];
    
    NSArray *priceStandardsData = [RoadAssetPrice allDistinctPropertiesNamed:@"standard"];
    NSMutableArray *temp = [NSMutableArray array];
    for (NSString *priceStandard in priceStandardsData) {
        [temp addObject:[RADataObject dataObjectWithName:priceStandard children:nil tag:TreeNodeTagPayStandards]];
    }
    self.payStandardsData = temp;
}

- (void)viewDidUnload
{
    [self setLeftTopView:nil];
    [self setLeftBottomView:nil];
    [self setRightView:nil];
    [self setTreeViewTop:nil];
    [self setTreeViewBottom:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Manage Data

- (void)updateSectionTwoWithTag:(TreeNodeTag)tag
{
    switch (tag) {
        case TreeNodeTagStateLaws: {
            self.data2 = self.stateLawsData;
            [self.treeViewBottom reloadData];
        }
            break;
        case TreeNodeTagMOTLaws: {
            self.data2 = self.motLawsData;
            [self.treeViewBottom reloadData];
        }
            break;
        case TreeNodeTagGZLaws: {
            self.data2 = self.gzLawsData;
            [self.treeViewBottom reloadData];
        }
            break;
        case TreeNodeTagPayStandards: {
            self.data2 = self.payStandardsData;
            [self.treeViewBottom reloadData];
        }
            break;
        case TreeNodeTagUsingStandards: {
            
        }
        default:
            break;
    }
}


#pragma mark - RATreeViewDataSource

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.textLabel.text = ((RADataObject *)item).name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        if (treeView == self.treeViewTop) {
            return [self.data1 count];
        } else {
            return [self.data2 count];
        }
        
    }
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        if (treeView == self.treeViewTop) {
            return [self.data1 objectAtIndex:index];
        } else {
            return [self.data2 objectAtIndex:index];
        }
    }
    return [data.children objectAtIndex:index];
}

#pragma mark - RATreeViewDelegate
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 47;
}

- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 2 * treeNodeInfo.treeDepthLevel;
}

- (BOOL)treeView:(RATreeView *)treeView shouldExpandItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return YES;
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
    if ([item isEqual:self.expandedNode]) {
        return YES;
    }
    return NO;
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return NO;
}


- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
    } else if (treeNodeInfo.treeDepthLevel == 1) {
        cell.backgroundColor = UIColorFromRGB(0xD1EEFC);
    } else if (treeNodeInfo.treeDepthLevel == 2) {
        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
    }
}

- (void)treeView:(RATreeView *)treeView didDeselectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    UITableViewCell *cell = [treeView cellForItem:item];
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
    } else if (treeNodeInfo.treeDepthLevel == 1) {
        cell.backgroundColor = UIColorFromRGB(0xD1EEFC);
    } else if (treeNodeInfo.treeDepthLevel == 2) {
        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
    }
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    UITableViewCell *cell = [treeView cellForItem:item];
    [cell setBackgroundColor:UIColorFromRGB(0xE0F8D8)];
    
    RADataObject *data = item;
    if (treeView == self.treeViewTop) {
        NSLog(@"%d, %d", treeNodeInfo.treeDepthLevel, treeNodeInfo.positionInSiblings);
        switch (data.tag) {
            case TreeNodeTagStateLaws:
            case TreeNodeTagMOTLaws:
            case TreeNodeTagGZLaws:
                [self updateSectionTwoWithTag:data.tag];
                break;
            case TreeNodeTagPayStandards: {
                [self updateSectionTwoWithTag:data.tag];
                [self.rightViewController showTableView:YES];
                [self.rightViewController showWebView:NO];
                NSArray *allPrices = [RoadAssetPrice roadAssetPricesForStandard:RoadAssetPriceStandardAllStandards];
                NSMutableArray *data = [NSMutableArray array];
                for (RoadAssetPrice *price in allPrices) {
                    NSArray *row = @[price.big_type, price.name, price.price.stringValue, price.spec, price.unit_name, price.remark];
                    [data addObject:row];
//                    [data addObject:[PriceStandard priceStandardFromCoreDataObject:price]];
                }
                [self.rightViewController loadTableData:data];
            }
                break;
            case TreeNodeTagUsingStandards: {
                [self.rightViewController showTableView:YES];
                [self.rightViewController showWebView:NO];
                self.data2 = @[];
                [self.treeViewBottom reloadData];
                NSArray *allPrices = [RoadEngrossPrice allInstances];
                NSMutableArray *data = [NSMutableArray array];
                for (RoadEngrossPrice *price in  allPrices) {
                    NSArray *row = @[price.type, price.name, price.price.stringValue, price.spec, price.unit_name, price.remark];
                    [data addObject:row];
                }
                [self.rightViewController loadTableData:data];
            }
                break;
            default:
                break;
        }
    } else {
        switch (data.tag) {
            case TreeNodeTagStateLaws:
            case TreeNodeTagMOTLaws:
            case TreeNodeTagGZLaws:
            {
                [self.rightViewController showTableView:NO];
                [self.rightViewController showWebView:YES];
                NSURL *pdfURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:data.name ofType:@"pdf"]];
                [self.rightViewController loadWebData:pdfURL];
            }
                break;
            case TreeNodeTagPayStandards: {
                [self.rightViewController showTableView:YES];
                [self.rightViewController showWebView:NO];
                NSArray *allPrices = [RoadAssetPrice roadAssetPricesForStandard:data.name];
                NSMutableArray *data = [NSMutableArray array];
                for (RoadAssetPrice *price in allPrices) {
                    NSArray *row = @[price.big_type, price.name, price.price.stringValue, price.spec, price.unit_name, price.remark];
                    [data addObject:row];
//                    [data addObject:[PriceStandard priceStandardFromCoreDataObject:price]];
                }
                [self.rightViewController loadTableData:data];
            }
                break;
            default:
                break;
        }
    }
    
    
}

@end
