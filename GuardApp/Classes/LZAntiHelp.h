//
//  LZAntiHelp.h
//  GuardApp
//
//  Created by 梁泽 on 2021/3/28.
//

#import <Foundation/Foundation.h>
#define antiDebugTimer xcodebl
#define antiNetworkTimer xcodebuild_cc
#define antiInjectionTimer xcodebuild_inj


@interface LZAntiHelp : NSObject
@property (nonatomic) dispatch_source_t antiDebugTimer;
@property (nonatomic) dispatch_source_t antiNetworkTimer;
@property (nonatomic) dispatch_source_t antiInjectionTimer;

+ (instancetype)share;
@end


/// 退出程序
static __attribute__((always_inline)) void lz_asm_exit() {
#ifdef __arm64__
    __asm__("mov X0, #0\n"
            "mov w16, #1\n"
            "svc #0x80\n"
            
            "mov x1, #0\n"
            "mov sp, x1\n"
            "mov x29, x1\n"
            "mov x30, x1\n"
            "ret");
#endif
    abort();
    exit(-1);
}
