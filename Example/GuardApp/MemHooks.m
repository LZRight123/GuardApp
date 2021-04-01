#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MemHooks.h"
#import "AeonLucid.h"
#include <sys/syscall.h>
#include <dlfcn.h>
#include <mach-o/dyld.h>

@implementation MemHooks
- (NSDictionary *)getFJMemory {
    NSData *FJMemory = [NSData dataWithContentsOfFile:@"/var/mobile/Library/Preferences/FJMemory" options:0 error:nil];
    NSDictionary *DecryptedFJMemory = [NSJSONSerialization JSONObjectWithData:FJMemory options:0 error:nil];
    return DecryptedFJMemory;
}
@end

struct ix_detected_pattern {
    char resultCode[12];
    char object[128];
    char description[128];
};

struct ix_detected_pattern_list_gamehack {
    struct ix_detected_pattern *pattern;
    int listCount;
};

uint8_t NOP[] = {
    0x1F, 0x20, 0x03, 0xD5  //NOP
};

uint8_t RET[] = {
    0xC0, 0x03, 0x5F, 0xD6  //RET
};

uint8_t RET0[] = {
    0x00, 0x00, 0x80, 0xD2,    //MOV X0, #0
    0xC0, 0x03, 0x5F, 0xD6  //RET
};

uint8_t RET1[] = {
    0x20, 0x00, 0x80, 0xD2,    //MOV X0, #1
    0xC0, 0x03, 0x5F, 0xD6  //RET
};

uint8_t MOV_X0_1[] = {
    0x20, 0x00, 0x80, 0xD2    //MOV X0, #1
};

uint8_t KJP[] = {
    0x1F, 0x20, 0x03, 0xD5,    //NOP
    0x09, 0x00, 0x00, 0x14    //B #0x24
};

uint8_t SYSOpenBlock[] = {
    0xB0, 0x00, 0x80, 0xD2, //MOV X16, #5
    0x00, 0x00, 0x80, 0x52  //MOV X0, #0
};

uint8_t SYSAccessBlock[] = {
    0xB0, 0x00, 0x80, 0xD2,    //MOV X16, #21
    0x40, 0x00, 0x80, 0x52    //MOV X0, #2
};

uint8_t SYSAccessNOPBlock[] = {
    0xB0, 0x00, 0x80, 0xD2, //MOV X16, #21
    0x1F, 0x20, 0x03, 0xD5,  //NOP
    0x1F, 0x20, 0x03, 0xD5,  //NOP
    0x1F, 0x20, 0x03, 0xD5,  //NOP
    0x40, 0x00, 0x80, 0x52  //MOV X0, #2
};

int (*orig_ix_sysCheckStart)(struct ix_detected_pattern **p_info);
int hook_ix_sysCheckStart(struct ix_detected_pattern **p_info)
{
    struct ix_detected_pattern *patternInfo = (struct ix_detected_pattern*)malloc(sizeof(struct ix_detected_pattern));
    strcpy(patternInfo->resultCode, "0000");
    strcpy(patternInfo->object, "SYSTEM_OK");
    strcpy(patternInfo->description, "SYSTEM_OK");
    *p_info = patternInfo;
    return 1;
}

int (*orig_ix_sysCheck_gamehack)(struct ix_detected_pattern **p_info, struct ix_detected_pattern_list_gamehack **p_list_gamehack);
int hook_ix_sysCheck_gamehack(struct ix_detected_pattern **p_info, struct ix_detected_pattern_list_gamehack **p_list_gamehack) {
    struct ix_detected_pattern *patternInfo = (struct ix_detected_pattern*)malloc(sizeof(struct ix_detected_pattern));
  struct ix_detected_pattern_list_gamehack *patternList = (struct ix_detected_pattern_list_gamehack*)malloc(sizeof(struct ix_detected_pattern_list_gamehack));

    strcpy(patternInfo->resultCode, "0000");
    strcpy(patternInfo->object, "SYSTEM_OK");
    strcpy(patternInfo->description, "SYSTEM_OK");
    patternList->listCount = 0;

    *p_info = patternInfo;
    *p_list_gamehack = patternList;

    return 1;
}

