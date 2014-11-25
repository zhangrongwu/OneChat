//
//  LoginViewController.m
//  OneChat
//
//  Created by laowang on 14-10-8.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import "LoginViewController.h"

#define kDuration 0.3   // 动画持续时间(秒)

@interface LoginViewController ()
- (IBAction)loginAction:(UIButton *)sender;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    DLog(@"loadView");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DLog(@"viewdidload");
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    
    
    
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionMoveIn;
//    animation.type = @"rippleEffect";  //波纹效果
//    animation.subtype = kCATransitionFromRight;
    
    NSString *isLogin = [[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"];
    
    if (isLogin != nil) {
        self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        self.loadingView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        self.loadingView.center = self.view.center;
        [self.view addSubview:_loadingView];
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.indicator.color = [UIColor orangeColor];
        self.indicator.center = self.view.center;
        [self.view addSubview:_indicator];
        [self.indicator startAnimating];
        
        //是自动登录
        if ([isLogin isEqualToString:@"Yes"]) {
            
            //登录环信
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"uid"]
                                                                password:@"123456"
                                                              completion:
             ^(NSDictionary *loginInfo, EMError *error) {
                 if (!error) {
                     DLog(@"--%@登录成功", [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"]);
                     
                     [self.indicator stopAnimating];
                     [self.loadingView removeFromSuperview];
                     
                     
                     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                     //  获取storyboard中的入口视图控制器对象
                     UIViewController *viewController = [mainStoryboard instantiateInitialViewController];
                     
                     [self presentViewController:viewController animated:NO completion:^{
                     }];
                     [[viewController.view layer] addAnimation:animation forKey:@"animation"];
                     
                     
                 }
             } onQueue:nil];
            
            
            
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 微博登陆方法
- (IBAction)loginAction:(UIButton *)sender {
    
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"LoginViewController"};
    [WeiboSDK sendRequest:request];
    

}





@end
