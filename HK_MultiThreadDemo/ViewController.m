//
//  ViewController.m
//  HK_MultiThreadDemo
//
//  Created by houke on 2018/3/3.
//  Copyright © 2018年 houke. All rights reserved.
//

#import "ViewController.h"
/*
 C语言内存4区模型
 栈区
 堆区
 数据区（分为静态全局区和常量区，从汇编角度细分的话还可以分为很多小的区）
 代码区
 
 *iOS内存分区
 iOS的内存分区跟C语言类似：
 
 栈区（stack）：存放的局部变量、先进后出、一旦出了作用域就会被销毁；函数跳转地址，现场保护等；程序猿不需要管理栈区变量的内存；栈区地址从高到低分配。
 
 堆区（heap）：堆区的内存分配使用的是alloc；需要程序猿管理内存；ARC的内存的管理，是编译器再编译的时候自动添加retain、release、autorelease；堆区的地址是从低到高分配。
 
 全局区/静态区（static）：包括两个部分：未初始化过 、初始化过；也就是说，（全局区/静态区）在内存中是放在一起的，初始化的全局变量和静态变量在一块区域，未初始化的全局变量和未初始化的静态变量在相邻的另一块区域；eg：int a;未初始化的。int a = 10;已初始化的。
 
 常量区：常量字符串就是放在这里。程序结束后由系统释放
 
 代码区：存放App二进制代码。
 */

/*
 同步/异步
 同步：从上到下 从左到右 代码执行顺序
    一个人依次执行多个任务,一个人同一时间执行一个任务
 异步：多个人同时可以执行多个任务
 */

/*
 进程/线程
 进程：指在系统中正在运行的一个应用程序
    每个进程之间是独立的，每个进程运行在其专用的且受保护的内存空间内
    通过 活动监视器可以查看Mac系统中所开启的进程
 线程：1个进程由多个线程组成(一个进程至少要有一个线程)
    线程是进程的基本执行单元，一个进程的所有任务都在线程中执行
 */

/*
 *多线程
    1个进程中可以开启多个线程,多个线程可以"同时"执行不同的任务
    多线程可以解决程序阻塞的问题
    多线程可以提高程序的执行效率
 */

/*
 多线程执行原理
 单任务操作系统 没有多线程概念，只有进程。CUP 执行完成一个进程后，才能继续执行下一个进程
 多任务操作系统 引入多线程的概念
    单核 CPU “同时”处理多个任务的原理
    CPU执行第一个线程(举例)15ns(纳秒)后，会把线程1当前的状态保存在内存中，(包括变量的值和代码执行的位置)，然后
    CPU 执行第二条线程15ns后,在内存中保存线程2的状态
    。。。
    依次执行到最后一条线程后，再次回到第一条线程继续执行(加载线程1的状态，回到记录的代码位置继续执行)。。。
    当某个线程上任务执行完，该线程会被销毁。
 
    a.(单核 CPU)同一时间,cpu 只能处理一个线程,只有一个线程在执行
    b.多线程同时执行，是 cpu快速的在多个线程之间切换
    c.cpu 调度线程的时间足够快，就造成了多个线程的“同时”执行
    d.如果线程数非常多,cpu会在n(10000)个线程之间切换,消耗大量的cpu资源,从而每个线程调度的次数会降低,线程的执行效率会降低
 */

/*
 多线程的优点/缺点
 优点
 1.能适当提高程序的执行效率
 2.能适当提高资源的利用率（CPU、内存）
 3.线程上的任务执行完成后，线程会自动销毁
 
 缺点
 1.开启线程需要占用一定的内存空间(默认情况下，每一个线程都占512KB)
 2.如果开启大量的线程，会占用大量的内存空间，降低程序性能
 3.线程越多，cpu在调用线程上的开销就越大
 4.程序设计更加复杂，比如线程间的通信、多线程的数据共享
 */

