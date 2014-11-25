//
//  NetworkHandle.m
//  豆瓣电影2.0
//
//  Created by 王强 on 14-8-25.
//  Copyright (c) 2014年 lanou3g.com 蓝鸥科技. All rights reserved.
//

#import "NetworkHandle.h"

@implementation NetworkHandle

- (void)getDataWithURL:(NSString *)path resultBlock:(void(^)(id result))block
{
    //封装的网络请求
    
    //1.创建请求
    
    //对地址进行加工处理,转码成UTF-8格式
    NSString *urlStr = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    request.HTTPMethod = @"get";
    
    //2.连接服务器
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
       
        //3.获取到数据 处理
        if (data != nil) {
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            //利用传入的block 处理结果数据
            block(result);
            
        }
    }];
    
    
    
}

+ (void)netWorkHandleGetDataWithURL:(NSString *)path resultBlock:(void(^)(id result))block
{
    NetworkHandle *netWork = [[NetworkHandle alloc] init];
    
    [netWork getDataWithURL:path resultBlock:block];
    
}

@end
