//
//  InitEmployee.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-17.
//
//

#import "InitEmployee.h"
#import "TBXML.h"
#import "EmployeeInfo.h"

@implementation InitEmployee;


- (void)downLoadEmployeeInfo{
    WebServiceInit;
    [service getEmployeeInfo];
}

- (void)xmlParser:(NSString *)webString{
    [[AppDelegate App] clearEntityForName:@"EmployeeInfo"];
    NSError *error=nil;
    TBXML *tbxml=[TBXML newTBXMLWithXMLString:webString error:&error];
    TBXMLElement *root=tbxml.rootXMLElement;
    TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
        
    TBXMLElement *r1=[TBXML childElementNamed:@"getEmployeeInfoListResponse" parentElement:rf];
    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
        
    TBXMLElement *author=[TBXML childElementNamed:@"ns1:EmployeeInfoModel" parentElement:r2];
    while (author) {
        @autoreleasepool {
            NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
            NSEntityDescription *entity=[NSEntityDescription entityForName:@"EmployeeInfo" inManagedObjectContext:context];
            EmployeeInfo *newInfo=[[EmployeeInfo alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            TBXMLElement *cardid=[TBXML childElementNamed:@"cardID" parentElement:author];
            newInfo.cardid=[TBXML textForElement:cardid];
            TBXMLElement *duty=[TBXML childElementNamed:@"duty" parentElement:author];
            newInfo.duty=[TBXML textForElement:duty];
            TBXMLElement *employee_id=[TBXML childElementNamed:@"id" parentElement:author];
            newInfo.employee_id=[TBXML textForElement:employee_id];
            TBXMLElement *enforce_code=[TBXML childElementNamed:@"enforce_code" parentElement:author];
            newInfo.enforce_code=[TBXML textForElement:enforce_code];
            TBXMLElement *name=[TBXML childElementNamed:@"name" parentElement:author];
            newInfo.name=[TBXML textForElement:name];
            TBXMLElement *orderdesc=[TBXML childElementNamed:@"orderdesc" parentElement:author];
            newInfo.orderdesc=[TBXML textForElement:orderdesc];
            TBXMLElement *organization_id=[TBXML childElementNamed:@"organization_id" parentElement:author];
            newInfo.organization_id=[TBXML textForElement:organization_id];
            TBXMLElement *sex=[TBXML childElementNamed:@"sex" parentElement:author];
            newInfo.sex=[TBXML textForElement:sex];
            TBXMLElement *telephone=[TBXML childElementNamed:@"telephone" parentElement:author];
            newInfo.telephone=[TBXML textForElement:telephone];
            [context save:nil];
        }
        author=author->nextSibling;
    }
}
 
@end
