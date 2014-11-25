//
//  ContactsCell.h
//  OneChat
//
//  Created by laowang on 14-10-8.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsModel.h"

@interface ContactsCell : UITableViewCell

@property (nonatomic, strong)ContactsModel *contact;
@property (strong, nonatomic) IBOutlet UIImageView *faceImg;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;

@end
