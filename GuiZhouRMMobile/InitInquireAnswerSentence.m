//
//  InitInquireAnswerSentence.m
//  GuiZhouRMMobile
//
//  Created by Sniper X on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitInquireAnswerSentence.h"
#import "TBXML.h"

#import "InquireAnswerSentence.h"

@implementation InitInquireAnswerSentence
+(void)initInquireAnswerSentence{
    void(^InquireAnswerParser)(void)=^(void){
        [[AppDelegate App] clearEntityForName:@"InquireAnswerSentence"];
        [[AppDelegate App] saveContext];
        
        NSManagedObjectContext *entitySaveContext=[[AppDelegate App] managedObjectContext];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"InquireAnswerSentence" inManagedObjectContext:entitySaveContext];
        NSError *error=nil;
        NSString *mainBundleDirectory = [[NSBundle mainBundle] pathForResource:@"InquireAnswerSentence" ofType:@"xml"];
        NSString *xmlString = [NSString stringWithContentsOfFile:mainBundleDirectory encoding:NSUTF8StringEncoding error:&error];
        TBXML *tbxml=[TBXML newTBXMLWithXMLString:xmlString error:&error];
        TBXMLElement *root=tbxml.rootXMLElement;
        TBXMLElement *r1=[TBXML childElementNamed:@"dbo.InquireAnswerSentence" parentElement:root];
        while (r1) {
            InquireAnswerSentence *ias =[[InquireAnswerSentence alloc]initWithEntity:entity insertIntoManagedObjectContext:entitySaveContext];
            TBXMLElement *child1=[TBXML childElementNamed:@"sentence" parentElement:r1];
            ias.sentence=[TBXML textForElement:child1];
            TBXMLElement *child3=[TBXML childElementNamed:@"ask_id" parentElement:r1];
            ias.ask_id=[TBXML textForElement:child3];
            [[AppDelegate App] saveContext];
            r1=r1->nextSibling;
        }
    };
//    BACKDISPATCH(XMLParser);
    InquireAnswerParser();
}
@end
