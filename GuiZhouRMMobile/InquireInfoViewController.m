//
//  InquireInfoViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InquireInfoViewController.h"
#import "Systype.h"
#import "Road.h"
#import "Citizen.h"
#import "UserInfo.h"
#import "EmployeeInfo.h"
#import "OrgInfo.h"

@interface InquireInfoViewController (){
    //判断当前信息是否保存
    bool inquireSaved;
    //位置字符串
    NSString *localityString;
}
//所选问题的标识
@property (nonatomic,copy)   NSString *askID;
@property (nonatomic,retain) NSMutableArray *caseInfoArray;
@property (nonatomic,retain) UIPopoverController *pickerPopOver;
@property (nonatomic,assign) BOOL isStartDate;

-(void)loadCaseInfoArray;
-(void)keyboardWillShow:(NSNotification *)aNotification;
-(void)keyboardWillHide:(NSNotification *)aNotification;
-(void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up;
-(void)insertString:(NSString *)insertingString intoTextView:(UITextView *)textView;
-(NSString *)getEventDesc;
@end

@implementation InquireInfoViewController

@synthesize uiButtonAdd = _uiButtonAdd;
@synthesize inquireTextView = _inquireTextView;
@synthesize textNexus = _textNexus;
@synthesize textParty = _textParty;
@synthesize textLocality = _textLocality;
@synthesize textInquireDate = _textInquireDate;
@synthesize caseInfoListView = _caseInfoListView;
@synthesize caseID = _caseID;
@synthesize caseInfoArray =  _caseInfoArray;
@synthesize pickerPopOver = _pickerPopOver;
@synthesize askID = _askID;
@synthesize inquireID = _inquireID;
@synthesize delegate = _delegate;
@synthesize isStartDate = _isStartDate;

- (void)viewDidLoad
{
    self.askID=@"";
    self.textNexus.text=@"当事人";
    
    NSString *imagePath=[[NSBundle mainBundle] pathForResource:@"询问笔录-bg" ofType:@"png"];
    self.view.layer.contents=(id)[[UIImage imageWithContentsOfFile:imagePath] CGImage];
    
    //监视键盘出现和隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.inquireTextView addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    
    //生成常见案件信息答案
    [self loadCaseInfoArray];
    
    //载入询问笔录
    [self loadInquireInfoForCase:self.caseID forInquire:self.inquireID];
    [super viewDidLoad];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.inquireTextView removeObserver:self forKeyPath:@"text"];
    if ([self.pickerPopOver isPopoverVisible]) {
        [self.pickerPopOver dismissPopoverAnimated:animated];
    }
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setCaseID:nil];
    [self setCaseInfoArray:nil];
    [self setInquireTextView:nil];
    [self setAskID:nil];
    [self setTextNexus:nil];
    [self setTextParty:nil];
    [self setTextLocality:nil];
    [self setTextInquireDate:nil];
    [self setUiButtonAdd:nil];
    [self setCaseInfoListView:nil];
    [self setDelegate:nil];
    [self setInquireID:nil];
    [self setTextOrgDuty:nil];
    [self setTextEndDate:nil];
    [self setSegSex:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


//添加常用问答
- (IBAction)btnAddRecord:(id)sender{
    [self pickerPresentForIndex:2 fromRect:[sender frame]];
}

//add by nx 2013.11.29
- (IBAction)btnAddInquireInfo:(id)sender {
    [self pickerPresentForIndex:4 fromRect:[sender frame]];
}


//返回按钮，若未保存，则提示
-(IBAction)btnDismiss:(id)sender{
    if (inquireSaved || [self.caseID isEmpty] || [self.textParty.text isEmpty]) {
        [self.delegate loadInquireForID:self.inquireID];
        [self dismissModalViewControllerAnimated:YES];
    } else {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前询问笔录已修改，尚未保存，是否返回？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];    
        [alert show];
    }    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self dismissModalViewControllerAnimated:YES];
    }
}


