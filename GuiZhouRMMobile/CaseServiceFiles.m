//
//  CaseServiceFiles.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-18.
//
//

#import "CaseServiceFiles.h"

NSString * const CaseServiceFilesDefaultSendWay = @"直接送达";

@implementation CaseServiceFiles

@dynamic receipt_date;
@dynamic repeiptername;
@dynamic service_file;
@dynamic caseinfo_id;
@dynamic servicer_name;
@dynamic reason;
@dynamic servicer_name2;
@dynamic send_way;
@dynamic send_address;
@dynamic remark;
@dynamic receipter_name;
//读取案号对应的记录
+(NSArray *)caseServiceFilesForCase:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc] init];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"caseinfo_id ==%@",caseID];
    fetchRequest.predicate=predicate;
    fetchRequest.entity=entity;
    return [context executeFetchRequest:fetchRequest error:nil];
}

+ (CaseServiceFiles *)newCaseServiceFilesForID:(NSString *)caseID{
    NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    CaseServiceFiles *caseServiceFiles = [[CaseServiceFiles alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    caseServiceFiles.caseinfo_id = caseID;
    [[AppDelegate App] saveContext];
    return caseServiceFiles;
}

+ (NSArray *)serviceFilesForProcessType:(kGuiZhouRMCaseProcessType)processType andYesOrNoType:(BOOL)YesOrNoType
{
    NSArray *fileNames = nil;
    switch (processType) {
        case kGuiZhouRMCaseProcessTypeFA:
            if (YesOrNoType) {
                fileNames = @[@"勘验（检查）笔录",
                              @"询问笔录",
                              @"交通违法行为通知书",
                              @"交通行政（当场）处罚决定书",
                              @"送达回证",
                              @"现场勘查平面示意图",
                              @"抽样取证凭证",
                              @"责令车辆停驶通知书",
                              @"责令改正通知书",
                              @"责令停止（改正）违法行为通知书",
                              @"超限车辆卸载通知书"];
            } else {
                fileNames = @[@"勘验（检查）笔录",
                              @"询问笔录",
                              @"交通违法行为通知书",
                              @"交通行政处罚决定书",
                              @"送达回证",
                              @"现场勘查平面示意图",
                              @"抽样取证凭证",
                              @"责令车辆停驶通知书",
                              @"责令改正通知书",
                              @"责令停止（改正）违法行为通知书",
                              @"超限车辆卸载通知书"];
            }
            break;
        case kGuiZhouRMCaseProcessTypePEI:
            fileNames = @[@"勘验（检查）笔录",
                          @"询问笔录",
                          @"公路路产损害赔（补）偿费计算表",
                          @"公路赔（补）偿通知书",
                          @"送达回证",
                          @"现场勘查平面示意图",
                          @"抽样取证凭证",
                          @"责令车辆停驶通知书",
                          @"责令改正通知书",
                          @"责令停止（改正）违法行为通知书",
                          @"超限车辆卸载通知书"];
            break;
        case kGuiZhouRMCaseProcessTypeQIANG:
            fileNames = @[@"勘验（检查）笔录",
                          @"询问笔录",
                          @"送达回证",
                          @"现场勘查平面示意图",
                          @"抽样取证凭证",
                          @"责令车辆停驶通知书" ,
                          @"责令改正通知书",
                          @"责令停止（改正）违法行为通知书",
                          @"超限车辆卸载通知书"];
            break;
        default:
            break;
    }
    return fileNames;
}

@end

