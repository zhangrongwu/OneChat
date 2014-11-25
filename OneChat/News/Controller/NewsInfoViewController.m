//
//  NewsInfoViewController.m
//  OneChat
//
//  Created by laowang on 14-10-11.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import "NewsInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "UILabel+StringFrame.h"
#import "DateHandle.h"
#import "PhotosViewController.h"

@interface NewsInfoViewController ()

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIImageView *faceImg;
@property (nonatomic, strong)UILabel *namelabel;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *fromLabel;
@property (nonatomic, strong)UILabel *textLab;
@property (nonatomic, strong)UIView *repostView;   //转发微薄的view
@property (nonatomic, strong)UILabel *repostLabel; //转发文字
@property (nonatomic, strong)UIImageView *collectImg; //收藏
@property (nonatomic, strong)NSMutableArray *imgArray;


@property (nonatomic, assign)CGFloat width;
//@property (nonatomic, assign)CGFloat *width2;
@property (nonatomic, assign)CGFloat height1;//发微博文字高度
@property (nonatomic, assign)CGFloat height2;//转发文字高度
@property (nonatomic, assign)CGFloat height3;//图片高度

@end

@implementation NewsInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.weiboDic = [NSDictionary dictionary];
        self.imgArray = [NSMutableArray array];
        self.height1 = 0;
        self.height2 = 0;
        self.height3 = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
//    self.automaticallyAdjustsScrollViewInsets = NO;
 
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    
    self.faceImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:_faceImg];
    
    self.namelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:_namelabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:_timeLabel];
    
    
    self.fromLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:_fromLabel];
    
    
