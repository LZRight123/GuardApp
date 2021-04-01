//
//  MemHooks.h
//  GuardApp_Example
//
//  Created by 梁泽 on 2021/4/1.
//  Copyright © 2021 350442340@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Dobby/Dobby.h>
void loadFJMemoryHooks();
void loadFJMemoryRunTimeHooks();
void loadFJMemoryIntegrityRecover();
void loadFJMemorySymbolHooks();
void loadSVC80MemHooks();
void loadSVC80OpenMemHooks();
void loadSVC80AccessMemHooks();
void loadSVC80ExitMemHooks();
void loadOpendirMemHooks();
void loadSVC80FWMemHooks();
void startHookTarget_lxShield(uint8_t* match);
void startHookTarget_AhnLab(uint8_t* match);
void startHookTarget_AhnLab2(uint8_t* match);
void startHookTarget_AhnLab3(uint8_t* match);
void startHookTarget_AhnLab4(uint8_t* match);
void startHookTarget_AhnLab5(uint8_t* match);
void startHookTarget_AppSolid(uint8_t* match);
void startPatchTarget_SYSAccess(uint8_t* match);
void startPatchTarget_SYSAccessNOP(uint8_t* match);
void startPatchTarget_SYSOpen(uint8_t* match);
void startPatchTarget_KJBank(uint8_t* match);
void startPatchTarget_KJBank2(uint8_t* match);
void startPatchTarget_nProtect(uint8_t* match);
void startPatchTarget_nProtect2(uint8_t* match);
void startPatchTarget_MiniStock(uint8_t* match);
void startPatchTarget_ixGuard(uint8_t* match);
void startPatchTarget_HanaBank(uint8_t* match);
void startPatchTarget_Yoti(uint8_t* match);
void startPatchTarget_SaidaBank(uint8_t* match);
void startHookTarget_ixShield(uint8_t* match);
void startHookTarget_ixShield2(uint8_t* match);
void startPatchTarget_MyGenesis(uint8_t* match);
void setTossPatched(bool isPatched);
bool isTossPatched();

@interface MemHooks: NSObject
- (NSDictionary *)getFJMemory;
@end
