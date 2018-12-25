//
//  InitSystype.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-9-10.
//
//

#import "InitSystype.h"

@implementation InitSystype


- (void)downLoadSystype{
    WebServiceInit;
    [service getSystypeList];
}

- (void)xmlParser:(NSString *)webString{
    [[AppDelegate App] clearEntityForName:@"Systype"];
    [[AppDelegate App] saveContext];
    NSManagedObjectContext *entitySaveContext=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Systype" inManagedObjectContext:entitySaveContext];
    NSError *error;
    TBXML *tbxml=[TBXML newTBXMLWithXMLString:webString error:&error];
    TBXMLElement *root=tbxml.rootXMLElement;
    TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
    TBXMLElement *r1=[TBXML childElementNamed:@"getSystypeListResponse" parentElement:rf];
    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
    
    TBXMLElement *row=[TBXML childElementNamed:@"ns1:SysTypeModel" parentElement:r2];
    while (row) {
        Systype *systype=[[Systype alloc] initWithEntity:entity insertIntoManagedObjectContext:entitySaveContext];
        TBXMLElement *child=[TBXML childElementNamed:@"sys_code" parentElement:row];
        if (child) {
            systype.sys_code=[TBXML textForElement:child];
        }
        child=[TBXML childElementNamed:@"code_name" parentElement:row];
        systype.code_name=[TBXML textForElement:child];
        child=[TBXML childElementNamed:@"type_code" parentElement:row];
        if (child) {
            systype.type_code=[TBXML textForElement:child];
        }
        child=[TBXML childElementNamed:@"type_value" parentElement:row];
        systype.type_value=[TBXML textForElement:child];
        [[AppDelegate App] saveContext];
        row=row->nextSibling;
    }
}
@end



#pragma mark - 

@implementation InitOrgSystype

- (void)downLoadOrgSystype{
    WebServiceInit;
    [service getOrgSysTypeList];
}

- (void)xmlParser:(NSString *)webString{
    [[AppDelegate App] clearEntityForName:@"OrgSysType"];
    [[AppDelegate App] saveContext];
    NSManagedObjectContext *entitySaveContext=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"OrgSysType" inManagedObjectContext:entitySaveContext];
    NSError *error;
    TBXML *tbxml=[TBXML newTBXMLWithXMLString:webString error:&error];
    TBXMLElement *root=tbxml.rootXMLElement;
    TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
    TBXMLElement *r1=[TBXML childElementNamed:@"getOrgSysTypeListResponse" parentElement:rf];
    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
    
    TBXMLElement *row=[TBXML childElementNamed:@"ns1:OrgSysTypeModel" parentElement:r2];
    while (row) {
        OrgSysType *systype=[[OrgSysType alloc] initWithEntity:entity insertIntoManagedObjectContext:entitySaveContext];
        TBXMLElement *child=[TBXML childElementNamed:@"remark" parentElement:row];
        systype.remark = [TBXML textForElement:child];
        child=[TBXML childElementNamed:@"code_name" parentElement:row];
        systype.code_name=[TBXML textForElement:child];
        child=[TBXML childElementNamed:@"type_value" parentElement:row];
        systype.type_value=[TBXML textForElement:child];
        [[AppDelegate App] saveContext];
        row=row->nextSibling;
    }
}
@end