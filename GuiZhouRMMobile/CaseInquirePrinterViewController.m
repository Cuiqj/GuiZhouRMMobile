//
//  CaseInquirePrinterViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-8-9.
//  Copyright (c) 2012年 中交宇科 . All rights reserved.
//

#import "CaseInquirePrinterViewController.h"
#import "TBXML+TraverseAddition.h"

typedef enum _kUITextFieldTag {
    kUITextFieldTagBase = 0x21,
    kUITextFieldTagInquirer1Name,
    kUITextFieldTagInquirer1No,
    kUITextFieldTagInquirer2Name,
    kUITextFieldTagInquirer2No,
    kUITextFieldTagRecorderName,
    kUITextFieldTagRecorderNo
} kUITextFieldTag;

enum kPageInfo {
    kPageInfoFirstPage = 0,
    kPageInfoSucessivePage
};

static NSString * const xmlName = @"InquireTable";
static NSString * const secondPageXmlName = @"InquireTable2_new"; //该文件改用来作为第二页 | xushiwen | 2013.7.30

@interface CaseInquirePrinterViewController () 
@property (nonatomic, retain) CaseInquire *caseInquire;
@property (nonatomic, strong) NSArray *employeeNames;
@property (nonatomic, strong) NSArray *employeeDuties;
@property (nonatomic, strong) NSArray *employeeCodes;
@end


@implementation CaseInquirePrinterViewController
@synthesize caseID = _caseID;
@synthesize caseInquire = _caseInquire;
@synthesize textdate_inquired_start = _textdate_inquired_start;
@synthesize textdate_inquired_end = _textdate_inquired_end;
@synthesize textinquired_times = _textinquired_times;
@synthesize textlocality = _textlocality;
@synthesize textinquirer_name = _textinquirer_name;
@synthesize textinquirer_name2 = _textinquirer_name2;
@synthesize textrecorder_name = _textrecorder_name;
@synthesize textanswerer_name = _textanswerer_name;
@synthesize textrelation = _textrelation;
@synthesize textsex = _textsex;
@synthesize textage = _textage;
@synthesize textid_card = _textid_card;
@synthesize textcompany_duty = _textcompany_duty;
@synthesize textphone = _textphone;
@synthesize textpostalcode = _textpostalcode;
@synthesize textaddress = _textaddress;
@synthesize textinquiry_note = _textinquiry_note;
@synthesize textremark = _textremark;
@synthesize textedu_level = _textedu_level;
@synthesize textinquirer1_no = _textinquirer1_no;
@synthesize textinquirer2_no = _textinquirer2_no;
@synthesize textrecorder_no = _textrecorder_no;
@synthesize textinquirer_org = _textinquirer_org;

- (NSInteger)dataCount{
    return [CaseInquire allInquireForCase:self.caseID].count;
}

