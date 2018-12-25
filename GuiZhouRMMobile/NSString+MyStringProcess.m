//
//  NSString+MyStringProcess.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-8-8.
//  Copyright (c) 2012年 中交宇科 . All rights reserved.
//

#import "NSString+MyStringProcess.h"
#import "NSAttributedString+DrawMethod.h"


@implementation NSString (MyStringProcess)
//在方框内居中绘制文字，lineBreakMode：WordWarp
- (CGSize)alignWithVerticalCenterDrawInRect:(CGRect)rect withFont:(UIFont *)font horizontalAlignment:(UITextAlignment)alignment{
    CGSize size = [self sizeWithFont:font constrainedToSize:rect.size lineBreakMode:UILineBreakModeWordWrap];
    CGFloat yOffset = (rect.size.height - size.height)/2.0f;
    CGRect newRect = CGRectMake(rect.origin.x, rect.origin.y + yOffset, rect.size.width, size.height);
    CGSize actualSize = [self drawInRect:newRect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:alignment];
    return actualSize;
}

//绘制多行文本，lineHeight为整行高度。返回值为剩余的字符。lineBreakMode：WordWarp
- (NSString *)drawMultiLineTextInRect:(CGRect)rect
                             withFont:(UIFont *)font
                  horizontalAlignment:(UITextAlignment)alignment
                           leftOffSet:(CGFloat)leftOffSet
                           lineHeight:(CGFloat)lineHeight{
    NSString *testString = @"测试";
    CGFloat fontHeight = [testString sizeWithFont:font].height;
    if (lineHeight < fontHeight) {
        [self drawInRect:rect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:alignment];
    } else {
		//设置字体
		CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName,font.pointSize,NULL);
		
		//设置对齐方式
		CTTextAlignment coreTextAlignment = kCTTextAlignmentLeft;
		if (alignment == UITextAlignmentCenter) {
			coreTextAlignment = kCTTextAlignmentCenter;
		} else if (alignment == UITextAlignmentRight) {
			coreTextAlignment = kCTTextAlignmentRight;
		}
		CTParagraphStyleSetting alignmentStyle;
		alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
		alignmentStyle.value = &coreTextAlignment;
		alignmentStyle.valueSize = sizeof(CTTextAlignment);
		
		CTParagraphStyleSetting settings[1] = {alignmentStyle};
		CTParagraphStyleRef style = CTParagraphStyleCreate(settings, sizeof(settings));
		
		//确定文本属性
		NSDictionary *attriDic = @{(__bridge id)kCTParagraphStyleAttributeName : (__bridge id)style, (__bridge id)kCTFontAttributeName : (__bridge id)fontRef };
		
		NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:self attributes:attriDic];
		
		CGPoint originPoint = rect.origin;
		CFRange currentRange = CFRangeMake(0, 0);
		
        
		//为将字符在行中靠下对齐，必须在整个输出框内一行行的单独计算位置后再画出。
		//计算字体y坐标，在整行的中偏下的位置。
		//设定偏下参数
		static CGFloat const Y_Position_Factor = 1;
		//得到字体框相对每行上线的偏移量
		CGFloat yOffSet = (lineHeight - fontHeight)/2 + (lineHeight - fontHeight)/2 * Y_Position_Factor;
        
		//当字符输出完成或者超出范围时停止
		while (currentRange.location <= attributeString.length && originPoint.y + lineHeight <= rect.origin.y + rect.size.height) {
			CGFloat drawPointY = originPoint.y + yOffSet;
			//在CoreText下，坐标y轴与普通输出时相反，为保证换算后字体位置正常，须在y值上取负
			CGRect textRect = CGRectMake(originPoint.x, -drawPointY, rect.size.width, fontHeight);
			//如果第一行，考虑向左的偏移量
			if (currentRange.location == 0) {
				if (leftOffSet < rect.size.width) {
					textRect = CGRectMake(originPoint.x + leftOffSet, -drawPointY, rect.size.width - leftOffSet, fontHeight);
				}
			}
			currentRange = [attributeString renderInRect:textRect withTextRange:currentRange];
			originPoint.y += lineHeight;
		}
		if (currentRange.location < attributeString.length) {
			return [self substringFromIndex:currentRange.location];
		}
	}
    return @"";
}


