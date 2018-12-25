//
//  InspectImageViewController.m
//  GuiZhouRMMobile
//
//  Created by luna on 14-1-22.
//
//

#import "InspectImageViewController.h"
#import "InspectionRecordNormal.h"
#import "InspectionRecordPhotosModel.h"
#import "CasePhoto.h"
#import "CaseInfo.h"


#define PHOTO(index) [self cachePhotoForIndex:index]

//载入对应照片，并显示一个序列文字标签
#define LOADPHOTOS  if (self.photoArray.count>0) {\
self.labelPhotoIndex.hidden=NO;\
self.labelPhotoIndex.text=[[NSString alloc] initWithFormat:@"%d/%d",self.imageIndex+1,self.photoArray.count];\
self.labelPhotoIndex.alpha=1.0;\
}\

#define SET_FRAME(IMAGE) x = IMAGE.frame.origin.x + increase;\
if(x < 0) x = pageWidth * 2;\
if(x > pageWidth * 2) x = 0.0f;\
[IMAGE setFrame:CGRectMake(x, \
IMAGE.frame.origin.y,\
IMAGE.frame.size.width,\
IMAGE.frame.size.height)]

#define WIDTH_OFF_SET 529.0
#define HEIGHT_OFF_SET 0
#define SCROLLVIEW_WIDTH 529.0
#define SCROLLVIEW_HEIGHT 482.0

#define CITIZENINFO_HEIGHT 620.0
#define ACCINFO_HEIGHT 450.0

@interface InspectImageViewController ()

//案件照片数组
@property (nonatomic,retain) NSMutableArray *photoArray;

@property (nonatomic,assign) NSInteger imageIndex;

@property (nonatomic,retain) UIImageView *leftImageView;
@property (nonatomic,retain) UIImageView *midImageView;
@property (nonatomic,retain) UIImageView *rightImageView;

@end

@implementation InspectImageViewController
@synthesize caseInfoPickerpopover,imageScrollView,uiButtonCamera,uiButtonPickFromLibrary;

- (NSString *)caseID{
    if (_caseID==nil) {
        _caseID=@"";
    }
    return _caseID;
}

- (UIImageView *)leftImageView{
    
    if (_leftImageView==nil) {
        _leftImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
        _leftImageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _leftImageView;
}

- (UIImageView *)midImageView{
    if (_midImageView==nil) {
        _midImageView=[[UIImageView alloc] initWithFrame:CGRectMake(SCROLLVIEW_WIDTH, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
        _midImageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _midImageView;
}

- (UIImageView *)rightImageView{
    if (_rightImageView==nil) {
        _rightImageView=[[UIImageView alloc] initWithFrame:CGRectMake(SCROLLVIEW_WIDTH*2, 0, SCROLLVIEW_WIDTH, SCROLLVIEW_HEIGHT)];
        _rightImageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _rightImageView;
}

- (NSMutableArray *)photoArray{
    if (_photoArray==nil) {
        _photoArray=[[NSMutableArray alloc] initWithCapacity:1];
    }
    return _photoArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
    
    self.imageScrollView.layer.cornerRadius=4;
    self.imageScrollView.layer.masksToBounds=YES;
    
    self.imageScrollView.pagingEnabled = YES;
    
    self.imageScrollView.scrollEnabled = YES;
    
    self.imageScrollView.showsHorizontalScrollIndicator = NO;
    
    [self loadCasePhotoForCase:self.caseID];
    
}

//将三个view都向右移动，并更新三个指针的指向
- (void)allImagesMoveRight:(CGFloat)pageWidth {
    //上一篇
    self.rightImageView.image = [self cachePhotoForIndex:self.imageIndex - 1];
	
    float increase = pageWidth;
    CGFloat x = 0.0f;
    SET_FRAME(self.rightImageView);
    SET_FRAME(self.leftImageView);
    SET_FRAME(self.midImageView);
    
    UIImageView *tempView = self.rightImageView;
    self.rightImageView = self.midImageView;
    self.midImageView = self.leftImageView;
    self.leftImageView = tempView;
}

- (void)allImagesMoveLeft:(CGFloat)pageWidth {
    self.leftImageView.image = [self cachePhotoForIndex:self.imageIndex + 1];
	
    float increase = -pageWidth;
    CGFloat x = 0.0f;
    SET_FRAME(self.midImageView);
    SET_FRAME(self.rightImageView);
    SET_FRAME(self.leftImageView);
    
    UIImageView *tempView = self.leftImageView;
    self.leftImageView = self.midImageView;
    self.midImageView = self.rightImageView;
    self.rightImageView = tempView;
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [self.imageScrollView setContentOffset:CGPointMake(SCROLLVIEW_WIDTH, 0) animated:NO];
    
    [UIView transitionWithView:self.imageScrollView duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.imageScrollView addSubview:self.leftImageView];
                        [self.imageScrollView addSubview:self.midImageView];
                        [self.imageScrollView addSubview:self.rightImageView];
                        LOADPHOTOS;
                        self.leftImageView.image = [self cachePhotoForIndex:self.imageIndex-1];
                        self.midImageView.image = [self cachePhotoForIndex:self.imageIndex];
                        self.rightImageView.image = [self cachePhotoForIndex:self.imageIndex+1];
                        
                    }
                    completion:^(BOOL finished){
                        //删除infoView上的所有手势，防止在非照片页面误操作
                        for (UIGestureRecognizer *gesture in [self.imageScrollView gestureRecognizers]) {
                            [gesture removeTarget:self action:@selector(showDeleteMenu:)];
                        }
                        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showDeleteMenu:)];
                        [self.imageScrollView addGestureRecognizer:longPressGesture];
                    }];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideLabelWithAnimation) userInfo:nil repeats:NO];
    
    if (self.photoArray.count<3) {
        
        self.imageScrollView.contentSize = CGSizeMake(SCROLLVIEW_WIDTH*self.photoArray.count
                                                      , SCROLLVIEW_HEIGHT);
    }else
    {
        self.imageScrollView.contentSize = CGSizeMake(SCROLLVIEW_WIDTH*3
                                                      , SCROLLVIEW_HEIGHT);
    }
}

