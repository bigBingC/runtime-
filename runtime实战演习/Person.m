//
//  Person.m
//  runtime实战演习
//
//  Created by cb on 16/6/28.
//  Copyright © 2016年 cuibing. All rights reserved.
//

#import "Person.h"

@interface Person ()

@end

@implementation Person
{
    NSString *name;
}
//@synthesize age;

- (instancetype)init
{
    self = [super init];
    if (self) {
        name = @"Tom";
        self.age = 12;
    }
    return self;
}

- (void)func1
{
    NSLog(@"方法1被执行");
}

- (void)func2
{
    NSLog(@"方法2被执行");
}
//输出 person 对象的方法
- (NSString *)description
{
    return [NSString stringWithFormat:@"name-%@ age-%d",name,self.age];
}

@end
