//
//  ChattingViewController.h
//  OneChat
//
//  Created by laowang on 14-10-7.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsModel.h"

@interface ChattingViewController : UIViewController


@property (nonatomic, strong)ContactsModel *contact;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *array;   //数据源
@property (strong, nonatomic) NSMutableArray *flagArray; //是否是发送者

@property (strong, nonatomic) EMConversation *conversation;//会话管理者

@end