- (void)hideLabelWithAnimation {
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         [self.labelPhotoIndex setAlpha:0.0];
                     }
                     completion:^(BOOL finished){ self.labelPhotoIndex.hidden=YES;}];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

- (IBAction)imageLibrary:(UIButton *)sender {
    
    [self pickPhoto:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)imagePhoto:(UIButton *)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self pickPhoto:UIImagePickerControllerSourceTypeCamera];
    }
}

- (IBAction)imageSave:(id)sender {
    NSMutableArray * array = [[NSMutableArray alloc]init];
    
    for (NSString * photo in self.photoArray) {
        InspectionRecordPhotosModel * inspection = [[InspectionRecordPhotosModel alloc]init];
        
        inspection.sketch = photo;

        [array addObject:inspection];
    }
}

- (void)pickPhoto:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.delegate=self;
    picker.sourceType=sourceType;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self presentModalViewController:picker animated:YES];
    } else if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        self.caseInfoPickerpopover = popover;
        CGRect infoCenter=CGRectMake(self.imageScrollView.center.x-5, self.imageScrollView.center.y-5, 10, 10);
        [self.caseInfoPickerpopover presentPopoverFromRect:infoCenter  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if (![self.caseID isEmpty]) {
        dispatch_queue_t myqueue=dispatch_queue_create("PhotoSave", nil);
        dispatch_async(myqueue, ^(void){
            UIImage *photo=[info objectForKey:UIImagePickerControllerOriginalImage];
            if ([self.photoPath isEmpty] || self.photoPath == nil) {
                NSArray *pathArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentPath=[pathArray objectAtIndex:0];
                NSString *photoPath=[NSString stringWithFormat:@"CasePhoto/%@",self.caseID];
                self.photoPath=[documentPath stringByAppendingPathComponent:photoPath];
            }
            if (![[NSFileManager defaultManager] fileExistsAtPath:self.photoPath]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:self.photoPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString *photoName;
            if (self.photoArray.count==0) {
                photoName=@"1.jpg";
            } else {
                NSInteger photoNumber=[[self.photoArray valueForKeyPath:@"@max.integerValue"] integerValue]+1;
                photoName=[[NSString alloc] initWithFormat:@"%d.jpg",photoNumber];
            }
            NSString *filePath=[self.photoPath stringByAppendingPathComponent:photoName];
            NSData *photoData=UIImageJPEGRepresentation(photo, 0.8);
            if ([photoData writeToFile:filePath atomically:YES]) {
                
                NSManagedObjectContext *context=[[AppDelegate App] managedObjectContext];
                NSEntityDescription *entity=[NSEntityDescription entityForName:@"CasePhoto" inManagedObjectContext:context];
                CasePhoto *newPhoto=[[CasePhoto alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
                newPhoto.caseinfo_id = self.caseID;
                newPhoto.photo_name = photoName;
                
                [[AppDelegate App] saveContext];
                [self.photoArray insertObject:photoName atIndex:self.imageIndex];
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    LOADPHOTOS;
                    self.leftImageView.image = [self cachePhotoForIndex:self.imageIndex-1];
                    self.midImageView.image = [self cachePhotoForIndex:self.imageIndex];
                    self.rightImageView.image = [self cachePhotoForIndex:self.imageIndex+1];
                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideLabelWithAnimation) userInfo:nil repeats:NO];
                });
            }
            
            if (self.photoArray.count<3) {
                
                self.imageScrollView.contentSize = CGSizeMake(SCROLLVIEW_WIDTH*self.photoArray.count
                                                              , SCROLLVIEW_HEIGHT);
            }else
            {
                self.imageScrollView.contentSize = CGSizeMake(SCROLLVIEW_WIDTH*3
                                                              , SCROLLVIEW_HEIGHT);
            }
            
        });
        dispatch_release(myqueue);
    }
    if ([self.caseInfoPickerpopover isPopoverVisible]) {
        [self.caseInfoPickerpopover dismissPopoverAnimated:YES];
    } else {
        [picker dismissModalViewControllerAnimated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if ([self.caseInfoPickerpopover isPopoverVisible]) {
        [self.caseInfoPickerpopover dismissPopoverAnimated:YES];
    } else {
        [picker dismissModalViewControllerAnimated:YES];
    }
}

//载入案件对应的照片
- (void)loadCasePhotoForCase:(NSString *)caseID{
    
    [self.photoArray removeAllObjects];
    NSArray *tempArray = [CasePhoto casePhotosForCase:caseID];
    self.photoArray = [(NSArray *)[tempArray valueForKeyPath:@"photo_name"] mutableCopy];
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [pathArray objectAtIndex:0];
    NSString *photoPath = [NSString stringWithFormat:@"CasePhoto/%@",caseID];
    self.photoPath = [documentPath stringByAppendingPathComponent:photoPath];
    self.imageIndex = 0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

//显示删除标签
- (void)showDeleteMenu:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (self.photoArray.count > 0) {
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            UIMenuItem *deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deletePiece:)];
            [self becomeFirstResponder];
            [menuController setMenuItems:@[deleteMenuItem]];
            [menuController setTargetRect:CGRectMake(self.imageScrollView.frame.origin.x + SCROLLVIEW_WIDTH/2, self.imageScrollView.frame.origin.y + SCROLLVIEW_HEIGHT/2, 0, 0) inView:self.view];
            [menuController setMenuVisible:YES animated:YES];
        }
    }
}

