//
//  HKView.m
//  HK_MultiThreadDemo
//
//  Created by houke on 2018/3/13.
//  Copyright © 2018年 houke. All rights reserved.
//

#import "HKView.h"

@implementation HKView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setTitle:@"test" forState:(UIControlStateNormal)];
        btn.frame = CGRectMake(0, 0, 40, 40);
        btn.backgroundColor = [UIColor grayColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
    }
    return self;
}

-(void)btnClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(protocolMethod)]) {
        [self.delegate protocolMethod];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