- (void)viewDidLoad
{
    [super setCaseID:self.caseID];
    CGRect viewFrame = CGRectMake(0.0, 0.0, VIEW_FRAME_WIDTH, VIEW_FRAME_HEIGHT);
    self.view.frame = viewFrame;
    if (![self.caseID isEmpty]) {
        [self LoadPaperSettings:xmlName];
        NSArray *inquireArray = [CaseInquire allInquireForCase:self.caseID];
        if (inquireArray.count > 0) {
            self.caseInquire = [inquireArray objectAtIndex:0];
            [self pageLoadInfo];
        } else {
            self.caseInquire = nil;
        }
    }    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.textinquirer_name.tag = kUITextFieldTagInquirer1Name;
    self.textinquirer1_no.tag = kUITextFieldTagInquirer1No;
    self.textinquirer_name2.tag = kUITextFieldTagInquirer2Name;
    self.textinquirer2_no.tag = kUITextFieldTagInquirer2No;
    self.textrecorder_name.tag = kUITextFieldTagRecorderName;
    self.textrecorder_no.tag = kUITextFieldTagRecorderNo;
    
    NSMutableArray *employeeNames = [NSMutableArray array];
    NSMutableArray *employeeDuties = [NSMutableArray array];
    NSMutableArray *employeeCodes = [NSMutableArray array];
    for (EmployeeInfo *employee in [EmployeeInfo allEmployeeInfo]) {
        [employeeNames addObject:employee.name];
        [employeeDuties addObject:[EmployeeInfo orgAndDutyForUserName:employee.name]];
        [employeeCodes addObject:[EmployeeInfo enforceCodeForUserName:employee.name]];
    }
    self.employeeNames = employeeNames;
    self.employeeDuties = employeeDuties;
    self.employeeCodes = employeeCodes;
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [self setTextInquireNames:nil];
    [self setTextInquireNos:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)initControlsInteraction
{
    CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
    if (caseInfo.isuploaded.boolValue) {
        [super initControlsInteraction];
    } else {
        setViewEnabled(self.textdate_inquired_start, NO);    // 开始时间
        setViewEnabled(self.textdate_inquired_end, NO);      // 结束时间
        setViewEnabled(self.textlocality, NO);               // 地点
        setViewEnabled(self.textanswerer_name, NO);          // 被询问人
        setViewEnabled(self.textsex, NO);                    // 性别
        setViewEnabled(self.textage, NO);                    // 年龄
        setViewEnabled(self.textcompany_duty, NO);           // 单位及职务
        setViewEnabled(self.textrelation, NO);               // 与案件关系
    }
}

-(NSURL *)toFullPDFWithPath:(NSString *)filePath{
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
        [self drawStaticTable:xmlName];
        [self drawDateTable:xmlName withDataModel:self.caseInquire];
        

        NSString *xmlString = [self xmlStringFromFile:xmlName];
        TBXML *tbxml = [TBXML newTBXMLWithXMLString:xmlString error:nil];
        TBXMLElement *root = tbxml.rootXMLElement;
        TBXMLElement *dataTable = [TBXML childElementNamed:@"DataTable" parentElement:root];
        if (dataTable) {
            //根据配置显示文字用Block
            void(^stringDrawWithXML)(NSString *,TBXMLElement *) = ^(NSString * contentString, TBXMLElement *rootElement){
                if (rootElement) {
                    CGFloat fontSize = 12;
                    TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:rootElement];
                    if (originInXML) {
                        CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]+prLeftMargin;
                        CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]+prTopMargin;
                        TBXMLElement *fontSizeInXML=[TBXML childElementNamed:@"fontSize" parentElement:rootElement];
                        if (fontSizeInXML) {
                            fontSize=[[TBXML textForElement:fontSizeInXML] floatValue];
                        }
                        UITextAlignment alignment = UITextAlignmentLeft;
                        TBXMLElement *alignmentInXML = [TBXML childElementNamed:@"alignment" parentElement:rootElement];
                        if (alignmentInXML) {
                            NSString *alignmentString = [TBXML textForElement:alignmentInXML];
                            alignmentString = [alignmentString lowercaseString];
                            if (![alignmentString isEmpty]) {
                                if ([alignmentString isEqualToString:@"center"]) {
                                    alignment = UITextAlignmentCenter;
                                } else if ([alignmentString isEqualToString:@"right"]){
                                    alignment = UITextAlignmentRight;
                                }
                            }
                        }
                        TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:rootElement];
                        if (sizeInXML) {
                            CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue;
                            CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue;
                            CGRect rect = CGRectMake(x, y, width, height);
                            UIFont *font = [UIFont fontWithName:FONT_FangSong size:fontSize];
                            [contentString alignWithVerticalCenterDrawInRect:rect withFont:font horizontalAlignment:alignment];
                        }
                    }
                }
            };
            @autoreleasepool {
                TBXMLElement *inquireNameInXML = [TBXML childElementNamed:@"InquirerName" parentElement:dataTable];
                NSString *inquireNames = @"";
                if (self.caseInquire.inquirer_name) {
                    if (self.caseInquire.inquirer_name2 && ![self.caseInquire.inquirer_name2 isEmpty]) {
                        inquireNames = [[NSString alloc] initWithFormat:@"%@、%@",self.caseInquire.inquirer_name,self.caseInquire.inquirer_name2];
                    } else {
                        inquireNames = [[NSString alloc] initWithFormat:@"%@",self.caseInquire.inquirer_name];
                    }
                }
                if (![inquireNames isEmpty]) {
                    stringDrawWithXML(inquireNames,inquireNameInXML);
                }
            }
            @autoreleasepool {
                TBXMLElement *inquireNOInXML = [TBXML childElementNamed:@"InquirerNo" parentElement:dataTable];
                NSString *inquireNos = @"";
                if (self.caseInquire.inquirer1_no) {
                    if (self.caseInquire.inquirer2_no && ![self.caseInquire.inquirer2_no isEmpty]) {
                        inquireNos = [[NSString alloc] initWithFormat:@"%@、%@",self.caseInquire.inquirer1_no,self.caseInquire.inquirer2_no];
                    } else {
                        inquireNos = [[NSString alloc] initWithFormat:@"%@",self.caseInquire.inquirer1_no];
                    }
                }
                if (![inquireNos isEmpty]) {
                    stringDrawWithXML(inquireNos,inquireNOInXML);
                }
            }
            TBXMLElement *inquiryNotePage1InXML = [TBXML childElementNamed:@"InquiryNote" parentElement:dataTable];
            if (inquiryNotePage1InXML) {
                CGFloat fontSize = 12;
                TBXMLElement *originInXML=[TBXML childElementNamed:@"origin" parentElement:inquiryNotePage1InXML];
                if (originInXML) {
                    CGFloat x=[[TBXML valueOfAttributeNamed:@"x" forElement:originInXML] floatValue]+prLeftMargin;
                    CGFloat y=[[TBXML valueOfAttributeNamed:@"y" forElement:originInXML] floatValue]+prTopMargin;
                    TBXMLElement *fontSizeInXML=[TBXML childElementNamed:@"fontSize" parentElement:inquiryNotePage1InXML];
                    if (fontSizeInXML) {
                        fontSize=[[TBXML textForElement:fontSizeInXML] floatValue];
                    }
                    UITextAlignment alignment = UITextAlignmentLeft;
                    TBXMLElement *alignmentInXML = [TBXML childElementNamed:@"alignment" parentElement:inquiryNotePage1InXML];
                    if (alignmentInXML) {
                        NSString *alignmentString = [TBXML textForElement:alignmentInXML];
                        alignmentString = [alignmentString lowercaseString];
                        if (![alignmentString isEmpty]) {
                            if ([alignmentString isEqualToString:@"center"]) {
                                alignment = UITextAlignmentCenter;
                            } else if ([alignmentString isEqualToString:@"right"]){
                                alignment = UITextAlignmentRight;
                            }
                        }
                    }
                    TBXMLElement *sizeInXML = [TBXML childElementNamed:@"size" parentElement:inquiryNotePage1InXML];
                    if (sizeInXML) {
                        CGFloat width = [TBXML valueOfAttributeNamed:@"width" forElement:sizeInXML].floatValue;
                        CGFloat height = [TBXML valueOfAttributeNamed:@"height" forElement:sizeInXML].floatValue;
                        CGRect page1Rect = CGRectMake(x, y, width, height);
                        UIFont *font = [UIFont fontWithName:FONT_FangSong size:fontSize];
                        
                        //默认无行高,直接画出
                        CGFloat lineHeight = 0;
                        TBXMLElement *lineHeightInXML = [TBXML childElementNamed:@"lineHeight" parentElement:inquiryNotePage1InXML];
                        if (lineHeightInXML) {
                            lineHeight = [TBXML textForElement:lineHeightInXML].floatValue;
                        }
                        
                        NSString *subTableXML = [self xmlStringFromFile:@"InquireSubTable"];
                        TBXML *subTbxml = [TBXML newTBXMLWithXMLString:subTableXML error:nil];
                        TBXMLElement *subRoot = subTbxml.rootXMLElement;
                        TBXMLElement *subDataTable = [TBXML childElementNamed:@"DataTable" parentElement:subRoot];
                        CGRect followPageRect = CGRectZero;
                        if (subDataTable) {
                            TBXMLElement *inquiryNoteFollowPageInXML = [TBXML childElementNamed:@"InquiryNote" parentElement:subDataTable];
                            if (inquiryNoteFollowPageInXML) {
                                TBXMLElement *subOrigin = [TBXML childElementNamed:@"origin" parentElement:inquiryNoteFollowPageInXML];
                                if (subOrigin) {
                                    CGFloat subX=[[TBXML valueOfAttributeNamed:@"x" forElement:subOrigin] floatValue]+prLeftMargin;
                                    CGFloat subY=[[TBXML valueOfAttributeNamed:@"y" forElement:subOrigin] floatValue]+prTopMargin;
                                    TBXMLElement *subSizeInXML = [TBXML childElementNamed:@"size" parentElement:inquiryNoteFollowPageInXML];
                                    if (sizeInXML) {
                                        CGFloat subWidth = [TBXML valueOfAttributeNamed:@"width" forElement:subSizeInXML].floatValue;
                                        CGFloat subHeight = [TBXML valueOfAttributeNamed:@"height" forElement:subSizeInXML].floatValue;
                                        followPageRect.origin.x = subX;
                                        followPageRect.origin.y = subY;
                                        followPageRect.size.width = subWidth;
                                        followPageRect.size.height = subHeight;
                                    }
                                }
                            }
                        }
                        TBXMLElement *sequenceNumberInPage1 = [TBXML childElementNamed:@"SequenceNumber" parentElement:dataTable];
                        TBXMLElement *pageNumberInPage1 = [TBXML childElementNamed:@"PageNumber" parentElement:dataTable];
                        TBXMLElement *pageNumberInFollowPage = [TBXML childElementNamed:@"PageNumber" parentElement:subDataTable];
                        TBXMLElement *sequenceNumberInFollowPage = [TBXML childElementNamed:@"SequenceNumber" parentElement:subDataTable];

                        if (followPageRect.size.width < 0.1 || followPageRect.size.height < 0.1) {
                            [self.caseInquire.inquiry_note drawMultiLineTextInRect:page1Rect withFont:font horizontalAlignment:alignment leftOffSet:0 lineHeight:lineHeight];

                            if (sequenceNumberInPage1) {
                                stringDrawWithXML(@"1", sequenceNumberInPage1);
                            }

                            if (pageNumberInPage1) {
                                stringDrawWithXML(@"1", pageNumberInPage1);
                            }
                        } else {
                            NSArray *pageArray = [self.caseInquire.inquiry_note pagesWithFont:font lineHeight:lineHeight horizontalAlignment:alignment page1Rect:page1Rect followPageRect:followPageRect];
                            NSString *totalPage = [[NSString alloc] initWithFormat:@"%d",pageArray.count];
                            for (int currentPage = 0; currentPage < pageArray.count; currentPage++) {
                                NSString *pageString = [pageArray objectAtIndex:currentPage];
                                NSString *sequenceNumber = [[NSString alloc] initWithFormat:@"%d", currentPage+1];
                                if (currentPage == 0) {
                                    [pageString drawMultiLineTextInRect:page1Rect withFont:font horizontalAlignment:alignment leftOffSet:0 lineHeight:lineHeight];
                                    stringDrawWithXML(totalPage, pageNumberInPage1);
                                    stringDrawWithXML(sequenceNumber, sequenceNumberInPage1);
                                } else {
                                    UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
                                    [self drawStaticTable:@"InquireSubTable"];
                                    [pageString drawMultiLineTextInRect:followPageRect withFont:font horizontalAlignment:alignment leftOffSet:0 lineHeight:lineHeight];
                                    stringDrawWithXML(totalPage, pageNumberInFollowPage);
                                    stringDrawWithXML(sequenceNumber, sequenceNumberInFollowPage);
                                }
                            }
                        }
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

- (void)pageLoadInfo{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.textdate_inquired_start.text = [dateFormatter stringFromDate:self.caseInquire.date_inquired_start];
    self.textdate_inquired_end.text = [dateFormatter stringFromDate:self.caseInquire.date_inquired_end];
    self.textinquired_times.text = [NSString stringWithFormat:@"%d",self.caseInquire.inquired_times.intValue];
    self.textlocality.text = self.caseInquire.locality;
    self.textinquirer_name.text = self.caseInquire.inquirer_name;
    self.textinquirer_name2.text = self.caseInquire.inquirer_name2;
    self.textrecorder_name.text = self.caseInquire.recorder_name;
    self.textanswerer_name.text = self.caseInquire.answerer_name;
    self.textrelation.text = self.caseInquire.relation;
    self.textsex.text = self.caseInquire.sex;
    self.textage.text = [NSString stringWithFormat:@"%d",self.caseInquire.age.intValue];
    self.textid_card.text = self.caseInquire.id_card;
    self.textcompany_duty.text = self.caseInquire.company_duty;
    self.textphone.text = self.caseInquire.phone;
    self.textpostalcode.text = self.caseInquire.postalcode;
    self.textaddress.text = self.caseInquire.address;
    self.textinquiry_note.text = self.caseInquire.inquiry_note;
    self.textremark.text = self.caseInquire.remark;
    self.textedu_level.text = self.caseInquire.edu_level;
    self.textinquirer1_no.text = self.caseInquire.inquirer1_no;
    self.textinquirer2_no.text = self.caseInquire.inquirer2_no;
    self.textrecorder_no.text = self.caseInquire.recorder_no;
    self.textinquirer_org.text = self.caseInquire.inquirer_org;
    
    NSString *inquireNames = @"";
    if (self.caseInquire.inquirer_name) {
        if (self.caseInquire.inquirer_name2 && ![self.caseInquire.inquirer_name2 isEmpty]) {
            inquireNames = [[NSString alloc] initWithFormat:@"%@、%@",self.caseInquire.inquirer_name,self.caseInquire.inquirer_name2];
        } else {
            inquireNames = [[NSString alloc] initWithFormat:@"%@",self.caseInquire.inquirer_name];
        }
    }
    self.textInquireNames.text = inquireNames;
    
    NSString *inquireNos = @"";
    if (self.caseInquire.inquirer1_no) {
        if (self.caseInquire.inquirer2_no && ![self.caseInquire.inquirer2_no isEmpty])  {
            inquireNos = [[NSString alloc] initWithFormat:@"%@、%@",self.caseInquire.inquirer1_no,self.caseInquire.inquirer2_no];
        } else {
            inquireNos = [[NSString alloc] initWithFormat:@"%@",self.caseInquire.inquirer1_no];
        }
    }
    self.textInquireNos.text = inquireNos;
    
}

- (void)pageSaveInfo{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    self.caseInquire.date_inquired_start = [dateFormatter dateFromString:self.textdate_inquired_start.text];
    self.caseInquire.date_inquired_end = [dateFormatter dateFromString:self.textdate_inquired_end.text];
    self.caseInquire.inquired_times = @(self.textinquired_times.text.integerValue);
    self.caseInquire.locality = self.textlocality.text;
    self.caseInquire.inquirer_name = self.textinquirer_name.text;
    self.caseInquire.inquirer_name2 = self.textinquirer_name2.text;
    self.caseInquire.recorder_name = self.textrecorder_name.text;
    self.caseInquire.answerer_name = self.textanswerer_name.text;
    self.caseInquire.relation = self.textrelation.text;
    self.caseInquire.sex = self.textsex.text;
    self.caseInquire.age = @(self.textage.text.integerValue);
    self.caseInquire.id_card = self.textid_card.text;
    self.caseInquire.company_duty = self.textcompany_duty.text;
    self.caseInquire.phone = self.textphone.text;
    self.caseInquire.postalcode = self.textpostalcode.text;
    self.caseInquire.address = self.textaddress.text;
    self.caseInquire.inquiry_note = self.textinquiry_note.text;
    self.caseInquire.remark = self.textremark.text;
    self.caseInquire.edu_level = self.textedu_level.text;
    self.caseInquire.inquirer1_no = self.textinquirer1_no.text;
    self.caseInquire.inquirer2_no = self.textinquirer2_no.text;
    self.caseInquire.recorder_no = self.textrecorder_no.text;
    self.caseInquire.inquirer_org = self.textinquirer_org.text;
	[[AppDelegate App] saveContext];
}

- (void)loadDataAtIndex:(NSInteger)index{
    [self pageSaveInfo];
    self.caseInquire = nil;
    self.caseInquire = [[CaseInquire allInquireForCase:self.caseID] objectAtIndex:index];
    [self pageLoadInfo];
}

- (BOOL)shouldDocDeleted{
    return NO;
}

- (BOOL)shouldGenereateDefaultDoc{
    return NO;
}


#pragma mark - Delegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case kUITextFieldTagInquirer1Name:
        case kUITextFieldTagInquirer2Name:
        case kUITextFieldTagRecorderName:
            [super presentPopverFrom:textField withDataSource:self.employeeNames];
            return NO;
            break;
        default:
            break;
    }
    return YES;
}

- (void)listSelect:(NormalListSelectController *)listSelectController selectedIndexPath:(NSIndexPath *)tableIndexPath
{
    if (self.popoverIndex == kUITextFieldTagInquirer1Name) {
        self.textinquirer_name.text = [self.employeeNames objectAtIndex:tableIndexPath.row];
        self.textinquirer1_no.text = [self.employeeCodes objectAtIndex:tableIndexPath.row];
    } else if (self.popoverIndex == kUITextFieldTagInquirer2Name) {
        self.textinquirer_name2.text = [self.employeeNames objectAtIndex:tableIndexPath.row];
        self.textinquirer2_no.text = [self.employeeCodes objectAtIndex:tableIndexPath.row];
    } else if (self.popoverIndex == kUITextFieldTagRecorderName) {
        self.textrecorder_name.text = [self.employeeNames objectAtIndex:tableIndexPath.row];
        self.textrecorder_no.text = [self.employeeCodes objectAtIndex:tableIndexPath.row];
    }
    [self dismissPopoverAnimated:YES];
}
-(NSURL *)toFormedPDFWithPath:(NSString *)filePath{
    if (!self.caseInquire) {
        return nil;
    }
    [self pageSaveInfo];
    if (![filePath isEmpty]) {
        NSString *formatFilePath = [NSString stringWithFormat:@"%@.format.pdf", filePath];
        CGRect pdfRect=CGRectMake(0.0, 0.0, paperWidth, paperHeight);
        UIGraphicsBeginPDFContextToFile(formatFilePath, CGRectZero, nil);
        NSArray *pages = [self pagesSplitted];
        NSMutableDictionary *dataInfo = [self getDataInfo];
        if ([pages count] < 2) {
            
            dataInfo[@"PageNumberInfo"][@"pageCount"][@"value"] = @([pages count]);
            dataInfo[@"PageNumberInfo"][@"pageNumber"][@"value"] = @([pages count]);
            
            UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
            [self drawDataTable:xmlName withDataInfo:dataInfo];
            
        } else {
            
            for (int i = [pages count] - 1 ; i >= kPageInfoFirstPage; i--) {
                //第i页
                dataInfo[@"CaseInquire"][@"inquiry_note"][@"value"] = pages[i];     //也会影响到dataInfo[@"Default"]对应的值
                dataInfo[@"PageNumberInfo"][@"pageCount"][@"value"] = @([pages count]);
                dataInfo[@"PageNumberInfo"][@"pageNumber"][@"value"] = @(i+1);
                
                UIGraphicsBeginPDFPageWithInfo(pdfRect, nil);
                if (i == kPageInfoFirstPage) {
                    [self drawDataTable:xmlName withDataInfo:dataInfo];
                } else {
                    [self drawDataTable:secondPageXmlName withDataInfo:dataInfo];
                }
            }
        }
        UIGraphicsEndPDFContext();
        return [NSURL fileURLWithPath:formatFilePath];
    } else {
        return nil;
    }
}

- (NSArray *)pagesSplitted {
    NSString *inquiryNote = self.caseInquire.inquiry_note;
    
    CGFloat fontSize1 = [self fontSizeInPage:kPageInfoFirstPage];
    CGFloat lineHeight1 = [self lineHeightInPage:kPageInfoFirstPage];
    UIFont *font1 = [UIFont fontWithName:FONT_FangSong size:fontSize1];
    CGRect page1Rect = [self rectInPage:kPageInfoFirstPage];
    
    CGFloat fontSize2 = [self fontSizeInPage:kPageInfoSucessivePage];
    CGFloat lineHeight2 = [self lineHeightInPage:kPageInfoSucessivePage];
    UIFont *font2 = [UIFont fontWithName:FONT_FangSong size:fontSize2];
    CGRect page2Rect = [self rectInPage:kPageInfoSucessivePage];
    
    NSArray *pages = [inquiryNote pagesWithFont:font1 lineHeight:lineHeight1 horizontalAlignment:UITextAlignmentLeft page1Rect:page1Rect followPageRect:page2Rect];
    
    if ([pages count] > 2) {
        NSString *textInFirstPage = pages[kPageInfoFirstPage];
        NSRange firstpageRange = NSMakeRange(0, [textInFirstPage length]);
        NSString *textInSuccessivePage = [inquiryNote stringByReplacingCharactersInRange:firstpageRange withString:@""];
        NSArray *successivePages = [textInSuccessivePage pagesWithFont:font2 lineHeight:lineHeight2 horizontalAlignment:UITextAlignmentLeft page1Rect:page2Rect followPageRect:page2Rect];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        [tempArr addObject:pages[kPageInfoFirstPage]];
        for (NSUInteger i = 0; i < [successivePages count]; i++) {
            [tempArr addObject:successivePages[i]];
        }
        pages = [tempArr copy];
    }
    return pages;
}

- (NSMutableDictionary *)getDataInfo{
    // dataInfo用法:
    // (1) id value = dataInfo[实体名][属性名][@"value"]
    // (2) NSAttributeDescription *desc = dataInfo[实体名][属性名][@"valueType"]
    // (3) dataInfo[@"Default"]针对XML中未指名实体的项
    NSMutableDictionary *dataInfo = [[NSMutableDictionary alloc] init];
    
    //将CaseInquire的属性名、属性值、属性描述装入dataInfo
    NSMutableDictionary *caseInquireDataInfo = [[NSMutableDictionary alloc] init];
    NSDictionary *caseInquireAttributes = [self.caseInquire.entity attributesByName];
    for (NSString *attribName in caseInquireAttributes.allKeys) {
        id attribValue = [self.caseInquire valueForKey:attribName];
        NSAttributeDescription *attribDesc = [caseInquireAttributes objectForKey:attribName];
        NSAttributeType attribType = attribDesc.attributeType;
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     attribValue,@"value",
                                     @(attribType),@"valueType",nil];
        [caseInquireDataInfo setObject:data forKey:attribName];
        
    }
    
    //将CaseInfo的属性名、属性值、属性描述装入dataInfo
    CaseInfo *relativeCaseInfo = [CaseInfo caseInfoForID:self.caseID];
    NSMutableDictionary *caseInfoDataInfo = [[NSMutableDictionary alloc] init];
    NSDictionary *caseInfoAttributes = [relativeCaseInfo.entity attributesByName];
    for (NSString *attribName in caseInfoAttributes.allKeys) {
        id attribValue = [relativeCaseInfo valueForKey:attribName];
        NSAttributeDescription *attribDesc = [caseInfoAttributes objectForKey:attribName];
        NSAttributeType attribType = attribDesc.attributeType;
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     attribValue,@"value",
                                     @(attribType),@"valueType",nil];
        [caseInfoDataInfo setObject:data forKey:attribName];
    }
    
    //设置一个Default（针对xml里没有entityName的节点），指向caseInquireDataInfo
    [dataInfo setObject:caseInquireDataInfo forKey:@"Default"];
    [dataInfo setObject:caseInquireDataInfo forKey:[self.caseInquire.entity name]];
    
    [dataInfo setObject:caseInfoDataInfo forKey:[relativeCaseInfo.entity name]];
    
    //预留页码位置
    NSMutableDictionary *pageCountInfo = [[NSMutableDictionary alloc] init];
    [pageCountInfo setObject:@(NSInteger32AttributeType) forKey:@"valueType"];
    NSMutableDictionary *pageNumberInfo = [[NSMutableDictionary alloc] init];
    [pageNumberInfo setObject:@(NSInteger32AttributeType) forKey:@"valueType"];
    [dataInfo setObject:[@{@"pageCount":pageCountInfo, @"pageNumber":pageNumberInfo} mutableCopy]
                 forKey:@"PageNumberInfo"];
    
    return dataInfo;
}
- (CGFloat)fontSizeInPage:(NSInteger)pageNo {
    NSString *xmlPathString = nil;
    if (pageNo == kPageInfoFirstPage) {
        xmlPathString = [super xmlStringFromFile:xmlName];
    } else if (pageNo >= kPageInfoSucessivePage) {
        xmlPathString = [super xmlStringFromFile:secondPageXmlName];
    }
    NSError *err;
    TBXML *xmlTree = [TBXML newTBXMLWithXMLString:xmlPathString error:&err];
    NSAssert(err==nil, @"Fail when creating TBXML object: %@", err.description);
    
    TBXMLElement *root = xmlTree.rootXMLElement;
    NSArray *elementsWrapped = [TBXML findElementsFrom:root byDotSeparatedPath:@"DataTable.UITextView" withPredicate:@"content.data.attributeName = inquiry_note"];
    NSAssert([elementsWrapped count]>0, @"Element not found.");
    
    NSValue *elementWrapped = elementsWrapped[0];
    TBXMLElement *inqurynoteElement = elementWrapped.pointerValue;
    
    TBXMLElement *fontSizeElement = [TBXML childElementNamed:@"fontSize" parentElement:inqurynoteElement error:&err];
    NSAssert(err==nil, @"Fail when looking up child element: %@", err.description);
    
    return [[TBXML textForElement:fontSizeElement] floatValue];
}
- (CGFloat)lineHeightInPage:(NSInteger)pageNo {
    NSString *xmlPathString = nil;
    if (pageNo == kPageInfoFirstPage) {
        xmlPathString = [super xmlStringFromFile:xmlName];
    } else if (pageNo >= kPageInfoSucessivePage) {
        xmlPathString = [super xmlStringFromFile:secondPageXmlName];
    }
    NSError *err;
    TBXML *xmlTree = [TBXML newTBXMLWithXMLString:xmlPathString error:&err];
    NSAssert(err==nil, @"Fail when creating TBXML object: %@", err.description);
    
    TBXMLElement *root = xmlTree.rootXMLElement;
    NSArray *elementsWrapped = [TBXML findElementsFrom:root byDotSeparatedPath:@"DataTable.UITextView" withPredicate:@"content.data.attributeName = inquiry_note"];
    NSAssert([elementsWrapped count]>0, @"Element not found.");
    
    NSValue *elementWrapped = elementsWrapped[0];
    TBXMLElement *inqurynoteElement = elementWrapped.pointerValue;
    
    TBXMLElement *lineHeightElement = [TBXML childElementNamed:@"lineHeight" parentElement:inqurynoteElement error:&err];
    NSAssert(err==nil, @"Fail when looking up child element: %@", err.description);
    
    return [[TBXML textForElement:lineHeightElement] floatValue];
}
- (CGRect)rectInPage:(NSInteger)pageNo {
    NSString *xmlPathString = nil;
    if (pageNo == kPageInfoFirstPage) {
        xmlPathString = [super xmlStringFromFile:xmlName];
    } else if (pageNo >= kPageInfoSucessivePage) {
        xmlPathString = [super xmlStringFromFile:secondPageXmlName];
    }
    NSError *err;
    TBXML *xmlTree = [TBXML newTBXMLWithXMLString:xmlPathString error:&err];
    NSAssert(err==nil, @"Fail when creating TBXML object: %@", err.description);
    
    TBXMLElement *root = xmlTree.rootXMLElement;
    NSArray *elementsWrapped = [TBXML findElementsFrom:root byDotSeparatedPath:@"DataTable.UITextView" withPredicate:@"content.data.attributeName = inquiry_note"];
    NSAssert([elementsWrapped count]>0, @"Element not found.");
    
    NSValue *elementWrapped = elementsWrapped[0];
    TBXMLElement *inqurynoteElement = elementWrapped.pointerValue;
    
    TBXMLElement *sizeElement = [TBXML childElementNamed:@"size" parentElement:inqurynoteElement error:&err];
    NSAssert(err==nil, @"Fail when looking up child element: %@", err.description);
    
    TBXMLElement *originElement = [TBXML childElementNamed:@"origin" parentElement:inqurynoteElement error:&err];
    NSAssert(err==nil, @"Fail when looking up child element: %@", err.description);
    
    NSAssert(sizeElement != nil && originElement != nil, @"Fail when looking up child element 'size' or 'origin'");
    
    CGFloat x = [[TBXML valueOfAttributeNamed:@"x" forElement:originElement] floatValue] * MMTOPIX * SCALEFACTOR;
    CGFloat y = [[TBXML valueOfAttributeNamed:@"y" forElement:originElement] floatValue] * MMTOPIX * SCALEFACTOR;
    CGFloat width = [[TBXML valueOfAttributeNamed:@"width" forElement:sizeElement] floatValue] * MMTOPIX * SCALEFACTOR;
    CGFloat height = [[TBXML valueOfAttributeNamed:@"height" forElement:sizeElement] floatValue] * MMTOPIX * SCALEFACTOR;
    return CGRectMake(x, y, width, height);
}
@end
