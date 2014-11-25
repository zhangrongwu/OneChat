//
//  DateHandle.h
//  OneChat
//
//  Created by laowang on 14-10-10.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHandle : NSObject

+ (NSString *)handleDate:(NSString *)date;
+ (NSString *)handleTime:(NSString *)timeStr;
//- (NSString *) compareCurrentTime:(NSDate*) compareDate;

@end