void (*orig_subroutine)(void);
void nothing(void)
{
    ;
}

int (*orig_int)(void);

int ret_0(void)
{
    return 0;
}

int ret_1(void)
{
    return 1;
}

void startHookTarget_lxShield(uint8_t* match) {
    uint8_t *func = find_start_of_function(match);
    hook_memory(func, RET, sizeof(RET));
}

void startHookTarget_AhnLab(uint8_t* match) {
    hook_memory(match, RET, sizeof(RET));
}

void startHookTarget_AhnLab2(uint8_t* match) {
    hook_memory(match - 0x10, RET, sizeof(RET));
}

void startHookTarget_AhnLab3(uint8_t* match) {
    hook_memory(match - 0x8, RET, sizeof(RET));
}

void startHookTarget_AhnLab4(uint8_t* match) {
    hook_memory(match - 0x10, RET, sizeof(RET));
}

void startHookTarget_AhnLab5(uint8_t* match) {
    hook_memory(match - 0x1C, RET, sizeof(RET));
}

void startHookTarget_AppSolid(uint8_t* match) {

    hook_memory(match, RET, sizeof(RET));

}

void startPatchTarget_KJBank(uint8_t* match) {
    hook_memory(match - 0x4, KJP, sizeof(KJP));
}

void startPatchTarget_KJBank2(uint8_t* match) {
    uint8_t B10[] = {
        0x04, 0x00, 0x00, 0x14  //B #0x10
    };

    hook_memory(match + 0x14, B10, sizeof(B10));
}

void startPatchTarget_nProtect(uint8_t* match) {
    hook_memory(match, RET, sizeof(RET));
}

void startPatchTarget_nProtect2(uint8_t* match) {
    hook_memory(match - 0x10, RET, sizeof(RET));
}

void startPatchTarget_MiniStock(uint8_t* match) {
    hook_memory(match - 0x1C, RET1, sizeof(RET1));
}

void startPatchTarget_MyGenesis(uint8_t* match) {
    hook_memory(match + 0xC, MOV_X0_1, sizeof(MOV_X0_1));
}

static bool tossPatched = false;
void setTossPatched(bool isPatched) {
    tossPatched = isPatched;
}

bool isTossPatched() {
    return tossPatched;
}

void startPatchTarget_ixGuard(uint8_t* match) {
    uint8_t *func = find_start_of_function(match);
    // NSLog(@"[FlyJB] Found ixGuard: %p", func - _dyld_get_image_vmaddr_slide(0));
    setTossPatched(true);
    hook_memory(func, RET, sizeof(RET));
}

void startPatchTarget_HanaBank(uint8_t* match) {
    uint8_t *func = find_start_of_function(match);
    // NSLog(@"[FlyJB] match: %p, Found HanaBank: %p", match - _dyld_get_image_vmaddr_slide(0),func - _dyld_get_image_vmaddr_slide(0));
    hook_memory(func, RET, sizeof(RET));
}

void startPatchTarget_Yoti(uint8_t* match) {
    hook_memory(match - 0x60, RET0, sizeof(RET0));
}

void startPatchTarget_SaidaBank(uint8_t* match) {
    hook_memory(match + 0x4, NOP, sizeof(NOP));
}

void startHookTarget_ixShield(uint8_t* match) {
    uint8_t *func = find_start_of_function(match);
    // NSLog(@"[FlyJB] Found ixShield_sysCheckStart: %p, match: %p", func - _dyld_get_image_vmaddr_slide(0), match - _dyld_get_image_vmaddr_slide(0));
//    MSHookFunction((void *)(func), (void *)hook_ix_sysCheckStart, (void **)&orig_ix_sysCheckStart);
}

void startHookTarget_ixShield2(uint8_t* match) {
    uint8_t *func = find_start_of_function(match);
    // NSLog(@"[FlyJB] Found ixShield_sysCheck_gamehack: %p, match: %p", func - _dyld_get_image_vmaddr_slide(0), match - _dyld_get_image_vmaddr_slide(0));
//    MSHookFunction((void *)(func), (void *)hook_ix_sysCheck_gamehack, (void **)&orig_ix_sysCheck_gamehack);
}

