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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _window = [[UIWindow alloc] initWithFrame:kMainScreenFrameRect];
    _window.rootViewController = [[VENTabBarController alloc] init];
    [_window makeKeyAndVisible];
    
    //创建window以后向window添加悬浮球
    [self createDebugSuspensionButton];
    
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
