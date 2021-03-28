//
//  AntiDebug.h
//  AntiDebug
//
//  Created by 梁泽 on 2021/3/28.
//

#import <dlfcn.h>
#import <sys/sysctl.h>
#import <Foundation/Foundation.h>
/// 直接pt
static __attribute__((always_inline)) void lz_ptrace() {
    int ptrace(int _request, int _pid, char *  _addr, int _data);
    ptrace(31, 0, 0, 0);
}

/// 间接pt
static __attribute__((always_inline)) void lz_dlhandle() {
    typedef int (*ptrace_ptr_t)(int _request, int _pid, char * _addr, int _data);
    
    void *handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
    ptrace_ptr_t ptrace = (ptrace_ptr_t)dlsym(handle, "ptrace");
    ptrace(31, 0, 0, 0);
}

/// syscall掉pt
static __attribute__((always_inline)) void lz_syscall() {
    // https://www.theiphonewiki.com/wiki/Kernel_Syscalls
    //    syscall(26, 31, 0, 0, 0);
    NSLog(@"在你的代码里掉syscall");
}

/// 汇编掉pt
static __attribute__((always_inline)) void lz_asm_pt() {
    __asm(
          "mov x0,#31\n"
          "mov x1,#0\n"
          "mov x2,#0\n"
          "mov x3,#0\n"
          "mov w16,#26\n" //26是ptrace
          "svc #0x80" //0x80触发中断去找w16执行
          );
}


//static int lz_get_pid() {
//    int err = 0;
//    struct kinfo_proc *proc_list = NULL;
//    size_t length = 0;
//    static const int sysName[] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
//    err = sysctl((int*)sysName, 4, proc_list, &length, NULL, 0);
//    if (!err) {
//        proc_list = malloc(length);
//        if (proc_list) {
//            err = sysctl((int*)sysName, 4, proc_list, &length, NULL, 0);
//        }
//    }
//    if (!err && proc_list) {
//        int proc_count = length / sizeof(struct kinfo_proc);
//        char buf[17];
//    }
//    return 0;
//}

///stysctl
static __attribute__((always_inline)) BOOL lz_isDebuggingWithSysctl() {
    /**
     需要检测进程信息的字段数组
     */
    int name[4];
    name[0] = CTL_KERN;
    name[1] = KERN_PROC;
    name[2] = KERN_PROC_PID;
    name[3] = getpid();
    
    /**
     查询进程信息结果的结构体
     */
    struct kinfo_proc info;
    size_t info_size = sizeof(info);
    info.kp_proc.p_flag = 0;
    
    /*查询成功返回0*/
    int error = sysctl(name, sizeof(name) / sizeof(*name), &info, &info_size, NULL, 0);
    if (error == -1) {
        NSLog(@"sysctl process check error ...");
        return NO;
    }
    
    /*根据标记位检测调试状态*/
    return ((info.kp_proc.p_flag & P_TRACED) != 0);
}

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

@interface LZAntiHelp : NSObject
@property (nonatomic) dispatch_source_t timer;
+ (instancetype)share;
@end


static __attribute__((always_inline)) void lz_anti_debug_for_sysctl() {
    if (LZAntiHelp.share.timer == nil) {
        LZAntiHelp.share.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    }
    
    dispatch_source_t timer = LZAntiHelp.share.timer;
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, ^{
            if (lz_isDebuggingWithSysctl()) {
//                abort();
                lz_asm_exit();
            }else {
//                NSLog(@"正常");
            }
        });
        dispatch_resume(timer);
}



/// 开启
static __attribute__((always_inline)) void lz_anti_start() {
    lz_ptrace();
    lz_dlhandle();
    lz_anti_debug_for_sysctl();
    lz_asm_pt();
}


static __attribute__((constructor)) void lz_anti_debug_entry() {
//    NSLog(@"lz_anti_debug_entry");
}