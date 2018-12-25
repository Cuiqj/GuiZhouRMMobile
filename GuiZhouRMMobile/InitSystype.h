//
//  InitSystype.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-9-10.
//
//

#import <Foundation/Foundation.h>
#import "Systype.h"
#import "InitData.h"
#import "OrgSysType.h"

@interface InitSystype : InitData
- (void)downLoadSystype;
@end
    
@interface InitOrgSystype : InitData
- (void)downLoadOrgSystype;
@end
