# GuardApp

## Installation

AntiDebug is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GuardApp', :git => "https://github.com/LZRight123/GuardApp.git"
```

## Requirements
无

## AntiDebug
反调试,退出程序

###### oc,swift用法：
```oc
lz_ptrace()
lz_dlhandle()
lz_anti_debug_for_sysctl()
lz_asm_pt()

let isDebug = lz_isDebuggingWithSysctl()
lz_asm_exit()
```

## Author

350442340@qq.com, 350442340@qq.com

## License

AntiDebug is available under the MIT license. See the LICENSE file for more info.