//    DLog(@"----dic----%@", _weiboDic);
    
    
    
    self.textLab = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:_textLab];
    
    
    self.repostView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:_repostView];
    
    self.repostLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.repostView addSubview:_repostLabel];
    
    
    self.collectImg = [[UIImageView alloc] initWithFrame:CGRectMake(280, 16, 28, 28)];

    if ([[self.weiboDic objectForKey:@"favorited"] boolValue] == YES) {
        self.collectImg.image = [UIImage imageNamed:@"card_icon_favorite_highlighted@2x.png"];
    } else {
        self.collectImg.image = [UIImage imageNamed:@"card_icon_favorite@2x.png"];
    }
    [self.scrollView addSubview:_collectImg];
    
   
    
    NSDictionary *userDic = [self.weiboDic objectForKey:@"user"];
    [self.faceImg setImageWithURL:[NSURL URLWithString:[userDic objectForKey:@"profile_image_url"]]];
    self.faceImg.frame = CGRectMake(10, 15, 33, 33);
    self.faceImg.clipsToBounds = YES;
    self.faceImg.layer.cornerRadius = 3;
    
    self.namelabel.text = [userDic objectForKey:@"name"];
    self.namelabel.frame = CGRectMake(50, 15, 200, 20);
    self.namelabel.textColor = [UIColor orangeColor];
    
    self.timeLabel.frame = CGRectMake(50, 35, 75, 15);
    self.timeLabel.font = [UIFont systemFontOfSize:11];
    self.timeLabel.text = [DateHandle handleTime:[self.weiboDic objectForKey:@"created_at"]];
    
    NSString *source = [self.weiboDic objectForKey:@"source"];
    int start = [source rangeOfString:@">"].location;
    NSRange range = NSMakeRange(start + 1, source.length - 5 - start);
    self.fromLabel.text = [NSString stringWithFormat:@"来自%@", [source substringWithRange:range]];
    self.fromLabel.frame = CGRectMake(130, 35, 150, 15);
    self.fromLabel.font = [UIFont systemFontOfSize:11];
    self.fromLabel.textColor = [UIColor grayColor];
    
  
    
    self.textLab.numberOfLines = 0;
    self.textLab.text = [self.weiboDic objectForKey:@"text"];
    self.height1 = [self.textLab boundingRectWithSize:CGSizeMake(300, 0)].height;
    self.textLab.frame = CGRectMake(10, 55, 300, _height1);
    
    self.imgArray = [self.weiboDic objectForKey:@"pic_urls"];
    
    DLog(@"----%d", self.imgArray.count);
    if (self.imgArray.count == 0) {
        self.height3 = 0;
    } else if (self.imgArray.count == 1) {
        NSString  *url = [self.weiboDic objectForKey:@"original_pic"];
        UIImageView *tempImg = [[UIImageView alloc] init];
        [tempImg setImageWithURL:[NSURL URLWithString:url]];
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//        //通过data产生图片
//        UIImage *image = [UIImage imageWithData:data];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:tempImg.image];
        [imgView setImageWithURL:[NSURL URLWithString:url]];
        
        if (tempImg.image.size.width != 0) {
            _height3 = 300 * tempImg.image.size.height / tempImg.image.size.width;
            imgView.frame = CGRectMake(10, 60 + _height1, 300, _height3);
            [self.scrollView addSubview:imgView];
        }
    } else if (self.imgArray.count == 4) {
        _height3 = 105 * 2;
        for (int i = 0; i < self.imgArray.count; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + i % 2 * 105, 60 + _height1 + _height2 + i / 2 * 105, 100, 100)];
            NSString *urlStr = [[self.imgArray objectAtIndex:i] objectForKey:@"thumbnail_pic"];
            [imgView setImageWithURL:[NSURL URLWithString:urlStr]];
            [self.scrollView addSubview:imgView];
        }
    } else {
        _height3 = (self.imgArray.count - 1) / 3 * 95 + 95;
        for (int i = 0; i < self.imgArray.count; i++) {
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + i % 3 * 102.5, 60 + _height1 + _height2 + i / 3 * 102.5, 95, 95)];
            imgView.tag = 1000 + i;
            imgView.userInteractionEnabled = YES;
            [imgView addGestureRecognizer:tap];
            
            NSString *urlStr = [[self.imgArray objectAtIndex:i] objectForKey:@"thumbnail_pic"];
            //            NSLog(@"-=======%@", urlStr);
            //            NSRange range = [urlStr rangeOfString:@"thumbnail"];
            //            urlStr = [NSString stringWithFormat:@"http://ww3.sinaimg.cn/original%@", [urlStr substringFromIndex:range.location + range.length]];
            //            NSLog(@"-=======%@", urlStr);
            [imgView setImageWithURL:[NSURL URLWithString:urlStr]];
            [self.scrollView addSubview:imgView];
        }

    }

    
    //该微博是转发的
    if ([self.weiboDic objectForKey:@"retweeted_status"] != nil) {
        [self.repostView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)]
        ;
        
        NSDictionary *newsDic = [_weiboDic objectForKey:@"retweeted_status"];
        NSString *str = [[newsDic objectForKey:@"user"] objectForKey:@"name"];
        self.repostLabel.numberOfLines = 0;
        self.repostLabel.text = [NSString stringWithFormat:@"@%@:%@", str, [newsDic objectForKey:@"text"]];
        self.repostView.backgroundColor = [UIColor colorWithWhite:0.75 alpha:0.25];
        self.height2 = [self.repostLabel boundingRectWithSize:CGSizeMake(300, 0)].height;
        
        self.repostLabel.frame = CGRectMake(0, 10, 300, _height2);
        [self.repostView addSubview:_repostLabel];
        self.imgArray = [newsDic objectForKey:@"pic_urls"];
        
        if (self.imgArray.count == 0) {
            self.height3 = 0;
        } else if (self.imgArray.count == 1) {
            NSString  *url = [self.weiboDic objectForKey:@"original_pic"];
            UIImageView *tempImg = [[UIImageView alloc] init];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:tempImg.image];
            [imgView setImageWithURL:[NSURL URLWithString:url]];
            
            if (tempImg.image.size.width != 0) {
                _height3 = 300 * tempImg.image.size.height / tempImg.image.size.width;
                imgView.frame = CGRectMake(10, 70 + _height1 + _height2, 300, _height3);
                [self.scrollView addSubview:imgView];
            }
        } else if (self.imgArray.count == 4) {
            _height3 = 105 * 2;
            for (int i = 0; i < self.imgArray.count; i++) {
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + i % 2 * 105, 70 + _height1 + _height2 + i / 2 * 105, 100, 100)];
                NSString *urlStr = [[self.imgArray objectAtIndex:i] objectForKey:@"thumbnail_pic"];
                [imgView setImageWithURL:[NSURL URLWithString:urlStr]];
                [self.scrollView addSubview:imgView];
            }
        } else {
            _height3 = (self.imgArray.count - 1) / 3 * 95 + 95;
            for (int i = 0; i < self.imgArray.count; i++) {
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + i % 3 * 102.5, 70 + _height1 + _height2 + i / 3 * 102.5, 95, 95)];
                NSString *urlStr = [[self.imgArray objectAtIndex:i] objectForKey:@"thumbnail_pic"];
                //            NSLog(@"-=======%@", urlStr);
                //            NSRange range = [urlStr rangeOfString:@"thumbnail"];
                //            urlStr = [NSString stringWithFormat:@"http://ww3.sinaimg.cn/original%@", [urlStr substringFromIndex:range.location + range.length]];
                //            NSLog(@"-=======%@", urlStr);
                [imgView setImageWithURL:[NSURL URLWithString:urlStr]];
                [self.scrollView addSubview:imgView];
            }
        }

        self.repostView.frame = CGRectMake(10, _height1 + 70, 300, _height2 + _height3 + 15);
       
        [self.scrollView addSubview:_repostView];
        
    } else {
        self.height2 = 0;
    }
    DLog(@"height1:%f--height2:%f--height3:%f", _height1, _height2, _height3);
    self.scrollView.contentSize = CGSizeMake(320, 90 + _height1 + _height2 + _height3);
    
    

}
#pragma mark - 图片点击手势
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    NSString *imgUrl = [[self.imgArray objectAtIndex:tap.view.tag - 1000] objectForKey:@"thumbnail_pic"];
    imgUrl = [imgUrl stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
    DLog(@"------click-------%@", imgUrl);
    
    PhotosViewController *photoVC = [[PhotosViewController alloc] init];
//    photoVC.imgArr = self.imgArray;
    photoVC.imageUrl = imgUrl;
    photoVC.index = tap.view.tag - 1000;
    [self presentViewController:photoVC animated:YES completion:^{
        
    }];
    
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

@end
