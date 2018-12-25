//
//  CaseViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CaseViewController.h"
#import "OrgInfo.h"
#import "UserInfo.h"
#import "Road.h"

#define PHOTO(index) [self cachePhotoForIndex:index]

//载入对应照片，并显示一个序列文字标签
#define LOADPHOTOS  if (self.photoArray.count>0) {\
                        self.labelPhotoIndex.hidden=NO;\
                        self.labelPhotoIndex.text=[[NSString alloc] initWithFormat:@"%d/%d",self.imageIndex+1,self.photoArray.count];\
                        self.labelPhotoIndex.alpha=1.0;\
                    }\
                    

#define WIDTH_OFF_SET 654.0
#define HEIGHT_OFF_SET 0
#define SCROLLVIEW_WIDTH 654.0
#define SCROLLVIEW_HEIGHT 336.0

#define CITIZENINFO_HEIGHT 620.0
#define ACCINFO_HEIGHT 450.0


typedef enum _kUITag {
    kUITagTextFieldBase = 0,
    kUITagTextFieldCasemark2,
    kUITagTextFieldCasemark3,
    kUITagTextFieldHappenDate,
    kUITagTextFieldRoadSegment,
    kUITagTextFieldSide,
    kUITagTextFieldPlace,
    kUITagTextFieldWeather,
    kUITagTextFieldStationStartKM,
    kUITagTextFieldStationStartM,
    kUITagTextFieldStationEndKM,
    kUITagTextFieldStationEndM,
    kUITagTextFieldCitizenName,
    kUITagTextFieldCaseDesc,
    kUITagTextFieldCasePrefix,
    
    kUITagButtonBase = 200,
    kUITagButtonEdit,
    kUITagButtonNewCase,
    kUITagButtonSave,
    kUITagButtonPickFromLibrary,
    kUITagButtonCamera,
    
    kUITagTableViewBase = 999,
    kUITagTableViewDocList,
    kUITagTableViewTemplates,
    
    kUITagScrollViewBase = 2000,
    kUITagScrollViewInfo,
    
    kUITagSegmentControlBase = 2100,
    kUITagSegmentControlSegInfoPage
} kUITag;

@interface CaseViewController(){
    NSString *currentFileName;
    //弹窗标识，为0弹出天气选择，为1弹出车型选择，为2弹出损坏程度选择
    NSInteger touchedTag;
}
//根据案件类型载入文书模版
- (void)configureDocTemplatesArray;
- (void)loadCaseDocList:(NSString *)caseID;
- (void)pickerPresentForIndex:(NSInteger)iIndex fromRect:(CGRect)rect;
- (void)roadSegmentPickerPresentPickerState:(RoadSegmentPickerState)state fromRect:(CGRect)rect;
- (void)keyboardWillShow:(NSNotification *)aNotification;
- (void)keyboardWillHide:(NSNotification *)aNotification;
- (void)citizenNameChange;
//所有文书模版名称
@property (nonatomic,retain) NSArray *docTemplatesArray;


//案件照片路径
@property (nonatomic,retain) NSString *photoPath;

//已有文书数组
@property (nonatomic,retain) NSArray *docListArray;

//案件照片数组
@property (nonatomic,retain) NSMutableArray *photoArray;

@property (nonatomic,retain) UIPopoverController *caseInfoPickerpopover;
@property (nonatomic,retain) UIPopoverController *caseListpopover;
//设定文书查看状态，编辑模式或者PDF查看模式
@property (nonatomic,assign) DocPrinterState docPrinterState;

//路段ID
@property (nonatomic,copy) NSString *roadSegmentID;

@property (nonatomic,assign) BOOL yesOrNoType;

@property (nonatomic,assign) RoadSegmentPickerState roadSegmentPickerState;

@property (nonatomic,assign) NSInteger imageIndex;
@property (nonatomic,retain) UIImageView *leftImageView;
@property (nonatomic,retain) UIImageView *midImageView;
@property (nonatomic,retain) UIImageView *rightImageView;
@property (nonatomic, strong) NSMutableDictionary *textFieldActions;

- (void)showDeleteMenu:(UILongPressGestureRecognizer *)gestureRecognizer;
@end



@implementation CaseViewController

@synthesize textCasePrefix = _textCasePrefix;
@synthesize infoView=_infoView;
@synthesize caseID=_caseID;
@synthesize textCasemark2=_textCasemark2;
@synthesize textCasemark3=_textCasemark3;
@synthesize textWeatheer=_textWeatheer;
@synthesize textSide = _textSide;
@synthesize textPlace = _textPlace;
@synthesize textRoadSegment = _textRoadSegment;
@synthesize textStationStartKM = _textStationStartKM;
@synthesize textStationStartM = _textStationStartM;
@synthesize textStationEndKM = _textStationEndKM;
@synthesize textStationEndM = _textStationEndM;
@synthesize textHappenDate = _textHappenDate;
@synthesize textCitizenName = _textAutoNumber;
@synthesize labelPhotoIndex = _labelPhotoIndex;
@synthesize textCaseDesc = _textCaseDesc;
@synthesize segInfoPage = _segInfoPage;
@synthesize uiButtonEdit = _uiButtonEdit;
@synthesize uiButtonNewCase = _uiButtonNewCase;
@synthesize uiButtonSave = _uiButtonSave;
@synthesize uiButtonCamera = _uiButtonCamera;
@synthesize uiButtonPickFromLibrary = _uiButtonPickFromLibrary;
@synthesize docListView = _docListView;
@synthesize docTemplatesView = _docTemplatesView;
@synthesize caseInfo=_caseInfo;
@synthesize accInfoBriefVC=_accInfoBriefVC;
@synthesize citizenInfoBriefVC=_citizenInfoBriefVC;
@synthesize inquireInfoBriefVC=_inquireInfoBriefVC;
@synthesize deformInfoVC=_deformInfoVC;
@synthesize paintBriefVC=_paintBriefVC;
@synthesize needsMove=_needsMove;
@synthesize caseListpopover=_caseListpopover;
@synthesize caseInfoPickerpopover=_caseInfoPickerpopover;
@synthesize docListArray=_docListArray;
@synthesize docPrinterState=_docPrinterState;
@synthesize roadSegmentID = _roadSegmentID;
@synthesize roadSegmentPickerState = _roadSegmentPickerState;

@synthesize caseProcessType  = _caseProcessType;

#pragma mark - init
- (NSString *)caseID{
    if (_caseID==nil) {
        _caseID=@"";
    }
    return _caseID;
}

- (NSMutableArray *)photoArray{
    if (_photoArray==nil) {
        _photoArray=[[NSMutableArray alloc] initWithCapacity:1];
    }
    return _photoArray;
}

