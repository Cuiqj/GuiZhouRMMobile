//
//  AnswererPickerViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AnswererPickerViewController.h"
#import "Systype.h"
#import "CaseInquire.h"

@interface AnswererPickerViewController ()
@property (nonatomic,retain) NSArray *dataArray;
@property (nonatomic,retain) NSArray *dataAnswerArray;
@end

@implementation AnswererPickerViewController
@synthesize delegate=_delegate;
@synthesize pickerPopover=_pickerPopover;
@synthesize dataArray=_dataArray;
@synthesize dataAnswerArray = _dataAnswerArray;


//弹出列表类型，0为被询问人类型，1为被询问人姓名，2为常见问题，3为常见答案
@synthesize pickerType=_pickerType;

-(void)viewWillAppear:(BOOL)animated{
    switch (self.pickerType) { 
        case 0:
            self.dataArray=[Systype typeValueForCodeName:@"与案件关系"];
            break;
        case 1:{           
            NSString *caseID=[self.delegate getCaseIDDelegate];
            NSArray *inquires = [CaseInquire allInquireForCase:caseID];
            NSArray *temp = [inquires valueForKeyPath:@"answerer_name"];
            CaseInfo *caseInfo = [CaseInfo caseInfoForID:caseID];
            //若相关件案件已上传，不添加新增被询问人按钮
            if (caseInfo.isuploaded.boolValue == NO) {
                NSArray *addNewDataString = @[TitleForNewInquire];
                self.dataArray = [temp arrayByAddingObjectsFromArray:addNewDataString];
            } else {
                self.dataArray = temp;
            }
        }
            break;
        case 2:
            //初始化常用问答
            self.dataArray = [Systype typeValueForCodeName:@"询问笔录"];
            break;
        case 4:
            //add by nx 2013.11.29 初始化根据案由选择询问语句模板
            self.dataArray = [Systype typeValueForCodeName:@"询问笔录模板"];
            self.dataAnswerArray = [Systype typeValueForCodeName:@"询问笔录模板回答"];
            break;
        default:
            break;
    }    
}

-(void)viewDidUnload{
    [self setDelegate:nil];
    [self setPickerPopover:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; 
    }
    // Configure the cell...
    switch (self.pickerType) {
        case 0:
            cell.textLabel.text=[self.dataArray objectAtIndex:indexPath.row];
            break;
        case 1:{
            NSString *dataString = [self.dataArray objectAtIndex:indexPath.row];
            if ([dataString isEqualToString:TitleForNewInquire]) {
                [cell.textLabel setTextColor:[UIColor redColor]];
            } else {
                [cell.textLabel setTextColor:[UIColor blackColor]];
            }
            cell.textLabel.text=[self.dataArray objectAtIndex:indexPath.row];
        }
            break;
        case 2:{
            cell.textLabel.lineBreakMode=UILineBreakModeWordWrap;
            cell.textLabel.numberOfLines=0;
            cell.textLabel.font=[UIFont systemFontOfSize:17];
            cell.textLabel.text=[self.dataArray objectAtIndex:indexPath.row];
        }
            break;
        case 4:{
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:17];
        }
        default:
            break;
    }    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    NSString *aText = cell.textLabel.text;
    switch (self.pickerType) {
        case 0:
            [self.delegate setNexusDelegate:aText];
            break;
        case 1:{
            if (![aText isEqualToString:TitleForNewInquire]) {
                NSString *caseID=[self.delegate getCaseIDDelegate];
                NSArray *temp = [CaseInquire allInquireForCase:caseID];
                CaseInquire *inquire = [temp objectAtIndex:indexPath.row];
                [self.delegate setAnswererDelegate:inquire.myid];
            } else {
                [self.delegate setAnswererDelegate:aText];
            }
        }
            break;
        case 2:
            [self.delegate setAnswerSentence:aText];
            break;
        case 4:{
            NSString *answerText = [self.dataAnswerArray objectAtIndex:indexPath.row];
            [self.delegate setAnswerSentenceUseMuban:answerText];
            
        }
            
        
            
        default:
            break;
    }
    [self.pickerPopover dismissPopoverAnimated:YES];    
}

@end