void startPatchTarget_SYSAccess(uint8_t* match) {

    hook_memory(match, SYSAccessBlock, sizeof(SYSAccessBlock));

}

void startPatchTarget_SYSAccessNOP(uint8_t* match) {

    hook_memory(match, SYSAccessNOPBlock, sizeof(SYSAccessNOPBlock));

}

void startPatchTarget_SYSOpen(uint8_t* match) {

    hook_memory(match, SYSOpenBlock, sizeof(SYSOpenBlock));

}

// ====== PATCH CODE ====== //
void SVC80_handler(RegisterContext *reg_ctx, const HookEntryInfo *info) {

    int syscall_num = (int)(uint64_t)reg_ctx->general.regs.x16;
    if(syscall_num == SYS_open || syscall_num == SYS_access || syscall_num == SYS_lstat64 || syscall_num == SYS_setxattr || syscall_num == SYS_stat64 || syscall_num == SYS_rename || syscall_num == SYS_stat || syscall_num == SYS_utimes || syscall_num == SYS_unmount || syscall_num == SYS_pathconf) {
        const char* path = (const char*)(uint64_t)(reg_ctx->general.regs.x0);
        NSString* path2 = [NSString stringWithUTF8String:path];
        if(![path2 hasSuffix:@"/sbin/mount"]) {
            *(unsigned long *)(&reg_ctx->general.regs.x0) = (unsigned long long)"/XsF1re";
            NSLog(@"[FlyJB] Bypassed SVC #0x80 - num: %d, path: %s", syscall_num, path);
        }
        else {
            NSLog(@"[FlyJB] Detected SVC #0x80 - num: %d, path: %s", syscall_num, path);
        }
    }

    else if(syscall_num == SYS_syscall) {
        int x0 = (int)(uint64_t)reg_ctx->general.regs.x0;
        NSLog(@"[FlyJB] Detected syscall of SVC #0x80 number: %d", x0);
    }

    else if(syscall_num == SYS_exit) {
        NSLog(@"[FlyJB] Detected SVC #0x80 Exit call stack: \n%@", [NSThread callStackSymbols]);
    }

    else {
        NSLog(@"[FlyJB] Detected Unknown SVC #0x80 number: %d", syscall_num);
    }

}

void startHookTarget_SVC80(uint8_t* match) {

    dobby_enable_near_branch_trampoline();
    DobbyInstrument((void *)(match), (DBICallTy)SVC80_handler);
    // NSLog(@"[FlyJB] svc80: %p", match-_dyld_get_image_vmaddr_slide(0));
    dobby_disable_near_branch_trampoline();

}

void loadSVC80MemHooks() {
    const uint8_t target[] = {
        0x01, 0x10, 0x00, 0xD4  //SVC #0x80
    };

    scan_executable_memory(target, sizeof(target), &startHookTarget_SVC80);
}

void SVC80Access_handler(RegisterContext *reg_ctx, const HookEntryInfo *info) {

    const char* path = (const char*)(uint64_t)(reg_ctx->general.regs.x0);
    NSString* path2 = [NSString stringWithUTF8String:path];

//Arxan 솔루션에서는 /sbin/mount 파일이 존재해야 우회됨.
    if(![path2 hasSuffix:@"/sbin/mount"]) {
        //Start Bypass
        NSLog(@"[FlyJB] Bypassed SVC #0x80 - SYS_Access path = %s", path);
        *(unsigned long *)(&reg_ctx->general.regs.x0) = (unsigned long long)"/XsF1re";
    }
    else {
        NSLog(@"[FlyJB] Detected SVC #0x80 - SYS_Access path = %s", path);
    }
}

void startHookTarget_SVC80Access(uint8_t* match) {

    dobby_enable_near_branch_trampoline();
    DobbyInstrument((void *)(match), (DBICallTy)SVC80Access_handler);
    dobby_disable_near_branch_trampoline();

}

