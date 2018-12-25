//
//  UIImage+ImageScale.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-26.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageScale)

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;

- (UIImage *)imageScaledToSize:(CGSize)size;

- (UIImage *)imageScaledToFitSize:(CGSize)size;
@end
