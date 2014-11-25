//
//  ChatCell.m
//  OneChat
//
//  Created by laowang on 14-10-9.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import "ChatCell.h"
#import "UIImageView+WebCache.h"
#import "UILabel+StringFrame.h"

@implementation ChatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    self.faceImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_faceImg];
    
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_messageLabel];
}
- (void)setImageUrl:(NSString *)imageUrl
{
    if (_imageUrl != imageUrl) {
        _imageUrl = imageUrl;
    }
//    DLog(@"---%@", imageUrl);
    
//    [self.faceImg setImageWithURL:[NSURL URLWithString:imageUrl]];
}
- (void)setContent:(NSString *)content
{
    if (_content != content) {
        _content = content;
    }
    
    self.messageLabel.text = content;
}
- (void)setIsSender:(NSString *)isSender
{
    if (_isSender != isSender) {
        _isSender = isSender;
    }
//    [isSender componentsSeparatedByString:@"|"];
    
    self.messageLabel.backgroundColor = UIColorFromRGB(0x00BFFF);
    self.messageLabel.clipsToBounds = YES;
    self.messageLabel.layer.cornerRadius = 4;
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.font = [UIFont systemFontOfSize:19];
    CGFloat height = [self.messageLabel boundingRectWithSize:CGSizeMake(180, 0)].height + 5;
    //不是发送者
    if ([isSender isEqualToString:@"0"]) {
//        [self.faceImg setImageWithURL:[NSURL URLWithString:_imageUrl]];
        self.faceImg.image = _faceIma;
        self.faceImg.frame = CGRectMake(10, 10, 40, 40);
        self.messageLabel.frame = CGRectMake(60, 10, 180, height);
        if (height < 40) {
            self.messageLabel.frame = CGRectMake(60, 10, [self.messageLabel boundingRectWithSize:CGSizeMake(0, 40)].width + 5, 40);
        }
        self.messageLabel.textAlignment = NSTextAlignmentLeft;
    } else {
        NSString *url = [[NSUserDefaults standardUserDefaults] valueForKey:@"imageUrl"];
        [self.faceImg setImageWithURL:[NSURL URLWithString:url]];
        self.faceImg.frame = CGRectMake(270, 10, 40, 40);
        self.messageLabel.frame = CGRectMake(80, 10, 180, height);
        if (height < 40) {
            self.messageLabel.frame = CGRectMake(260 - [self.messageLabel boundingRectWithSize:CGSizeMake(0, 40)].width - 5, 10, [self.messageLabel boundingRectWithSize:CGSizeMake(0, 40)].width + 5, 40);
        }
        self.messageLabel.textAlignment = NSTextAlignmentLeft;
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
