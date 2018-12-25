//
//  UpDataModel.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-21.
//
//

#import "UpDataModel.h"

@implementation UpDataModel
@synthesize dateFormatter = _dateFormatter;

- (NSDateFormatter *)dateFormatter{
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timezone = [[NSTimeZone alloc] initWithName:@"GMT"];
        [_dateFormatter setTimeZone:timezone];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    }
    return _dateFormatter;
}


- (NSString *)XMLStringFromObjectWithPrefix:(NSString *)prefix{
    int i;
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
    NSString *xmlString=@"";
    xmlString = [xmlString stringByAppendingFormat:@"<%@:%@> \n",prefix,NSStringFromClass([self class])];
    for ( i=0; i < propertyCount; i++ ) {
        objc_property_t *thisProperty = propertyList + i;
        const char* propertyName = property_getName(*thisProperty);
        NSString *propertyKey=[[NSString alloc] initWithUTF8String:propertyName];
        NSString *propertyValue = [self valueForKey:propertyKey]==nil ? @"":[self valueForKey:propertyKey];
        if ([propertyKey isEqualToString:@"myid"]) {
            propertyKey = @"id";
        }
        if (![propertyValue isEmpty]) {
            xmlString = [xmlString stringByAppendingFormat:@"<%@:%@>%@</%@:%@> \n",prefix,propertyKey,propertyValue,prefix,propertyKey];
        }
    }
    xmlString = [xmlString stringByAppendingFormat:@"</%@:%@> \n",prefix,NSStringFromClass([self class])];
    return xmlString;
}


- (NSString *)XMLStringWithOutModelNameFromObjectWithPrefix:(NSString *)prefix{
    int i;
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
    NSString *xmlString=@"";
    for ( i=0; i < propertyCount; i++ ) {
        objc_property_t *thisProperty = propertyList + i;
        const char* propertyName = property_getName(*thisProperty);
        NSString *propertyKey=[[NSString alloc] initWithUTF8String:propertyName];
        NSString *propertyValue = [self valueForKey:propertyKey] == nil ? @"" : [self valueForKey:propertyKey];
        if ([propertyKey isEqualToString:@"myid"]) {
            propertyKey = @"id";
        }
        if (![propertyValue isEmpty]) {
            xmlString = [xmlString stringByAppendingFormat:@"<%@:%@>%@</%@:%@> \n",prefix,propertyKey,propertyValue,prefix,propertyKey];
        }
    }
    return xmlString;
}

- (void)dealloc{
    _dateFormatter = nil;
}
@end
