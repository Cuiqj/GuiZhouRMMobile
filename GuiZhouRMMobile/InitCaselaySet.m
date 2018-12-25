//
//  InitCaselaySet.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-4.
//
//

#import "InitCaselaySet.h"
#import "CaseLaySet.h"

@implementation InitCaselaySet
- (void)downLoadCaselaySet{
    WebServiceInit;
    [service getCaselaySet];
}

- (void)xmlParser:(NSString *)webString{
    [[AppDelegate App] clearEntityForName:@"CaseLaySet"];
    [[AppDelegate App] saveContext];
    NSManagedObjectContext *entitySaveContext=[[AppDelegate App] managedObjectContext];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CaseLaySet" inManagedObjectContext:entitySaveContext];
    NSError *error;
    TBXML *tbxml=[TBXML newTBXMLWithXMLString:webString error:&error];
    TBXMLElement *root=tbxml.rootXMLElement;
    TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
    TBXMLElement *r1=[TBXML childElementNamed:@"getCaselaysetModelResponse" parentElement:rf];
    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
    
    TBXMLElement *row=[TBXML childElementNamed:@"ns1:CaselaysetModel" parentElement:r2];
    while (row) {
        CaseLaySet *caseLaySet=[[CaseLaySet alloc] initWithEntity:entity insertIntoManagedObjectContext:entitySaveContext];
        TBXMLElement *child=[TBXML childElementNamed:@"caseType" parentElement:row];
        caseLaySet.casetype = [TBXML textForElement:child];
        child=[TBXML childElementNamed:@"case_reson" parentElement:row];
        caseLaySet.case_reson=[TBXML textForElement:child];
        child=[TBXML childElementNamed:@"weifan" parentElement:row];
        caseLaySet.weifan=[TBXML textForElement:child];
        child=[TBXML childElementNamed:@"yiju" parentElement:row];
        caseLaySet.yiju=[TBXML textForElement:child];
        [[AppDelegate App] saveContext];
        row=row->nextSibling;
    }
}
@end
