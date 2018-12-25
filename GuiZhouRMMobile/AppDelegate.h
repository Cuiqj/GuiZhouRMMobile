//
//  AppDelegate.h
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
+ (AppDelegate *)App;
@property (nonatomic,strong)NSString *serverAddress;
@property (nonatomic,strong)NSString *fileAddress;
@property (nonatomic,strong) NSOperationQueue *operationQueue;
-(void)initServer;


-(NSMutableArray *)getAllOrgInfo:(NSString *)belongtoid;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void)clearEntityForName:(NSString *)entityName;

-(NSString *)getOrgName:(NSString *)orgid;
 
-(NSString *)getUserName:(NSString *)account;

-(NSMutableArray *)getIconInfoByType:(NSString *)iconType;
-(NSMutableArray *)getIconInfoByName:(NSString *)iconName;

@end