/*
 线程的属性
 线程的名称 -- 线程执行的方法内部出现异常时 记录异常和当前线程
 线程的优先级 -- 取值范围0-1，默认0.5,高优先级比低优先级线程会被内核调度器更多的时间片执行,增大时间片执行的几率，并不能保证高优先级线程先执行完
 判断是否主线程
 */

/**
 多线程操作共享资源的问题
 共享资源：1块资源可能会被多个线程共享,也就是多个线程可能会访问同一块资源
    比如多线程访问同一个对象，同一变量，同一文件
 当多线程访问同一块资源时，很容易引发数据错乱和数据安全问题
 
线程是不安全的 -- 不能保证数据跟预期一致

 互斥锁使用
 @synchronized(锁对象) {//需要锁定的代码 （锁定的代码越少越好）}
 能有效防止因多线程抢夺资源造成的数据安全问题
 
 相关专业术语 -- 线程同步
 多条线程按顺序的执行任务
 互斥锁就是使用了线程同步技术
 
 
 */

@interface ViewController ()

//总票数
@property (nonatomic, assign) int ticketsCount;
/*
 原子属性
 属性中的修饰符
 nonatomic:非原子属性
 atomic:原子属性(线程安全),针对多线程设计的，默认值
        保证同一时间只能有一个线程写入(但同一时间多个线程都可以取值)™
        atomic 本身就有一把锁(自旋锁)
        单写多读 单个线程写入，多个线程可以读取
 nonatomic 与 atomic对比
 atomic  线程安全，需要消耗大量资源
 nonatomic 非线程安全，适合内存小的移动设备
 
 ios 开发建议
 所有属性都声明为 nonatomic
 尽量避免多线程抢夺同一块资源
 尽量将加锁 抢夺资源的的业务交给服务器端处理，减小移动客户端的压力
 */
/*
 互斥锁
 如果发现其他线程正在执行锁定代码,该线程会进入休眠（就绪）状态,等其他线程时间片到打开锁后,线程会被唤醒（执行）
 
 自旋锁
 如果发现有其他线程正在锁定代码,该线程会用死循环的方式一直等待锁定的代码执行完成,自旋锁更适合执行不耗时代码
 
 线程安全
 多线程同时操作是不安全的
 线程安全要保证多线程进行读写操作时,仍然能够保证数据的正确
 
 主线程
 几乎所有UIKit提供的类都是线程不安全的，所有更新 UI 的操作都在主线程执行
 所有包含 Mutable的类都是线程不安全的
 
 */

/* */
@property (nonatomic, strong) NSString *aaa;
/* */
@property (nonatomic, strong) NSString *bbb;

/* <#注释#>*/
@property (nonatomic, strong) NSMutableString *mstr;

//原子属性是线程安全的 自选锁
@property (nonatomic, copy) NSString *name;

@end

@implementation ViewController
//当同时重写 getter setter方法时,不会自动生成_name成员变量

//为属性生成对应的成员变量
@synthesize name = _name;

