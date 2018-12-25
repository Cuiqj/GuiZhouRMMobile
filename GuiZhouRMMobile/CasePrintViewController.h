//
//  CasePrintViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "TBXML.h"
#import "DataModelsHeader.h"
#import "NormalListSelectController.h"

#define VIEW_FRAME_WIDTH 946.0f
#define VIEW_FRAME_HEIGHT 1337.0f

#define VIEW_SMALL_WIDTH 768.0f
#define VIEW_SMALL_HEIGHT 955.0f

#define FONT_SongTi @"SimSun"
#define FONT_HeiTi @"SimHei"
#define FONT_FangSong @"FangSong_GB2312"

@interface CasePrintViewController : UIViewController<NormalListSelectDelegate> {
    CGFloat prLeftMargin,prTopMargin,prRightMargin,prBottomMargin,paperWidth,paperHeight;
}

@property (nonatomic, strong) UIPopoverController *myPopover;
@property (nonatomic) NSUInteger popoverIndex;

@property (nonatomic,copy) NSString * caseID;
@property (nonatomic,readonly) NSInteger dataCount;

//打印整个表格
- (NSURL *)toFullPDFWithPath:(NSString *)filePath;
//套打
- (NSURL *)toFormedPDFWithPath:(NSString *)filePath;

//返回xml文件字符串
- (NSString *)xmlStringFromFile:(NSString *)xmlName;

- (void)pageLoadInfo;
- (void)pageSaveInfo;
/*
-(void)drawText:(NSString *)text
         inRect:(CGRect)rect
   withFontSize:(CGFloat)   fontSize
         isBold:(BOOL)fontBold;
*/

- (NSInteger)dataCount;

- (void)drawLineFromPoint1x:(CGFloat)p1x
                   Point1y:(CGFloat)p1y 
                 toPoint2x:(CGFloat)p2x
                   Point2y:(CGFloat)p2y 
                 LineWidth:(CGFloat)lineWidth;

- (void)drawRectFromPoint1x:(CGFloat)p1x
                   Point1y:(CGFloat)p1y
                 toPoint2x:(CGFloat)p2x
                   Point2y:(CGFloat)p2y
                 LineWidth:(CGFloat)lineWidth;

- (void)loadDataAtIndex:(NSInteger)index;

- (void)drawDateTable:(NSString *)xmlName withDataModel:(NSManagedObject *)data;

//根据数据和子表配置输出报表，并返回剩余未输出的数据
- (NSArray *)drawSubTable:(NSString *)subXMLName withDataArray:(NSArray *)dataArray inRect:(CGRect)rect;

- (void)drawStaticTable:(NSString *)xmlName;
- (void)LoadPaperSettings:(NSString *)xmlName;

//返回是否可以重新生成默认值
- (BOOL)shouldGenereateDefaultDoc;
- (void)generateDefaultAndLoad;

//返回是否可以删除文书
- (BOOL)shouldDocDeleted;
//删除当前文书
- (void)deleteCurrentDoc;
- (void)drawDataTable:(NSString *)xmlName withDataInfo:(NSDictionary *)dataInfo ;
- (void)presentPopverFrom:(UIControl *)control withDataSource:(NSArray *)dataSource;
- (void)dismissPopoverAnimated:(BOOL)animated;

- (void)initControlsInteraction;
@end

#pragma mark - 常用方法
UIColor *GetBGColorForDisabledControl(void);
UIColor *GetBGColorForEnabledControl(void);
void setViewEnabled(UIView *view, BOOL enabled);