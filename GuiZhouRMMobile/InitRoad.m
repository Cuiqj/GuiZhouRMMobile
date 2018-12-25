//
//  InitRoad.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-22.
//
//

#import "InitRoad.h"
#import "Road.h"

@implementation InitRoad
- (void)downLoadRoadModel{
    WebServiceInit;
    [service getRoad];
}

- (void)xmlParser:(NSString *)webString{
    [[AppDelegate App] clearEntityForName:@"Road"];
    NSError *error = nil;
    TBXML *tbxml = [TBXML newTBXMLWithXMLString:webString error:&error];
    TBXMLElement *root = tbxml.rootXMLElement;
    TBXMLElement *rf = [TBXML childElementNamed:@"soap:Body" parentElement:root];
    
    TBXMLElement *r1 = [TBXML childElementNamed:@"getRoadModelResponse" parentElement:rf];
    TBXMLElement *r2 = [TBXML childElementNamed:@"out" parentElement:r1];
    
    TBXMLElement *author = [TBXML childElementNamed:@"ns1:RoadModel" parentElement:r2];
    while (author) {
        @autoreleasepool {
            NSManagedObjectContext *context = [[AppDelegate App] managedObjectContext];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Road" inManagedObjectContext:context];
            Road *newInfo = [[Road alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
            TBXMLElement *code = [TBXML childElementNamed:@"code" parentElement:author];
            newInfo.code = [TBXML textForElement:code];
            TBXMLElement *delflag = [TBXML childElementNamed:@"delflag" parentElement:author];
            newInfo.delflag = [TBXML textForElement:delflag];
            TBXMLElement *road_id = [TBXML childElementNamed:@"id" parentElement:author];
            newInfo.road_id = [TBXML textForElement:road_id];
            TBXMLElement *name = [TBXML childElementNamed:@"name" parentElement:author];
            newInfo.name = [TBXML textForElement:name];
            TBXMLElement *place_end = [TBXML childElementNamed:@"place_end" parentElement:author];
            newInfo.place_end = [TBXML textForElement:place_end];
            TBXMLElement *place_start = [TBXML childElementNamed:@"place_start" parentElement:author];
            newInfo.place_start = [TBXML textForElement:place_start];
            TBXMLElement *remark = [TBXML childElementNamed:@"remark" parentElement:author];
            newInfo.remark = [TBXML textForElement:remark];
            TBXMLElement *station_end = [TBXML childElementNamed:@"station_end" parentElement:author];
            newInfo.station_end = @([TBXML textForElement:station_end].integerValue);
            TBXMLElement *station_start = [TBXML childElementNamed:@"station_start" parentElement:author];
            newInfo.station_start = @([TBXML textForElement:station_start].integerValue);
            [context save:nil];
        }
        author = author->nextSibling;
    }
}
@end
