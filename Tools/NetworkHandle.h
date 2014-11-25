//
//  NetworkHandle.h
//  豆瓣电影2.0
//
//  Created by 王强 on 14-8-25.
//  Copyright (c) 2014年 lanou3g.com 蓝鸥科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkHandle : NSObject

///  通过get请求获得数据
- (void)getDataWithURL:(NSString *)path resultBlock:(void(^)(id result))block;

///  创建一个类方法 少写一个alloc对象的过程
+ (void)netWorkHandleGetDataWithURL:(NSString *)path resultBlock:(void(^)(id result))block;

@end
