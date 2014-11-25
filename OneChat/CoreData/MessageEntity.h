//
//  MessageEntity.h
//  OneChat
//
//  Created by laowang on 14-10-14.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MessageEntity : NSManagedObject

@property (nonatomic, retain) NSString * senderUid;    //发送者id
@property (nonatomic, retain) NSString * receiverUid;  //接受者id
@property (nonatomic, retain) NSString * messageId;    //消息id
@property (nonatomic, retain) NSString * message;      //消息内容
@property (nonatomic, retain) NSNumber * isRead;       //是否已读
@property (nonatomic, retain) NSNumber * isSender;     //是否是发送者

@end
