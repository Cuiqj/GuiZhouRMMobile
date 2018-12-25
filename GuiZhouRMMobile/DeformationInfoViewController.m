//
//  DeformationInfoViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DeformationInfoViewController.h"

@interface DeformationInfoViewController ()
@property (retain,nonatomic) NSArray *roadAssetLabels;
@property (retain,nonatomic) NSArray *roadAssetWithLabel; 
- (void)textFieldTextDidChange:(NSNotification *)aNotification;
- (void)assetUnitFieldDidChange:(NSNotification *)aNotificaion;
@property (nonatomic,assign) BOOL isAddNewAsset;
@property (nonatomic,strong) UIPopoverController *popOverController;
@property (nonatomic,strong) NSString *currentPriceStandard;
@property (nonatomic,strong) NSArray *allPriceStandards;
@end

@implementation DeformationInfoViewController
@synthesize caseID=_caseID;
@synthesize roadAssetListView = _roadAssetListView;
@synthesize labelPicker = _labelPicker;
@synthesize roadAssetLabels=_roadAssetLabels;
@synthesize roadAssetWithLabel=_roadAssetWithLabel;
@synthesize deformInfoVC=_deformInfoVC;
@synthesize labelQuantity = _labelQuantity;
@synthesize textQuantity = _textQuantity;
@synthesize labelLength = _labelLength;
@synthesize textLength = _textLength;
@synthesize labelWidth = _labelWidth;
@synthesize textWidth = _textWidth;
@synthesize btnAddDeform = _btnAddDeform;
@synthesize labelPrice = _labelPrice;
@synthesize textPrice = _textPrice;
@synthesize addNewAssetView = _addNewAssetView;
@synthesize textAssetName = _textAssetName;
@synthesize textSpec = _textSpec;
@synthesize textAssetUnit = _textAssetUnit;
@synthesize textAssetPrice = _textAssetPrice;
@synthesize isAddNewAsset = _isAddNewAsset;

- (UIView *)addNewAssetView{
    if (_addNewAssetView == nil) {
        _addNewAssetView = [[[NSBundle mainBundle] loadNibNamed:@"AddNewAsset" owner:self options:nil] objectAtIndex:0];
        [_addNewAssetView setFrame:self.roadAssetListView.frame];
        [_addNewAssetView setHidden:YES];
        [self.view addSubview:_addNewAssetView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:self.textAssetPrice];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assetUnitFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.textAssetUnit];
    }
    return _addNewAssetView;
}

- (NSString *)getCaseIDdelegate{
    return self.caseID;
}


- (NSArray *)allPriceStandards {
    if (_allPriceStandards == nil) {
        NSMutableArray *temp = [NSMutableArray arrayWithObject:RoadAssetPriceStandardAllStandards];
        [temp addObjectsFromArray:[RoadAssetPrice allDistinctPropertiesNamed:@"standard"]];
        _allPriceStandards = [temp copy];
    }
    return _allPriceStandards;
}