//键盘出现和消失时，变动TextView的大小
-(void)moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up{
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.inquireTextView.frame;
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    if (keyboardFrame.size.height>360) {
        newFrame.size.height = up?225:591;
    } else {
        newFrame.size.height =  up?279:591;
    }
    self.inquireTextView.frame = newFrame;
    
    [UIView commitAnimations];   
}

-(void)keyboardWillShow:(NSNotification *)aNotification{
    [self moveTextViewForKeyboard:aNotification up:YES];
}

-(void)keyboardWillHide:(NSNotification *)aNotification{
    [self moveTextViewForKeyboard:aNotification up:NO];
}

//保存当前询问笔录信息
-(IBAction)btnSave:(id)sender{
    [self saveInquireInfoForCase:self.caseID forInquire:self.inquireID];
}

- (void)loadInquireInfoForCase:(NSString *)caseID forInquire:(NSString *)inquireID{
    if (![caseID isEmpty]) {
        if ([inquireID isEmpty]) {
            self.inquireID = @"";
            for (UITextField *textField in self.view.subviews) {
                if ([textField isMemberOfClass:[UITextField class]]) {
                    textField.text = @"";
                }
            }
            self.inquireTextView.text = @"";
            [self loadCaseInfoArray];
            if ([CaseInquire allInquireForCase:caseID].count == 0) {
                Citizen *citizen = [Citizen citizenForCase:caseID];
                if ([citizen.citizen_flag isEqualToString:@"单位"]) {
                    self.textParty.text = citizen.driver;
                    self.textNexus.text = @"驾驶员";
                } else if ([citizen.citizen_flag isEqualToString:@"个人"]){
                    self.textParty.text = citizen.party;
                    self.textNexus.text = @"当事人";
                }
                self.textOrgDuty.text = [NSString stringWithFormat:@"%@ %@",citizen.org_name?citizen.org_name:@"",citizen.profession?citizen.profession:@""];
                if ([citizen.sex isEqualToString:@"女"]) {
                    [self.segSex setSelectedSegmentIndex:1];
                } else {
                    [self.segSex setSelectedSegmentIndex:0];
                }
            }

            self.textLocality.text = localityString;
            
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[NSLocale currentLocale]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            self.textInquireDate.text = [dateFormatter stringFromDate:[NSDate date]];
            self.textEndDate.text = [dateFormatter stringFromDate:[NSDate date]];
            
            inquireSaved = NO;
        } else {
            CaseInquire *caseInquire = [CaseInquire inquirerForCase:caseID ForID:inquireID];
            if (caseInquire) {
                self.textParty.text=caseInquire.answerer_name;
                self.textNexus.text=caseInquire.relation;
                self.inquireTextView.text=caseInquire.inquiry_note;
                if ([caseInquire.locality isEmpty]) {
                    self.textLocality.text=localityString;
                } else {
                    self.textLocality.text=caseInquire.locality;
                }
                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                [dateFormatter setLocale:[NSLocale currentLocale]];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                self.textInquireDate.text=[dateFormatter stringFromDate:caseInquire.date_inquired_start];
                self.textEndDate.text = [dateFormatter stringFromDate:caseInquire.date_inquired_end];
                self.textOrgDuty.text = caseInquire.company_duty;
                if ([caseInquire.sex isEqualToString:@"女"]) {
                    [self.segSex setSelectedSegmentIndex:1];
                } else {
                    [self.segSex setSelectedSegmentIndex:0];
                }
                self.inquireID = caseInquire.myid;
            }
            inquireSaved = YES;
        }
    }    
}

