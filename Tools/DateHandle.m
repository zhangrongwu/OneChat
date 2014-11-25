//
//  DateHandle.m
//  OneChat
//
//  Created by laowang on 14-10-10.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import "DateHandle.h"

@implementation DateHandle

+ (NSString *) compareCurrentTime:(NSDate *)compareDate
{
    
    //从已有日期获取日期
    NSDate *now = [NSDate date];
    unsigned units  = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit;
    NSCalendar *myCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp1 = [myCal components:units fromDate:now];
    NSInteger mon = [comp1 month];
    NSInteger year = [comp1 year];
    NSInteger day = [comp1 day];
    //获得系统时间
    NSDate *  senddate = [NSDate date];
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"HH:mm"];
//    NSString *  locationString=[dateformatter stringFromDate:senddate];
    //[dateformatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
    //NSString *  morelocationString=[dateformatter stringFromDate:senddate];
    
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags = NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
//    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
//    NSInteger day=[conponent day];
//    NSString *  nsDateString= [NSString  stringWithFormat:@"%4d年%2d月%2d日",year,month,day];
    
    

    
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    //   NSLog(@"time == %f", timeInterval);
    long temp = 0;
    NSString *result;
    if (timeInterval < 60 * 3) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    //时间在今年
    else if((temp = temp /24 / 30) < month){
        
        result = [NSString stringWithFormat:@"%d-%d",mon, day];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%d-%d-%d", year % 100, mon, day];
    }
    
    return  result;
}

+ (NSString *)handleDate:(NSString *)string
{
//    string = @"Fri Oct 10 14:30:10 +0800 2014";
//    NSString* string = @"Wed, 3 Apr 2013 04:11:02 GMT";
//    DLog(@"+++++++%@", string);
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    

//    NSLog(@"testDate:%@", str);
//
////    
//    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
//
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
////
////    //获取时间差 NSDateFormatterFullStyle
////    //@"1992-05-21 13:08:08"
//    NSDate *requestDate = [formatter dateFromString:str];
//    NSLog(@"date----%@", requestDate);
    
    NSString *ss = [self compareCurrentTime:inputDate];
//    DLog(@"------%@", ss);
    return ss;
    
}
+ (NSString *)handleTime:(NSString *)timeStr
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDate* inputDate = [inputFormatter dateFromString:timeStr];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    
    //从已有日期获取日期
    NSDate *now = [NSDate date];
    unsigned units  = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit;
    NSCalendar *myCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp1 = [myCal components:units fromDate:now];;
    NSInteger y = [comp1 year];
    
    //获得系统日期
    NSDate *  senddate = [NSDate date];
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags = NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    //    NSInteger year=[conponent year];
    NSInteger year =[conponent year];
    if (year != y) {
        [outputFormatter setDateFormat:@"yy-MM-dd HH:mm"];
    } else {
        [outputFormatter setDateFormat:@"MM-dd HH:mm"];
    }
    NSString *str = [outputFormatter stringFromDate:inputDate];
    
    return str;
}

@end