//删除对应照片
- (void)deletePiece:(UIMenuController *)controller
{
    NSString *photoName = [self.photoArray objectAtIndex:self.imageIndex];
    [CasePhoto deletePhotoForCase:self.caseID photoName:photoName];
    NSString *photoPath = [self.photoPath stringByAppendingPathComponent:photoName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:photoPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:photoPath error:nil];
    }
    
    [self.photoArray removeObjectAtIndex:self.imageIndex];
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        LOADPHOTOS;
        self.leftImageView.image = [self cachePhotoForIndex:self.imageIndex-1];
        self.midImageView.image = [self cachePhotoForIndex:self.imageIndex];
        self.rightImageView.image = [self cachePhotoForIndex:self.imageIndex+1];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideLabelWithAnimation) userInfo:nil repeats:NO];
    });
}

- (UIImage *)cachePhotoForIndex:(NSInteger)index{
    if (self.photoArray.count>0) {
        NSString *photoPath;
        if (index<0) {
            photoPath=[self.photoPath stringByAppendingPathComponent:[self.photoArray lastObject]];
        } else if (index>(self.photoArray.count-1)) {
            photoPath=[self.photoPath stringByAppendingPathComponent:[self.photoArray objectAtIndex:0]];
        } else {
            photoPath=[self.photoPath stringByAppendingPathComponent:[self.photoArray objectAtIndex:index]];
        }
        
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:photoPath];
        CGImageRef imageRef = [image CGImage];
        CGRect rect = CGRectMake(0.f, 0.f, SCROLLVIEW_WIDTH/3*4, SCROLLVIEW_HEIGHT);
        CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                           rect.size.width,
                                                           rect.size.height,
                                                           CGImageGetBitsPerComponent(imageRef),
                                                           CGImageGetBytesPerRow(imageRef),
                                                           CGImageGetColorSpace(imageRef),
                                                           kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little
                                                           );
        
        CGContextDrawImage(bitmapContext, rect, imageRef);
        CGImageRef compressedImageRef = CGBitmapContextCreateImage(bitmapContext);
        UIImage* compressedImage = [[UIImage alloc] initWithCGImage: compressedImageRef];
        CGImageRelease(compressedImageRef);
        CGContextRelease(bitmapContext);
        return compressedImage;
    } else {
        return nil;
    }
}

//实现照片的循环和载入
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.imageScrollView]) {
        CGFloat pageWidth= WIDTH_OFF_SET;
        // 0 1 2
        int page = floor((self.imageScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        if(page == 1) {
            
        } else if (page == 0) {
            [self allImagesMoveRight:pageWidth];
            self.imageIndex--;
        } else {
            [self allImagesMoveLeft:pageWidth];
            self.imageIndex++;
        }
        if (self.imageIndex<0) {
            self.imageIndex=self.photoArray.count-1;
        } else if (self.imageIndex>(self.photoArray.count-1)) {
            self.imageIndex=0;
        }
        [UIView transitionWithView:self.imageScrollView
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            LOADPHOTOS;
                        }
                        completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideLabelWithAnimation) userInfo:nil repeats:NO];
        [scrollView setContentOffset:CGPointMake(SCROLLVIEW_WIDTH, 0) animated:NO];
        self.leftImageView.image = [self cachePhotoForIndex:self.imageIndex - 1];
        self.rightImageView.image = [self cachePhotoForIndex:self.imageIndex + 1];
    }
}

- (IBAction)backButton:(UIBarButtonItem *)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setImageScrollView:nil];
    [self setLabelPhotoIndex:nil];
    [self setUiButtonCamera:nil];
    [self setUiButtonPickFromLibrary:nil];
    [super viewDidUnload];
}
@end
