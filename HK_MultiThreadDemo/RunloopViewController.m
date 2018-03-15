//
//  RunloopViewController.m
//  HK_MultiThreadDemo
//
//  Created by houke on 2018/3/15.
//  Copyright © 2018年 houke. All rights reserved.
//

#import "RunloopViewController.h"

@interface RunloopViewController ()

@end

@implementation RunloopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(dispatch_get_main_queue(), ^{
        <#code#>
    });
    // Do any additional setup after loading the view.
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
