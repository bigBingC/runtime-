//
//  ViewController.m
//  runtime实战演习
//
//  Created by cb on 16/6/28.
//  Copyright © 2016年 cuibing. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "Person.h"
#import "Person+PersonCategory.h"
@interface ViewController ()

@end

@implementation ViewController
{
    Person *per;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    per = [[Person alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//获取所有方法
- (IBAction)getAllVariable:(UIButton *)sender
{
    /**
     Ivar，一个指向objc_ivar结构体指针,包含了变量名、变量类型等信息。
     
     ①class_copyIvarList能够获取一个含有类中所有成员变量的列表，列表中包括属性变量和实例变量。需要注意的是，如果如本例中，age返回的是"_age"，但是如果在person.m中加入：
     @synthesize age;
     那么控制台第二行返回的是"(Name: age) ----- (Type:i) ；"（因为@property是生成了"_age"，而@synthesize是执行了"@synthesize age = _age;"，关于OC属性变量与实例变量的区别、@property、@synthesize的作用等具体的知识，有兴趣的童鞋可以自行了解。）
     
     ②如果单单需要获取属性列表的话，可以使用函数：class_copyPropertyList（）;只是返回的属性变量仅仅是“age”，做为实例变量的name是不被获取的。
     
     而class_copyIvarList（）函数则能够返回实例变量和属性变量的所有成员变量。
     */
    unsigned int count = 0;
    //获取类的一个包含所有变量的列表,Ivar是 runtime 声明的宏,是实例变量的意思
    Ivar *allVariable = class_copyIvarList([Person class], &count);
    for (int i = 0; i < count; i ++) {
        Ivar ivar = allVariable[i];
        //获取成员变量名称
        const char *Variablename = ivar_getName(ivar);
        //获取成员变量类型
        const char *VariableType = ivar_getTypeEncoding(ivar);
        NSLog(@"name-%s  ---  Type-%s",Variablename,VariableType);
    }
    
    //获取属性列表
    objc_property_t *allProPerty = class_copyPropertyList([Person class], &count);
    for (int i = 0; i < count; i ++) {
        objc_property_t ivar = allProPerty[i];
        const char *Vname = property_getName(ivar);
        NSLog(@"Pname-%s",Vname);
    }

}
//获取所有方法
- (IBAction)getAllMethod:(UIButton *)sender
{
    unsigned int count = 0;
    //获取方法列表,所有在.m文件显示实现的方法都会被找到,包括 setter,getter 方法
    Method *allMethod = class_copyMethodList([Person class], &count);
    for (int i = 0; i < count; i ++) {
        Method md = allMethod[i];
        SEL sel = method_getName(md);
        //得到sel的方法名：以字符串格式获取sel的name，也即@selector()中的方法名称
        const char *methodName = sel_getName(sel);
        NSLog(@"methodName-%s",methodName);
    }
}
//改变私有变量
- (IBAction)changeVariable:(UIButton *)sender
{
    NSLog(@"改变前的 person:%@",per);
    
    unsigned int count = 0;
    Ivar *allList = class_copyIvarList([Person class], &count);
    //从第一个方法getAllVariable中输出的控制台信息，我们可以看到name为第一个实例属性；
    Ivar iv = allList[0];
    object_setIvar(per, iv, @"JJ");
    NSLog(@"改变后的 person:%@",per);
}
//添加一个新属性
- (IBAction)addVarible:(UIButton *)sender
{
    per.height = 12;
    NSLog(@"height-%f",per.height);
}
//添加一个新方法
- (IBAction)addMethod:(UIButton *)sender
{
    class_addMethod([per class], @selector(NewMethod), (IMP)newAddMethod, 0);
    [per performSelector:@selector(NewMethod)];
}

- (void)NewMethod{
  
}

int newAddMethod(id self,SEL _cmd){
    NSLog(@"新增方法");
    return 1;
}

//交换两个方法的功能
- (IBAction)replaceMethod:(UIButton *)sender
{
    Method method1 = class_getInstanceMethod([Person class], @selector(func1));
    Method method2 = class_getInstanceMethod([Person class], @selector(func2));
    //交换方法
    method_exchangeImplementations(method1, method2);
    [per func1];
}

@end
