//
//  WriteNewsViewController.m
//  OneChat
//
//  Created by laowang on 14-10-11.
//  Copyright (c) 2014年 蓝鸥科技. All rights reserved.
//

#import "WriteNewsViewController.h"
#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>

@interface WriteNewsViewController ()<UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong)CLLocationManager *locationManager;

//@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)UITextView *contentText;
@property (nonatomic, strong)UIButton *send;
@property (nonatomic, strong)UIImageView *imgView;  //选择相册的图片
@property (nonatomic, strong)UIButton *insertLoc;
@property (nonatomic, assign)CGFloat latitude;
@property (nonatomic, assign)CGFloat longitude;


@end

@implementation WriteNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.latitude = 0.0f;
        self.longitude = 0.0f;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xF8F8FF);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    view.backgroundColor = UIColorFromRGB(0x696969);
    [self.view addSubview:view];
    
    
    
    self.send = [UIButton buttonWithType:UIButtonTypeSystem];
    self.send.frame = CGRectMake(260, 25, 40, 30);
    [view addSubview:_send];
    [_send setTitle:@"发送" forState:UIControlStateNormal];
    _send.tintColor = [UIColor whiteColor];
    self.send.titleLabel.font = [UIFont systemFontOfSize:16];
    self.send.titleLabel.alpha = 0.6;
    if (_flag == 1) {
        self.send.titleLabel.font = [UIFont systemFontOfSize:18];
        self.send.titleLabel.alpha = 1;
    }
    [_send addTarget:self action:@selector(sendWeibo:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeSystem];
    cancel.frame = CGRectMake(20, 25, 40, 30);
    [view addSubview:cancel];
    cancel.tintColor = [UIColor whiteColor];
    cancel.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
   
    self.contentText = [[UITextView alloc] initWithFrame:CGRectMake(20, 70, 280, 140)];
    self.contentText.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_contentText];
    self.contentText.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    self.contentText.delegate = self;
    self.contentText.font = [UIFont fontWithName:@"Arial" size:18];//设置字体名字和字体大小
//    self.contentText.text = @"试一下";
//    self.contentText.placeholder = @"想说点什么...";
//    [self.contentText addTarget:self action:@selector(valueChanage:) forControlEvents:UIControlEventValueChanged];
    
    
    self.insertLoc = [UIButton buttonWithType:UIButtonTypeSystem];
    self.insertLoc.frame = CGRectMake(140, 240, 160, 30);
    [self.view addSubview:_insertLoc];
//    self.insertLoc.backgroundColor = [UIColor orangeColor];
    self.insertLoc.titleLabel.textAlignment = NSTextAlignmentRight;
    self.insertLoc.tintColor = [UIColor lightGrayColor];
    self.insertLoc.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.insertLoc setTitle:@"插入位置" forState:UIControlStateNormal];
    [self.insertLoc addTarget:self action:@selector(insertLoc:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *insertImage = [UIButton buttonWithType:UIButtonTypeSystem];
    insertImage.frame = CGRectMake(20, 240, 90, 30);
    [self.view addSubview:insertImage];
    insertImage.tintColor = [UIColor lightGrayColor];
    insertImage.titleLabel.font = [UIFont systemFontOfSize:17];
    [insertImage setTitle:@"插入图片" forState:UIControlStateNormal];
    [insertImage addTarget:self action:@selector(insertImage:) forControlEvents:UIControlEventTouchUpInside];


    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 270, 120, 120)];
    [self.view addSubview:_imgView];
    
}

- (void)textViewDidChange:(UITextView *)textView
{
//    DLog(@"------%@", textView.text);
    if (textView.text.length > 140) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不能超过140个字" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        
    } else if (textView.text.length > 0) {
        if ([self isBlankString:textView.text] == YES) {
            self.send.titleLabel.font = [UIFont systemFontOfSize:16];
            self.send.titleLabel.alpha = 0.6;
        } else {
            self.send.titleLabel.font = [UIFont systemFontOfSize:18];
            self.send.titleLabel.alpha = 1;
        }
    } else if (textView.text.length == 0) {
        self.send.titleLabel.font = [UIFont systemFontOfSize:16];
        self.send.titleLabel.alpha = 0.6;
    }
}
- (void)request
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates =  YES;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/css", @"text/html", @"text/plain", nil];
    NSNumber *lat = [NSNumber numberWithFloat:self.latitude];
    NSNumber *lon = [NSNumber numberWithFloat:self.longitude];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *path = [NSString stringWithFormat:@"https://api.weibo.com/2/statuses/update.json"];
    NSDictionary *dic = @{@"access_token": [user objectForKey:@"wbtoken"], @"status" : self.contentText.text, @"lat":lat, @"long":lon};
    if (self.imgView.image != nil) {
        UIImage *ima = self.imgView.image;
        NSData *data = UIImagePNGRepresentation(ima);
        path = @"https://upload.api.weibo.com/2/statuses/upload.json";
        dic = @{@"access_token": [user objectForKey:@"wbtoken"], @"status" : self.contentText.text, @"pic":data, @"lat":lat, @"long":lon};
    }
    DLog(@"--%@", path);
    [manager POST:path parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DLog(@"---%@", responseObject);
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"--%@", error);
    }];

