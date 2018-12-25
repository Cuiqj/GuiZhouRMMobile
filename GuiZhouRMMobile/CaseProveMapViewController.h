//
//  CaseProveMapViewController.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-12-25.
//
//

#import "CasePrintViewController.h"

@interface CaseProveMapViewController : CasePrintViewController
@property (weak, nonatomic) IBOutlet UILabel *labelShortDesc;
@property (weak, nonatomic) IBOutlet UILabel *labelCitizen;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelProvePlace;
@property (weak, nonatomic) IBOutlet UILabel *labelProveStart;
@property (weak, nonatomic) IBOutlet UILabel *labelProveEnd;
@property (weak, nonatomic) IBOutlet UILabel *labelProve1;
@property (weak, nonatomic) IBOutlet UILabel *labelProve1Duty;
@property (weak, nonatomic) IBOutlet UILabel *labelProve1No;
@property (weak, nonatomic) IBOutlet UILabel *labelProve2;
@property (weak, nonatomic) IBOutlet UILabel *labelProve2Duty;
@property (weak, nonatomic) IBOutlet UILabel *labelProve2No;
@property (weak, nonatomic) IBOutlet UILabel *labelRecorder;
@property (weak, nonatomic) IBOutlet UILabel *labelRecorderDuty;
@property (weak, nonatomic) IBOutlet UILabel *labelRecorderNO;

@property (weak, nonatomic) IBOutlet UIImageView *mapView;

- (void)generateDefaultInfo:(CaseProveInfo *)caseProveInfo;
@end
