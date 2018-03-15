//
//  HKPerson.m
//  HK_MultiThreadDemo
//
//  Created by houke on 2018/3/12.
//  Copyright © 2018年 houke. All rights reserved.
//

#import "HKPerson.h"

@interface HKPerson ()
@end


@implementation HKPerson

+ (instancetype)initWithName:(NSString *)name
{
    HKPerson *person = [[[HKPerson alloc] init] autorelease];
    person.name = name;
    
    return person;
    
}


@end
