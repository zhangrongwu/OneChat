//
//  PhotosViewController.h
//  OneChat
//
//  Created by laowang on 14-10-18.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosViewController : UIViewController

@property (nonatomic, strong)NSString *imageUrl;
@property (nonatomic, assign)int index;  //点击图片的下标
@property (nonatomic, strong)NSArray *imgArr;

@end
