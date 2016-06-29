//
//  Person+PersonCategory.m
//  runtime实战演习
//
//  Created by cb on 16/6/28.
//  Copyright © 2016年 cuibing. All rights reserved.
//

#import "Person+PersonCategory.h"
#import <objc/runtime.h>

const char *str = "myKey";

@implementation Person (PersonCategory)
//使用runtime中objc_setAssociatedObject()和objc_getAssociatedObject()方法，本质上只是为对象per添加了对height的属性关联，但是达到了新属性的作用；
- (void)setHeight:(float)height
{
    NSNumber *num = [NSNumber numberWithFloat:height];
    /**
     *  第一个参数是需要添加的属性对象
        第二个参数是属性的 key
        第三个参数是属性的值,类型必须为 id, 所以此处的 height 先转为 nsnumber 类型
        第四个参数是使用策略,是一个枚举
     */
    objc_setAssociatedObject(self, str, num, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)height
{
    NSNumber *numb = objc_getAssociatedObject(self, str);
    return [numb floatValue];
}

@end