//    } else {
//
        //    NSNumber *visible = [NSNumber numberWithInt:0];
        //    NSNumber *lat = [NSNumber numberWithFloat:0.0];
        //    NSNumber *lon = [NSNumber numberWithFloat:0.0];
        //    NSString *urlContent = [self.contentText.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //    NSDictionary *dic = @{@"access_token": [user objectForKey:@"wbtoken"], @"status" : urlContent, @"visible" : visible, @"list_id":@"0", @"lat":lat, @"long":lon, @"annotations":@"", @"rip":@"124.202.203.186"};
        
//        DLog(@"--%@", path);
//        [manager POST:path parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            DLog(@"---%@", responseObject);
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            DLog(@"--%@", error);
//        }];
//    }
    
}

- (void)zhuanfaRequest
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates =  YES;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/css", @"text/html", @"text/plain", nil];
    
    NSString *zhuanfaPath = @"https://api.weibo.com/2/statuses/repost.json";
    DLog(@"======%@", _weiboId);
    NSDictionary *dic = @{@"access_token": Token, @"status" : self.contentText.text, @"id" : [NSNumber numberWithLongLong:[_weiboId longLongValue]]};

    DLog(@"----%@", dic);
    [manager POST:zhuanfaPath parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        DLog(@"---%@", responseObject);
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"--%@", error);
    }];
}
- (BOOL)isBlankString:(NSString *)string{
    
    if (string == nil) {
        
        return YES;
        
    }
    
    if (string == NULL) {
        
        return YES;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        
        return YES;
    } 
    
    return NO;
    
}
//- te
#pragma mark - 发送微博
- (void)sendWeibo:(UIButton *)btn
{
    [self.contentText resignFirstResponder];
    DLog(@"---length---%d", self.contentText.text.length);
    
    //发微博
    if (_weiboId == nil) {
        if ([self.contentText.text isEqualToString:@""] && self.imgView.image == nil) {
            
        } else {
            [self request];
        }
    } else {   //转发微博
        [self zhuanfaRequest];
    }
    
    
}
#pragma mark - 取消发送
- (void)cancel:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark - 插入位置
- (void)insertLoc:(UIButton *)btn
{
    [self.contentText resignFirstResponder];
    DLog(@"++");
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10.0f;
    [_locationManager startUpdatingLocation];
    
    
}
#pragma mark - 定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [_locationManager stopUpdatingLocation];
    self.latitude = newLocation.coordinate.latitude;
    self.longitude = newLocation.coordinate.longitude;
    
//    NSLog(@"经度--%.2f,维度--%.2f", newLocation.coordinate.latitude,  newLocation.coordinate.longitude);
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark *placemark in placemarks) {
            NSDictionary *test = [placemark addressDictionary];
            
            //  Country(国家)  State(城市)  SubLocality(区)
            NSString *location = [NSString stringWithFormat:@"%@%@", [test objectForKey:@"State"], [test objectForKey:@"SubLocality"]];
//            self.insertLoc.titleLabel.text = location;
            [self.insertLoc setTitle:location forState:UIControlStateNormal];
            DLog(@"位置:%@", location);
        }
        
    }];
    
    
    
    
}
#pragma mark - 发送图片
- (void)insertImage:(UIButton *)btn
{
    [self.contentText resignFirstResponder];
    DLog(@"--");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;//是否可以对原图进行编辑
        
        //打开相册选择照片
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"图片库不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }

}
#pragma mark - UIImagePickerControllerDelegate
#pragma mark - 拍照/选择图片结束
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"如果允许编辑%@",info);//picker.allowsEditing= YES允许编辑的时候 字典会多一些键值。
    //获取图片
    //    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];//原始图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];//编辑后的图片
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//把图片存到图片库
        self.imgView.image = image;
    }else{
        self.send.titleLabel.font = [UIFont systemFontOfSize:18];
        self.send.titleLabel.alpha = 1;
        self.imgView.image = image;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - 取消拍照/选择图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.contentText resignFirstResponder];
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
