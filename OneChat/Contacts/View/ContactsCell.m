//
//  ContactsCell.m
//  OneChat
//
//  Created by laowang on 14-10-8.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import "ContactsCell.h"
#import "UIImageView+WebCache.h"

@implementation ContactsCell

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
    self.faceImg.clipsToBounds = YES;
    self.faceImg.layer.cornerRadius = self.faceImg.frame.size.height / 2;
    
}
- (void)setContact:(ContactsModel *)contact
{
    if (contact != _contact) {
        _contact = contact;
    }
    if ([self.contact.remark isEqualToString:@""]) {
        self.nameLabel.text = contact.name;
    } else {
        self.nameLabel.text = contact.remark;
    }
    if ([contact.description isEqualToString:@""]) {
        self.descLabel.text = @"暂无描述";
    } else {
        self.descLabel.text = contact.description;
    }
    [self.faceImg setImageWithURL:[NSURL URLWithString:contact.profile_image_url]];
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