void loadSVC80AccessMemHooks() {

    const uint8_t target[] = {
        0x30, 0x04, 0x80, 0xD2, //MOV X16, #21
        0x01, 0x10, 0x00, 0xD4  //SVC #0x80
    };
    scan_executable_memory(target, sizeof(target), &startHookTarget_SVC80Access);

    const uint8_t target2[] = {
        0x30, 0x04, 0x80, 0xD2, //MOV X16, #21
        0x1F, 0x20, 0x03, 0xD5,  //NOP
        0x1F, 0x20, 0x03, 0xD5,  //NOP
        0x1F, 0x20, 0x03, 0xD5,  //NOP
        0x01, 0x10, 0x00, 0xD4  //SVC #0x80
    };
    scan_executable_memory(target2, sizeof(target2), &startHookTarget_SVC80Access);

}

void SVC80Open_handler(RegisterContext *reg_ctx, const HookEntryInfo *info) {

    const char* path = (const char*)(uint64_t)(reg_ctx->general.regs.x0);
    NSString* path2 = [NSString stringWithUTF8String:path];

    if(![path2 hasSuffix:@"/sbin/mount"]) {
        //Start Bypass
        NSLog(@"[FlyJB] Bypassed SVC #0x80 - SYS_Open path = %s", path);
        *(unsigned long *)(&reg_ctx->general.regs.x0) = (unsigned long long)"/XsF1re";
    }
    else {
        NSLog(@"[FlyJB] Detected SVC #0x80 - SYS_Open path = %s", path);
    }
}

void startHookTarget_SVC80Open(uint8_t* match) {
    dobby_enable_near_branch_trampoline();
    DobbyInstrument((void *)(match), (DBICallTy)SVC80Open_handler);
    dobby_disable_near_branch_trampoline();
}

void loadSVC80OpenMemHooks() {

    const uint8_t target[] = {
        0xB0, 0x00, 0x80, 0xD2, //MOV X16, #5
        0x01, 0x10, 0x00, 0xD4  //SVC #0x80
    };
    scan_executable_memory(target, sizeof(target), &startHookTarget_SVC80Open);
}

void SVC80Exit_handler(RegisterContext *reg_ctx, const HookEntryInfo *info) {
    NSLog(@"[FlyJB] Detected SVC #0x80 Exit call stack: \n%@", [NSThread callStackSymbols]);
}

void startHookTarget_SVC80Exit(uint8_t* match) {
    // dobby_enable_near_branch_trampoline();
    DobbyInstrument((void *)(match + 0x4), (DBICallTy)SVC80Exit_handler);
    // dobby_disable_near_branch_trampoline();
}

void loadSVC80ExitMemHooks() {

    const uint8_t target[] = {
        0x30, 0x00, 0x80, 0xD2, //MOV X16, #1
        0x01, 0x10, 0x00, 0xD4  //SVC #0x80
    };
    scan_executable_memory(target, sizeof(target), &startHookTarget_SVC80Exit);
}
//
// void blrx8_handler(RegisterContext *reg_ctx, const HookEntryInfo *info) {
//     uint64_t x8 = (uint64_t)(reg_ctx->general.regs.x8);
//     NSLog(@"[FlyJB] BLR X8: %llX", x8 - _dyld_get_image_vmaddr_slide(3));
//     NSLog(@"[FlyJB] BLR X8 callstack: %@", [NSThread callStackSymbols]);
// }
//
// void blrx9_handler(RegisterContext *reg_ctx, const HookEntryInfo *info) {
//     uint64_t x9 = (uint64_t)(reg_ctx->general.regs.x9);
//     NSLog(@"[FlyJB] BLR X9: %llX", x9 - _dyld_get_image_vmaddr_slide(3));
// }
//
// void blrx10_handler(RegisterContext *reg_ctx, const HookEntryInfo *info) {
//     uint64_t x10 = (uint64_t)(reg_ctx->general.regs.x10);
//     NSLog(@"[FlyJB] BLR X10: %llX", x10 - _dyld_get_image_vmaddr_slide(3));
// }





