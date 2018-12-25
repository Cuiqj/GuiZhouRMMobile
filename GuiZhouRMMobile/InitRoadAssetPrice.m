//
//  InitRoadAssetPrice.m
//  GuiZhouRMMobile
//
//  Created by Sniper X on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitRoadAssetPrice.h"
#import "TBXML.h"

#import "RoadAssetPrice.h"

@implementation InitRoadAssetPrice
- (void)downLoadRoadAssetPrice{
    WebServiceInit;
    [service getRoadassetPriceModel];
}

- (void)xmlParser:(NSString *)webString{
    [[AppDelegate App] clearEntityForName:@"RoadAssetPrice"];
    NSError *error;
    TBXML *tbxml=[TBXML newTBXMLWithXMLString:webString error:&error];
    TBXMLElement *root=tbxml.rootXMLElement;
    TBXMLElement *rf=[TBXML childElementNamed:@"soap:Body" parentElement:root];
    TBXMLElement *r1=[TBXML childElementNamed:@"getRoadassetPriceModelResponse" parentElement:rf];
    TBXMLElement *r2=[TBXML childElementNamed:@"out" parentElement:r1];
    
    TBXMLElement *r3=[TBXML childElementNamed:@"ns1:RoadAssetPriceModel" parentElement:r2];

    while (r3) {
        NSManagedObjectContext *entitySaveContext=[[AppDelegate App] managedObjectContext];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"RoadAssetPrice" inManagedObjectContext:entitySaveContext];
        RoadAssetPrice *roadAsset=[[RoadAssetPrice alloc] initWithEntity:entity insertIntoManagedObjectContext:entitySaveContext];
        roadAsset.roadasset_id=[TBXML textForElement:[TBXML childElementNamed:@"id" parentElement:r3]];
        TBXMLElement *xmlBigType=[TBXML childElementNamed:@"big_type" parentElement:r3];
        roadAsset.big_type=[TBXML textForElement:xmlBigType];
        TBXMLElement *xmlDamageType=[TBXML childElementNamed:@"damage_type" parentElement:r3];
        roadAsset.damage_type=[TBXML textForElement:xmlDamageType];;
        TBXMLElement *xmlName=[TBXML childElementNamed:@"name" parentElement:r3];
        NSString *name=[TBXML textForElement:xmlName];
        roadAsset.name=name;
        TBXMLElement *xmlSpec=[TBXML childElementNamed:@"spec" parentElement:r3];
        NSString *spec=[TBXML textForElement:xmlSpec];
        roadAsset.spec=spec;
        TBXMLElement *xmlPrice=[TBXML childElementNamed:@"price" parentElement:r3];
        NSString *price=[TBXML textForElement:xmlPrice];
        roadAsset.price=[NSNumber numberWithDouble:[price doubleValue]];
        TBXMLElement *xmlUnitName=[TBXML childElementNamed:@"unit_name" parentElement:r3];
        NSString *unitName=[TBXML textForElement:xmlUnitName];
        roadAsset.unit_name=unitName;
        TBXMLElement *xmlDepartNum=[TBXML childElementNamed:@"depart_num" parentElement:r3];
        roadAsset.depart_num=[TBXML textForElement:xmlDepartNum];
        TBXMLElement *xmlStandard=[TBXML childElementNamed:@"standard" parentElement:r3];
        roadAsset.standard=[TBXML textForElement:xmlStandard];
        TBXMLElement *xmlType=[TBXML childElementNamed:@"type" parentElement:r3];
        roadAsset.type=[TBXML textForElement:xmlType];
        TBXMLElement *xmlRemark=[TBXML childElementNamed:@"remark" parentElement:r3];
        roadAsset.remark=[TBXML textForElement:xmlRemark];
        [entitySaveContext save:nil];
        r3=r3->nextSibling;
    }
}

@end
