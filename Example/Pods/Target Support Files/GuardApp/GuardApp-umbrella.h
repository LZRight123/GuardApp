#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AntiDebug.h"
#import "AntiInjection.h"
#import "AntiNetWork.h"
#import "GuardApp.h"
#import "LZAntiHelp.h"

FOUNDATION_EXPORT double GuardAppVersionNumber;
FOUNDATION_EXPORT const unsigned char GuardAppVersionString[];