- (UIImageView *)leftImageView{
    if (_leftImageView==nil) {
        _leftImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
        _leftImageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _leftImageView;
}

- (UIImageView *)midImageView{
    if (_midImageView==nil) {
        _midImageView=[[UIImageView alloc] initWithFrame:CGRectMake(SCROLLVIEW_WIDTH, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
        _midImageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _midImageView;
}

- (UIImageView *)rightImageView{
    if (_rightImageView==nil) {
        _rightImageView=[[UIImageView alloc] initWithFrame:CGRectMake(SCROLLVIEW_WIDTH*2, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
        _rightImageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _rightImageView;
}

//根据案件类型载入文书模版
- (void)configureDocTemplatesArray{
    switch (self.caseProcessType) {
        case 120:{
            if (self.yesOrNoType) {
                self.docTemplatesArray = @[@"勘验检查笔录", @"询问笔录", @"违法行为通知书", @"行政（当场）处罚决定书", @"送达回证", @"现场勘查平面示意图", @"抽样取证凭证", @"责令停驶通知书" , @"责令改正通知书", @"责令停止（改正）违法行为通知书", @"超限车辆卸载通知书"];
            } else {
                self.docTemplatesArray = @[@"勘验检查笔录", @"询问笔录", @"违法行为通知书", @"行政处罚决定书", @"送达回证", @"现场勘查平面示意图", @"抽样取证凭证", @"责令停驶通知书" , @"责令改正通知书", @"责令停止（改正）违法行为通知书", @"超限车辆卸载通知书"];
            }
        }
            break;
        case 130:
            self.docTemplatesArray = @[@"勘验检查笔录", @"询问笔录", @"赔（补）偿费计算表", @"赔（补）偿通知书", @"送达回证", @"现场勘查平面示意图", @"抽样取证凭证", @"责令停驶通知书" , @"责令改正通知书", @"责令停止（改正）违法行为通知书", @"超限车辆卸载通知书"];
            break;
        case 140:
            self.docTemplatesArray = @[@"勘验检查笔录", @"询问笔录", @"送达回证", @"现场勘查平面示意图", @"抽样取证凭证", @"责令停驶通知书" , @"责令改正通知书", @"责令停止（改正）违法行为通知书", @"超限车辆卸载通知书"];
            break;
        default:
            break;
    }
    [self.docTemplatesView reloadData];
}

- (NSMutableDictionary *)textFieldActions{
    if (_textFieldActions == nil) {
        _textFieldActions = [[NSMutableDictionary alloc] init];
    }
    return _textFieldActions;
}


- (void)viewDidLoad{
    
    //为UI控件分配Tag
    [self assignUITags];
     
    //初始化案件前缀及类型
    NSString *currentOrgID=[[NSUserDefaults standardUserDefaults] stringForKey:ORGKEY];
    NSString *filePre=[[OrgInfo orgInfoForOrgID:currentOrgID] valueForKey:@"file_pre"];
    filePre=[filePre stringByAppendingFormat:@"赔"];
    self.textCasePrefix.text=filePre;
    self.caseProcessType = 130;
    self.yesOrNoType = NO;
    [self configureDocTemplatesArray];
    
    self.caseID = @"";
    currentFileName=@"";
    self.caseInfo=nil;
    touchedTag=-1;
    
    //删除无用的案件数据
    [CaseInfo deleteEmptyCaseInfo];
    
    //界面初始化
    self.labelPhotoIndex.alpha=0.0;
    self.labelPhotoIndex.hidden=YES;
    
    UIFont *segFont = [UIFont boldSystemFontOfSize:15.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:segFont
                                                           forKey:UITextAttributeFont];
    [self.segInfoPage setTitleTextAttributes:attributes 
                                    forState:UIControlStateNormal];
    
    self.infoView.layer.cornerRadius=4;
    self.infoView.layer.masksToBounds=YES;
    
    NSString *imagePath=[[NSBundle mainBundle] pathForResource:@"案件信息-bg" ofType:@"png"];
    self.view.layer.contents=(id)[[UIImage imageWithContentsOfFile:imagePath] CGImage];
    imagePath=[[NSBundle mainBundle] pathForResource:@"蓝底按钮" ofType:@"png"];
    UIImage *btnBlueImage=[[UIImage imageWithContentsOfFile:imagePath] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.uiButtonNewCase setBackgroundImage:btnBlueImage forState:UIControlStateNormal];
    
    //小按钮进入图片缓存，否则在旋转之后，显示将不正常
    UIImage *btnWhiteImage=[[UIImage imageNamed:@"小按钮.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.uiButtonEdit setBackgroundImage:btnWhiteImage forState:UIControlStateNormal];
    [self.uiButtonEdit setAlpha:0.0];
    [self.uiButtonEdit setHidden:YES];
    
    imagePath=[[NSBundle mainBundle] pathForResource:@"蓝底主按钮" ofType:@"png"];
    UIImage *btnYelloImage=[[UIImage imageWithContentsOfFile:imagePath] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.uiButtonSave setBackgroundImage:btnYelloImage forState:UIControlStateNormal];
    
    //事故信息页面初始化
    self.accInfoBriefVC=[self.storyboard instantiateViewControllerWithIdentifier:@"AccidentBriefInfo"];
    self.accInfoBriefVC.delegate=self;
    self.accInfoBriefVC.view.frame=CGRectMake(0.0, 0.0, SCROLLVIEW_WIDTH,ACCINFO_HEIGHT);
    [self.infoView addSubview:self.accInfoBriefVC.view];
    self.infoView.contentMode=UIViewContentModeLeft;
    self.infoView.bounces=NO;
    self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, ACCINFO_HEIGHT);
    self.infoView.contentInset=UIEdgeInsetsZero;
    
    //当事人信息页面初始化
    self.citizenInfoBriefVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CitizenBriefInfo"];
    self.citizenInfoBriefVC.delegate=self;
    self.citizenInfoBriefVC.view.frame=CGRectMake(0.0, 0.0, SCROLLVIEW_WIDTH, CITIZENINFO_HEIGHT);
    
    //勘验草图显示页面初始化
    self.paintBriefVC=[self.storyboard instantiateViewControllerWithIdentifier:@"PaintBriefInfo"];
    self.paintBriefVC.view.frame=CGRectMake(0.0, 0.0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
    
    //询问笔录页面初始化
    self.inquireInfoBriefVC=[self.storyboard instantiateViewControllerWithIdentifier:@"InquireBriefInfo"];
    self.inquireInfoBriefVC.view.frame=CGRectMake(0.0, 0.0, SCROLLVIEW_WIDTH,SCROLLVIEW_HEIGHT);
    self.inquireInfoBriefVC.delegate = self;
    
    //赔补偿清单页面初始化
    self.deformInfoVC=[self.storyboard instantiateViewControllerWithIdentifier:@"DeformBriefInfo"];
    self.deformInfoVC.delegate=self;
    self.deformInfoVC.viewLocal=0;
    self.deformInfoVC.view.frame=CGRectMake(0.0, 0.0, SCROLLVIEW_WIDTH,SCROLLVIEW_HEIGHT);
    
    //默认选中事故信息页面
    self.segInfoPage.selectedSegmentIndex=0;
    

        
    [self.uiButtonCamera setHidden:YES];
    [self.uiButtonPickFromLibrary setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.needsMove=NO;
    self.yesOrNoType = NO;
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self addObserver:self forKeyPath:@"caseInfo" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    if ([self.caseListpopover isPopoverVisible]) {
        [self.caseListpopover dismissPopoverAnimated:NO];
    }
    
    if ([self.caseInfoPickerpopover isPopoverVisible]) {
        [self.caseInfoPickerpopover dismissPopoverAnimated:animated];
    }
    
    [self removeObserver:self forKeyPath:@"caseInfo"];
    
    [super viewWillDisappear:animated];
}


- (void)viewDidAppear:(BOOL)animated{
    if (self.segInfoPage.selectedSegmentIndex == 3 && self.caseID) {
        [self.inquireInfoBriefVC loadInquireInfoForCase:self.caseID forInquire:@""];
    }
}


- (void)viewDidUnload
{
    [[self.infoView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self setInfoView:nil];
    [self setCaseID:nil];
    [self setTextCasemark2:nil];
    [self setTextCasemark3:nil];
    [self setTextWeatheer:nil];
    [self setTextSide:nil];
    [self setTextPlace:nil];
    [self setTextRoadSegment:nil];
    [self setTextStationStartKM:nil];
    [self setTextStationStartM:nil];
    [self setTextStationEndKM:nil];
    [self setTextStationEndM:nil];
    [self setTextHappenDate:nil];
    [self setTextCitizenName:nil];
    [self setTextCaseDesc:nil];
    [self setSegInfoPage:nil];
   
    [self setUiButtonEdit:nil];
    [self setUiButtonNewCase:nil];
    [self setUiButtonSave:nil];
    
    [self setCaseInfo:nil];
    
    [self setAccInfoBriefVC:nil];
    [self setCitizenInfoBriefVC:nil];
    [self setInquireInfoBriefVC:nil];
    [self setDeformInfoVC:nil];
    [self setPaintBriefVC:nil];
    
    [self setRoadSegmentID:nil];
    [self setCaseListpopover:nil];
    [self setCaseInfoPickerpopover:nil];
    [self setDocListArray:nil];
    [self setDocListView:nil];
    [self setDocTemplatesView:nil];
    [self setUiButtonCamera:nil];
    [self setUiButtonPickFromLibrary:nil];
    [self setLabelPhotoIndex:nil];
    [self setTextCasePrefix:nil];
    currentFileName = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


#pragma mark - prepare for Segue
//初始化各弹出选择页面
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *segueIdentifier= [segue identifier];
    if ([segueIdentifier isEqualToString:@"toCaseDocument"]){
        CaseDocumentsViewController *documentsVC=segue.destinationViewController;
        documentsVC.fileName=currentFileName;
        documentsVC.caseID=self.caseID;
        documentsVC.docPrinterState=self.docPrinterState;
        documentsVC.docReloadDelegate=self;
    } else if ([segueIdentifier isEqualToString:@"toCitizenListView"]) {
        CitizenListViewController *clVC=segue.destinationViewController;
        clVC.delegate=self;
        clVC.caseID=self.caseID;
        clVC.citizenListPopover=[(UIStoryboardPopoverSegue *)segue popoverController];
    } else if ([segueIdentifier isEqualToString:@"toCaseDescList"]) {
        CaseDescListViewController *cdlVC=segue.destinationViewController;
        cdlVC.delegate=self;
        cdlVC.caseProcessType = self.caseProcessType;
        cdlVC.popOver=[(UIStoryboardPopoverSegue *)segue popoverController];
    } else if ([segueIdentifier isEqualToString:@"toDateTimePicker"]) {
        DateSelectController *dsVC=segue.destinationViewController;
        dsVC.dateselectPopover=[(UIStoryboardPopoverSegue *) segue popoverController];
        dsVC.delegate=self;
        dsVC.pickerType=1;
        dsVC.datePicker.maximumDate=[NSDate date];
        [dsVC showdate:self.textHappenDate.text];
    } else if ([segueIdentifier isEqualToString:@"toDeformInfoEditor"]) {
        DeformationInfoViewController *diVC=segue.destinationViewController;
        diVC.caseID=self.caseID;
    } else if ([segueIdentifier isEqualToString:@"toInquireInfoEditor"]) {
        InquireInfoViewController *iiVC=segue.destinationViewController;
        iiVC.caseID=self.caseID;
        iiVC.delegate=self;
        iiVC.inquireID = self.inquireInfoBriefVC.inquireID;
    } else if ([segueIdentifier isEqualToString:@"toPaintEditor"]) {
        CasePaintViewController *cpVC=segue.destinationViewController;
        cpVC.delegate = self;
        cpVC.caseID=self.caseID;
    }
}


#pragma mark - textField Delegate
//使日期选择框,案件前缀显示框不可编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{    
    if (textField.tag==kUITagTextFieldHappenDate || textField.tag==kUITagTextFieldCasePrefix) {
        return NO;
    } else {
        return YES;
    }

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == self) {
        if ([keyPath isEqualToString:@"caseInfo"]) {
            if (self.caseInfo.isuploaded.boolValue == YES) {
                
                UIColor *colorForDiabledBackground = [UIColor colorWithRed:0.8 green:0.83 blue:0.85 alpha:1.0];
                
                //案件信息页面控件
                for (UIView *subView in self.view.subviews) {
                    if ([subView isKindOfClass:[UITextField class]]) {
                        UITextField *textField = (UITextField *)subView;
                        [textField setBackgroundColor:colorForDiabledBackground];
                        [textField setUserInteractionEnabled:NO];
                    }
                }
                
                //基本性质子页面控件
                for (UIView *subView in self.accInfoBriefVC.view.subviews) {
                    if ([subView isKindOfClass:[UITextField class]]) {
                        [subView setBackgroundColor:colorForDiabledBackground];
                        [subView setUserInteractionEnabled:NO];
                    } else if ([subView isKindOfClass:[UIControl class]]) {
                        [subView setUserInteractionEnabled:NO];
                    }
                }
                
                //当事人信息子页面控件
                for (UIView *subView in self.citizenInfoBriefVC.view.subviews) {
                    if ([subView isKindOfClass:[UITextField class]]) {
                        [subView setBackgroundColor:colorForDiabledBackground];
                        [subView setUserInteractionEnabled:NO];
                    } else if ([subView isKindOfClass:[UIControl class]]) {
                        [subView setUserInteractionEnabled:NO];
                    }
                }
                
            } else if (self.caseInfo.isuploaded.boolValue == NO) {
                //案件信息页面控件
                for (UIView *subView in self.view.subviews) {
                    if ([subView isKindOfClass:[UITextField class]]) {
                        UITextField *textField = (UITextField *)subView;
                        [textField setBackgroundColor:[UIColor whiteColor]];
                        [textField setUserInteractionEnabled:YES];
                    }
                }
                
                //基本性质子页面控件
                for (UIView *subView in self.accInfoBriefVC.view.subviews) {
                    if ([subView isKindOfClass:[UITextField class]]) {
                        [subView setBackgroundColor:[UIColor whiteColor]];
                        [subView setUserInteractionEnabled:YES];
                    } else if ([subView isKindOfClass:[UIControl class]]) {
                        [subView setUserInteractionEnabled:YES];
                    }
                }
                
                //当事人信息子页面控件
                for (UIView *subView in self.citizenInfoBriefVC.view.subviews) {
                    if ([subView isKindOfClass:[UITextField class]]) {
                        [subView setBackgroundColor:[UIColor whiteColor]];
                        [subView setUserInteractionEnabled:YES];
                    } else if ([subView isKindOfClass:[UIControl class]]) {
                        [subView setUserInteractionEnabled:YES];
                    }
                }
            }
        }
    }
}

- (void)editWarning{
    if (self.caseInfo != nil && self.caseInfo.isuploaded.boolValue == YES) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"已上传案件，不能修改" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
}
    
#pragma mark - TableView dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   
    NSInteger number=0;
    if (tableView.tag==kUITagTableViewDocList) {
        number=self.docListArray.count;
    } else if (tableView.tag==kUITagTableViewTemplates) {
        number=self.docTemplatesArray.count;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView.tag==kUITagTableViewTemplates) {
        static NSString *CellIdentifier = @"DocTemplatesCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.text = [self.docTemplatesArray objectAtIndex:indexPath.row];
    } else if (tableView.tag==kUITagTableViewDocList) {
        static NSString *CellIdentifier = @"DocListCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.textLabel.text=[self.docListArray objectAtIndex:indexPath.row];
    } 
    return cell;
}

//点击进入文书编辑和打印页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==kUITagTableViewTemplates) {
        self.docPrinterState=1;
    } else if (tableView.tag==kUITagTableViewDocList) {
        self.docPrinterState = kPDFView;
    }
    UITableViewCell *myCell=[tableView cellForRowAtIndexPath:indexPath];
    currentFileName=myCell.textLabel.text;
    if (![self.caseID isEmpty]) {
        [self saveCaseInfoForCase:self.caseID];
    }    
    [self performSegueWithIdentifier:@"toCaseDocument" sender:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - IBActions

//各信息页面切换
- (IBAction)changeInfoPage:(UISegmentedControl *)sender {
    for(UIView *subview in [self.infoView subviews]) {
        [subview removeFromSuperview];
    }

    //删除infoView上的所有手势，防止在非照片页面误操作
    for (UIGestureRecognizer *gesture in [self.infoView gestureRecognizers]) {
        [gesture removeTarget:self action:@selector(showDeleteMenu:)];
    }
     
    [self.labelPhotoIndex setAlpha:0.0];
    [self.labelPhotoIndex setHidden:YES];
    if (sender.selectedSegmentIndex!=5) {
        self.infoView.pagingEnabled=NO;
        self.infoView.delegate=nil;
        [self.infoView setContentOffset:CGPointZero animated:NO];
    } else {
        self.infoView.delegate=self;
        self.infoView.pagingEnabled=YES;
        self.infoView.contentSize=CGSizeMake(self.infoView.bounds.size.width*3, self.infoView.bounds.size.height);
        [self.infoView setContentOffset:CGPointMake(self.infoView.bounds.size.width, 0) animated:NO];
    }
    if (sender.selectedSegmentIndex != 1) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:self.textCitizenName];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(citizenNameChange) name:UITextFieldTextDidEndEditingNotification object:self.textCitizenName];
    }
    switch (sender.selectedSegmentIndex) {
        //事故信息
        case 0:{
            self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, ACCINFO_HEIGHT);
            if (![self.accInfoBriefVC.caseID isEqualToString:self.caseID]) {
                [self.accInfoBriefVC loadDataForCase:self.caseID];
            }
            [UIView transitionWithView:self.infoView duration:0.3 
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{ 
                                [self.uiButtonEdit setAlpha:0.0];
                                [self.uiButtonPickFromLibrary setAlpha:0.0];
                                [self.uiButtonCamera setAlpha:0.0];
                                [self.infoView addSubview:self.accInfoBriefVC.view];
                            } 
                            completion:^(BOOL finished){
                                [self.uiButtonEdit setHidden:YES];
                                [self.uiButtonCamera setHidden:YES];
                                [self.uiButtonPickFromLibrary setHidden:YES];
                            }];
        }
            break;
        //当事人信息    
        case 1:{
            [UIView transitionWithView:self.infoView duration:0.3 
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{ 
                                [self.uiButtonEdit setAlpha:0.0];
                                [self.uiButtonPickFromLibrary setAlpha:0.0];
                                [self.uiButtonCamera setAlpha:0.0];
                                [self.infoView addSubview:self.citizenInfoBriefVC.view];
                            } 
                            completion:^(BOOL finished){
                                [self.uiButtonEdit setHidden:YES];
                                [self.uiButtonCamera setHidden:YES];
                                [self.uiButtonPickFromLibrary setHidden:YES];
                            }];
            self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, CITIZENINFO_HEIGHT);
            if (![self.citizenInfoBriefVC.caseID isEqualToString:self.caseID]) {
                [self.citizenInfoBriefVC loadCitizenInfoForCase:self.caseID];
            }
            if (![self.citizenInfoBriefVC.textParty.text isEqualToString:self.textCitizenName.text]) {
                self.citizenInfoBriefVC.textParty.text = self.textCitizenName.text;
            }
        }
            break;
        //赔补偿清单    
        case 2:{
            self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
            self.deformInfoVC.caseID=self.caseID;
            [UIView transitionWithView:self.infoView duration:0.3       
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                if (self.caseInfo != nil && self.caseInfo.isuploaded.boolValue == NO) {
                                    [self.uiButtonEdit setHidden:NO];
                                    [self.uiButtonEdit setAlpha:1.0];
                                } else {
                                    [self.uiButtonEdit setHidden:YES];
                                    [self.uiButtonEdit setAlpha:0.0];
                                }
                                [self.uiButtonPickFromLibrary setAlpha:0.0];
                                [self.uiButtonCamera setAlpha:0.0];
                                [self.infoView addSubview:self.deformInfoVC.view];
                            } 
                            completion:^(BOOL finished){
                                [self.uiButtonCamera setHidden:YES];
                                [self.uiButtonPickFromLibrary setHidden:YES];
                            }];
        }
            break;
        //询问笔录    
        case 3:{
            self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
            self.inquireInfoBriefVC.caseID=self.caseID;
            [UIView transitionWithView:self.infoView duration:0.3 
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{ 
                                if (self.caseInfo != nil && self.caseInfo.isuploaded.boolValue == NO) {
                                    [self.uiButtonEdit setHidden:NO];
                                    [self.uiButtonEdit setAlpha:1.0];
                                } else {
                                    [self.uiButtonEdit setHidden:YES];
                                    [self.uiButtonEdit setAlpha:0.0];
                                }
                                [self.uiButtonPickFromLibrary setAlpha:0.0];
                                [self.uiButtonCamera setAlpha:0.0];
                                [self.infoView addSubview:self.inquireInfoBriefVC.view];
                            } 
                            completion:^(BOOL finished){
                                [self.uiButtonCamera setHidden:YES];
                                [self.uiButtonPickFromLibrary setHidden:YES];
                            }];
            [self.inquireInfoBriefVC loadInquireInfoForCase:self.caseID forInquire:@""];
        }
            break;
        //现场勘验图    
        case 4:{
            self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
            self.paintBriefVC.caseID = self.caseID;
            [UIView transitionWithView:self.infoView duration:0.3 
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{ 
                                if (self.caseInfo != nil && self.caseInfo.isuploaded.boolValue == NO) {
                                    [self.uiButtonEdit setHidden:NO];
                                    [self.uiButtonEdit setAlpha:1.0];
                                } else {
                                    [self.uiButtonEdit setHidden:YES];
                                    [self.uiButtonEdit setAlpha:0.0];
                                }
                                [self.uiButtonPickFromLibrary setAlpha:0.0];
                                [self.uiButtonCamera setAlpha:0.0];
                                [self.infoView addSubview:self.paintBriefVC.view];
                            } 
                            completion:^(BOOL finished){
                                [self.uiButtonCamera setHidden:YES];
                                [self.uiButtonPickFromLibrary setHidden:YES];
                            }];
        }
            break;
        //现场照片
        case 5:{
            [self.infoView setContentOffset:CGPointMake(SCROLLVIEW_WIDTH, 0) animated:NO];
            [UIView transitionWithView:self.infoView duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [self.infoView addSubview:self.leftImageView];
                                [self.infoView addSubview:self.midImageView];
                                [self.infoView addSubview:self.rightImageView];
                                LOADPHOTOS;
                                self.leftImageView.image = [self cachePhotoForIndex:self.imageIndex-1];
                                self.midImageView.image = [self cachePhotoForIndex:self.imageIndex];
                                self.rightImageView.image = [self cachePhotoForIndex:self.imageIndex+1];
                                [self.uiButtonEdit setAlpha:0.0];
                                
                                if (self.caseInfo != nil && self.caseInfo.isuploaded.boolValue == NO) {
                                    [self.uiButtonCamera setHidden:NO];
                                    [self.uiButtonCamera setAlpha:1.0];
                                    [self.uiButtonPickFromLibrary setHidden:NO];
                                    [self.uiButtonPickFromLibrary setAlpha:1.0];
                                } else {
                                    [self.uiButtonCamera setHidden:YES];
                                    [self.uiButtonCamera setAlpha:0.0];
                                    [self.uiButtonPickFromLibrary setHidden:YES];
                                    [self.uiButtonPickFromLibrary setAlpha:0.0];
                                }
                                
                            }
                            completion:^(BOOL finished){
                                [self.uiButtonEdit setHidden:YES];
                                UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showDeleteMenu:)];
                                [self.infoView addGestureRecognizer:longPressGesture];
                            }];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideLabelWithAnimation) userInfo:nil repeats:NO];
        }
            break;
        default:
            break;
    } 
}


