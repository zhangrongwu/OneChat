//
//  ChattingViewController.m
//  OneChat
//
//  Created by laowang on 14-10-7.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import "ChattingViewController.h"
#import "ChatCell.h"
#import "ChatSendHelper.h"
#import "UIImageView+WebCache.h"
#import "MessageEntity.h"
#import "AppDelegate.h"
#import "UILabel+StringFrame.h"


//动画时间
#define kAnimationDuration 0.25
//view高度
#define kViewHeight 45

@interface ChattingViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, IChatManagerDelegate, IDeviceManagerDelegate, UIScrollViewDelegate, UIAlertViewDelegate>

- (IBAction)sendAction:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *sendBtn;

@property (strong, nonatomic) IBOutlet UITextField *messageText;

@property (nonatomic, strong) UIView *sendView;
@property (nonatomic, strong) UIImage *faceImg;   //头像







@property (nonatomic, assign)CGFloat height;

@end

@implementation ChattingViewController

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
    
    self.height = 0;
    
    self.array = [NSMutableArray array];
    self.flagArray = [NSMutableArray array];
//    //根据接收者的uid获取当前会话的管理者
//    _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.contact.uid isGroup:NO];

}
- (void)setContact:(ContactsModel *)contact
{
    if (_contact != contact) {
        _contact = contact;
    }
    
    UIImageView *tempImage = [[UIImageView alloc] init];
    [tempImage setImageWithURL:[NSURL URLWithString:contact.profile_image_url]];
    
    self.faceImg = tempImage.image;
    
    
    if ([contact.remark isEqualToString:@""]) {
        self.navigationItem.title = contact.name;
    } else {
        self.navigationItem.title = contact.remark;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteMessage)];
    
 
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg7.jpg"]];
    
  
    
    self.sendView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - kViewHeight + 5, 320, kViewHeight - 5)];
    [self.view addSubview:_sendView];
    self.sendView.backgroundColor = [UIColor lightGrayColor];
    
    self.messageText.frame = CGRectMake(20, 4, 220, 34);
    self.sendBtn.frame = CGRectMake(260, 4, 40, 35);
    [self.sendView addSubview:_messageText];
    [self.sendView addSubview:_sendBtn];
    
    self.tableView.frame =  CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - kViewHeight);
//    self.tableView.frame = self.view.bounds;
//    self.tableView.bounces = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.tableView addGestureRecognizer:tap];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //注册listener,以接收聊天消息
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];

    
    //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];

    //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardWillHideNotification object:nil];
    
    if (self.array.count > 1) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.array.count - 1 inSection:0] ;
        DLog(@"indexpath-------%d", indexpath.row);
        [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *tempLabel = [[UILabel alloc] init];
    tempLabel.text = [self.array objectAtIndex:indexPath.row];
//    tempLabel.text = self.messageText.text;
    tempLabel.numberOfLines = 0;
//    DLog(@"=====%.2f", [tempLabel boundingRectWithSize:CGSizeMake(180, 0)].height);
    return  [tempLabel boundingRectWithSize:CGSizeMake(180, 0)].height + 30;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCell *chatCell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    chatCell.backgroundColor = [UIColor clearColor];
    chatCell.faceIma = _faceImg;
    chatCell.content = [self.array objectAtIndex:indexPath.row];
    chatCell.isSender = [self.flagArray objectAtIndex:indexPath.row];
//    chatCell.imageUrl = self.contact.profile_image_url;
    
    return chatCell;
}

#pragma mark - 键盘监听
// 键盘弹出时
-(void)keyboardDidShow:(NSNotification *)notification
{
    
    //获取键盘高度
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    
    [keyboardObject getValue:&keyboardRect];
    _tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 50 - keyboardRect.size.height);
    if (self.array.count > 1) {
        //滑到最后一行
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.array.count - 1 inSection:0] ;
        [_tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        //调整放置有textView的view的位置
    }
    
    
    [UIView beginAnimations:nil context:nil];
    
    //定义动画时间
    [UIView setAnimationDuration:kAnimationDuration];
    
    //设置view的frame，往上平移
    [self.sendView setFrame:CGRectMake(0, self.view.frame.size.height-keyboardRect.size.height - kViewHeight, 320, kViewHeight)];
    
    [UIView commitAnimations];
    
    
}
-(void)keyboardDidHidden
{
    _tableView.frame =  CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - kViewHeight);
    //定义动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
    //设置view的frame，往下平移
    [self.sendView setFrame:CGRectMake(0, self.view.frame.size.height - kViewHeight, 320, kViewHeight)];
    [UIView commitAnimations];
}

