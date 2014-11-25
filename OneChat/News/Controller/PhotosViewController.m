//
//  PhotosViewController.m
//  OneChat
//
//  Created by laowang on 14-10-18.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import "PhotosViewController.h"
#import "UIImageView+WebCache.h"

@interface PhotosViewController ()

@end

@implementation PhotosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(0, 1200);
    [self.view addSubview:scrollView];
    
//    for (int i = 0; i < self.imgArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320 * 0, 0, 320, 1200)];
        [imageView setImageWithURL:[NSURL URLWithString:_imageUrl]];
        [scrollView addSubview:imageView];
//    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 20, 45, 30);
    [self.view addSubview:button];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)returnAction:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:^{
        
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
