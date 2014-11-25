//
//  AppDelegate.m
//  OneChat
//
//  Created by laowang on 14-10-7.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TTGlobalUICommon.h"
#import "MessageEntity.h"
#import "AFNetworking.h"
#import "ViewController.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"lanouclass15#lanou3ghehe" apnsCertName:nil];
#if DEBUG
    [[EaseMob sharedInstance] enableUncaughtExceptionHandler];
#endif
    
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    //注册listener,以接收聊天消息
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    // Override point for customization after application launch.
    
    self.window.backgroundColor = [UIColor whiteColor];
    
   
//    NSLog(@"====%@", NSTemporaryDirectory());

    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    DLog(@"resignActive");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DLog(@"back");
    //注册listener,以接收聊天消息
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    if ([request isKindOfClass:WBProvideMessageForWeiboRequest.class])
    {
        DLog(@"xxxx");
    }
}
// 微博登陆之后回调函数
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        //        NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
        
        NSString *uid = [response.userInfo objectForKey:@"uid"];
        DLog(@"登陆--%@", uid);
        
        if (uid != nil) {
           
            //注册环信
            [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:uid password:@"123456" withCompletion:^(NSString *username, NSString *password, EMError *error) {
                
                if (!error) {
                    
                    DLog(@"--%@", uid);
                    
                } else {
                    switch (error.errorCode) {
                        case EMErrorServerNotReachable:
//                            TTAlertNoTitle(@"连接服务器失败!");
                            break;
                        case EMErrorServerDuplicatedAccount:
//                            TTAlertNoTitle(@"您注册的用户已存在!");
                            break;
                        case EMErrorServerTimeout:
//                            TTAlertNoTitle(@"连接服务器超时!");
                            break;
                        default:
//                            TTAlertNoTitle(@"注册失败");
                            break;
                    }
                }
            } onQueue:nil];

            
            
            self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
            self.loadingView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
            self.loadingView.center = self.window.center;
            [self.window addSubview:_loadingView];
            
            self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            self.indicator.color = [UIColor orangeColor];
            self.indicator.center = self.window.center;
            [self.window addSubview:_indicator];
            [self.indicator startAnimating];
            
//            self.label = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 80, 30)];
//            self.label.textColor = [UIColor blueColor];
//            self.label.text = @"正在登录";
//            [self.window addSubview:_label];
            
            CATransition *animation = [CATransition animation];
            animation.delegate = self;
            animation.duration = 0.3;
            animation.timingFunction = UIViewAnimationCurveEaseInOut;
            animation.type = kCATransitionMoveIn;
            
            //登录环信
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:uid
                                                                password:@"123456"
                                                              completion:
             ^(NSDictionary *loginInfo, EMError *error) {
                 if (!error) {
                     DLog(@"--%@登录成功", [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"]);
                     
                     [self.indicator stopAnimating];
                     [self.loadingView removeFromSuperview];
                     
                     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                     //  获取storyboard中的入口视图控制器对象
                     UIViewController *viewController = [mainStoryboard instantiateInitialViewController];
                     [self.window.rootViewController presentViewController:viewController animated:NO completion:^{
                         
                     }];
                     
                     [[viewController.view layer] addAnimation:animation forKey:@"animation"];
                     
                     self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
                     NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                     [user setValue:uid forKey:@"uid"];
                     [user setValue:_wbtoken forKey:@"wbtoken"];
                     [user setValue:@"Yes" forKey:@"isLogin"];
                     
                     [self request];
                     
                     //立即同步
                     
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     
                 }
             } onQueue:nil];
            
            
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败,请从新登陆"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
//            LoginViewController *loginVC = [[LoginViewController alloc] init];
//            [self.window.rootViewController presentViewController:loginVC animated:NO completion:^{
//                
//            }];
        }
        
        

        
    }
}
// 获取个人信息
- (void)request
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates =  YES;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/css", @"text/html", @"text/plain", nil];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *path = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@", [user objectForKey:@"wbtoken"], [user objectForKey:@"uid"]];
    DLog(@"path--%@", path);
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        [user setValue:[responseObject objectForKey:@"avatar_hd"] forKey:@"imageUrl"];
        [user setValue:[responseObject objectForKey:@"screen_name"] forKey:@"name"];
        NSString *desc = [responseObject objectForKey:@"description"];
        if (![desc isEqualToString:@""]) {
            desc = [desc substringToIndex:[desc rangeOfString:@"-"].location];
        }
        [user setValue:desc forKey:@"description"];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"error:%@", error);
    }];
}
#pragma mark - 收到消息
-(void)didReceiveMessage:(EMMessage *)message {
    
    // 收到消息时，震动
    [[EaseMob sharedInstance].deviceManager asyncPlayVibration];
    // 收到消息时，播放音频
//    [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
    
    EMTextMessageBody *body = [message.messageBodies firstObject];
    DLog(@"---%@", message);
    NSString *fromUid = message.from;
    
    
    MessageEntity *messageEntity = [NSEntityDescription  insertNewObjectForEntityForName:@"MessageEntity" inManagedObjectContext:self.managedObjectContext];
    messageEntity.senderUid = fromUid;
    messageEntity.receiverUid =  message.to;
    messageEntity.messageId =  message.messageId;
    
    if (body.messageBodyType == eMessageBodyType_Text) {
        NSString *msg = ((EMTextMessageBody *)body).text;
        
        DLog(@"收到的消息---%@", msg);
        messageEntity.message = msg;
    } else {
        messageEntity.message = @"其他类型消息,处理错误";
    }
    
    messageEntity.isRead = NO;
    messageEntity.isSender = NO;
    
    
    NSError *error;
    [self.managedObjectContext save:&error];
    if (!error) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"插入成功" message:nil
//                                                       delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//        [alert show];

        DLog(@"收到消息");
        
    } else {
        NSLog(@"Error:%@", error);
    }

    
}


#pragma mark - coreData
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;

    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    //创建连接器
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MessageData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
//连接器get方法
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    //数据库url
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MessageData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *dic = @{NSMigratePersistentStoresAutomaticallyOption: @(YES)};
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:dic error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end
