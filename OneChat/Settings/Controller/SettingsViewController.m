//
//  SettingsViewController.m
//  OneChat
//
//  Created by laowang on 14-10-7.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "UILabel+StringFrame.h"
#import "SDImageCache.h"

@interface SettingsViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

//@property (strong, nonatomic) IBOutlet UILabel *uidLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *faceImg;
@property (strong, nonatomic) UILabel *descLabel;

@property (strong, nonatomic) UIButton *logoutButton;


@property (strong, nonatomic) UIView *tableHeaderView;
@property (strong, nonatomic) UIView *tableFooterView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *array;   //数据源
@property (strong, nonatomic) NSMutableArray *imgArray;   //对应的图片

@property (nonatomic, assign)float clean;


@end

@implementation SettingsViewController

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
    
    self.array = [NSMutableArray arrayWithObjects:@"我的收藏", @"清理缓存", @"聊天背景", @"关于我们", nil];
    
    self.imgArray = [NSMutableArray arrayWithObjects:@"MyFavorites@2x.png", @"Clean@2x.png", @"MoreSetting@2x.png", @"About@2x.png", nil];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:_tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.75 alpha:0.25];
    
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 120)];
    self.tableHeaderView.backgroundColor = [UIColor whiteColor];
    self.faceImg = [[UIImageView alloc] initWithFrame:CGRectMake(14, 22, 80, 80)];
    self.faceImg.clipsToBounds = YES;
    self.faceImg.layer.cornerRadius = 5;
   
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 29, 200, 20)];
    self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 60, 200, 50)];
    self.descLabel.font = [UIFont systemFontOfSize:14];
    self.descLabel.textColor = [UIColor grayColor];
    self.descLabel.numberOfLines = 0;
    NSLog(@"=======%@", NSTemporaryDirectory());
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    DLog(@"-----url%@", [user objectForKey:@"imageUrl"]);
    self.nameLabel.text = [user objectForKey:@"name"];
    self.descLabel.text = [user objectForKey:@"description"];
    [self.faceImg setImageWithURL:[NSURL URLWithString:[user objectForKey:@"imageUrl"]]];
    self.faceImg.layer.borderWidth = 0.5;
    self.faceImg.layer.borderColor = [[UIColor grayColor] CGColor];
    
    CGFloat height = [self.descLabel boundingRectWithSize:CGSizeMake(200, 0)].height;
//    DLog(@"---%f", height);
    self.descLabel.frame = CGRectMake(110, 63, 200, height);

    
    
    [self.tableHeaderView addSubview:_faceImg];
    [self.tableHeaderView addSubview:_nameLabel];
    [self.tableHeaderView addSubview:_descLabel];
    
    self.tableView.tableHeaderView = _tableHeaderView;
    
    
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.logoutButton.frame = CGRectMake(0, 0, 320, 48);
    self.logoutButton.backgroundColor = [UIColor whiteColor];
    self.logoutButton.tintColor = [UIColor redColor];
    self.logoutButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.logoutButton.titleLabel.font = [UIFont boldSystemFontOfSize:21];
    [self.logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.logoutButton addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [self.tableFooterView addSubview: _logoutButton];
    self.tableView.tableFooterView = _tableFooterView;
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuse"];
    
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    cell.imageView.image = [UIImage imageNamed:[self.imgArray objectAtIndex:indexPath.row]];
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    if (indexPath.row == 1) {
        SDImageCache *sdimage = [[SDImageCache alloc] init];
        self.clean = [sdimage checkTmpSize];
        DLog(@"---%.2f", _clean);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM缓存", _clean];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"真的么?" message:@"清理缓存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"真的", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.clean = 0;
        SDImageCache *sdimage = [[SDImageCache alloc] init];
        [sdimage clearMemory];
        [sdimage clearDisk];
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

- (void)logoutAction:(UIButton *)btn {
    
    //退出登录
    [[EaseMob sharedInstance].chatManager asyncLogoff];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
//    LoginViewController *loginVC = [[LoginViewController alloc] init];
//    [self presentViewController:loginVC animated:NO completion:^{
//        
//    }];
}
@end