//显示各信息详细编辑页面按钮
- (IBAction)btnClickToEditor:(id)sender {
    [[AppDelegate App]saveContext];
    switch ([self.segInfoPage selectedSegmentIndex]) {
        case 2:
            [self performSegueWithIdentifier:@"toDeformInfoEditor" sender:self];
            break;
        case 3:
            [self performSegueWithIdentifier:@"toInquireInfoEditor" sender:self];
            break;
        case 4:
            [self performSegueWithIdentifier:@"toPaintEditor" sender:self];
        default:
            break;
    }
}

//新增案件按钮
- (IBAction)btnNewCase:(id)sender;{
    NSString *caseIDString = [NSString randomID];
    self.caseID = caseIDString;
    self.caseInfo=nil;
    [self.photoArray removeAllObjects];
    self.roadSegmentID=@"";
    self.photoPath = nil;
    self.imageIndex = 0;
    self.docListArray = nil;
    [self.docListView reloadData];
    
    self.caseInfo=[CaseInfo newDataObject];
    self.caseInfo.caseinfo_id = caseIDString;
    self.caseInfo.organization_id = [[NSUserDefaults standardUserDefaults] stringForKey:ORGKEY];
    self.caseInfo.isuploaded = @(NO);
    self.caseInfo.file_pre = [[OrgInfo orgInfoForOrgID:self.caseInfo.organization_id] valueForKey:@"file_pre"]?[[OrgInfo orgInfoForOrgID:self.caseInfo.organization_id] valueForKey:@"file_pre"]:@"";
    NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
    self.caseInfo.initialuser = currentUserID;
    self.caseInfo.record_date = [NSDate date];

    for (UITextField *text in [self.view subviews]) {
        if ([text isKindOfClass:[UITextField class]] && text.tag != kUITagTextFieldCasePrefix) {
            text.text=@"";
        }
    }
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *dateString=[dateFormatter stringFromDate:[NSDate date]];
    NSString *yearString=[dateString substringToIndex:4];
    self.textCasemark2.text=yearString;
    self.textHappenDate.text=dateString;    
    
    NSInteger caseMark3InCoreData = [CaseInfo maxCaseMark3];
    NSInteger caseMark3InDefaults=[[NSUserDefaults standardUserDefaults] stringForKey:@"CaseMark3"].integerValue;
    NSString *caseMark3 = [[NSString alloc] initWithFormat:@"%d",MAX(caseMark3InDefaults, caseMark3InCoreData)+1];
    NSString *oldCaseMark2=[[NSUserDefaults standardUserDefaults] stringForKey:@"CaseMark2"];
    if (yearString.integerValue>oldCaseMark2.integerValue) {
        caseMark3=@"1";
        [[NSUserDefaults standardUserDefaults] setObject:yearString forKey:@"CaseMark2"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:yearString forKey:@"CaseMark2"];
    [[NSUserDefaults standardUserDefaults] setObject:caseMark3 forKey:@"CaseMark3"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.textCasemark3.text=caseMark3;
    
    [self.accInfoBriefVC newDataForCase:caseIDString];
    [self.citizenInfoBriefVC newDataForCase:caseIDString];
    [self.inquireInfoBriefVC newDataForCase:caseIDString];
    [self.paintBriefVC.Image setImage:nil];
    
    [self.segInfoPage setSelectedSegmentIndex:0];
    [self changeInfoPage:self.segInfoPage];
}

//弹出以往案件选择框
- (IBAction)btnPreviousCase:(id)sender {
    if ([self.caseListpopover isPopoverVisible]) {
        [self.caseListpopover dismissPopoverAnimated:YES];
    } else {
        CaseListViewController *caseListVC=[self.storyboard instantiateViewControllerWithIdentifier:@"CaseListView"]; 
        self.caseListpopover=[[UIPopoverController alloc] initWithContentViewController:caseListVC];
        caseListVC.delegate=self;
        caseListVC.myPopover=self.caseListpopover;
        [self.caseListpopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

//弹窗
- (void)pickerPresentForIndex:(NSInteger)iIndex fromRect:(CGRect)rect{
    if ((iIndex==touchedTag) && ([self.caseInfoPickerpopover isPopoverVisible])) {
        [self.caseInfoPickerpopover dismissPopoverAnimated:YES];
    } else {
        touchedTag=iIndex;
        CaseInfoPickerViewController *acPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"CaseInfoPicker"];
        acPicker.pickerType=iIndex;
        acPicker.delegate=self;
        self.caseInfoPickerpopover=[[UIPopoverController alloc] initWithContentViewController:acPicker];        
        switch (iIndex) {
            case 0:{
                [self.caseInfoPickerpopover setPopoverContentSize:CGSizeMake(140, 264)];
                [acPicker.tableView setFrame:CGRectMake(0, 0, 140, 264)];
            }    
                break;
            case 1:{
                [self.caseInfoPickerpopover setPopoverContentSize:CGSizeMake(170,308)];
                [acPicker.tableView setFrame:CGRectMake(0, 0, 170, 308)];
            }    
                break;
            case 2:{
                [self.caseInfoPickerpopover setPopoverContentSize:CGSizeMake(100, 176)];
                [acPicker.tableView setFrame:CGRectMake(0, 0, 100, 176)];
            }
                break;
            case 3:{
                [self.caseInfoPickerpopover setPopoverContentSize:CGSizeMake(180, 176)];
                [acPicker.tableView setFrame:CGRectMake(0, 0, 180, 176)];
            }
                break;
            default:
                break;
        }
        [self.caseInfoPickerpopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        acPicker.pickerPopover=self.caseInfoPickerpopover;
    }
}

//弹出天气选择框
- (IBAction)selectWeather:(id)sender {
    [self pickerPresentForIndex:0 fromRect:[(UITextField*)sender frame]];
}

//弹出案由选择
- (IBAction)selectCaseDesc:(id)sender {
    [self performSegueWithIdentifier:@"toCaseDescList" sender:self];
}

//弹出案件处理类型选择
- (IBAction)selectCaseProcessType:(id)sender {
    [self pickerPresentForIndex:3 fromRect:[(UITextField*)sender frame]];
}

//时间选择
- (IBAction)selectDateAndTime:(id)sender {
    [self performSegueWithIdentifier:@"toDateTimePicker" sender:self];
}

//保存案件信息按钮
- (IBAction)btnSaveCaseInfo:(id)sender {
    if (self.caseInfo != nil && self.caseInfo.isuploaded.boolValue == YES) {
        [self editWarning];
    } else {
        [self saveCaseInfo];
    }
}


- (void)saveCaseInfo{
    if (![self.textCasemark2.text isEmpty] && ![self.textCasemark3.text isEmpty]) {
        if ([self.caseID isEmpty] || self.caseInfo ==  nil) {
            NSString *caseIDString=[NSString randomID];
            self.caseID=caseIDString;
            self.caseInfo=[CaseInfo newDataObject];
            self.caseInfo.caseinfo_id = caseIDString;
            self.caseInfo.organization_id = [[NSUserDefaults standardUserDefaults] stringForKey:ORGKEY];
            self.caseInfo.isuploaded = @(NO);
            self.caseInfo.file_pre = [[OrgInfo orgInfoForOrgID:self.caseInfo.organization_id] valueForKey:@"file_pre"]?[[OrgInfo orgInfoForOrgID:self.caseInfo.organization_id] valueForKey:@"file_pre"]:@"";
            NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
            self.caseInfo.initialuser = currentUserID;
            self.caseInfo.record_date = [NSDate date];
        }
        if (!self.caseInfo.isuploaded.boolValue) {
            NSInteger caseMarkInText = self.textCasemark3.text.integerValue;
            NSInteger caseMark3InCoreData = [CaseInfo maxCaseMark3];
            NSInteger caseMark3InDefaults=[[NSUserDefaults standardUserDefaults] stringForKey:@"CaseMark3"].integerValue;
            if (caseMarkInText < caseMark3InDefaults && caseMarkInText > caseMark3InCoreData) {
                NSString *caseMark3 = [[NSString alloc] initWithFormat:@"%d",caseMarkInText];
                [[NSUserDefaults standardUserDefaults] setObject:caseMark3 forKey:@"CaseMark3"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            [self saveCaseInfoForCase:self.caseID];
        }
    }
}

//选择路段级路段号
- (IBAction)selectRoadSegmet:(UITextField *)sender {
    [self roadSegmentPickerPresentPickerState:kRoadSegment fromRect:sender.frame];
}

//选择方向
- (IBAction)selectRoadSide:(UITextField *)sender {
    [self roadSegmentPickerPresentPickerState:kRoadSide fromRect:sender.frame];
}

//选择位置
- (IBAction)selectRoadPlace:(UITextField *)sender {
    [self roadSegmentPickerPresentPickerState:kRoadPlace fromRect:sender.frame];
}

//路段选择弹窗
- (void)roadSegmentPickerPresentPickerState:(RoadSegmentPickerState)state fromRect:(CGRect)rect{
    if ((state==self.roadSegmentPickerState) && ([self.caseInfoPickerpopover isPopoverVisible])) {
        [self.caseInfoPickerpopover dismissPopoverAnimated:YES];
    } else {
        self.roadSegmentPickerState=state;
        RoadSegmentPickerViewController *icPicker=[[RoadSegmentPickerViewController alloc] initWithStyle:UITableViewStylePlain];
        icPicker.tableView.frame=CGRectMake(0, 0, 150, 243);
        icPicker.pickerState=state;
        icPicker.delegate=self;
        self.caseInfoPickerpopover=[[UIPopoverController alloc] initWithContentViewController:icPicker];
        [self.caseInfoPickerpopover setPopoverContentSize:CGSizeMake(150, 243)];
        [self.caseInfoPickerpopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        icPicker.pickerPopover=self.caseInfoPickerpopover;
    }
}

#pragma mark - CaseID Handler Delegate
//新打印文档后，重新载入文书列表
- (void)reloadDocuments{
    [self loadCaseDocList:self.caseID];
}

- (void)loadInquireForID:(NSString *)inquireID{
    [self.inquireInfoBriefVC loadInquireInfoForCase:self.caseID forInquire:inquireID];
}

//显示所选天气
- (void)setWeather:(NSString *)textWeather{
    self.textWeatheer.text=textWeather;
}

- (void)setCaseType:(NSString *)caseType{
    if ([caseType hasSuffix:@"（当场处罚）"]) {
        self.yesOrNoType = YES;
    } else {
        self.yesOrNoType = NO;
    }
    caseType = [caseType substringToIndex:1];
    if ([caseType isEqualToString:@"罚"]) {
        self.caseProcessType = 120;
    } else if ([caseType isEqualToString:@"赔"]){
        self.caseProcessType = 130;
    } else if ([caseType isEqualToString:@"强"]){
        self.caseProcessType = 140;
    }
    [self configureDocTemplatesArray];
    NSString *currentOrgID=[[NSUserDefaults standardUserDefaults] stringForKey:ORGKEY];
    NSString *filePre=[[OrgInfo orgInfoForOrgID:currentOrgID] valueForKey:@"file_pre"];
    filePre = [filePre stringByAppendingString:caseType];
    self.textCasePrefix.text = filePre;
}

#pragma mark - CaseIDHandler
//删除车辆信息时清空
- (void)clearCitizenInfo{
    self.textCitizenName.text=@"";
    [self.citizenInfoBriefVC newDataForCase:self.caseID];
}

//已立案件delegate，以设定所选案件的caseID，并载入相关数据，并切换到事故信息页面
- (void)setCaseIDdelegate:(NSString *)caseID{
    if (![self.caseID isEmpty]) {
        [self saveCaseInfo];
    }
    [self loadCaseInfoForCase:caseID];
    if (self.segInfoPage.selectedSegmentIndex!=0) {        
        for (UIView *view in self.infoView.subviews) {
            [view removeFromSuperview];
        }
        [self.labelPhotoIndex setAlpha:0.0];
        [self.labelPhotoIndex setHidden:YES];
        self.infoView.pagingEnabled=NO;
        self.infoView.delegate=nil;
        self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, ACCINFO_HEIGHT);
        [self.infoView setContentOffset:CGPointZero animated:NO];
        [UIView transitionWithView:self.infoView duration:0.4 
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{  
                            [self.uiButtonEdit setAlpha:0.0];
                            [self.infoView addSubview:self.accInfoBriefVC.view];
                            if (!self.uiButtonCamera.hidden) {
                                [self.uiButtonPickFromLibrary setAlpha:0.0];
                                [self.uiButtonCamera setAlpha:0.0];
                            }
                        }
                        completion:^(BOOL finished){
                            [self.uiButtonEdit setHidden:YES];
                            [self.uiButtonPickFromLibrary setHidden:YES];
                            [self.uiButtonCamera setHidden:YES];
                        }];
        [self.segInfoPage setSelectedSegmentIndex:0];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:self.textCitizenName];
    }
}

//显示所选时间
- (void)setDate:(NSString *)date{
    self.textHappenDate.text=date;
}

//为其他ViewController返回当前caseID
- (NSString *)getCaseIDdelegate{
    return self.caseID;
}


//返回当前选定车号
- (NSString *)getCitizenNameDelegate{
    if (self.textCitizenName.text != nil) {
        return self.textCitizenName.text;
    } else {
        return @"";
    }
}

//设定案由
- (void)setCaseDescDelegate:(NSString *)caseDesc{
    NSString *caseFullDesc = [@"涉嫌" stringByAppendingString:caseDesc];
    if (self.textCaseDesc.text == nil || [self.textCaseDesc.text isEmpty]) {
        self.textCaseDesc.text = caseFullDesc;
    } else {
        self.textCaseDesc.text = [self.textCaseDesc.text stringByAppendingFormat:@"；%@",caseFullDesc];
    }  
}

//进入新增询问笔录页面
- (void)pushInquireEditor{
    [self performSegueWithIdentifier:@"toInquireInfoEditor" sender:self];
}

//根据caseID删除以往案件
- (void)deleteCaseAllDataForCase:(NSString *)caseID{
    if ([self.caseID isEqualToString:caseID]) {
        self.caseID=@"";
        self.roadSegmentID=@"";
        self.yesOrNoType = NO;
        for (UITextField *text in [self.view subviews]) {
            if ([text isKindOfClass:[UITextField class]]) {
                text.text=@"";
            }
        }
        //初始化案件前缀
        NSString *currentOrgID=[[NSUserDefaults standardUserDefaults] stringForKey:ORGKEY];
        NSString *filePre=[[OrgInfo orgInfoForOrgID:currentOrgID] valueForKey:@"file_pre"];
        filePre=[filePre stringByAppendingFormat:@"赔"];
        self.textCasePrefix.text=filePre;
        self.caseProcessType = 130;
        self.yesOrNoType = NO;
        [self configureDocTemplatesArray];
        [self.accInfoBriefVC newDataForCase:@""];
        [self.citizenInfoBriefVC newDataForCase:@""];
        self.caseInfo=nil;
    }
    [CaseInfo deleteCaseInfoForID:caseID];
}

#pragma mark - RoadPickerDelegate
- (void)setRoad:(NSString *)aRoadID roadName:(NSString *)roadName{
    self.roadSegmentID=aRoadID;
    self.textRoadSegment.text=roadName;
}

- (void)setRoadPlace:(NSString *)place{
    self.textPlace.text=place;
}

- (void)setRoadSide:(NSString *)side{
    self.textSide.text=side;
}

#pragma mark - ReloadPaintDelegate
- (void)reloadPaint{
    if (self.segInfoPage.selectedSegmentIndex == 4) {
        [self.paintBriefVC loadCasePaint];
    }
}

#pragma mark - keyboard show&hide events
//左下输入框delegate，设定scrollview需要上移
- (void)scrollViewNeedsMove{
    self.needsMove=YES;
}

//软键盘隐藏，恢复左下scrollview位置
- (void)keyboardWillHide:(NSNotification *)aNotification{
    if (self.needsMove) {        
        NSDictionary* userInfo = [aNotification userInfo];
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];


        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];

        [self.infoView setFrame:CGRectMake(self.infoView.frame.origin.x,302,self.infoView.frame.size.width,self.infoView.frame.size.height)];
        if (self.segInfoPage.selectedSegmentIndex==1) {
            self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, CITIZENINFO_HEIGHT);
        } else if (self.segInfoPage.selectedSegmentIndex == 0){
            self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, ACCINFO_HEIGHT);
        } else{
            self.infoView.contentSize=CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
        }        
        [self.view bringSubviewToFront:self.infoView];
        [UIView commitAnimations];
    }
}

//软键盘出现，上移scrollview至左上，防止编辑界面被阻挡
- (void)keyboardWillShow:(NSNotification *)aNotification{
    if (self.needsMove) {
        NSDictionary* userInfo = [aNotification userInfo];
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];

        CGRect keyboardEndFrame;
        [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];

        [self.infoView setFrame:CGRectMake(self.infoView.frame.origin.x,18,self.infoView.frame.size.width,self.infoView.frame.size.height)];
        CGSize tempSize;
        if (self.segInfoPage.selectedSegmentIndex==1) {
            tempSize=CGSizeMake(SCROLLVIEW_WIDTH, CITIZENINFO_HEIGHT);
        } else if (self.segInfoPage.selectedSegmentIndex == 0){
            tempSize=CGSizeMake(SCROLLVIEW_WIDTH, ACCINFO_HEIGHT);
        } else{
            tempSize=CGSizeMake(SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT);
        }
        tempSize=CGSizeMake(tempSize.width, keyboardEndFrame.size.width - (704 - 18 - self.infoView.frame.size.height) + tempSize.height);
        self.infoView.contentSize=tempSize;
        [self.view bringSubviewToFront:self.infoView];
        [UIView commitAnimations];
    }
}

//左上普通文本框点击时，scrollview不移动
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.needsMove=NO;
}


