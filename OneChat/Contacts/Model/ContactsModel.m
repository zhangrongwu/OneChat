//
//  ContactsModel.m
//  OneChat
//
//  Created by laowang on 14-10-7.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import "ContactsModel.h"

@implementation ContactsModel

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.uid = [dic objectForKey:@"idstr"];
        self.screen_name = [dic objectForKey:@"screen_name"];
        self.name = [dic objectForKey:@"name"];
        self.profile_image_url = [dic objectForKey:@"profile_image_url"];
        self.remark = [dic objectForKey:@"remark"];
        self.description = [dic objectForKey:@"description"];
    }
    return self;
}

@end
