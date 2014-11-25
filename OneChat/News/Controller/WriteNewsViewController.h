//
//  WriteNewsViewController.h
//  OneChat
//
//  Created by laowang on 14-10-11.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteNewsViewController : UIViewController

@property (nonatomic, strong)NSString *weiboId; //要转发的微博id
@property (nonatomic, assign)int flag;  //0--写微博,1--转发微博

@end
