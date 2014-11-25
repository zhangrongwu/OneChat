//
//  ContactsViewController.m
//  OneChat
//
//  Created by laowang on 14-10-7.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import "ContactsViewController.h"
#import "AFNetworking.h"
#import "ContactsModel.h"
#import "ContactsCell.h"
#import "ChattingViewController.h"

@interface ContactsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;
- (IBAction)swiAction:(UISegmentedControl *)sender;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *string;

@end

@implementation ContactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)request
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates =  YES;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/css", @"text/html", @"text/plain", nil];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *path = [NSString stringWithFormat:@"https://api.weibo.com/2/friendships/%@.json?access_token=%@&uid=%@&count=200&cursor=0&trim_status=1", self.string, [user objectForKey:@"wbtoken"], [user objectForKey:@"uid"]];
//    DLog(@"--%@", path);
    [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.array removeAllObjects];
        for (NSDictionary *dic in [responseObject objectForKey:@"users"]) {
            ContactsModel *contact = [[ContactsModel alloc] initWithDictionary:dic];
            [self.array addObject:contact];
        }
        [self.tableView reloadData];
//        DLog(@"-----%@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.array = [NSMutableArray array];
    self.string = @"followers";
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self request];
    // Do any additional setup after loading the view.
//    self.tableView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height - 150);
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    
    self.tableView.tableHeaderView = _searchBar;
    
    self.tableView.frame = self.view.bounds;
    
    [self getFriendsList];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    
    
    cell.contact = [self.array objectAtIndex:indexPath.row];;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ChattingViewController *chattingVC = [[ChattingViewController alloc] init];
//    chattingVC.contact = [self.array objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:chattingVC animated:YES];
//}


#pragma mark - 环信获取好友列表

- (void)getFriendsList
{
    
    
    //获取好友列表
    NSArray *buddys = [[EaseMob sharedInstance].chatManager buddyList];
    NSMutableArray *usernames = [NSMutableArray array];
    //循环取得 EMBuddy 对象
    for (EMBuddy *buddy in buddys) {
        //屏蔽发送了好友申请, 但未通过对方接受的用户
        if (!buddy.isPendingApproval) {
            DLog(@"----%@", buddy.username);
            [usernames addObject:buddy.username];
        }
    }
    
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] isGroup:NO];
    
    NSLog(@"--=-=%@", conversation.messages);
    
    
//    NSArray *arr = [conversation loadAllMessages];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    ChattingViewController *chattingVC = segue.destinationViewController;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    ContactsModel *contact = [self.array objectAtIndex:indexPath.row];
    chattingVC.contact = contact;
    
    
    //根据接收者的uid获取当前会话的管理者
    chattingVC.conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:contact.uid isGroup:NO];


    for (EMMessage *message in [chattingVC.conversation loadAllMessages]) {
        EMTextMessageBody *body = [message.messageBodies firstObject];
//        DLog(@"---%@", message);
        if (body.messageBodyType == eMessageBodyType_Text) {
            NSString *msg = ((EMTextMessageBody *)body).text;
//            DLog(@"收到的消息---%@", msg);
            [chattingVC.array addObject:msg];
        }
        NSString *fromUid = message.from;
        if ([fromUid isEqualToString:contact.uid]) {
            [chattingVC.flagArray addObject:@"0"];  //发送方
        } else {
            [chattingVC.flagArray addObject:@"1"];  //接受方
        }
    }

    
}


- (IBAction)swiAction:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.string = @"followers";
        [self request];
    } else if (sender.selectedSegmentIndex == 1) {
        self.string = @"friends";
        [self request];
    }
}

@end
