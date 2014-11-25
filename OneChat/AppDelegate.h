//
//  AppDelegate.h
//  OneChat
//
//  Created by laowang on 14-10-7.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, WeiboSDKDelegate, IChatManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *wbtoken;

@property (nonatomic, strong)UIActivityIndicatorView *indicator;
@property (nonatomic, strong)UIView *loadingView;
@property (nonatomic, strong)UILabel *label;

//数据管理类
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//数据模型
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//数据连接器
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