- (void)saveInquireInfoForCase:(NSString *)caseID forInquire:(NSString *)inquireID{
    if (![caseID isEmpty]) {
        if (![self.textParty.text isEmpty]) {
            CaseInquire *caseInquire;
            if ([inquireID isEmpty]) {
                NSString *newID = [NSString randomID];
                NSManagedObjectContext *context = [[AppDelegate App] managedObjectContext];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"CaseInquire" inManagedObjectContext:context];
                caseInquire = [[CaseInquire alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
                caseInquire.myid = newID;
                caseInquire.caseinfo_id = caseID;
                self.inquireID = newID;
                caseInquire.edu_level = @"";
                caseInquire.inquired_times = @(1);
            } else {
                caseInquire = [CaseInquire inquirerForCase:caseID ForID:inquireID];
            }
            if (caseInquire) {
                NSString *currentUserID=[[NSUserDefaults standardUserDefaults] stringForKey:USERKEY];
                NSString *currentUserName=[[UserInfo userInfoForUserID:currentUserID] valueForKey:@"username"];
                NSArray *inspectorArray = [[NSUserDefaults standardUserDefaults] objectForKey:INSPECTORARRAYKEY];
                if (inspectorArray.count < 1) {
                    caseInquire.inquirer_name = currentUserName;
                    caseInquire.inquirer1_no = [EmployeeInfo enforceCodeForUserName:currentUserName];
                } else if (inspectorArray.count == 1){
                    caseInquire.inquirer_name = [inspectorArray objectAtIndex:0];
                    caseInquire.inquirer1_no = [EmployeeInfo enforceCodeForUserName:caseInquire.inquirer_name];
                } else {
                    caseInquire.inquirer_name = [inspectorArray objectAtIndex:0];
                    caseInquire.inquirer1_no = [EmployeeInfo enforceCodeForUserName:caseInquire.inquirer_name];
                    caseInquire.inquirer_name2 = [inspectorArray objectAtIndex:1];
                    caseInquire.inquirer2_no = [EmployeeInfo enforceCodeForUserName:caseInquire.inquirer_name2];
                }
                caseInquire.recorder_name = currentUserName;
                caseInquire.recorder_no = [EmployeeInfo enforceCodeForUserName:currentUserName];
                NSString *currentOrg=[[NSUserDefaults standardUserDefaults] stringForKey:ORGKEY];
                caseInquire.inquirer_org=[[OrgInfo orgInfoForOrgID:currentOrg] valueForKey:@"orgname"];
                
                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                [dateFormatter setLocale:[NSLocale currentLocale]];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                caseInquire.date_inquired_start=[dateFormatter dateFromString:self.textInquireDate.text];
                caseInquire.date_inquired_end = [dateFormatter dateFromString:self.textEndDate.text];
                caseInquire.company_duty = self.textOrgDuty.text;
                caseInquire.locality=self.textLocality.text;
                caseInquire.inquiry_note=self.inquireTextView.text;
                caseInquire.answerer_name = self.textParty.text;
                caseInquire.relation = self.textNexus.text;
                caseInquire.sex = self.segSex.selectedSegmentIndex == 0? @"男":@"女";
                caseInquire.company_duty = self.textOrgDuty.text;
                Citizen *citizen=[Citizen citizenForCase:caseID];
                if (citizen) {
                    if ([self.textParty.text isEqualToString:citizen.party]) {
                        caseInquire.age=citizen.age;
                        caseInquire.phone=citizen.tel_number;
                        caseInquire.postalcode=citizen.postalcode;
                        caseInquire.address=citizen.address;
                        caseInquire.id_card = citizen.identity_card;
                    }
                }
                [[AppDelegate App] saveContext];
                inquireSaved = YES;
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"被询问人不能为空！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

//文本框点击事件
- (IBAction)textTouched:(UITextField *)sender {
    switch (sender.tag) {
        case 102:{
            //被询问人类型
            [self pickerPresentForIndex:0 fromRect:sender.frame];
        }
            break;
        case 103:{
            //被询问人
            [self pickerPresentForIndex:1 fromRect:sender.frame];
        }
            break;
        case 104:{
            //询问地点
            if ([self.pickerPopOver isPopoverVisible]) {
                [self.pickerPopOver dismissPopoverAnimated:YES];
            }
        }
            break;
        case 105:{
            //询问开始时间
            if ([self.pickerPopOver isPopoverVisible]) {
                [self.pickerPopOver dismissPopoverAnimated:YES];
            } else {
                DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
                datePicker.delegate=self;
                datePicker.pickerType=1;
                datePicker.datePicker.maximumDate=[NSDate date];
                [datePicker showdate:self.textInquireDate.text];
                self.pickerPopOver=[[UIPopoverController alloc] initWithContentViewController:datePicker];
                [self.pickerPopOver presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                datePicker.dateselectPopover=self.pickerPopOver;
            }
            self.isStartDate = YES;
        }
            break;
        case 106:{
            //询问结束时间
            if ([self.pickerPopOver isPopoverVisible]) {
                [self.pickerPopOver dismissPopoverAnimated:YES];
            } else {
                DateSelectController *datePicker=[self.storyboard instantiateViewControllerWithIdentifier:@"datePicker"];
                datePicker.delegate=self;
                datePicker.pickerType=1;
                datePicker.datePicker.maximumDate=[NSDate date];
                [datePicker showdate:self.textEndDate.text];
                self.pickerPopOver=[[UIPopoverController alloc] initWithContentViewController:datePicker];
                [self.pickerPopOver presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
                datePicker.dateselectPopover=self.pickerPopOver;
            }
            self.isStartDate = NO;
        }
            break;
        default:
            break;
    }
}



//弹窗
-(void)pickerPresentForIndex:(NSInteger )pickerType fromRect:(CGRect)rect{
    if ([_pickerPopOver isPopoverVisible]) {
        [_pickerPopOver dismissPopoverAnimated:YES];
    } else {
        AnswererPickerViewController *pickerVC=[[AnswererPickerViewController alloc] initWithStyle:
                                                UITableViewStylePlain];
        pickerVC.pickerType=pickerType;
        pickerVC.delegate=self;
        self.pickerPopOver=[[UIPopoverController alloc] initWithContentViewController:pickerVC];
        if (pickerType == 0 || pickerType == 1 ) {
            pickerVC.tableView.frame=CGRectMake(0, 0, 140, 176);
            self.pickerPopOver.popoverContentSize=CGSizeMake(140, 176);
        } 
        if (pickerType == 2 || pickerType ==3) {
            pickerVC.tableView.frame=CGRectMake(0, 0, 388, 280);
            [pickerVC.tableView setRowHeight:70];
            self.pickerPopOver.popoverContentSize=CGSizeMake(388, 280);
        }
        if (pickerType == 4) {
            pickerVC.tableView.frame=CGRectMake(0, 0, 388, 280);
            [pickerVC.tableView setRowHeight:70];
            self.pickerPopOver.popoverContentSize=CGSizeMake(388, 280);
        }
        [_pickerPopOver presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        pickerVC.pickerPopover=self.pickerPopOver;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.caseInfoArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"CaseInfoAnswserCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text=[self.caseInfoArray objectAtIndex:indexPath.row];
    return cell;
}

//将选中的答案填到textfield和textview中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [self insertString:cell.textLabel.text intoTextView:self.inquireTextView];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//载入案件数据常用答案
-(void)loadCaseInfoArray{
    if (self.caseInfoArray==nil) {
        self.caseInfoArray=[[NSMutableArray alloc] initWithCapacity:1];
    } else {
        [self.caseInfoArray removeAllObjects];
    }    
    //事故信息
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    NSString *dateString;
    NSString *reasonString;
    if (caseInfo) {
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
        dateString=[formatter stringFromDate:caseInfo.happen_date];
        if (dateString) {
            [self.caseInfoArray addObject:dateString];
        }        
        NSNumberFormatter *numFormatter=[[NSNumberFormatter alloc] init];
        [numFormatter setPositiveFormat:@"000"];        
        NSInteger stationStartM=caseInfo.station_start.integerValue%1000;        
        NSString *stationStartKMString=[NSString stringWithFormat:@"%d", caseInfo.station_start.integerValue/1000];
        NSString *stationStartMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationStartM]];
        NSString *stationString;
        if (caseInfo.station_end.integerValue == 0 || caseInfo.station_end.integerValue == caseInfo.station_start.integerValue  ) {
            stationString=[NSString stringWithFormat:@"%@公里+%@米处",stationStartKMString,stationStartMString];
        } else {            
            NSInteger stationEndM=caseInfo.station_end.integerValue%1000;
            NSString *stationEndKMString=[NSString stringWithFormat:@"%d",caseInfo.station_end.integerValue/1000];
            NSString *stationEndMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationEndM]];
            stationString=[NSString stringWithFormat:@"%@公里+%@米至%@公里+%@米处",stationStartKMString,stationStartMString,stationEndKMString,stationEndMString ];
        }
        NSString *roadName=[Road roadNameFromID:caseInfo.roadsegment_id];

        localityString=[NSString stringWithFormat:@"%@%@%@",roadName,caseInfo.side,stationString];
        [self.caseInfoArray addObject:localityString];
        if (caseInfo.case_reason && ![caseInfo.case_reason isEmpty]) {
            reasonString=[NSString stringWithFormat:@"由于%@",caseInfo.case_reason];
            [self.caseInfoArray addObject:reasonString];
        }
    }
    
    //当事人信息
    Citizen *citizen = [Citizen citizenForCase:self.caseID];
    if (citizen) {
        [self.caseInfoArray addObject:citizen.party];
        if (citizen.driver && ![citizen.driver isEmpty]) {
            if (![citizen.driver isEqualToString:citizen.party]) {
                [self.caseInfoArray addObject:citizen.driver];
            }            
            if ([citizen.driver isEqualToString:self.textParty.text]) {
                NSString *eventDesc=[NSString stringWithFormat:@"我%@",[self getEventDesc]];
                [self.caseInfoArray addObject:eventDesc];
            } else {
                NSString *eventDesc=[citizen.driver stringByAppendingString:[self getEventDesc]];
                [self.caseInfoArray addObject:eventDesc];
            }
        }
        if (citizen.automobile_pattern && ![citizen.automobile_pattern isEmpty]) {
            [self.caseInfoArray addObject:citizen.automobile_pattern];
        }
        if (citizen.automobile_number && ![citizen.automobile_number isEmpty]) {
            [self.caseInfoArray addObject:citizen.automobile_number];
        }
        NSString *deformDesc=[self getDeformDesc];
        if (![deformDesc isEmpty] ) {
            [self.caseInfoArray addObject:deformDesc];
        }
    }
    [self.caseInfoListView reloadData];
}

- (NSString *)getEventDesc{
    CaseInfo *caseInfo=[CaseInfo caseInfoForID:self.caseID];
    NSString *roadName=[Road roadNameFromID:caseInfo.roadsegment_id];
    NSString *caseDescString=@"";
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    NSString *happenDate=[dateFormatter stringFromDate:caseInfo.happen_date];
    
    NSNumberFormatter *numFormatter=[[NSNumberFormatter alloc] init];
    [numFormatter setPositiveFormat:@"000"];        
    NSInteger stationStartM=caseInfo.station_start.integerValue%1000;        
    NSString *stationStartKMString=[NSString stringWithFormat:@"%d", caseInfo.station_start.integerValue/1000];
    NSString *stationStartMString=[numFormatter stringFromNumber:[NSNumber numberWithInteger:stationStartM]];
    NSString *stationString=[NSString stringWithFormat:@"%@公里+%@米处",stationStartKMString,stationStartMString];    
    Citizen *citizen = [Citizen citizenForCase:self.caseID];
    if (citizen) {
        caseDescString=[caseDescString stringByAppendingFormat:@"于%@驾驶%@%@行至%@%@%@在公路%@由于%@发生交通事故。",happenDate,citizen.automobile_number,citizen.automobile_pattern,roadName,caseInfo.side,stationString,caseInfo.place,caseInfo.case_reason];      
    }
    return caseDescString;
}

-(NSString *)getDeformDesc{
    NSString *deformString=@"";
    NSArray *deformArray=[CaseDeformation allDeformationsForCase:self.caseID];
    if (deformArray.count>0) {
        for (CaseDeformation *deform in deformArray) {
            NSString *roadSizeString=[deform.rasset_size stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([roadSizeString isEmpty]) {
                roadSizeString=@"";
            } else {
                roadSizeString=[NSString stringWithFormat:@"（%@）",roadSizeString];
            }
            NSString *remarkString=[deform.remark stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([remarkString isEmpty]) {
                remarkString=@"";
            } else {
                remarkString=[NSString stringWithFormat:@"（%@）",remarkString];
            }
            NSString *quantity=[[NSString alloc] initWithFormat:@"%.2f",deform.quantity.floatValue];
            NSCharacterSet *zeroSet=[NSCharacterSet characterSetWithCharactersInString:@".0"];
            quantity=[quantity stringByTrimmingTrailingCharactersInSet:zeroSet];
            deformString=[deformString stringByAppendingFormat:@"、%@%@%@%@%@",deform.roadasset_name,roadSizeString,quantity,deform.unit,remarkString];
        }
        NSCharacterSet *charSet=[NSCharacterSet characterSetWithCharactersInString:@"、"];
        deformString=[deformString stringByTrimmingCharactersInSet:charSet];
        Citizen *citzen = [Citizen citizenForCase:self.caseID];
        if (citzen) {
            NSString *partyName=citzen.driver==nil?@"":citzen.driver;
            deformString=[partyName stringByAppendingFormat:@"损坏路产：%@。",deformString];
        }
    } else {
        deformString=@"";
    }    
    return deformString;
}

//在光标位置插入文字
-(void)insertString:(NSString *)insertingString intoTextView:(UITextView *)textView  
{  
    NSRange range = textView.selectedRange;
    if (range.location != NSNotFound) {
        NSString * firstHalfString = [textView.text substringToIndex:range.location];
        NSString * secondHalfString = [textView.text substringFromIndex: range.location];
        textView.scrollEnabled = NO;  // turn off scrolling
        
        textView.text=[NSString stringWithFormat:@"%@%@%@",
                       firstHalfString,
                       insertingString,
                       secondHalfString
                       ];
        range.location += [insertingString length];
        textView.selectedRange = range;
        textView.scrollEnabled = YES;  // turn scrolling back on.
    } else {
        textView.text = insertingString;
        [textView becomeFirstResponder];
    }
}

-(void)setAnswerSentence:(NSString *)answerSentence{
    if ([self.inquireTextView.text isEmpty]) {
        self.inquireTextView.text = answerSentence;
    } else {
        [self insertString:@"\n" intoTextView:self.inquireTextView];
        [self insertString:[answerSentence stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]] intoTextView:self.inquireTextView];
    }
}

-(void)setAnswerSentenceUseMuban:(NSString *)answerSentence
{
    self.inquireTextView.text = answerSentence;
}


//delegate，返回caseID
-(NSString *)getCaseIDDelegate{
    return self.caseID;
}

//delegate，设置被询问人名称
-(void)setAnswererDelegate:(NSString *)aText{
    [self loadCaseInfoArray];
    if (!inquireSaved) {
        [self saveInquireInfoForCase:self.caseID forInquire:self.inquireID];
    }
    if ([aText isEqualToString:TitleForNewInquire]) {
        [self loadInquireInfoForCase:self.caseID forInquire:@""];
    } else {
        [self loadInquireInfoForCase:self.caseID forInquire:aText];
    }
}

//delegate，设置被询问人类型
-(void)setNexusDelegate:(NSString *)aText{
    self.textNexus.text=aText;
}

//设置询问时间
-(void)setDate:(NSString *)date{
    if (self.isStartDate) {
        self.textInquireDate.text=date;
    } else {
        self.textEndDate.text = date;
    }

}

//询问记录改变，保存标识设置为NO
-(void)textViewDidChange:(UITextView *)textView{
    inquireSaved=NO;
} 

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"text"]) {
        inquireSaved=NO;
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==105 || textField.tag==102 || textField.tag == 106) {
        return NO;
    } else {
        return YES;
    }
}
@end
