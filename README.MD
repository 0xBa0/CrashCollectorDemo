# UM+ & Bugly

关于收集crash报告，市场上有腾讯的[**Bugly**](https://bugly.qq.com/v2/index)和[**友盟+**](https://www.umeng.com)等等方案，今天就来研究一下两者的区别和使用方法。


## UM+ 
### 用法说明[官方文档](https://developer.umeng.com/docs/119267/cate/119475)

```
pod 'UMCCommon'
pod 'UMCAnalytics'
```

#### Objective-C
```
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UMConfigure initWithAppkey:@"APPKEY" channel:@"CHANNEL"];
       
    return YES;
}
```

#### Swift
因为UM+本身不是纯swift的库，所以还得把头文件加入到桥接文件里**PROJECTNAME-Bridging-Header.h**

```
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UMConfigure.initWithAppkey("APPKEY", channel: "CHANNEL")
        
        return true
    }
```

好了，就这样，我们将UM+的错误报告收集集成完毕。

### 错误分析

![UM+Analysis](https://github.com/Zac-Cheung/CrashCollectorDemo/blob/develop/images/UM%2BErrorAnalysis.jpg)

友盟+的错误分析，包含了崩溃次数、崩溃率、影响用户数、以及版本间的对比，还算具体

### 错误列表

![UM+ErrorList](https://github.com/Zac-Cheung/CrashCollectorDemo/blob/develop/images/UM%2BErrorList.jpg)
友盟+的错误列表，从APP收集到的crash report会在此界面展示，然而值得注意的是，错误列表有延迟，大概**10~20**分钟才能将最新收集到的报告显示出来。

### 错误信息
![UM+ErrorInfo](https://github.com/Zac-Cheung/CrashCollectorDemo/blob/develop/images/UM%2BErrorInfo.jpg)
友盟+的错误信息，包含了设备机型、系统版本、包名、APP版本（没有build number）、堆栈信息等等，需要上传对应的dSYM文件（符号表文件）才能解析堆栈里的信息

### 符号表上传
1. 打开Xcode的Organizer
2. 右键对应项目的Archive，打开文件所在位置
	![dSYM_Step_0](https://github.com/Zac-Cheung/CrashCollectorDemo/blob/develop/images/dSYM_Step_0.jpg)
3. 右键对应项目的.xcarchive，打开包内容，找到dSYM文件，压缩成zip格式
	![dSYM_Step_1](https://github.com/Zac-Cheung/CrashCollectorDemo/blob/develop/images/dSYM_Step_1.png)
4. 在对应的错误信息里上传符号表即可
	![dSYM_Step_2](https://github.com/Zac-Cheung/CrashCollectorDemo/blob/develop/images/dSYM_Step_2.jpg)
5. 回到错误信息界面，查看解析出来的堆栈，定位crash位置
	![parase](https://github.com/Zac-Cheung/CrashCollectorDemo/blob/develop/images/UM%2BErrorInfo.jpg)
**友盟+解析力度差了点**

***


## Bugly
### 用法说明[官方文档](https://bugly.qq.com/docs/user-guide/instruction-manual-ios/?v=20180709165613)

```
pod 'Bugly'
```

#### Objective-C

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Bugly startWithAppId:@"APPID"];
    return YES;
}

```

#### Swift 

```
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {        
        Bugly.start(withAppId: "APPID")
        return true
    }
```

真是轻松啊，一句代码即可集成。

### 崩溃分析（信息列表）
![BuglyCrashAnalysis](https://github.com/Zac-Cheung/CrashCollectorDemo/blob/develop/images/BuglyCrashAnalysis.jpg)
可以根据包版本（含build number）查看对应的崩溃信息列表，值得称赞的是，崩溃信息同步比较迅速，1分钟内。

### 崩溃信息
![BuglyCrashInfo](https://github.com/Zac-Cheung/CrashCollectorDemo/blob/develop/images/BuglyCrashInfo.png)
Bugly的崩溃信息，包含了设备机型、系统版本、包版本（含build number）、发生时间、上报时间，堆栈信息等等，需要上传对应的dSYM文件（符号表文件）才能解析堆栈里的信息

### 上传符号表
![BulgyUploadSymbol](https://github.com/Zac-Cheung/CrashCollectorDemo/blob/develop/images/BulgyUploadSymbol.jpg)
dSYM文件在上面以及提到过如何获取，将获取后的dSYM压缩成zip，上传即可

[如果想要做成sh脚本，自动上传符号表文件](https://bugly.qq.com/docs/user-guide/symbol-configuration-ios/?v=1568792836231#xcode-sh)

### 解析堆栈信息
![BuglyStackInfo](https://github.com/Zac-Cheung/CrashCollectorDemo/blob/develop/images/BuglyStackInfo.png)
从堆栈信息中，能看出来，发送crash的控制器以及方法名

***

## 总结

Bugly更好用，更专业，直接支持swift

UM+还是用来做统计吧

最后附上[Demo](https://github.com/Zac-Cheung/CrashCollectorDemo)


