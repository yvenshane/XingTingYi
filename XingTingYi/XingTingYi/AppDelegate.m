//
//  AppDelegate.m
//  XingTingYi
//
//  Created by YVEN on 2019/7/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "VENTabBarController.h"
#import "SandBoxPreviewTool/SuspensionButton.h" //悬浮球按钮
#import "SandBoxPreviewTool.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMConfigure.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _window = [[UIWindow alloc] initWithFrame:kMainScreenFrameRect];
    _window.rootViewController = [[VENTabBarController alloc] init];
    [_window makeKeyAndVisible];
    
    //创建window以后向window添加悬浮球
//    [self createDebugSuspensionButton];
    
    // U-Share 平台设置
    [UMConfigure initWithAppkey:@"5dfb46eb4ca357ac510001c3" channel:@"App Store"];
    
    [self confitUShareSettings];
    [self configUSharePlatforms];
    
    return YES;
}

- (void)confitUShareSettings {
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
    //配置微信平台的Universal Links
    //微信和QQ完整版会校验合法的universalLink，不设置会在初始化平台失败
    NSString *wx = @"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/";
    NSString *qq = @"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/qq_conn/101833697";
    [UMSocialGlobal shareInstance].universalLinkDic = @{@(UMSocialPlatformType_WechatSession) : wx,
                                                        @(UMSocialPlatformType_QQ) : qq};
}

- (void)configUSharePlatforms {
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx62eac9bacf5cd990" appSecret:@"de8421fe3ecdd2ea62f3b675c488dfa9" redirectURL:@"http://mobile.umeng.com/social"];
    // QQ 1a81b5fea5d90324120d8725a0473a3c
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"101833697"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
         // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * __nullable restorableObjects))restorationHandler {
    if (![[UMSocialManager defaultManager] handleUniversalLink:userActivity options:nil]) {
        // 其他SDK的回调
    }
    return YES;
}

// 创建悬浮球按钮
- (void)createDebugSuspensionButton{
   //自行添加哦~ 记得上线前要去除哦。 QA或者调试开发阶段可以这么使用
  SuspensionButton * button = [[SuspensionButton alloc] initWithFrame:CGRectMake(-5, [UIScreen mainScreen].bounds.size.height/2 - 100 , 50, 50) color:[UIColor colorWithRed:135/255.0 green:216/255.0 blue:80/255.0 alpha:1]];
    button.leanType = SuspensionViewLeanTypeEachSide;
    [button addTarget:self action:@selector(pushToDebugPage) forControlEvents:UIControlEventTouchUpInside];
    [self.window.rootViewController.view addSubview:button];
}

//open or close sandbox preview
- (void)pushToDebugPage{
    [[SandBoxPreviewTool sharedTool] autoOpenCloseApplicationDiskDirectoryPanel];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
