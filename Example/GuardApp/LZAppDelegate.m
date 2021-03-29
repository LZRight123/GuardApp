//
//  LZAppDelegate.m
//  GuardApp
//
//  Created by 350442340@qq.com on 03/28/2021.
//  Copyright (c) 2021 350442340@qq.com. All rights reserved.
//

#import "LZAppDelegate.h"
#import "GuardApp_Example-Swift.h"
#import <GuardApp/GuardApp.h>
#include <termios.h>
#import <mach/task.h>
#import <mach/mach_init.h>



@implementation LZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_SIGNAL, SIGSTOP, 0, dispatch_get_main_queue());
    dispatch_source_set_event_handler(source, ^{
        NSLog(@"SIGSTOP!!!");
    });
    dispatch_resume(source);

  
    lz_anti_debug_start();

   

    return YES;
}

@end
