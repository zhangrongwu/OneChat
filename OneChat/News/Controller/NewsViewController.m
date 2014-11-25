//
//  NewsViewController.m
//  OneChat
//
//  Created by laowang on 14-10-7.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import "NewsViewController.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "NewsCell.h"
#import "UILabel+StringFrame.h"
#import "WriteNewsViewController.h"
#import "NewsInfoViewController.h"
#import "UIImageView+WebCache.h"

@interface NewsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)NSString *token;
@property (nonatomic, strong)NSMutableArray *array;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSString *path;
@property (nonatomic, assign)int page;
@property (nonatomic, assign)int flag;

@end

@implementation NewsViewController

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
    _page = 1;
    _flag = 0;
    self.path = [NSString stringWithFormat:@"https://api.weibo.com/2/statuses/home_timeline.json?access_token=%@&since_id=0&max_id=0&count=30&base_app=0&feature=0&trim_user=0", Token];
}
- (void)request
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates =  YES;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/css", @"text/html", @"text/plain", nil];

    NSString *tempPage = [NSString stringWithFormat:@"&page=%d", _page];
//    DLog(@"--%@", [_path stringByAppendingString:tempPage]);
    [manager GET:[_path stringByAppendingString:tempPage] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (_page == 1) {
            
            self.array = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"statuses"]];
        } else {
                [self.array addObjectsFromArray:[responseObject objectForKey:@"statuses"]];
        }
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0xAB82FF);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"selectNews.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addNews.png"] style:UIBarButtonItemStylePlain target:self action:@selector(writeNews)];
    [self createTable];
//    [self request];
    
    [self setupRefresh];
    
    self.selectView = [[UIView alloc] initWithFrame:CGRectMake(10, 65, 100, 100)];
    self.selectView.backgroundColor = [UIColor colorWithRed:105 / 255.0 green:105 / 255.0 blue:105 / 255.0 alpha:0.85];
    
    
    
}

- (void)createTable
{
//    （判断当前系统是否大于7.0,可以用来做iOS6和iOS7的适配）
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    } else {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    [self.view addSubview:_tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.75 alpha:0.25];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[NewsCell class] forCellReuseIdentifier:@"reuse"];
}
#pragma mark - 发微博
- (void)writeNews
{
    WriteNewsViewController *writeVC = [[WriteNewsViewController alloc] init];
    writeVC.flag = 0;
    [self presentViewController:writeVC animated:YES completion:^{
        
    }];
}
- (void)leftAction
{
    
    self.flag++;
    if (_flag % 2 == 1) {
        [self.view addSubview:_selectView];
        UIButton *home = [UIButton buttonWithType:UIButtonTypeCustom];
        home.frame = CGRectMake(0, 0, 100, 40);
        [self.selectView addSubview:home];
        [home setTitle:@"首页" forState:UIControlStateNormal];
        [home addTarget:self action:@selector(home:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *myNews = [UIButton buttonWithType:UIButtonTypeCustom];
        myNews.frame = CGRectMake(0, 45, 100, 40);
        [self.selectView addSubview:myNews];
//        myNews.backgroundColor = [UIColor grayColor];
        [myNews setTitle:@"我的微博" forState:UIControlStateNormal];
        [myNews addTarget:self action:@selector(myNews:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self.selectView removeFromSuperview];
    }
}
- (void)home:(UIButton *)btn
{
    [self.selectView removeFromSuperview];
    _page = 1;
    _flag = 0;
    self.path = [NSString stringWithFormat:@"https://api.weibo.com/2/statuses/home_timeline.json?access_token=%@&since_id=0&max_id=0&count=30&base_app=0&feature=0&trim_user=0", Token];
    [self request];
}
- (void)myNews:(UIButton *)btn
{
    [self.selectView removeFromSuperview];
    _page = 1;
    _flag = 1;
    self.path = [NSString stringWithFormat:@"https://api.weibo.com/2/statuses/user_timeline.json?access_token=%@&count=30", Token];

    [self request];
}
#pragma mark - tableVIew协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
//    cell.backgroundColor = [UIColor colorWithWhite:0.75 alpha:0.25];
    cell.backgroundColor = [UIColor clearColor];
    cell.dic = [self.array objectAtIndex:indexPath.row];
    cell.flag = _flag;
    //删除微博
    cell.deleteBlock = ^(NSString *weiboId) {
        DLog(@"--------%@", weiboId);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.securityPolicy.allowInvalidCertificates =  YES;
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/css", @"text/html", @"text/plain", nil];
        NSString *deletepath = @"https://api.weibo.com/2/statuses/destroy.json";
        NSDictionary *dic = @{@"access_token": Token, @"id" : [NSNumber numberWithLongLong:[weiboId longLongValue]]};
        [manager POST:deletepath parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            DLog(@"success");
            [self.array removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"error====%@", error);
         }];
        
    };
    //转发微博
    cell.zhuanfaBlock = ^(NSString *weiboId) {
        WriteNewsViewController *writeVC = [[WriteNewsViewController alloc] init];
        writeVC.weiboId = weiboId;
        writeVC.flag = 1;
        [self presentViewController:writeVC animated:YES completion:^{
            
        }];
    };
    
    //转发微博详情
    cell.weiboInfoBlock = ^(NSDictionary *dic) {
        NewsInfoViewController *newsInfoVC = [[NewsInfoViewController alloc] init];
        newsInfoVC.weiboDic = dic;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newsInfoVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    tempLabel.numberOfLines = 0;
    NSDictionary *dic = [self.array objectAtIndex:indexPath.row];
    tempLabel.text = [dic objectForKey:@"text"];
    CGFloat height1 = [tempLabel boundingRectWithSize:CGSizeMake(300, 0)].height;
    NSDictionary *newsDic = [dic objectForKey:@"retweeted_status"];
    CGFloat height2 = 0;
    if (newsDic != nil) {
        NSString *str = [[newsDic objectForKey:@"user"] objectForKey:@"name"];
        
        tempLabel.font = [UIFont systemFontOfSize:15];
        tempLabel.text = [NSString stringWithFormat:@"@%@:%@", str, [newsDic objectForKey:@"text"]];
        height2 = [tempLabel boundingRectWithSize:CGSizeMake(300, 0)].height + 20;
    }
    return 51 + height1 + height2 + 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsInfoViewController *newsInfoVC = [[NewsInfoViewController alloc] init];
    newsInfoVC.weiboDic = [self.array objectAtIndex:indexPath.row];
    
//    if ([[[self.array objectAtIndex:indexPath.row] objectForKey:@"pic_urls"] count] == 1) {
//        UIImageView *imgView = [[UIImageView alloc] init];
//        NSString *url = [[self.array objectAtIndex:indexPath.row] objectForKey:@"original_pic"];
//        [imgView setImageWithURL:[NSURL URLWithString:url]];
//        newsInfoVC.oneImage = imgView.image;
//    }
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsInfoVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    self.tabBarController.tabBar.hidden = YES;
}
//结束滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    self.tabBarController.tabBar.hidden = NO;
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


//刷新方法
/**
集成刷新控件
**/
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    [self.tableView headerBeginRefreshing];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _page = 1;
    [self request];
    // 2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
    
    
    
}

- (void)footerRereshing
{
    _page++;
    [self request];
    // 2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });
}

@end