// 为字符串分行
// 将字符串本身分行，3个参数分别为第一行字数、第二行字数（后面所有行字数等于第二行）、总行数
- (NSArray *)getLinesWithCharNumerOfLine1:(NSInteger)line1
                                    line2:(NSInteger)line2
                             andLineCount:(NSInteger)line_num;{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:line_num];
    for (int i = 0; i < line_num; i++) {
        [result addObject:@""];
    }
    int index1 = 0;
    int index2 = 0;
    for (int i = 0; i < line_num; i++) {
        // 下标赋值
        if (i == 0) {
            index1 = 0;
            index2 = line1;
        } else {
            index1 = index2;
            index2 = index1 + line2;
        }
        // 下标不能越界
        if (self.length < index2) {
            index2 = self.length;
        }
        // 如果以回车开头，则去掉
        NSString *temp = [self substringWithRange:NSMakeRange(index1, index2 - index1)];
        while ([temp hasPrefix:@"\r"] || [temp hasPrefix:@"\n"]) {
            index1 += 1;
            index2 += 1;
            if (self.length < index2) {
                index2 = self.length;
            }
            temp = [self substringWithRange:NSMakeRange(index1, index2 - index1)];
        }
        // 如果已经是最后一行，则去掉回车全部输出
        if (i == line_num - 1) {
            NSString *subString = [self substringFromIndex:index1];
            subString = [subString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            [result replaceObjectAtIndex:i withObject:subString];
            return [NSArray arrayWithArray:result];
        }
        //
        NSInteger enter = [temp rangeOfString:@"\n"].location;
        if (enter != NSNotFound) {
            index2 = index1 + enter + 1;
        }
        NSString *subString = [self substringWithRange:NSMakeRange(index1, index2 - index1)];
        subString = [subString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        [result replaceObjectAtIndex:i withObject:subString];
        if (index2 == self.length) {
            break;
        }
    }    
    return [NSArray arrayWithArray:result];
}

//将文本分页，可定义第一页和后续页大小，及整体行高
- (NSArray *)pagesWithFont:(UIFont *)font
                lineHeight:(CGFloat)lineHeight
       horizontalAlignment:(UITextAlignment)alignment
                 page1Rect:(CGRect)page1Rect
            followPageRect:(CGRect)followPageRect{
    NSMutableArray *pages = [[NSMutableArray alloc] initWithCapacity:1];
    NSString *test1 = @"测试";
	CGFloat fontHeight = [test1 sizeWithFont:font].height;
    if (lineHeight < fontHeight) {
        [pages addObject:self];
    } else {
        CGFloat lineSpace = lineHeight - fontHeight;
        
        CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName,font.pointSize,NULL);
        
        //设置行高
        CTParagraphStyleSetting lineSpaceStyle;
        lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
        lineSpaceStyle.value = &lineSpace;
        lineSpaceStyle.valueSize = sizeof(CGFloat);
        
        //设置对齐方式
        CTTextAlignment coreTextAlignment = kCTTextAlignmentLeft;
        if (alignment == UITextAlignmentCenter) {
            coreTextAlignment = kCTTextAlignmentCenter;
        } else if (alignment == UITextAlignmentRight) {
            coreTextAlignment = kCTTextAlignmentRight;
        }
        CTParagraphStyleSetting alignmentStyle;
        alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
        alignmentStyle.value = &coreTextAlignment;
        alignmentStyle.valueSize = sizeof(CTTextAlignment);
        
        CTParagraphStyleSetting settings[2] = {lineSpaceStyle, alignmentStyle};
        CTParagraphStyleRef style = CTParagraphStyleCreate(settings, sizeof(settings));
        
        NSDictionary *attriDic = @{(__bridge id)kCTParagraphStyleAttributeName : (__bridge id)style, (__bridge id)kCTFontAttributeName : (__bridge id)fontRef };
        
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:self attributes:attriDic];
        CFRange currentRange = CFRangeMake(0, 0);
        BOOL done = NO;
        do {
            //如果是第一页
            if (currentRange.location == 0) {
                currentRange = [attributeString rangeInRect:page1Rect withTextRange:currentRange];
            } else {
                currentRange = [attributeString rangeInRect:followPageRect withTextRange:currentRange];
            }
            [pages addObject:[self substringWithRange:NSMakeRange(currentRange.location, currentRange.length)]];
            
            currentRange.location += currentRange.length;
            currentRange.length = 0;
            if (currentRange.location == attributeString.length)
                done = YES;
        } while (!done);
    }
    return pages;
}