- (void)viewDidLoad
{
    [self.roadAssetListView.layer setCornerRadius:4];
    [self.roadAssetListView.layer setMasksToBounds:YES];
    
    NSString *imagePath=[[NSBundle mainBundle] pathForResource:@"蓝底按钮" ofType:@"png"];
    UIImage *btnImage=[[UIImage imageWithContentsOfFile:imagePath] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.btnAddDeform setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    //初始化读取路产清单
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSError *error=nil;
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"RoadAssetPrice" inManagedObjectContext:context];
    NSFetchRequest *fecthRequest=[[NSFetchRequest alloc] init];
    [fecthRequest setEntity:entity];
    [fecthRequest setPredicate:nil];
    self.roadAssetWithLabel=[context executeFetchRequest:fecthRequest error:&error];
    self.roadAssetLabels=[self.roadAssetWithLabel valueForKeyPath:@"@distinctUnionOfObjects.big_type"];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.roadAssetLabels];
    [temp addObject:@"新增"];
    self.roadAssetLabels = [[NSArray alloc] initWithArray:temp];
    if (self.roadAssetLabels.count > 1) {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"big_type == %@",[self.roadAssetLabels objectAtIndex:0]];
        [fecthRequest setPredicate:predicate];
        self.isAddNewAsset = NO;
    } else {
        [self.addNewAssetView setHidden:NO];
        [self.view sendSubviewToBack:self.roadAssetListView];
        [self.roadAssetListView setHidden:YES];
        self.isAddNewAsset = YES;
    }

    self.roadAssetWithLabel = [context executeFetchRequest:fecthRequest error:&error];
    

    
    self.deformInfoVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DeformBriefInfo"];
    self.deformInfoVC.delegate=self;
    self.deformInfoVC.viewLocal=1;
    self.deformInfoVC.view.frame=CGRectMake(0, 260, 1024, 488);
    [self.view addSubview:self.deformInfoVC.view];
    
    
    
    //在未选中路产的情况下，长宽等输入框隐藏
    [self.labelLength setAlpha:0.0];
    [self.labelWidth setAlpha:0.0];
    [self.textLength setAlpha:0.0];
    [self.textWidth setAlpha:0.0];
    self.textLength.text=@"";
    self.textWidth.text=@"";
    self.textQuantity.text=@"";
    self.textPrice.text=@"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:self.textQuantity];     

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addObserver:self forKeyPath:@"currentPriceStandard" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self removeObserver:self forKeyPath:@"currentPriceStandard"];
    if ([self.popOverController isPopoverVisible]) {
        [self.popOverController dismissPopoverAnimated:animated];
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setCaseID:nil];
    [self setRoadAssetLabels:nil];
    [self setRoadAssetWithLabel:nil];
    [self setRoadAssetListView:nil];
    [self setLabelQuantity:nil];
    [self setTextQuantity:nil];
    [self setLabelLength:nil];
    [self setTextLength:nil];
    [self setLabelWidth:nil];
    [self setTextWidth:nil];
    [self setBtnAddDeform:nil];
    [self setLabelPrice:nil];
    [self setTextPrice:nil];
    [self setLabelPicker:nil];
    [self setAddNewAssetView:nil];
    [self setTextAssetName:nil];
    [self setTextSpec:nil];
    [self setTextAssetUnit:nil];
    [self setTextAssetPrice:nil];
    [self setBarButtonSelectPriceStandard:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return self.roadAssetWithLabel.count;
}

//定义路产列表
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RoadAssetCell";
    RoadAssetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    RoadAssetPrice *roadAssetPrice=[self.roadAssetWithLabel objectAtIndex:indexPath.row];
    cell.textLabel.text=roadAssetPrice.name;
    cell.specLabel.text=roadAssetPrice.spec;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2f元/%@",[roadAssetPrice.price doubleValue],roadAssetPrice.unit_name];
    return cell;
}

//根据路产的选择与点击，显示与隐藏数量、长、宽、添加等增加操作组件
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if (cell.isSelected) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [UIView animateWithDuration:0.3 
                              delay:0.0 
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.labelLength setAlpha:0.0];
                             [self.labelWidth setAlpha:0.0];
                             [self.textLength setAlpha:0.0];
                             [self.textWidth setAlpha:0.0];
                         }
                         completion:nil];
        self.textLength.text=@"";
        self.textWidth.text=@"";
        self.textQuantity.text=@"";
        self.textPrice.text=@"";
        return nil;
    } else {
        [UIView animateWithDuration:0.3 
                              delay:0.0 
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{ 
                             if ([[[self.roadAssetWithLabel objectAtIndex:indexPath.row] valueForKey:@"unit_name"] isEqualToString:@"平方米"]) {
                                 [self.labelLength setAlpha:1.0];
                                 [self.labelWidth setAlpha:1.0];
                                 [self.textLength setAlpha:1.0];
                                 [self.textWidth setAlpha:1.0];
                             } else {
                                 [self.labelLength setAlpha:0.0];
                                 [self.labelWidth setAlpha:0.0];
                                 [self.textWidth setAlpha:0.0];
                                 [self.textLength setAlpha:0.0];
                                 self.textWidth.text=@"";
                                 self.textLength.text=@"";
                             }                          
                         } 
                         completion:nil];
        return indexPath;
    }
}

//根据选择路产与输入数量计算金额
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![self.textQuantity.text isEmpty]) {
        double assetPrice=[[[self.roadAssetWithLabel objectAtIndex:indexPath.row] valueForKey:@"price"] doubleValue];
        double payPrice=assetPrice*self.textQuantity.text.doubleValue;
        self.textPrice.text=[NSString stringWithFormat:@"%.2f元",payPrice];
    }
}