#pragma mark - 删除聊天记录
- (void)deleteMessage
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"真的删除聊天记录?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
   
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        DLog(@"-=-===delete  %d", [self.conversation removeAllMessages]);
        [self.array removeAllObjects];
        [self.flagArray removeAllObjects];
        [self.tableView reloadData];
    }
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

-(void)addChatDataToMessage:(EMMessage *)message
{
//    __weak ChatViewController *weakSelf = self;
//    dispatch_async(_messageQueue, ^{
//        NSArray *messages = [weakSelf addChatToMessage:message];
//        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
//        
//        for (int i = 0; i < messages.count; i++) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.dataSource.count+i inSection:0];
//            //            [indexPaths insertObject:indexPath atIndex:0];
//            [indexPaths addObject:indexPath];
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf.tableView beginUpdates];
//            [weakSelf.dataSource addObjectsFromArray:messages];
//            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//            [weakSelf.tableView endUpdates];
//            
//            //            [weakSelf.tableView reloadData];
//            
//            [weakSelf.tableView scrollToRowAtIndexPath:[indexPaths lastObject] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        });
//    });
}

#pragma mark - 收发消息
//接收信息
-(void)didReceiveMessage:(EMMessage *)message {
    
    // 收到消息时，震动
    [[EaseMob sharedInstance].deviceManager asyncPlayVibration];
    // 收到消息时，播放音频
    [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
    
    EMTextMessageBody *body = [message.messageBodies firstObject];
    DLog(@"---%@", message);
    NSString *fromUid = message.from;
    
    if ([fromUid isEqualToString:self.contact.uid]) {
        if (body.messageBodyType == eMessageBodyType_Text) {
            NSString *msg = ((EMTextMessageBody *)body).text;
            DLog(@"收到的消息---%@", msg);
            [self.array addObject:msg];
            [self.flagArray addObject:@"0"];  //接受者
            [self.tableView reloadData];
        }
    }
    
    //滑到最后一行
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.array.count - 1 inSection:0] ;
    [_tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

//发送消息
- (IBAction)sendAction:(UIButton *)sender {
    
//    [self.messageText resignFirstResponder];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.managedObjectContext = app.managedObjectContext;

    EMMessage *tempMessage = [ChatSendHelper sendTextMessageWithString:self.messageText.text toUsername:self.contact.uid isChatGroup:NO requireEncryption:NO];
    [self addChatDataToMessage:tempMessage];

    [self.array addObject:self.messageText.text];
    [self.flagArray addObject:@"1"];  //发送者
    [self.tableView reloadData];
    
    //滑到最后一行
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.array.count - 1 inSection:0] ;
    [_tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];

    
    
    self.messageText.text = @"";
    
//    MessageEntity *messageEntity = [NSEntityDescription  insertNewObjectForEntityForName:@"MessageEntity" inManagedObjectContext:self.managedObjectContext];
//    messageEntity.senderUid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
//    messageEntity.receiverUid =  self.contact.uid;
//    messageEntity.messageId =  @"";
//    messageEntity.message = self.messageText.text;
//    
//    messageEntity.isRead = NO;
//    messageEntity.isSender = NO;
//    
//    
//    NSError *error;
//    [self.managedObjectContext save:&error];
//    if (!error) {
//        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"插入成功" message:nil
//        //                                                       delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//        //        [alert show];
//        
//        DLog(@"发出消息");
//        
//    } else {
//        NSLog(@"Error:%@", error);
//    }
//    EMChatText *text = [[EMChatText alloc] initWithText:self.messageText.text];
//    
//    // 创建一个Message Body
//    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:text];
//    
//   // 创建一个Message对象
//    EMMessage *msg =[[ EMMessage alloc] initWithReceiver:self.contact.uid bodies:[NSArray arrayWithObject:body]];
//    // 发送消息
//    [[EaseMob sharedInstance].chatManager sendMessage:msg progress:nil error:nil];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [self.messageText resignFirstResponder];
}
- (void)tapAction:(UITapGestureRecognizer *)tap
{
     [self.messageText resignFirstResponder];
}


@end
