//
//  ProjectModel.h
//  GuiZhouRMMobile
//
//  Created by Sniper One on 12-10-29.
//
//

#import "UpDataModel.h"
#import "CaseInfo.h"

@interface ProjectModel : UpDataModel
@property (nonatomic, retain) NSString * myid;
@property (nonatomic, retain) NSString * inituser_account;
@property (nonatomic, retain) NSString * process_id;
@property (nonatomic, retain) NSString * process_name;

- (id)initWithCaseInfo:(CaseInfo *)caseInfo;
@end