//长宽输入变化时自动计算数量
- (IBAction)textNumberChanged:(id)sender {
    if (![self.textLength.text isEmpty] && ![self.textWidth.text isEmpty]) {
        double length=self.textLength.text.doubleValue;
        double width=self.textWidth.text.doubleValue;
        self.textQuantity.text=[NSString stringWithFormat:@"%.2f",length*width];
        
        double assetPrice = 0.0;
        if (self.isAddNewAsset) {
            assetPrice = [self.textAssetPrice.text doubleValue];
        } else {
            NSIndexPath* indexPath=[self.roadAssetListView indexPathForSelectedRow];
            if (indexPath!=nil){
                assetPrice=[[[self.roadAssetWithLabel objectAtIndex:indexPath.row] valueForKey:@"price"] doubleValue];
            }
        }
        double payPrice=assetPrice*self.textQuantity.text.doubleValue;
        self.textPrice.text=[NSString stringWithFormat:@"%.2f元",payPrice];
    }
}

//数量输入变化时自动计算金额
-(void)textFieldTextDidChange:(NSNotification *)aNotification{
    if (!self.textLength.hidden) {
        self.textLength.text = @"";
        self.textWidth.text = @"";
    }
    double assetPrice = 0.0;
    if (self.isAddNewAsset) {
        assetPrice = [self.textAssetPrice.text doubleValue];
    } else {
        NSIndexPath* indexPath=[self.roadAssetListView indexPathForSelectedRow];
        if (indexPath!=nil){
            assetPrice=[[[self.roadAssetWithLabel objectAtIndex:indexPath.row] valueForKey:@"price"] doubleValue];
        }
    }
    double payPrice=assetPrice*self.textQuantity.text.doubleValue;
    self.textPrice.text=[NSString stringWithFormat:@"%.2f元",payPrice];
}

- (void)assetUnitFieldDidChange:(NSNotification *)aNotificaion{
    if (self.textAssetUnit) {
        if ([self.textAssetUnit.text isEqualToString:@"平方米"]) {
            [self.labelLength setAlpha:1.0];
            [self.labelWidth setAlpha:1.0];
            [self.textLength setAlpha:1.0];
            [self.textWidth setAlpha:1.0];
        } else {
            [self.labelLength setAlpha:0.0];
            [self.labelWidth setAlpha:0.0];
            [self.textWidth setAlpha:0.0];
            [self.textLength setAlpha:0.0];
            self.textWidth.text=@"";
            self.textLength.text=@"";
        }
    }
}

#pragma mark - Picker View Delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.roadAssetLabels.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.roadAssetLabels objectAtIndex:row]==nil? @"":[self.roadAssetLabels objectAtIndex:row];
}

//由picker实现选择路产类别，选择不同类别，右方tableview显示不同路产信息
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *rowTitle=[pickerView.delegate pickerView:pickerView titleForRow:row forComponent:component];
    if ([rowTitle isEqualToString:@"新增"]) {
        if (self.addNewAssetView.hidden == YES) {
            [self.addNewAssetView setHidden:NO];
            for (UITextField *text in self.addNewAssetView.subviews) {
                if ([text isMemberOfClass:[UITextField class]]) {
                    text.text = @"";
                }
            }
            [self.view sendSubviewToBack:self.roadAssetListView];
            [self.roadAssetListView setHidden:YES];
            self.isAddNewAsset = YES;
        }
    } else {
        if (self.addNewAssetView.hidden == NO) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.textAssetPrice];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.textAssetUnit];
            [self.addNewAssetView removeFromSuperview];
            [self setAddNewAssetView:nil];
            [self.view bringSubviewToFront:self.roadAssetListView];
            [self.roadAssetListView setHidden:NO];
        }
        NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
        NSError *error=nil;
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"RoadAssetPrice" inManagedObjectContext:context];
        NSFetchRequest *fecthRequest=[[NSFetchRequest alloc] init];
        [fecthRequest setEntity:entity];
        NSPredicate *predicate = nil;
        if (self.currentPriceStandard == nil || [self.currentPriceStandard isEqualToString:RoadAssetPriceStandardAllStandards]) {
            predicate=[NSPredicate predicateWithFormat:@"big_type == %@",rowTitle];
        } else {
            predicate=[NSPredicate predicateWithFormat:@"big_type == %@ and standard = %@",rowTitle,self.currentPriceStandard];
        }
        
        [fecthRequest setPredicate:predicate];
        self.roadAssetWithLabel=[context executeFetchRequest:fecthRequest error:&error];
        [self.roadAssetListView reloadData];
        self.isAddNewAsset = NO;
    }
}



