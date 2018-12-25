//
//  CaseLaySet.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-4.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CaseLaySet : NSManagedObject

@property (nonatomic, retain) NSString * case_reson;
@property (nonatomic, retain) NSString * yiju;
@property (nonatomic, retain) NSString * weifan;
@property (nonatomic, retain) NSString * casetype;

// 案件法律依据
+ (NSString *)getLayYiJuForCase:(NSString *)caseID;

// 案件违反法律
+ (NSString *)getLayWeiFanForCase:(NSString *)caseID;
@end
