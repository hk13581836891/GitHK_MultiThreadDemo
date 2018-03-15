//
//  StrongWeakViewController.m
//  HK_MultiThreadDemo
//
//  Created by houke on 2018/3/13.
//  Copyright © 2018年 houke. All rights reserved.
//

#import "StrongWeakViewController.h"
#import "HKPerson.h"
#import "HKView.h"
/*
 self.label = [UILabel alloc] init];从内存的角度理解这行代码
 等号右边，在 heap上分配内存空间，存储一个 UILbel的对象
 等号左侧，在 stack上分配内存空间，存放等号右侧UILbel对象所存放的内存的地址，相当于左侧创建的指针指向右侧的地址
 */
/*
 strong Oc 对象用strong
 weak 连线的UI控件用weak,因为控件本身被self.view持有,所以不需要用strong再被self强引用一次
    （即使是局部创建的控件，添加到 self.view 上后，即便是出了其作用域，该控件的引用计数依然不为0，所以在堆上分配的内存空间依然存在）
 */

/*
 自动释放池
 标记为autorelease的对象,会被添加到最近一次创建的自动释放中
 当自动释放池被销毁或耗尽时,会向自动释放池中所有的对象发送 release消息
 
 自动释放池什么时候创建的？又是什么时候销毁的？
 每一次主线程消息循环开始的时候会先创建自动释放池
 运行循环结束前，会销毁自动释放池
 自动释放池销毁或耗尽时会向池中所有对象发送 release消息,释放所有 autorelease的对象
 使用NSThread做多线程开发时,需要在线程调度方法中手动添加自动释放池
 */

/*
 消息循环 Runloop
 Runloop 的作用
 让程序不退出
 处理事件
 */

/*
 自动释放池和主线程
 在消息循环开始的时候创建了自动释放池,在消息循环结束的时候倾倒自动释放池
 */
/*
 什么时候使用自动释放池
 在一个循环中创建大量临时对象的时候
 在创建一个子线程时需要使用自动释放池，因为子线程无法使用主线程中的自动释放池
 
 */

/*
 属性修饰符
 strong ARC中使用 NSMutableString NSMutableArray NSMutableDictionary用 strong
 
 weak ARC中使用
 通常用于解决循环引用问题
 
 assign MRC中ARC中都可以使用
 用 weak或 assign的区别就是，对象的内存被回收后，变量存储的内存地址变化的区别，用 weak地址变为0x0,而 assign还是存放内存被回收前的地址，再调用该变量时会引起崩溃
 
 copy MRC中ARC中都可以使用
 NSString NSArray NSDictionary因为有对应NSMutable类型，所以用 copy
 copy可变变量：在赋值指针的同时也会复制指针指向的内存区域。深拷贝，例如NSMutableString对象。
 copy不可变变量：等同于strong，还是浅拷贝，例如NSString对象。
 
 
 block作为属性(有一个前提就是block内部调用了外部的变量或对象，即第二种 block的情况) block 在 ARC中已被拷贝到堆区，而且block又是不可变的，即时用 copy修饰也只是拷贝指针浅拷贝 所以用copy/strong修饰都行，推荐用 strong
    如果用weak修饰，虽然创建出堆block,但期引用计数为0，在堆上创建完即被销毁，任然是无法被调用
 delegate 用weak/assign修饰 即对 vc self堆内存地址的引用计数不加1 ,用 weak或 assign的区别就是，对象的内存被回收后，变量存储的内存地址变化的区别，用 weak地址变为0x0,而 assign还是存放内存被回收前的地址，再调用该变量时会引起崩溃
 
 retain MRC中使用

 */
@interface StrongWeakViewController ()<MyDelegate>
{
    
}
@property (nonatomic, weak) HKPerson *p1;
@property (nonatomic, weak) HKPerson *p2;

/* <#注释#>*/
@property (nonatomic, copy) NSArray *array;

/* <#注释#> */
@property (nonatomic, copy) NSDictionary *dic;
/* <#注释#>*/
@property (nonatomic, strong) HKView *hkView;

@property (nonatomic, strong) NSArray *array2;



@end

@implementation StrongWeakViewController

-(void)protocolMethod{
    self.view.backgroundColor = [UIColor purpleColor];
}
-(void)dealloc
{
    NSLog(@"zoule");
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"----%p",[self.view viewWithTag:10]);
//    for (int i = 0; i <  10000000; i++) {
//        @autoreleasepool{
//            NSString *str = [NSString stringWithFormat:@"hello --%i",i];
//        }
//    }
//    self.array = @[@"11", @"22"];
    self.array = @[@"22",@"33"];
