# GuardApp
### 持续更新中....

## Installation

AntiDebug is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GuardApp', :git => "https://github.com/LZRight123/GuardApp.git"
```

## 反调试

```oc
lz_anti_debug_start()
```
内部调用了`lz_ptrace`，`lz_dlhandle`，`lz_anti_debug_for_sysctl`，`lz_asm_pt`，`lz_anti_debug_isatty`，`lz_asm_exit`

## 反代理，反网络抓包

```oc
lz_anti_net_start();
```

## 反注入
- 调试阶段
```oc
lz_anti_injected_start();
```

## Author

350442340@qq.com, 350442340@qq.com

## License

AntiDebug is available under the MIT license. See the LICENSE file for more info.