- (void)citizenNameChange{
    if (self.segInfoPage.selectedSegmentIndex == 1) {
        self.citizenInfoBriefVC.textParty.text = self.textCitizenName.text;
    }
}

#pragma mark - methods save&load
//根据caseID载入相应案件数据
- (void)loadCaseInfoForCase:(NSString *)caseID{
    self.caseInfo=nil;
    self.caseID=caseID;
    self.caseInfo = [CaseInfo caseInfoForID:caseID];
    if (self.caseInfo) {
        self.textCasemark2.text=self.caseInfo.case_mark2;
        self.textCasemark3.text=self.caseInfo.case_mark3;
        self.textWeatheer.text=self.caseInfo.weather;
        self.textRoadSegment.text=[Road roadNameFromID:self.caseInfo.roadsegment_id];
        self.roadSegmentID=self.caseInfo.roadsegment_id;
        self.textPlace.text=self.caseInfo.place;
        self.textSide.text=self.caseInfo.side;
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        self.textHappenDate.text=[formatter stringFromDate:self.caseInfo.happen_date];
        self.textStationStartKM.text=[NSString stringWithFormat:@"%d", self.caseInfo.station_start.integerValue/1000];
        self.textStationStartM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_start.integerValue%1000];
        self.textStationEndKM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_end.integerValue/1000];
        self.textStationEndM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_end.integerValue%1000];
        NSString *filePre=self.caseInfo.file_pre;
        NSString *caseType;
        switch (self.caseInfo.case_process_type.integerValue) {
            case 120:
                caseType = @"罚";
                break;
            case 130:
                caseType = @"赔";
                break;
            case 140:
                caseType = @"强";
                break;
            default:
                break;
        }
        filePre = [filePre stringByAppendingString:caseType];
        self.caseProcessType = self.caseInfo.case_process_type.integerValue;
        self.yesOrNoType = self.caseInfo.yesornotype.boolValue;
        [self configureDocTemplatesArray];
        self.textCasePrefix.text = filePre;
        
        self.textCaseDesc.text = self.caseInfo.casereason;
        self.textCitizenName.text = self.caseInfo.citizen_name;
    }
    [self loadCaseDocList:caseID];
    [self loadCasePhotoForCase:caseID];
    [self.accInfoBriefVC loadDataForCase:caseID];
    
}