//    NSArray *arr = self.array;
//    NSLog(@"---%p",arr);
    NSLog(@"---%li",CFGetRetainCount((__bridge CFTypeRef)(self.array)));
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    CFGetRetainCount((__bridge CFTypeRef)(obj))
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     for (int i = 0; i<100000; i++) {
         NSLog(@"---%i",i);
     }
    });
    
    self.array = [NSArray arrayWithObject:@"11"];
    NSLog(@"---%p",self.array);
    NSLog(@"+++%@",self.array);
    NSLog(@"---%li",CFGetRetainCount((__bridge CFTypeRef)(self.array)));
    
    NSArray *mArr = @[@"33"];
    NSLog(@"---%p",mArr);
    self.array2 = mArr;
    NSLog(@"==%p",self.array2);
    
    NSArray *arry = @[@"99"];
    NSLog(@"---%p",arry);
     NSLog(@"---%li",CFGetRetainCount((__bridge CFTypeRef)(arry)));

    NSLog(@"fengexian------");

    //第一种block  全局block NSGlobalBlock 存储在内存中的代码区，(函数存储在代码区)
//    void(^myblock)() = ^() {
//        NSLog(@"neirong");
//    };
//    myblock();
//    NSLog(@"---%@",myblock);
    
    //第二种block  block内部调用外部的变量或对象
    //在 ARC中，是NSMallocBlock堆block；但实际在MRC中，该种 block 是NSStackBlock 是一个栈block
    //因为 block 是不可变的，所以 block 属性变量用 copy修饰，也只是浅拷贝，所以推荐用strong
//    int number = 5;
//    void(^myblock)() = ^() {
//        NSLog(@"neirong--%d",number);
//    };
//    myblock();
//    NSLog(@"---%@",myblock);
    
    //第三种block MRC的情况 对栈上的block做一次copy操作就成为了堆block NSMallocBlock堆block
    int number = 5;
    void(^myblock)() = ^() {
        NSLog(@"neirong--%d",number);
    };
    myblock();
    NSLog(@"---%@",[myblock copy]);
    
//    return;
//
//    HKView *hkView = [[HKView alloc] initWithFrame:CGRectMake(20, 100, 100, 100)];
//    hkView.backgroundColor = [UIColor redColor];
//    hkView.tag = 10;
//    hkView.delegate = self;
//    [self.view addSubview:hkView];
//    NSLog(@"++++%p",hkView);
//
//    NSMutableArray *mArray = [NSMutableArray array];
//    [mArray addObject:@"1"];
//    self.array = mArray;
//    [mArray addObject:@"2"];
//
//    NSLog(@"---%@",self.array);
//
//    NSMutableString *mStr = [NSMutableString string];
//    [mStr appendString:@"hello"];
//    self.ss = mStr;
//    [mStr appendString:@"zs"];
//    NSLog(@"---%@",self.ss);
//    NSLog(@"---%p",self.ss);
//    NSLog(@"---%p",mStr);
//
//    NSString *str = nil;
//    NSData *data = nil;
//    NSLog(@"%@",nil);
//    NSLog(@"%@",str);
//    NSLog(@"%@",data);
//    NSLog(@"%p",nil);
//    NSLog(@"%p",str);
//    NSLog(@"%p",data);
//    NSLog(@"%d",(data == nil));
//
//    int *pointerToInt = NULL;
//    char *pointerToChar = NULL;
//    struct TreeNode *rootNode = NULL;
//    NSLog(@"%@",pointerToInt);
//    NSLog(@"%s",pointerToChar);
//    NSLog(@"%@",rootNode);
//    NSLog(@"%d",pointerToInt==NULL);  //
//    NSLog(@"%d",pointerToInt==nil);   //
//
//
//    NSArray *array = @[@"ss", @"qq", [NSNull null]];
//    NSLog(@"000%@",array);
//
//
//    self.p1 = [[HKPerson alloc] init];
//    NSLog(@"999%@",self.p1);
//    self.p1.name = @"zs";
//
//    NSLog(@"self.p1.name---%@",self.p1.name);
//
//    self.p2 = [HKPerson initWithName:@"ls"];
//    NSLog(@"self.p2.name---%@",self.p2.name);
//
    // Do any additional setup after loading the view.
}
- (IBAction)buttonClick:(id)sender {
    
    self.myBlock();
    //    if (self.delegate && [self.delegate respondsToSelector:@selector(myControllerProtocolMethod)]) {
    //        [self.delegate myControllerProtocolMethod];
    //    }
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
