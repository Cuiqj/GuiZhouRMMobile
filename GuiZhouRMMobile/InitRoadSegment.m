//
//  InitRoadSegment.m
//  GuiZhouRMMobile
//
//  Created by Sniper X on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitRoadSegment.h"
#import "TBXML.h"
#import "RoadSegment.h"


@implementation InitRoadSegment
+(void)initRoadSegment{
    void(^RoadSegmentParser)(void)=^(void){
        [[AppDelegate App] clearEntityForName:@"RoadSegment"];
        NSManagedObjectContext *entitySaveContext=[[AppDelegate App] managedObjectContext];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"RoadSegment" inManagedObjectContext:entitySaveContext];
        NSError *error=nil;
        NSString *mainBundleDirectory = [[NSBundle mainBundle] pathForResource:@"RoadSegment" ofType:@"xml"];
        NSString *xmlString = [NSString stringWithContentsOfFile:mainBundleDirectory encoding:NSUTF8StringEncoding error:&error];
        TBXML *tbxml=[TBXML newTBXMLWithXMLString:xmlString error:&error];
        TBXMLElement *root=tbxml.rootXMLElement;
        TBXMLElement *row=[TBXML childElementNamed:@"dbo.RoadSegment" parentElement:root];
        while (row) {
            RoadSegment *road=[[RoadSegment alloc]initWithEntity:entity insertIntoManagedObjectContext:entitySaveContext];
            road.roadsegment_id=[TBXML textForElement:[TBXML childElementNamed:@"id" parentElement:row ]];
            road.station_start=[NSNumber numberWithInteger:[[TBXML textForElement:[TBXML childElementNamed:@"station_start" parentElement:row]] integerValue]];
            road.station_end=[NSNumber numberWithInteger:[[TBXML textForElement:[TBXML childElementNamed:@"station_end" parentElement:row]] integerValue]];
            road.place_start=[TBXML textForElement:[TBXML childElementNamed:@"place_start" parentElement:row]];
            road.place_end=[TBXML textForElement:[TBXML childElementNamed:@"place_end" parentElement:row]];
            road.driveway_count=[TBXML textForElement:[TBXML childElementNamed:@"driveway_count" parentElement:row]];
            road.road_grade=[TBXML textForElement:[TBXML childElementNamed:@"road_grade" parentElement:row]];
            road.group_id=[TBXML textForElement:[TBXML childElementNamed:@"group_id" parentElement:row]];
            road.group_flag=[NSNumber numberWithInteger:[[TBXML textForElement:[TBXML childElementNamed:@"group_flag" parentElement:row]] integerValue]];
            
            TBXMLElement *xmlCode=[TBXML childElementNamed:@"code" parentElement:row];
            NSString *code=[TBXML textForElement:xmlCode];
            road.code=code;
            TBXMLElement *xmlName=[TBXML childElementNamed:@"name" parentElement:row];
            NSString *name=[TBXML textForElement:xmlName];
            road.name=name;
            TBXMLElement *xmlroadId=[TBXML childElementNamed:@"road_id" parentElement:row];
            NSString *roadId=[TBXML textForElement:xmlroadId];
            road.road_id=roadId;
            TBXMLElement *xmlOrgID=[TBXML childElementNamed:@"orginfo_id" parentElement:row];
            NSString *orgID=[TBXML textForElement:xmlOrgID];
            road.organizationid=orgID;
            //        TBXMLElement *xmlPlacePrefix1=[TBXML childElementNamed:@"place_prefix1" parentElement:row];
            //        NSString *placePrefix1=[TBXML textForElement:xmlPlacePrefix1];
            road.placeprefix1=@"";
            road.placeprefix2=@"";
            [[AppDelegate App] saveContext];
            row=row->nextSibling;
        }
    };
//    BACKDISPATCH(XMLParser);
    RoadSegmentParser();
}
@end
