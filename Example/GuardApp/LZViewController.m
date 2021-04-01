//
//  LZViewController.m
//  GuardApp
//
//  Created by 350442340@qq.com on 03/28/2021.
//  Copyright (c) 2021 350442340@qq.com. All rights reserved.
//

#import "LZViewController.h"
//#include <sys/ioctl.h>
#import <GuardApp.h>
#import <Dobby/Dobby.h>
@interface LZViewController ()

@end


#pragma mark -
#pragma mark -NSLogc
static void (*orig_NSLog)(NSString *, ...);
static void my_NSLog(NSString *format, ...){
    va_list args;
    if(format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        orig_NSLog(@"我的输出:%@", message);
        va_end(args);
    }
}

int sum(int a,int b){
    return  a + b;
}

static int(*sum_p)(int a,int b);
//新函数
int mySum(int a,int b){
    NSLog(@"原有的结果是:%d",sum_p(a,b));
    return a - b;
}




@implementation LZViewController
+(void)load
{
    //Hook sum
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSLog(@"打印出：%d",sum(10, 20));

//    DobbyHook(sum, mySum, (void *)&sum_p);
//    DobbyHook(NSLog, my_NSLog, (void *)&orig_NSLog);


	// Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if (!ioctl(1, TIOCGWINSZ)) {
//         NSLog(@"Being Debugged ioctl");
//     } else {
//         NSLog(@"ioctl bypassed");
//     }
    sum(10, 20);
    NSLog(@"打印出：%d",sum(10, 20));


}





@end