//将当前页面显示数据保存至该caseID下
- (void)saveCaseInfoForCase:(NSString *)caseID{
    self.caseInfo.caseinfo_id=caseID;
    self.caseInfo.case_mark2=self.textCasemark2.text;
    self.caseInfo.case_mark3=self.textCasemark3.text;
    self.caseInfo.weather=self.textWeatheer.text;
    self.caseInfo.side=self.textSide.text;
    self.caseInfo.place=self.textPlace.text;
    self.caseInfo.roadsegment_id=self.roadSegmentID;
    self.caseInfo.station_start=[NSNumber numberWithInteger:(self.textStationStartKM.text.integerValue*1000+self.textStationStartM.text.integerValue)];
    self.caseInfo.station_end=[NSNumber numberWithInteger:(self.textStationEndKM.text.integerValue*1000+self.textStationEndM.text.integerValue)];
    if (self.caseInfo.station_end.integerValue == 0) {
        self.caseInfo.station_end = [self.caseInfo.station_start copy];
    }
    self.textStationStartKM.text=[NSString stringWithFormat:@"%d", self.caseInfo.station_start.integerValue/1000];
    self.textStationStartM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_start.integerValue%1000];
    self.textStationEndKM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_end.integerValue/1000];
    self.textStationEndM.text=[NSString stringWithFormat:@"%d",self.caseInfo.station_end.integerValue%1000];
    self.caseInfo.case_process_type = @(self.caseProcessType);
    self.caseInfo.yesornotype = @(self.yesOrNoType);
    self.caseInfo.casereason = self.textCaseDesc.text;
    self.caseInfo.citizen_name = self.textCitizenName.text;
    Citizen *citizen = [Citizen citizenForCase:self.caseID];
    if (citizen) {
        citizen.party = self.caseInfo.citizen_name;
    }
    NSInteger stationStartM=self.caseInfo.station_start.integerValue%1000;
    NSString *stationStartKMString=[NSString stringWithFormat:@"%d", self.caseInfo.station_start.integerValue/1000];
    NSString *stationStartMString=[NSString stringWithFormat:@"%03d",stationStartM];
    NSString *stationString;
    if (self.caseInfo.station_end.integerValue == 0 || self.caseInfo.station_end.integerValue == self.caseInfo.station_start.integerValue) {
        stationString=[NSString stringWithFormat:@"%@公里+%@米",stationStartKMString,stationStartMString];
    } else {
        NSInteger stationEndM=self.caseInfo.station_end.integerValue%1000;
        NSString *stationEndKMString=[NSString stringWithFormat:@"%d",self.caseInfo.station_end.integerValue/1000];
        NSString *stationEndMString=[NSString stringWithFormat:@"%03d",stationEndM];
        stationString=[NSString stringWithFormat:@"%@公里+%@米至%@公里+%@米",stationStartKMString,stationStartMString,stationEndKMString,stationEndMString ];
    }
    NSString *roadName=[Road roadNameFromID:self.caseInfo.roadsegment_id];
    self.caseInfo.case_address=[NSString stringWithFormat:@"%@%@%@%@",roadName,self.caseInfo.side,stationString,self.caseInfo.place];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    if ([self.textHappenDate.text isEmpty] || self.textHappenDate.text == nil) {
        self.caseInfo.happen_date = [NSDate date];
        self.textHappenDate.text = [formatter stringFromDate:self.caseInfo.happen_date];
    } else {
        self.caseInfo.happen_date=[formatter dateFromString:self.textHappenDate.text];
    }
    [[AppDelegate App] saveContext];
    [CasePhoto upDatePhotoInfoForCase:caseID];
    [CaseMap upDateMapInfoForCase:caseID];
    switch (self.segInfoPage.selectedSegmentIndex) {
        case 0:
            [self.accInfoBriefVC saveDataForCase:caseID];
            break;
        case 1:
            [self.citizenInfoBriefVC saveCitizenInfoForCase:caseID];
            break;
        default:
            break;
    }  
}

