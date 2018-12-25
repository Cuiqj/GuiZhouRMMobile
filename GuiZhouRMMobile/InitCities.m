//
//  InitCities.m
//  GuiZhouRMMobile
//
//  Created by Sniper X on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitCities.h"
#import "TBXML.h"

#import "Cities.h"

@implementation InitCities
+(void)initCitiesInfo{
    void(^CitiesParser)(void)=^(void){
        [[AppDelegate App] clearEntityForName:@"Cities"];
        NSError *error;
        NSString *mainBundleDirectory = [[NSBundle mainBundle] pathForResource:@"CityCode" ofType:@"xml"];
        NSString *xmlString = [NSString stringWithContentsOfFile:mainBundleDirectory encoding:NSUTF8StringEncoding error:&error];
        TBXML *tbxml=[TBXML newTBXMLWithXMLString:xmlString error:&error];
        TBXMLElement *root=tbxml.rootXMLElement;
        TBXMLElement *r1=[TBXML childElementNamed:@"dbo.CityCode" parentElement:root];
        while (r1) {
            NSManagedObjectContext *entitySaveContext=[[AppDelegate App] managedObjectContext];
            NSEntityDescription *modelsEntity=[NSEntityDescription entityForName:@"Cities" inManagedObjectContext:entitySaveContext];
            Cities *city=[[Cities alloc]initWithEntity:modelsEntity insertIntoManagedObjectContext:entitySaveContext];
            TBXMLElement *xmlCityCode=[TBXML childElementNamed:@"city_code" parentElement:r1];
            NSString *cityCode=[TBXML textForElement:xmlCityCode];
            city.citycode=cityCode;
            TBXMLElement *xmlCityName=[TBXML childElementNamed:@"city_name" parentElement:r1];
            NSString *cityName=[TBXML textForElement:xmlCityName];
            city.cityname=cityName;
            TBXMLElement *xmlprovinceId=[TBXML childElementNamed:@"province_id" parentElement:r1];
            NSString *provinceId=[TBXML textForElement:xmlprovinceId];
            city.provinceid=provinceId;
            [[AppDelegate App] saveContext];
            r1=r1->nextSibling;
        }
    };
//    BACKDISPATCH(XMLParser);
    CitiesParser();
}
@end
