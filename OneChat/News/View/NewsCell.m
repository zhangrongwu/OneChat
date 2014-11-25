//
//  NewsCell.m
//  OneChat
//
//  Created by laowang on 14-10-9.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import "NewsCell.h"
#import "UIImageView+WebCache.h"
#import "UILabel+StringFrame.h"
#import "DateHandle.h"
#import "AFNetworking.h"
#import "AppDelegate.h"

@implementation NewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteWeibo:)];
        [self.contentView addGestureRecognizer:longPress];
        
        self.dic = [NSDictionary dictionary];
        self.imgArray = [NSMutableArray array];
        
        self.bgView = [[UIView alloc] init];
        [self.contentView addSubview:_bgView];
        
        self.faceImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.bgView addSubview:_faceImg];
        
        self.namelabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.bgView addSubview:_namelabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.bgView addSubview:_timeLabel];
        
        
        self.fromLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.bgView addSubview:_fromLabel];
        
        self.textLab = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.bgView addSubview:_textLab];
        
        
        self.repostView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.bgView addSubview:_repostView];
        
        self.repostLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.repostView addSubview:_repostLabel];
        
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.bgView addSubview:_imgView];
        
        self.lineLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.repostView addSubview:_lineLabel1];
        
//        self.lineLabel2 = [[UILabel alloc] initWithFrame:CGRectZero];
//        [self.repostView addSubview:_lineLabel2];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}
- (void)setDic:(NSDictionary *)dic
{
    if (_dic != dic) {
        _dic = dic;
    }
    [self.repostLabel.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.bgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSDictionary *userDic = [dic objectForKey:@"user"];
    [self.faceImg setImageWithURL:[NSURL URLWithString:[userDic objectForKey:@"profile_image_url"]]];
    [self.bgView addSubview:_faceImg];
    self.namelabel.text = [userDic objectForKey:@"name"];
    [self.bgView addSubview:_namelabel];
    NSString *time = [DateHandle handleDate:[dic objectForKey:@"created_at"]];
    if ([time isEqualToString:@"刚刚"]) {
        self.timeLabel.textColor = [UIColor orangeColor];
    } else {
        self.timeLabel.textColor = [UIColor blackColor];
    }
    self.timeLabel.text = time;
    [self.bgView addSubview:_timeLabel];
    NSString *source = [dic objectForKey:@"source"];
    int start = [source rangeOfString:@">"].location;
    NSRange range = NSMakeRange(start + 1, source.length - 5 - start);
    self.fromLabel.text = [NSString stringWithFormat:@"来自%@", [source substringWithRange:range]];
    [self.contentView addSubview:_fromLabel];
    self.textLab.text = [dic objectForKey:@"text"];
    self.height1 = [self.textLab boundingRectWithSize:CGSizeMake(300, 0)].height;
    self.textLab.frame = CGRectMake(10, 45, 300, _height1);
    [self.bgView addSubview:_textLab];
    
    
    if ([[dic objectForKey:@"pic_urls"] count] != 0) {
        [self.bgView addSubview:_imgView];
    }
    
    //该微博是转发的
    if ([dic objectForKey:@"retweeted_status"] != nil) {
        [self.repostView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)]
        ;
        
        NSDictionary *newsDic = [dic objectForKey:@"retweeted_status"];
        NSString *str = [[newsDic objectForKey:@"user"] objectForKey:@"name"];
        self.repostLabel.text = [NSString stringWithFormat:@"@%@:%@", str, [newsDic objectForKey:@"text"]];
        self.repostView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.25];
        self.height2 = [self.repostLabel boundingRectWithSize:CGSizeMake(300, 0)].height + 20;
        self.repostLabel.frame = CGRectMake(0, 5, 300, _height2 - 20);
        self.repostView.frame = CGRectMake(10, _height1 + 50, 300, _height2 - 10);
        
        if ([[newsDic objectForKey:@"pic_urls"] count] != 0) {
            [self.bgView addSubview:_imgView];
        }
        
        [self.repostView addSubview:_repostLabel];
        [self.bgView addSubview:_repostView];
        
        self.lineLabel1.frame = CGRectMake(0, 50 + _height1 + _height2, 320, 1.25);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self.repostView addGestureRecognizer:tap];
        
        
    } else {
        
        self.repostLabel.frame = CGRectZero;
        self.repostView.frame = CGRectZero;
        
        _height2 = 0;
        
        self.lineLabel1.frame = CGRectMake(0, 50 + _height1, 320, 1.25);
    }
    
    [self.bgView addSubview:_lineLabel1];
    
//    self.lineLabel2.frame = CGRectMake(0, 80 + _height1 + _height2, 320, 0.25);
//    [self.contentView addSubview:_lineLabel2];
    
    
    self.bgView.frame = CGRectMake(0, 0, 320, 51 + _height1 + _height2);
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.faceImg.frame = CGRectMake(10, 5, 33, 33);
    self.faceImg.clipsToBounds = YES;
    self.faceImg.layer.cornerRadius = 3;
    
    self.namelabel.frame = CGRectMake(50, 5, 200, 20);
    self.namelabel.textColor = [UIColor orangeColor];
    self.timeLabel.frame = CGRectMake(50, 25, 50, 15);
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.fromLabel.frame = CGRectMake(100, 25, 150, 15);
    self.fromLabel.font = [UIFont systemFontOfSize:11];
    self.fromLabel.textColor = [UIColor grayColor];
    
    self.imgView.frame = CGRectMake(270, 24, 20, 15);
    self.imgView.image = [UIImage imageNamed:@"Fav_Img_Download@2x.png"];
//    self.imgView.backgroundColor = [UIColor orangeColor];
    //    self.textLab.frame = CGRectMake(10, 35, 300, 10);
    self.textLab.numberOfLines = 0;
    self.textLabel.font = [UIFont systemFontOfSize:16];
    
    self.repostLabel.numberOfLines = 0;
    self.repostLabel.font = [UIFont systemFontOfSize:15];
    
    self.lineLabel1.backgroundColor = [UIColor colorWithWhite:0.75 alpha:0.5];
    
//    self.lineLabel2.backgroundColor = [UIColor lightGrayColor];
}
#pragma mark - 转发视图手势
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    self.weiboInfoBlock([self.dic objectForKey:@"retweeted_status"]);
    
}

- (void)deleteWeibo:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateEnded) {
        DLog(@"-----flag----%d", _flag);
        if (_flag == 0) {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"确定转发微博?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
            action.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [action showInView:[UIApplication sharedApplication].keyWindow];
        } else {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"确定删除微博?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles: nil];
            action.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [action showInView:[UIApplication sharedApplication].keyWindow];

        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (_flag == 0) {  //删除微博
            self.zhuanfaBlock([self.dic objectForKey:@"idstr"]);
        } else {           //转发微博
            self.deleteBlock([self.dic objectForKey:@"idstr"]);
        }
        
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
