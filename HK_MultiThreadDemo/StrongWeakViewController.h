//
//  StrongWeakViewController.h
//  HK_MultiThreadDemo
//
//  Created by houke on 2018/3/13.
//  Copyright © 2018年 houke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyControllerProtocol <NSObject>
-(void)myControllerProtocolMethod;

@end

@interface StrongWeakViewController : UIViewController

@property (nonatomic,copy) void (^myBlock)();
@property (nonatomic,weak) id<MyControllerProtocol> delegate;
@property (nonatomic, copy) NSString *ss;
@end
