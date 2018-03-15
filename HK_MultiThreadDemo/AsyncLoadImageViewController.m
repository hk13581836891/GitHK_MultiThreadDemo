//
//  AsyncLoadImageViewController.m
//  HK_MultiThreadDemo
//
//  Created by houke on 2018/3/8.
//  Copyright © 2018年 houke. All rights reserved.
//

#import "AsyncLoadImageViewController.h"
#import "StrongWeakViewController.h"

@interface AsyncLoadImageViewController ()
//<MyControllerProtocol>
/* <#注释#>*/
@property (nonatomic, ) UIScrollView *scrollView;
/* u*/
@property (nonatomic, strong) UIImageView *imageView;


/*  */
@property (nonatomic, copy) NSString *str;
/* <#注释#>*/
//@property (nonatomic, strong) StrongWeakViewController *vc;

@end

@implementation AsyncLoadImageViewController
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    StrongWeakViewController *vc = segue.destinationViewController;
    [vc setMyBlock:^{
        self.str = @"222";
    }];
//    self.vc.delegate = self;
    
    vc.ss = @"123";
}
-(void)dealloc
{
    NSLog(@"控制器走了");
}
-(void)myControllerProtocolMethod
{
    self.view.backgroundColor = [UIColor purpleColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(downLoadImage) object:nil];
    [thread start];
    // Do any additional setup after loading the view.
}


//viewDidLoad的前一个方法
//-(void)loadView
//{
//    self.scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.scrollView.backgroundColor = [UIColor redColor];
//    self.view = self.scrollView;
//    
//    self.imageView = [[UIImageView alloc] init];
//    [self.scrollView addSubview:self.imageView];
//}

//下载网络图片
-(void)downLoadImage
{
    //图片下载异步执行
    NSURL *url = [NSURL URLWithString:@"http://p1b0tkq2t.bkt.clouddn.com/u=169725531,3494195910&fm=200&gp=0.jpg"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:data];
  
    //切换到主线程更新 UI
    //在主线程上更新 UI控件，线程间通讯
    //waitUntilDone YES会等待方法执行完毕,才会执行后续代码
//    [self performSelectorOnMainThread:@selector(updateUI:) withObject:img waitUntilDone:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = img;
        //    self.imageView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
        [self.imageView sizeToFit];//让 imageView 的大小和图片的大小一致
        
        self.scrollView.contentSize = img.size;
    });
}

-(void) updateUI:(UIImage *)img
{
    self.imageView.image = img;
    //    self.imageView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    [self.imageView sizeToFit];//让 imageView 的大小和图片的大小一致
    
    self.scrollView.contentSize = img.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
