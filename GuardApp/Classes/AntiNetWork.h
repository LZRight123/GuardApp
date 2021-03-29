//
//  AntiNetWork.h
//  GuardApp
//
//  Created by 梁泽 on 2021/3/28.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "LZAntiHelp.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#import <pthread.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


/// 获取ip
static __attribute__((always_inline)) NSDictionary * lz_anti_net_getip() {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    NSMutableDictionary *dic = @{}.mutableCopy;
    if([addresses.allKeys containsObject:IOS_WIFI @"/" IP_ADDR_IPv4]){
        dic[IOS_WIFI @"/" IP_ADDR_IPv4] = addresses[IOS_WIFI @"/" IP_ADDR_IPv4];
    }
    if([addresses.allKeys containsObject:IOS_WIFI @"/" IP_ADDR_IPv6]){
        dic[IOS_WIFI @"/" IP_ADDR_IPv6] = addresses[IOS_WIFI @"/" IP_ADDR_IPv6];
    }
    return dic;
}


/// CFNetworkCopyProxiesForURL 检车
/*
 wifi:     kCFProxyTypeKey = kCFProxyTypeNone;
 
 
 */
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
    } else {
        //设置代理了
        abort();
        lz_asm_exit();
    }
    
}


///
/*
 wifi:     (null)
 {
     ExceptionsList =     (
         "*.local",
         "169.254/16"
     );
     FTPPassive = 1;
     HTTPEnable = 1;
     HTTPPort = 8888;
     HTTPProxy = "192.168.50.161";
     HTTPSEnable = 1;
     HTTPSPort = 8888;
     HTTPSProxy = "192.168.50.161";
     "__SCOPED__" =     {
         en0 =         {
             ExceptionsList =             (
                 "*.local",
                 "169.254/16"
             );
             FTPPassive = 1;
             HTTPEnable = 1;
             HTTPPort = 8888;
             HTTPProxy = "192.168.50.161";
             HTTPSEnable = 1;
             HTTPSPort = 8888;
             HTTPSProxy = "192.168.50.161";
         };
     };
 }
 
 */
static __attribute__((always_inline)) void lz_anti_net2() {
    CFDictionaryRef dicRef = CFNetworkCopySystemProxySettings();
    NSDictionary *proxySettings = CFBridgingRelease((__bridge CFTypeRef _Nullable)((__bridge NSDictionary *)CFNetworkCopySystemProxySettings()));
    
    const CFStringRef proxyCFstr = (const CFStringRef)CFDictionaryGetValue(dicRef,
                                                                           (const void*)kCFNetworkProxiesHTTPProxy);
    NSString* proxy = (__bridge NSString *)proxyCFstr;
    if (proxy.length > 0 ) {
        // 有代理
        abort();
        lz_asm_exit();
    }

}

/*
 wifi:     (null)
 
 
 */
//static __attribute__((always_inline)) void lz_anti_net3(){
//    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
//    NSLog(@"Supported interfaces: %@", ifs);
//    id info = nil;
//    for (NSString *ifnam in ifs) {
//        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
//        NSLog(@"%@ => %@", ifnam, info);
//        if (info && [info count]) { break; }
//    }
////    NSLog(@"lz_anti_net3 == %@", info);
//}


static __attribute__((always_inline)) void lz_anti_net_start() {
    @try {
        if (LZAntiHelp.share.antiNetworkTimer == nil) {
            LZAntiHelp.share.antiNetworkTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
        }
        
        dispatch_source_t timer = LZAntiHelp.share.antiNetworkTimer;
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 20.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, ^{
            lz_anti_net1();
            lz_anti_net2();
        });
        dispatch_resume(timer);
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
}


static __attribute__((constructor)) void lz_anti_network_entry() {
//    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            lz_anti_net_start();
//        });
//    }];
}

