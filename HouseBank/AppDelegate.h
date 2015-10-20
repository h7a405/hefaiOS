//
//  AppDelegate.h
//  HouseBank
//
//  Created by 鹰眼 on 14-9-11.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import <CoreData/CoreData.h>
@class CustomStatueBar;
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>
{
    
    CLLocationManager *_location;
}


@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)CustomStatueBar* statueBar;
+(AppDelegate *) shareApp;
-(void)showMessage:(NSString *)message;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