-(NSString *)name
{
    return _name;
}
-(void)setName:(NSString *)name
{
    @synchronized (self) {
        _name = name;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ticketsCount = 30;
}

-(void)testStrongCopyProperty
{
    NSMutableString *mStr = [NSMutableString stringWithString:@"张三"];
    self.name = mStr;
    NSLog(@"使用 strong 第一次得到的名字%@",self.name);
    NSLog(@"使用 copy 第二次得到的名字%@",self.name);
    [mStr appendString:@"丰"];
    NSLog(@"使用 strong 第二次得到的名字%@",self.name);
    NSLog(@"使用 copy 第二次得到的名字%@",self.name);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   
    //模拟卖票窗口1
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(sellTicketsThreadNotSafe) object:nil];
    thread1.name = @"t1";
    thread1.threadPriority = 1;
    [thread1 start];
    
    //模拟卖票窗口2
    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(sellTicketsThreadNotSafe) object:nil];
    thread2.name = @"t2";
    thread2.threadPriority = 0.2;
    [thread2 start];
    
    //模拟卖票窗口3
    NSThread *thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(sellTicketsThreadNotSafe) object:nil];
    thread3.name = @"t3";
    thread3.threadPriority = 1;
    [thread3 start];
}
//线程是不安全的
//模拟卖票的方法
-(void)sellTicketsThreadNotSafe
{
    while (YES) {
        //模拟耗时
        [NSThread sleepForTimeInterval:1];
//        NSLog(@"--%@",[NSThread currentThread]);
        //任意一个对象内部都有一把锁
        //加锁会影响程序的性能
        
        //互斥锁 -- 目的是实现线程同步,让线程排队执行锁住的代码
        //线程同步 -- 这里必须加互斥锁，把读和写的操作变成原子操作
        @synchronized (self) {
            //判断还有没有票
            if (self.ticketsCount > 0) {
                self.ticketsCount = self.ticketsCount - 1;
                NSLog(@"剩余%i张票",self.ticketsCount);
            }else{
                NSLog(@"票卖完了");
                break;
            }
        }
        
    }
}

int sum(int a ,int b)
{
    int c = a+b;
    return c;
}

-(void)multiThreadDemo
{
        int c = sum(10, 10);
        NSLog(@"88%i",c);
    
        [NSThread detachNewThreadSelector:@selector(demo3) toTarget:self withObject:nil];
        /*
         线程生命周期五种状态
         新建状态
         就绪状态 -- 进入可调度线程池
         运行状态 -- cpu及操作系统控制，无法用代码描述
         阻塞状态
         死亡状态
         */
        //新建状态
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(demo2:) object:@"name"];
        //就绪状态 -- 进入可调度线程池
        [thread start];
        //线程的属性
        thread.name = @"tttt";
        thread.threadPriority = 0.4;//线程优先级
    
    //界面卡死(阻塞)
    //    [self demo];
    //    [self performSelectorInBackground:@selector(demo) withObject:nil];
    
//    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(demo4) object:nil];
//    thread1.name = @"t1";
//    thread1.threadPriority = 1;
//    [thread1 start];
//
//    NSThread *thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(demo4) object:nil];
//    thread2.name = @"t2";
//    thread2.threadPriority = 0;
//    [thread2 start];
}
-(void) demo2 :(NSString *)sender
{
    NSLog(@"%@---%@",sender, [NSThread currentThread]);
    for (int i = 0; i<20; i++) {
        NSLog(@"---%i",i);
        
        if (i == 5) {
            //阻塞状态
            [NSThread sleepForTimeInterval:3];
        }
        
        if (i == 10) {
            //线程退出 死亡状态
            [NSThread exit];
        }
    }
    //线程的任务执行完毕，自然死亡
}

-(void)demo3
{
    NSLog(@"++++++%@",[NSThread currentThread]);
}

-(void)demo4 {
    for (int i = 0; i < 20; i++) {
        NSLog(@"--%i --- %@",i, [NSThread currentThread]);
    }
}


//1 循环的速度非常快
//2 定义了一个整形变量 整形变量存储在栈空间，操作内存的栈空间速度非常快
//3 操作内存堆空间，速度有点慢
//4 I/O操作速度非常慢 (操作外部设备包括：硬盘、屏幕-控制台打印、打印机等)
//5 网络请求 最慢的操作
//耗时操作
-(void)demo
{
    NSLog(@"begin");
    for (int i =0; i<100000; i++) {
//        int a = 2;//2
//        NSString *str  = @"hello"; //字符串存储在常量区。如果每次创建的字符串一样，没有重新开辟内存空间
//        NSString *str = [NSString stringWithFormat:@"hello%i",i];//3 (执行此行代码时 循环非常消耗 CPU资源，操作内存堆区间耗内存)
        NSLog(@"hello %i",i);//4 I/O 操作
        
        
    }
    NSLog(@"end");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

















