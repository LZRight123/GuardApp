//
//  LZAntiHelp.m
//  GuardApp
//
//  Created by 梁泽 on 2021/3/28.
//

#import "LZAntiHelp.h"

@implementation LZAntiHelp
+ (instancetype)share {
    static LZAntiHelp *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });

    return _sharedManager;
}
@end
