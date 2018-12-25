//
//  InitRoadEngrossPrice.m
//  GuiZhouRMMobile
//
//  Created by XU SHIWEN on 13-10-25.
//
//

#import "InitRoadEngrossPrice.h"
#import "RoadEngrossPrice.h"

@implementation InitRoadEngrossPrice

- (void)downloadRoadEngrossPrice
{
    WebServiceInit;
    [service getRoadEngrossPriceModel];
}

- (void)xmlParser:(NSString *)webString
{
    [[AppDelegate App] clearEntityForName:@"RoadEngrossPrice"];
    NSError *err;
    TBXML *tbxml=[TBXML newTBXMLWithXMLString:webString error:&err];
    TBXMLElement *root=tbxml.rootXMLElement;
    TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
    TBXMLElement *r1=[TBXML childElementNamed:@"getRoadEngrossPriceModelResponse" parentElement:rf];
    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
    
    TBXMLElement *r3=[TBXML childElementNamed:@"ns1:RoadEngrossPriceModel" parentElement:r2];
    
    
//    @property (nonatomic, retain) NSString * name;
//    @property (nonatomic, retain) NSString * spec;
//    @property (nonatomic, retain) NSString * type;
//    @property (nonatomic, retain) NSNumber * price;
//    @property (nonatomic, retain) NSString * unit_name;
//    @property (nonatomic, retain) NSString * remark;

    
    while (r3) {
        NSManagedObjectContext *entitySaveContext=[[AppDelegate App] managedObjectContext];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"RoadEngrossPrice" inManagedObjectContext:entitySaveContext];
        RoadEngrossPrice *roadEngrossPrice=[[RoadEngrossPrice alloc] initWithEntity:entity insertIntoManagedObjectContext:entitySaveContext];
        
        TBXMLElement *xmlID = [TBXML childElementNamed:@"id" parentElement:r3];
        roadEngrossPrice.roadengrossprice_id = [TBXML textForElement:xmlID];
        
        TBXMLElement *xmlName = [TBXML childElementNamed:@"name" parentElement:r3];
        roadEngrossPrice.name = [TBXML textForElement:xmlName];
        
        TBXMLElement *xmlSpec = [TBXML childElementNamed:@"spec" parentElement:r3];
        roadEngrossPrice.spec = [TBXML textForElement:xmlSpec];
        
        TBXMLElement *xmlType = [TBXML childElementNamed:@"type" parentElement:r3];
        roadEngrossPrice.type = [TBXML textForElement:xmlType];
        
        TBXMLElement *xmlPrice = [TBXML childElementNamed:@"price" parentElement:r3];
        roadEngrossPrice.price = @([TBXML textForElement:xmlPrice].doubleValue);
        
        TBXMLElement *xmlUnitName = [TBXML childElementNamed:@"unit_name" parentElement:r3];
        roadEngrossPrice.unit_name = [TBXML textForElement:xmlUnitName];
        
        TBXMLElement *xmlRemark = [TBXML childElementNamed:@"remark" parentElement:r3];
        roadEngrossPrice.remark = [TBXML textForElement:xmlRemark];
        
        NSLog(@"RoadEngrossPrice Downloaded: %@", roadEngrossPrice);
        
        [entitySaveContext save:nil];
        r3=r3->nextSibling;
    }
}

@end
