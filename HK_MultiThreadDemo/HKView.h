//
//  HKView.h
//  HK_MultiThreadDemo
//
//  Created by houke on 2018/3/13.
//  Copyright © 2018年 houke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyDelegate <NSObject>

-(void)protocolMethod;

@end

@interface HKView : UIView

@property (nonatomic,weak) id<MyDelegate> delegate;
@end