//载入案件已生成文书信息
- (void)loadCaseDocList:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseDocuments" inManagedObjectContext:context];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id==%@",self.caseID];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    NSArray *temp=[context executeFetchRequest:fetchRequest error:nil];
    self.docListArray=[temp valueForKeyPath:@"@distinctUnionOfObjects.document_name"];
    [self.docListView reloadData];
}

//载入案件对应的照片
- (void)loadCasePhotoForCase:(NSString *)caseID{
    [self.photoArray removeAllObjects];
    NSArray *tempArray=[CasePhoto casePhotosForCase:caseID];
    self.photoArray=[(NSArray *)[tempArray valueForKeyPath:@"photo_name"] mutableCopy];
    NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath=[pathArray objectAtIndex:0];
    NSString *photoPath=[NSString stringWithFormat:@"CasePhoto/%@",caseID];
    self.photoPath=[documentPath stringByAppendingPathComponent:photoPath];
    self.imageIndex=0;
}


#pragma mark - Photo
- (IBAction)btnImageFromCamera:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self pickPhoto:UIImagePickerControllerSourceTypeCamera];
    }
}

- (IBAction)btnImageFromLibrary:(id)sender {
    [self pickPhoto:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)pickPhoto:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.delegate=self;
    picker.sourceType=sourceType;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;

    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self presentModalViewController:picker animated:YES];
    } else if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        self.caseInfoPickerpopover = popover;
        CGRect infoCenter=CGRectMake(self.infoView.center.x-5, self.infoView.center.y-5, 10, 10);
        [self.caseInfoPickerpopover presentPopoverFromRect:infoCenter  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if (![self.caseID isEmpty]) {
        dispatch_queue_t myqueue=dispatch_queue_create("PhotoSave", nil);
        dispatch_async(myqueue, ^(void){
            UIImage *photo=[info objectForKey:UIImagePickerControllerOriginalImage];
            if ([self.photoPath isEmpty] || self.photoPath == nil) {
                NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentPath=[pathArray objectAtIndex:0];
                NSString *photoPath=[NSString stringWithFormat:@"CasePhoto/%@",self.caseID];
                self.photoPath=[documentPath stringByAppendingPathComponent:photoPath];
            }
            if (![[NSFileManager defaultManager] fileExistsAtPath:self.photoPath]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:self.photoPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString *photoName;
            if (self.photoArray.count==0) {
                photoName=@"1.jpg";
            } else {
                NSInteger photoNumber=[[self.photoArray valueForKeyPath:@"@max.integerValue"] integerValue]+1;
                photoName=[[NSString alloc] initWithFormat:@"%d.jpg",photoNumber];
            }
            NSString *filePath=[self.photoPath stringByAppendingPathComponent:photoName];
            NSData *photoData=UIImageJPEGRepresentation(photo, 0.8);
            if ([photoData writeToFile:filePath atomically:YES]) {
                NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
                NSEntityDescription *entity=[NSEntityDescription entityForName:@"CasePhoto" inManagedObjectContext:context];
                CasePhoto *newPhoto=[[CasePhoto alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
                NSString *codeString = @"";
                switch (self.caseInfo.case_process_type.integerValue) {
                    case 120:
                        codeString = @"罚";
                        break;
                    case 130:
                        codeString = @"赔";
                        break;
                    case 140:
                        codeString = @"强";
                        break;
                    default:
                        break;
                }
                NSString *caseCodeFormat = [self.caseInfo caseCodeFormat];
                codeString = [[NSString alloc] initWithFormat:caseCodeFormat,codeString];
                newPhoto.case_code = codeString;
                newPhoto.citizen_party = self.caseInfo.citizen_name;
                newPhoto.caseinfo_id=self.caseID;
                newPhoto.photo_name=photoName;
                newPhoto.isuploaded = @(NO);
                [[AppDelegate App] saveContext];
                [self.photoArray insertObject:photoName atIndex:self.imageIndex];
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    LOADPHOTOS;
                    self.leftImageView.image = [self cachePhotoForIndex:self.imageIndex-1];
                    self.midImageView.image = [self cachePhotoForIndex:self.imageIndex];
                    self.rightImageView.image = [self cachePhotoForIndex:self.imageIndex+1];
                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideLabelWithAnimation) userInfo:nil repeats:NO];
                });
            }
        });
        dispatch_release(myqueue);
    }
    if ([self.caseInfoPickerpopover isPopoverVisible]) {
        [self.caseInfoPickerpopover dismissPopoverAnimated:YES];
    } else {
        [picker dismissModalViewControllerAnimated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if ([self.caseInfoPickerpopover isPopoverVisible]) {
        [self.caseInfoPickerpopover dismissPopoverAnimated:YES];
    } else {
        [picker dismissModalViewControllerAnimated:YES];
    }
}

//显示删除标签
- (void)showDeleteMenu:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (self.caseInfo.isuploaded.boolValue == NO) {
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            if (self.photoArray.count > 0) {
                UIMenuController *menuController = [UIMenuController sharedMenuController];
                UIMenuItem *deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deletePiece:)];
                [self becomeFirstResponder];
                [menuController setMenuItems:@[deleteMenuItem]];
                [menuController setTargetRect:CGRectMake(self.infoView.frame.origin.x + SCROLLVIEW_WIDTH/2, self.infoView.frame.origin.y + SCROLLVIEW_HEIGHT/2, 0, 0) inView:self.view];
                [menuController setMenuVisible:YES animated:YES];
            }
        }
    }
}

