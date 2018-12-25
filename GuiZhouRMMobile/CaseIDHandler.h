//
//  CaseIDHandler.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CaseIDHandler <NSObject>

@optional
-(void)setCaseIDdelegate:(NSString *)caseID;
-(void)setWeather:(NSString *)textWeather;
-(void)setCaseDescDelegate:(NSString *)caseDesc;
-(void)setBadDesc:(NSString *)textBadDesc;
-(void)setAutoNumber:(NSString *)textAutoNumber;
- (void)setCaseType:(NSString *)caseType;
-(void)reloadDocuments;
-(void)loadInquireForID:(NSString *)inquireID;
-(void)clearCitizenInfo;
-(void)scrollViewNeedsMove;
-(void)deleteCaseAllDataForCase:(NSString *)caseID;
- (void)pushInquireEditor;
-(NSString *)getCaseIDdelegate;
-(NSString *)getCitizenNameDelegate;
@end
