//
//  UpDataModel.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-21.
//
//

#import <Foundation/Foundation.h>
#import <objc/objc.h>
#import <objc/runtime.h>

@interface UpDataModel : NSObject
@property (nonatomic,readonly) NSDateFormatter *dateFormatter;
- (NSString *)XMLStringFromObjectWithPrefix:(NSString *)prefix;
- (NSString *)XMLStringWithOutModelNameFromObjectWithPrefix:(NSString *)prefix;
@end
