//
//  AntiInjection.h
//  GuardApp
//
//  Created by 梁泽 on 2021/3/29.
//

#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>

static __attribute__((always_inline)) void lz_anti_injected1() {
    int count = _dyld_image_count();
    if (count > 0) {
        for (int i = 0; i < count; i++) {//遍历所有的image_name。判断是否有DynamicLibraries
            const char * dyld = _dyld_get_image_name(i);
            if (strstr(dyld, "DynamicLibraries")) {
                NSLog(@"lz_anti_Injected1");
                return ;
            }
        }
    }
}

static __attribute__((always_inline)) void lz_anti_injected2() {
    int count = _dyld_image_count();
    if (count > 0) {
        for (int i = 0; i < count; i++) {//遍历所有的image_name。判断是否有DynamicLibraries
            const char * dyld = _dyld_get_image_name(i);
            if (strstr(dyld, "/private/var/containers/Bundle/Application") && strstr(dyld, ".app") &&  strstr(dyld, ".dylib")) {
                NSLog(@"lz_anti_Injected2 === 命中");
                return ;
            }
        }
    }
}

/// 检测环境变量是否有DYLD_INSERT_LIBRARIES
static __attribute__((always_inline)) void lz_anti_injected3() {
    char* env = getenv("DYLD_INSERT_LIBRARIES");
    printf("lz_anti_injected2 env = %s", env);
    if(env){
        NSLog(@"lz_anti_Injected3");
        return;
    }
}

static __attribute__((always_inline)) void lz_anti_injected_start() {
    
    @try {
        if (LZAntiHelp.share.antiInjectionTimer == nil) {
            LZAntiHelp.share.antiInjectionTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
        }
        
        dispatch_source_t timer = LZAntiHelp.share.antiInjectionTimer;
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, ^{
            lz_anti_injected1();
            lz_anti_injected2();
            lz_anti_injected3();
        });
        
        dispatch_resume(timer);
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
}

