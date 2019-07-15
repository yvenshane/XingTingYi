//
//  VENTabBarController.m
//  
//  Created by YVEN.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENTabBarController.h"
#import "VENNavigationController.h"

@interface VENTabBarController () <UITabBarControllerDelegate>

@end

@implementation VENTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIViewController *vc1 = [self loadChildViewControllerWithClassName:@"VENHomePageViewController" andTitle:@"首页" andImageName:@"icon_tab01"];
    UIViewController *vc2 = [self loadChildViewControllerWithClassName:@"VENMaterialPageViewController" andTitle:@"素材专区" andImageName:@"icon_tab02"];
    UIViewController *vc3 = [self loadChildViewControllerWithClassName:@"VENNewsPageViewController" andTitle:@"动态圈" andImageName:@"icon_tab03"];
    UIViewController *vc4 = [self loadChildViewControllerWithClassName:@"VENMinePageViewController" andTitle:@"我的" andImageName:@"icon_tab04"];
    
    self.viewControllers = @[vc1, vc2, vc3, vc4];
    
    self.delegate = self;
    self.tabBar.tintColor = COLOR_THEME;
    self.tabBar.translucent = NO;
}

- (UIViewController *)loadChildViewControllerWithClassName:(NSString *)className andTitle:(NSString *)title andImageName:(NSString *)imageName {
    
    // 把类名的字符串转成类的类型
    Class class = NSClassFromString(className);
    
    // 通过转换出来的类的类型来创建控制器
    UIViewController *vc = [class new];
    
    // 设置TabBar的文字
    vc.tabBarItem.title = title;
    
    NSString *normalImageName = [imageName stringByAppendingString:@""];
    // 设置默认状态的图片
    vc.tabBarItem.image = [[UIImage imageNamed:normalImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 拼接选中状态的图片
    NSString *selectedImageName = [imageName stringByAppendingString:@"_active"];
    // 设置选中图片
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 创建导航控制器
    VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
    
    return nav;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
