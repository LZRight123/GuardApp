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
@interface LZViewController ()

@end

@implementation LZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if (!ioctl(1, TIOCGWINSZ)) {
//         NSLog(@"Being Debugged ioctl");
//     } else {
//         NSLog(@"ioctl bypassed");
//     }
    
    lz_anti_debug_start();


}

@end