//添加记录按钮
- (IBAction)btnAddDeformation:(id)sender {
    [self.textQuantity resignFirstResponder];
    if (self.isAddNewAsset) {
        if (self.textQuantity.text.doubleValue >0) {
            if ([self.textAssetName.text isEmpty] || [self.textAssetPrice.text isEmpty] || [self.textAssetUnit.text isEmpty] || self.textAssetPrice.text.doubleValue <= 0){
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"错误" message:@"路产名称、单价或单位输入错误！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            } else {
                CaseDeformation *deform = [CaseDeformation newDataObject];
                deform.caseinfo_id = self.caseID;
                deform.assetId = @"";
                deform.roadasset_name = self.textAssetName.text;
                deform.price = @(self.textAssetPrice.text.doubleValue);
                deform.quantity = @(self.textQuantity.text.doubleValue);
                deform.unit = self.textAssetUnit.text;
                deform.rasset_size = self.textSpec.text;
                deform.total_price = @(deform.price.doubleValue * deform.quantity.doubleValue);
                NSString *remark=@"";
                if ((![self.textLength.text isEmpty]) && (![self.textWidth.text isEmpty])) {
                    remark=[NSString stringWithFormat:@"长%@米，宽%@米",self.textLength.text,self.textWidth.text];
                }
                deform.remark = remark;
                [[AppDelegate App] saveContext];
                [self.deformInfoVC reloadDeformTableView];
            }
        }
    } else {
        NSIndexPath* indexPath=[self.roadAssetListView indexPathForSelectedRow];
        if (indexPath!=nil) {
            if (self.textQuantity.text.doubleValue>0) {
                double quantity=self.textQuantity.text.doubleValue;
                NSString *remark=@"";
                if ((![self.textLength.text isEmpty]) && (![self.textWidth.text isEmpty])) {
                    remark=[NSString stringWithFormat:@"长%@米，宽%@米",self.textLength.text,self.textWidth.text];
                }
                [self.deformInfoVC addDeformationForRoadAsset:[self.roadAssetWithLabel objectAtIndex:indexPath.row] andQuantity:quantity withRemark:remark];
            }
        }
    }
}

-(IBAction)btnDismiss:(id)sender{    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)selectPriceStandard:(UIBarButtonItem *)sender {
    NSArray *dataSource =  self.allPriceStandards;
    NormalListSelectController *listSelectController = [self.storyboard instantiateViewControllerWithIdentifier:@"NormalListSelectController"];
    listSelectController.dataSource = dataSource;
    listSelectController.delegate = self;
    if (self.popOverController == nil) {
        self.popOverController = [[UIPopoverController alloc] initWithContentViewController:listSelectController];
    } else {
        [self.popOverController setContentViewController:listSelectController];
    }
    if ([self.popOverController isPopoverVisible]) {
        [self.popOverController dismissPopoverAnimated:YES];
    } else {
        [self.popOverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark - NormalListSelectDelegate

- (void)listSelect:(NormalListSelectController *)listSelectController selectedIndexPath:(NSIndexPath *)tableIndexPath {
    self.currentPriceStandard = [self.allPriceStandards objectAtIndex:tableIndexPath.row];
    [self.popOverController dismissPopoverAnimated:YES];
}

#pragma mark - Key Value Obeservation

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isKindOfClass:[self class]]) {
        if ([keyPath isEqualToString:@"currentPriceStandard"]) {
            
            NSString *newPriceStandard = [change objectForKey:NSKeyValueChangeNewKey];
            self.barButtonSelectPriceStandard.title = newPriceStandard;
            NSMutableArray *pickerViewDataSource = [NSMutableArray arrayWithArray:[[RoadAssetPrice roadAssetPricesForStandard:newPriceStandard] valueForKeyPath:@"@distinctUnionOfObjects.big_type"]];
            [pickerViewDataSource addObject:@"新增"];
            self.roadAssetLabels = pickerViewDataSource;
            
            [self.labelPicker reloadAllComponents];
            [self.labelPicker selectRow:0 inComponent:0 animated:YES];
            [self pickerView:self.labelPicker didSelectRow:0 inComponent:0];
        }
    }
}


@end