//删除对应照片
- (void)deletePiece:(UIMenuController *)controller
{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (!caseInfo.isuploaded.boolValue) {
        NSString *photoName = [self.photoArray objectAtIndex:self.imageIndex];
        [CasePhoto deletePhotoForCase:self.caseID photoName:photoName];
        NSString *photoPath = [self.photoPath stringByAppendingPathComponent:photoName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:photoPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:photoPath error:nil];
        }
        [self.photoArray removeObjectAtIndex:self.imageIndex];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            LOADPHOTOS;
            self.leftImageView.image = [self cachePhotoForIndex:self.imageIndex-1];
            self.midImageView.image = [self cachePhotoForIndex:self.imageIndex];
            self.rightImageView.image = [self cachePhotoForIndex:self.imageIndex+1];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideLabelWithAnimation) userInfo:nil repeats:NO];
        });
    }
}

- (UIImage *)cachePhotoForIndex:(NSInteger)index{
    if (self.photoArray.count>0) {
        NSString *photoPath;
        if (index<0) {
            photoPath=[self.photoPath stringByAppendingPathComponent:[self.photoArray lastObject]];
        } else if (index>(self.photoArray.count-1)) {
            photoPath=[self.photoPath stringByAppendingPathComponent:[self.photoArray objectAtIndex:0]];
        } else {
            photoPath=[self.photoPath stringByAppendingPathComponent:[self.photoArray objectAtIndex:index]];
        }
        
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:photoPath];
        CGImageRef imageRef = [image CGImage];
        CGRect rect = CGRectMake(0.f, 0.f, SCROLLVIEW_HEIGHT/3*4, SCROLLVIEW_HEIGHT);
        CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                           rect.size.width,
                                                           rect.size.height,
                                                           CGImageGetBitsPerComponent(imageRef),
                                                           CGImageGetBytesPerRow(imageRef),
                                                           CGImageGetColorSpace(imageRef),
                                                           kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little
                                                           );
        
        CGContextDrawImage(bitmapContext, rect, imageRef);
        CGImageRef compressedImageRef = CGBitmapContextCreateImage(bitmapContext);
        UIImage* compressedImage = [[UIImage alloc] initWithCGImage: compressedImageRef];
        CGImageRelease(compressedImageRef);
        CGContextRelease(bitmapContext);        
        return compressedImage;
    } else {
        return nil;
    }
}


