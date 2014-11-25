//
//  ChatListViewController.m
//  OneChat
//
//  Created by laowang on 14-10-14.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChattingViewController.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "AppDelegate.h"
#import "MessageEntity.h"
#import "ChatListCell.h"
#import "NSDate+Category.h"
#import "AFNetworking.h"
#import "ContactsModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

@interface ChatListViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, IChatManagerDelegate>

@property (nonatomic, strong)NSMutableArray *array;  //数据源
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)ContactsModel *contact;

@property (nonatomic, strong)NSMutableArray *modelArr;

@end

@implementation ChatListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.array = [NSMutableArray array];
    self.modelArr = [NSMutableArray array];
    self.contact = [[ContactsModel alloc] init];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    self.array = [self loadDataSource];
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    
    self.tabBarItem.badgeValue = @"111";
    
    [self tableView];
    
    self.array = [self loadDataSource];
    
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    self.managedObjectContext = app.managedObjectContext;
    
    [self setupRefresh];

}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//        self.tableView
        [self.view addSubview:_tableView];
//        _tableView.backgroundColor = [UIColor orangeColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ChatListCell class] forCellReuseIdentifier:@"chatListCell"];
    }
    
    return _tableView;
}
#pragma mark - private

- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    //获取当前登陆用户的会话对象列表
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    
    NSMutableArray *arr = [NSMutableArray array];
    
//    DLog(@"----%d", conversations.count);

    for (EMConversation *conversation in conversations) {
        if (conversation.messages.count != 0) {
            [arr addObject:conversation];
        }
    }
    NSArray* sorte = [arr sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    return ret;
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = @"[图片]";
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                ret = didReceiveText;
            } break;
            case eMessageBodyType_Voice:{
                ret = @"[声音]";
            } break;
            case eMessageBodyType_Location: {
                ret = @"[位置]";
            } break;
            case eMessageBodyType_Video: {
                ret = @"[视频]";
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}

#pragma mark - TableViewDelegate & TableViewDatasource

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"chatListCell";
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    
    EMConversation *conversation = [self.array objectAtIndex:indexPath.row];
    cell.name = conversation.chatter;
//    if ([conversation.chatter isEqualToString:@"admin"]) {
//        cell.name = conversation.chatter;
//    } else {
//        [self request:indexPath];
//        if (self.modelArr.count != 0) {
//            ContactsModel *contact = [self.modelArr objectAtIndex:indexPath.row];
//            if ([contact.remark isEqualToString:@""]) {
//                cell.name = contact.name;
//            } else {
//                cell.name = contact.remark;
//            }
//        }

//    }
    
    if (!conversation.isGroup) {
        cell.placeholderImage = [UIImage imageNamed:@"chatListCellHead.png"];
    }
    else{
        NSString *imageName = @"groupPublicHeader";
        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *group in groupArray) {
            if ([group.groupId isEqualToString:conversation.chatter]) {
                cell.name = group.groupSubject;
                imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                break;
            }
        }
        cell.placeholderImage = [UIImage imageNamed:imageName];
    }
    cell.detailMsg = [self subTitleMessageByConversation:conversation];
    cell.time = [self lastMessageTimeByConversation:conversation];
    cell.unreadCount = [self unreadMessageCountByConversation:conversation];
//    if (indexPath.row % 2 == 1) {
        cell.contentView.backgroundColor = [UIColor colorWithRed:246 / 255.0 green:246 / 255.0 blue:246 / 255.0 alpha:1];
//    }else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
//    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    DLog(@"--------%d", self.array.count);
    return  self.array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EMConversation *conversation = [self.array objectAtIndex:indexPath.row];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChattingViewController *chattingVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"chatting"];
    [self request:indexPath];
//    DLog(@"=====%d====", self.modelArr.count);
    chattingVC.contact = self.contact;
    
//    //根据接收者的uid获取当前会话的管理者
    chattingVC.conversation = conversation;
    
    
//    DLog(@"++++%d+++++", [[conversation loadAllMessages] count]);
    
    for (EMMessage *message in [conversation loadAllMessages]) {
        EMTextMessageBody *body = [message.messageBodies firstObject];
        //        DLog(@"---%@", message);
        if (body.messageBodyType == eMessageBodyType_Text) {
            NSString *msg = ((EMTextMessageBody *)body).text;
            //            DLog(@"收到的消息---%@", msg);
            [chattingVC.array addObject:msg];
        }
        NSString *fromUid = message.from;
        if ([fromUid isEqualToString:conversation.chatter]) {
            [chattingVC.flagArray addObject:@"0"];  //发送方
        } else {
            [chattingVC.flagArray addObject:@"1"];  //接受方
        }
    }

    self.hidesBottomBarWhenPushed = YES;
    
    [conversation markMessagesAsRead:YES];
    [self.navigationController pushViewController:chattingVC animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)request:(NSIndexPath *)indexPath
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates =  YES;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/css", @"text/html", @"text/plain", nil];
    
    EMConversation *conversation = [self.array objectAtIndex:indexPath.row];
    if ([conversation.chatter isEqualToString:@"admin"]) {
        ContactsModel *contact = [[ContactsModel alloc] init];
        contact.uid = @"admin";
        contact.name = @"admin";
        [self.modelArr addObject:_contact];
    } else {
        
        NSString *path = [NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@", Token, conversation.chatter];
        DLog(@"path--%@", path);
        [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        DLog(@"=========%@", responseObject);
            self.contact = [[ContactsModel alloc] initWithDictionary:responseObject];
            [self.modelArr addObject:_contact];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"error:%@", error);
        }];
    }
    
    
}


#pragma mark - 刷新
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
//    [self.tableView headerBeginRefreshing];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        self.array = [self loadDataSource];
        [self.tableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
    
   
}

@end
