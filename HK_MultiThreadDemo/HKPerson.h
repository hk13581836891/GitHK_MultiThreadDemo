//
//  HKPerson.h
//  HK_MultiThreadDemo
//
//  Created by houke on 2018/3/12.
//  Copyright © 2018年 houke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKPerson : NSObject

/*  */
@property (nonatomic, copy) NSString *name;
/* <#注释#> */
@property (nonatomic, assign) NSString *age;

@property (nonatomic, copy) NSString *ss;
+ (instancetype)initWithName:(NSString *)name;
@end
