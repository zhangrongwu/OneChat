//
//  ChatCell.h
//  OneChat
//
//  Created by laowang on 14-10-9.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell

@property (nonatomic, strong)NSString *imageUrl;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *isSender; //1为发送者,0--接受者

@property (nonatomic, strong)UIImage *faceIma;
@property (strong, nonatomic)  UIImageView *faceImg;
@property (strong, nonatomic)  UILabel *messageLabel;


@end
