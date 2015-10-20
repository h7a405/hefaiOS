//
//  AppDelegate.m
//  HouseBank
//
//  Created by 鹰眼 on 14-9-11.
//  Copyright (c) 2014年 QCloud. All rights reserved.
//

#import "AppDelegate.h"
#import "XSNotification.h"
#import "CustomStatueBar.h"
#import "Address.h"
#import "Tool.h"
#import "XGPush.h"
#import "Constants.h"
#import "Share.h"
#import "FYUserDao.h"
#import "FYUploadCityTask.h"
#import "SWRevealViewController.h"
#import "LaunchViewController.h"

#define PUSHKey 2200052744
#define PUSHACCESSKEY @"I7JNZ689UW6D"

BMKMapManager *_manager;
@implementation AppDelegate
-(void)shareSDKRegister
{
    
    [ShareSDK registerApp:KShareSDKKey];
    
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:KWeiboKey
                                appSecret:@"e7dd12d381aea220dba0ee5a9aa2b543"
                              redirectUri:@"https://api.weibo.com/oauth2/default.html"
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
    [ShareSDK connectTencentWeiboWithAppKey:KTXWbKey
                                  appSecret:@"511def3606d8b3b8ef2ad45c99b63119"
                                redirectUri:@"http://dl.fybanks.com"
                                   wbApiCls:[WeiboApi class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    //    [ShareSDK connectQZoneWithAppKey:KQQKey
    //                           appSecret:nil
    //                   qqApiInterfaceCls:[QQApiInterface class]
    //                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wxeea5e1a6a2a0f2bc"
                           wechatCls:[WXApi class]];
    
}
/**
 *  注册推送
 */
- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor redColor];
    
    if(launchOptions){//保存推送消息
        [self saveNotification:launchOptions];
    }
    [self setupLocationInfo];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden=NO;
    [self shareSDKRegister];
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0) {
        _location=[[CLLocationManager alloc]init];
        [_location requestAlwaysAuthorization];
    }
    
#endif
    
    _manager=[[BMKMapManager alloc]init];
    [_manager start:KBMapKey generalDelegate:self];
    
    if (![FYUserDao new].isLaunch) {
        self.window.rootViewController = [LaunchViewController new];
    }else{
        self.window.rootViewController=[[UIStoryboard storyboardWithName:@"Home" bundle:nil]instantiateViewControllerWithIdentifier:@"RootViewController"];
    }
    
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registerPushForLoginSuccess) name:KLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removePushForLoginOut) name:KLoginOut object:nil];
    
    //清除角标
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    
    return YES;
}
/**
 *  登录成功后注册推送
 */
-(void)registerPushForLoginSuccess
{
    [self startXGPush:nil];
}
/**
 *  注销推送
 */
-(void)removePushForLoginOut
{
    [XGPush startApp:PUSHKey appKey:PUSHACCESSKEY];
    [XGPush unRegisterDevice:^{
        NSLog(@"成功");
    } errorCallback:^{
        NSLog(@"失败");
    }];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //注册设备
    [XGPush registerDevice: deviceToken];
    
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    NSLog(@"%@",str);
}

-(void) startXGPush : (NSDictionary *)launchOptions {
    [XGPush startApp:PUSHKey appKey:PUSHACCESSKEY];
    
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [self registerPush];
            }
            else{
                [self registerPushForIOS8];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [self registerPush];
#endif
        }
    };
    FYUserDao *userDao = [FYUserDao new];
    UserBean *user = [userDao user];
    
    [XGPush initForReregister:successCallback];
    [XGPush setAccount:user.mobilephone];
    //[XGPush registerPush];  //注册Push服务，注册后才能收到推送
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //清除所有通知(包含本地通知)
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        NSLog(@"[XGPush]handleLaunching's successBlock");            //成功之后的处理
    };
    
    void (^errorBlock)(void) = ^(void){
        NSLog(@"[XGPush]handleLaunching's errorBlock");            //失败之后的处理
    };
    
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo{
    [XGPush handleReceiveNotification:userInfo];
    [self saveNotification:userInfo];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

+(AppDelegate *) shareApp{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
};

-(void)showMessage:(NSString *)message
{
    
    if (_statueBar==nil) {
        _statueBar= [[CustomStatueBar alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    }
    [_statueBar showStatusMessage:message];
    [_statueBar fullStatueBar:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_statueBar fullStatueBar:NO];
    });
}
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
-(void)saveNotification:(NSDictionary *)tmp
{
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:tmp];
    [dict setObject:dict[@"aps"][@"alert"] forKey:@"content"];
    BOOL result=[XSNotification notificationWithDict:dict];
    NSLog(@"%d",result);
    
}
#pragma mark - 百度地图授权回调
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
        
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}
- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}
#pragma mark - 初始化默认位置
-(void)setupLocationInfo
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    if ([user objectForKey:KLocationCityName]==nil) {
        [user setObject:@"全国" forKey:KLocationCityName];
        [user setObject:@"0" forKey:KLocationCityId];
        [user synchronize];
    }
}



#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.qi-cloud.coredata" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"data" withExtension:@"momd"];
    
    
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"data.sqlite"];
    NSError *error = nil;
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                                       NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                                       NSInferMappingModelAutomaticallyOption, nil];
    NSLog(@"%@",optionsDictionary);
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:optionsDictionary error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