//将数字日期转换成为中文汉字日期，仅转换单独数字。如果是2013-01-01等类型的日期，需分隔开之后再单独转换处理，参数决定是否按年份转换
- (NSString *)numberDateToChineseAndIsYearDate:(BOOL)isYearDate{
	NSString *result = @"";
	NSArray *strChinese = @[@"〇", @"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十"];
	if (isYearDate) {
		NSString *numberStringFromSelf = [[NSString alloc] initWithFormat:@"%d",self.integerValue];
		for (int i = 0; i < numberStringFromSelf.length; i++) {
			NSString *sub = [numberStringFromSelf substringWithRange:NSMakeRange(i, 1)];
			result = [result stringByAppendingString:[strChinese objectAtIndex:sub.integerValue]];
		}
	} else {
		NSInteger dateNumber = self.integerValue%100;
		NSInteger date1 = dateNumber/10;
		NSInteger date2 = dateNumber%10;
		if (date1 > 1) {
			result = [result stringByAppendingString:[strChinese objectAtIndex:date1]];
		}
		if (date1 > 0) {
			result = [result stringByAppendingString:[strChinese objectAtIndex:10]];
		}
		if (date2 != 0) {
			result = [result stringByAppendingString:[strChinese objectAtIndex:date2]];
		}
	}
	return result;
}


//检查字符串是否为空
- (BOOL)isEmpty{
    if([self length] == 0) { 
        //string is empty or nil
        return YES;
    } else if([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        //string is all whitespace
        return YES;
    }
    return NO;
}


//生成随机ID
+ (NSString *)randomID{
	NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
	[dateFormatter setLocale:[NSLocale currentLocale]];
	[dateFormatter setDateFormat:@"yyMMddHHmmssSSS"];
    NSString *IDString=[dateFormatter stringFromDate:[NSDate date]];
    return IDString;
}

- (NSString *)encryptedString{
    static char cvt[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    "abcdefghijklmnopqrstuvwxyz"
    "0123456789#@$";
    
	static char fillchar = '*';
    
    NSString *temp = [self lowercaseString];
    NSData *tempData = [temp dataUsingEncoding:NSUTF8StringEncoding];
    UInt8 *data = (UInt8 *)[tempData bytes];
    int c;
    int len = [tempData length];
    NSMutableString *ret = [NSMutableString stringWithCapacity:((len / 3) + 1) * 4];
    for (int i = 0; i < len; ++i) {
        c = (data[i] >> 2) & 0x3f;
        [ret appendFormat:@"%c",cvt[c]];
        c = (data[i] << 4) & 0x3f;
        if (++i < len) {
            c |= (data[i] >> 4) & 0x0f;
        }
        [ret appendFormat:@"%c",cvt[c]];
        if (i < len) {
            c = (data[i] << 2) & 0x3f;
            if (++i < len) {
                c |= (data[i] >> 6) & 0x03;
            }
            [ret appendFormat:@"%c",cvt[c]];
        } else {
            ++i;
            [ret appendFormat:@"%c",fillchar];

        }
        if (i < len) {
            c = data[i] & 0x3f;
            [ret appendFormat:@"%c",cvt[c]];
        } else {
            [ret appendFormat:@"%c",fillchar];
        }
    }
    return ret;
}


- (NSString *)serializedXMLElementStringWithElementName:(NSString *)elementName{
    NSString *serializedXML;
    if ([self isEmpty]) {
        serializedXML = [[NSString alloc] initWithFormat:@"<%@ xsi:nil=\"true\" />",elementName];
    } else {
        serializedXML = [[NSString alloc] initWithFormat:@"<%@>%@</%@>",elementName,self,elementName];
    }
    return serializedXML;
}
@end


@implementation NSString (TrimmingAdditions)

- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];    
    [self getCharacters:charBuffer];    
    for (location=0; location < length; location++) {
        if (![characterSet characterIsMember:charBuffer[location]]) {
            break;
        }
    }    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length=[self length];
    unichar charBuffer[length];    
    [self getCharacters:charBuffer];    
    for (length=[self length]; length > 0; length--) {
        if (![characterSet characterIsMember:charBuffer[length - 1]]) {
            break;
        }
    }    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

@end