#pragma mark -UIScrollViewDelegate

#define SET_FRAME(IMAGE) x = IMAGE.frame.origin.x + increase;\
                            if(x < 0) x = pageWidth * 2;\
                            if(x > pageWidth * 2) x = 0.0f;\
                            [IMAGE setFrame:CGRectMake(x, \
                                    IMAGE.frame.origin.y,\
                                    IMAGE.frame.size.width,\
                                    IMAGE.frame.size.height)]
//将三个view都向右移动，并更新三个指针的指向
- (void)allImagesMoveRight:(CGFloat)pageWidth {
    //上一篇
    self.rightImageView.image = [self cachePhotoForIndex:self.imageIndex - 1];
	
    float increase = pageWidth;
    CGFloat x = 0.0f;
    SET_FRAME(self.rightImageView);
    SET_FRAME(self.leftImageView);
    SET_FRAME(self.midImageView);
    
    UIImageView *tempView = self.rightImageView;
    self.rightImageView = self.midImageView;
    self.midImageView = self.leftImageView;
    self.leftImageView = tempView;
}

- (void)allImagesMoveLeft:(CGFloat)pageWidth {
    self.leftImageView.image = [self cachePhotoForIndex:self.imageIndex + 1];
	
    float increase = -pageWidth;
    CGFloat x = 0.0f;
    SET_FRAME(self.midImageView);
    SET_FRAME(self.rightImageView);
    SET_FRAME(self.leftImageView);
    
    UIImageView *tempView = self.leftImageView;
    self.leftImageView = self.midImageView;
    self.midImageView = self.rightImageView;
    self.rightImageView = tempView;
}


//实现照片的循环和载入
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.infoView]) {        
        CGFloat pageWidth= WIDTH_OFF_SET;
        // 0 1 2
        int page = floor((self.infoView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        if(page == 1) {
            //用户拖动了，但是滚动事件没有生效
        } else if (page == 0) {
            [self allImagesMoveRight:pageWidth];
            self.imageIndex--;
        } else {
            [self allImagesMoveLeft:pageWidth];
            self.imageIndex++;
        }
        if (self.imageIndex<0) {
            self.imageIndex=self.photoArray.count-1;
        } else if (self.imageIndex>(self.photoArray.count-1)) {
            self.imageIndex=0;
        }
        [UIView transitionWithView:self.infoView
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            LOADPHOTOS;
                        }
                        completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideLabelWithAnimation) userInfo:nil repeats:NO];
        [scrollView setContentOffset:CGPointMake(SCROLLVIEW_WIDTH, 0) animated:NO];
        self.leftImageView.image = [self cachePhotoForIndex:self.imageIndex - 1];
        self.rightImageView.image = [self cachePhotoForIndex:self.imageIndex + 1];
    }
}

//照片序号标签的消失动画
- (void)hideLabelWithAnimation {    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         [self.labelPhotoIndex setAlpha:0.0];
                     }
                     completion:^(BOOL finished){ self.labelPhotoIndex.hidden=YES;}];
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

#pragma mark - Private Methods

- (void)assignUITags
{
    self.textCasemark2.tag          =   kUITagTextFieldCasemark2;
    self.textCasemark3.tag          =   kUITagTextFieldCasemark3;
    self.textHappenDate.tag         =   kUITagTextFieldHappenDate;
    self.textRoadSegment.tag        =   kUITagTextFieldRoadSegment;
    self.textSide.tag               =   kUITagTextFieldSide;
    self.textPlace.tag              =   kUITagTextFieldPlace;
    self.textWeatheer.tag           =   kUITagTextFieldWeather;
    self.textStationStartKM.tag     =   kUITagTextFieldStationStartKM;
    self.textStationStartM.tag      =   kUITagTextFieldStationStartM;
    self.textStationEndKM.tag       =   kUITagTextFieldStationEndKM;
    self.textStationEndM.tag        =   kUITagTextFieldStationEndM;
    self.textCitizenName.tag        =   kUITagTextFieldCitizenName;
    self.textCaseDesc.tag           =   kUITagTextFieldCaseDesc;
    self.textCasePrefix.tag         =   kUITagTextFieldCasePrefix;
    
    self.docListView.tag            =   kUITagTableViewDocList;
    self.docTemplatesView.tag       =   kUITagTableViewTemplates;
}
 
@end
