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
#import <Dobby/Dobby.h>

static int (*ptrace_ptr_t)(int _request,pid_t _pid, caddr_t _addr,int _data);
int my_ptrace(int _request, pid_t _pid, caddr_t _addr, int _data){
    if(_request != 31){
        return ptrace_ptr_t(_request,_pid,_addr,_data);
    }
    
    
    return 0;
}




#import "MemHooks.h"
#import "AeonLucid.h"

// ====== PATCH CODE ====== //



@implementation LZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{


    loadSVC80AccessMemHooks();
            loadSVC80OpenMemHooks();
//                    loadSVC80FWMemHooks();
//    DobbyHook(DobbySymbolResolver(NULL, "ptrace"), my_ptrace, &ptrace_ptr_t);
//    DobbyDestroy(ptrace_ptr_t);
//    lz_asm_exit();
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_SIGNAL, SIGSTOP, 0, dispatch_get_main_queue());
    dispatch_source_set_event_handler(source, ^{
        NSLog(@"SIGSTOP!!!");
    });
    dispatch_resume(source);


//    lz_anti_debug_start();

   

    return YES;
}

@end
