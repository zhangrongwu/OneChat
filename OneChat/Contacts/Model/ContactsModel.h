//
//  ContactsModel.h
//  OneChat
//
//  Created by laowang on 14-10-7.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactsModel : NSObject

@property (nonatomic, strong)NSString *uid;
@property (nonatomic, strong)NSString *screen_name;  //用户昵称
@property (nonatomic, strong)NSString *name;        //友好显示名称
@property (nonatomic, strong)NSString *profile_image_url;  //头像
@property (nonatomic, strong)NSString *remark;   //备注
@property (nonatomic, strong)NSString *description; //描述

- (id)initWithDictionary:(NSDictionary *)dic;

@end
