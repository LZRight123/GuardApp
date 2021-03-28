//
//  AntiNetWork.h
//  GuardApp
//
//  Created by 梁泽 on 2021/3/28.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>

NS_ASSUME_NONNULL_BEGIN

@interface AntiNetWork : NSObject

@end

NS_ASSUME_NONNULL_END

/// CFNetworkCopyProxiesForURL 检车
static __attribute__((always_inline)) void lz_anti_net1() {
    
    NSDictionary *proxySettings = CFBridgingRelease((__bridge CFTypeRef _Nullable)((__bridge NSDictionary *)CFNetworkCopySystemProxySettings()));
    NSArray *proxies = CFBridgingRelease((__bridge CFTypeRef _Nullable)((__bridge NSArray *)CFNetworkCopyProxiesForURL((__bridge CFURLRef)[NSURL URLWithString:@"http://www.google.com"], (__bridge CFDictionaryRef)proxySettings)));
    NSDictionary *settings = [proxies objectAtIndex:0];
    NSLog(@"host=%@", [settings objectForKey:(NSString *)kCFProxyHostNameKey]);
    NSLog(@"port=%@", [settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
    NSLog(@"type=%@", [settings objectForKey:(NSString *)kCFProxyTypeKey]);
    if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"])
    {
        //没有设置代理
//        return NO;
        NSLog(@"");

    } else {
        //设置代理了
        NSLog(@"");

//        return YES;
    }
    
}


///
static __attribute__((always_inline)) void lz_anti_net2() {
    CFDictionaryRef dicRef = CFNetworkCopySystemProxySettings();
      const CFStringRef proxyCFstr = (const CFStringRef)CFDictionaryGetValue(dicRef,
                                                                             (const void*)kCFNetworkProxiesHTTPProxy);
      NSString* proxy = (__bridge NSString *)proxyCFstr;
    NSLog(@"");
}


static __attribute__((always_inline)) void lz_anti_net3(){
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
       NSLog(@"Supported interfaces: %@", ifs);
       id info = nil;
       for (NSString *ifnam in ifs) {
           info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
           NSLog(@"%@ => %@", ifnam, info);
           if (info && [info count]) { break; }
       }
    NSLog(@"%@", info);
}


static __attribute__((always_inline)) void lz_anti_net_start() {
    lz_anti_net1();
    lz_anti_net2();
    lz_anti_net3();
}
