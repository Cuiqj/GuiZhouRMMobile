//
//  PageScrollDelegate.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-7-2.
//  Copyright (c) 2012年 中交宇科 . All rights reserved.
//

#import <Foundation/Foundation.h>
@class MoveableImage;

@protocol CasePaintDelegate <NSObject>

@optional
-(void)autoScrollPage:(CGFloat)offset;

-(void)deleteMoveableImage:(MoveableImage *)moveableImage;

-(void)addMoveTextInRect:(CGRect)rect;

-(NSInteger)getCurrentPageDelegate;

-(CGFloat)getCurrentContentSize;
@end
