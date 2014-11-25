//
//  NewsCell.h
//  OneChat
//
//  Created by laowang on 14-10-9.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell<UIActionSheetDelegate>

@property (nonatomic, strong)UIView *bgView;  //背景视图
@property (nonatomic, strong)NSDictionary *dic;
@property (nonatomic, strong)UIImageView *faceImg;
@property (nonatomic, strong)UILabel *namelabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *fromLabel;
@property (nonatomic, strong)UILabel *textLab;
@property (nonatomic, strong)UIView *repostView;   //转发微薄的view
@property (nonatomic, strong)UILabel *repostLabel; //转发
@property (nonatomic, strong)UIImageView *imgView; //是否有图
@property (nonatomic, strong)NSMutableArray *imgArray;
@property (nonatomic, strong)UILabel *lineLabel1;  //分割线1
//@property (nonatomic, strong)UILabel *lineLabel2;  //分割线2


@property (nonatomic, assign)float height1;   //发送的内容的高度
@property (nonatomic, assign)float height2;   //转发的内容的高度

@property (nonatomic, assign)int flag;   //0--为好友微博,1--登陆用户的微博

@property (nonatomic, copy)void(^deleteBlock)(NSString *weiboId);//删除
@property (nonatomic, copy)void(^zhuanfaBlock)(NSString *weiboId);//转发
@property (nonatomic, copy)void(^weiboInfoBlock)(NSDictionary *dic);//转发微博详情

@end
