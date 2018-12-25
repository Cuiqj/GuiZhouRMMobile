//
//  PaintBriefViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PaintBriefViewController.h"
#import "RoadModelBoard.h"
#import "CaseMap.h"

@interface PaintBriefViewController ()
@end

@implementation PaintBriefViewController
@synthesize Image;

- (void)viewDidLoad
{
    [self.view setBackgroundColor:BGCOLOR];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated{
    [self loadCasePaint];
}

- (void)loadCasePaint{
    if (![self.caseID isEmpty]) {
        CaseMap *caseMap = [CaseMap caseMapForCase:self.caseID];
        if (caseMap) {
            NSString *filePath=caseMap.map_path;
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                UIImage *imageFile = [[UIImage alloc] initWithContentsOfFile:filePath];
                self.Image.image = imageFile;
            }
        } else {
            self.Image.image = nil;
        }
    }
}

- (void)viewDidUnload
{
    [self setImage:nil];
    [self setCaseID:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
