//
//  VENLoginPageViewController.m
//
//  Created by YVEN on 2019/5/7.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENLoginPageViewController.h"
#import "VENResetPasswordViewController.h"
#import "VENRegisterPageViewController.h"
#import "VENBindingPhoneViewController.h"
#import <UMShare/UMShare.h>

@interface VENLoginPageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic, assign) BOOL is11;
@property (nonatomic, assign) BOOL is916;

@end

@implementation VENLoginPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 去除导航栏半透明效果 使背景色为白色
    self.navigationController.navigationBar.translucent = NO;
    // 去除导航栏底部横线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
    self.loginButton.layer.cornerRadius = 24.0f;
    self.loginButton.layer.masksToBounds = YES;
    
    // UITextField 监听
    self.phoneNumberTextField.tag = 994;
    self.passwordTextField.tag = 993;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self setupNavigationItemLeftBarButtonItem];
}

#pragma mark - 登录
- (IBAction)loginButtonClick:(id)sender {
    NSDictionary *parameters = @{@"mobile" : self.phoneNumberTextField.text,
                                 @"password" : self.passwordTextField.text};
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"login/login" parameters:parameters successBlock:^(id responseObject) {
        
//         [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"content"] forKey:@"LOGIN"];
        
         [[NSUserDefaults standardUserDefaults] setObject:@"1234" forKey:@"LOGIN"];
        
//         NSDictionary *dict = @{@"type" : @"login",
//                                @"tel" : self.phoneNumberTextField.text,
//                                @"password" : self.passwordTextField.text};
//         [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"AutoLogin"];

        [self dismissViewControllerAnimated:YES completion:nil];

        if (self.loginSuccessBlock) {
            self.loginSuccessBlock();
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 忘记密码
- (IBAction)forgetPasswordButtonClick:(id)sender {
    VENResetPasswordViewController *vc = [[VENResetPasswordViewController alloc] init];
    VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 注册
- (IBAction)registerButtonClick:(id)sender {
    VENRegisterPageViewController *vc = [[VENRegisterPageViewController alloc] init];
    VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - QQ 登录
- (IBAction)qqButtonClick:(id)sender {
    [self getUserInfoForPlatform:UMSocialPlatformType_QQ];
}

#pragma mark - 微信登录
- (IBAction)wechatButtonClick:(id)sender {
    [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession];
}

#pragma mark - 谷歌登录
- (IBAction)googleButtonClick:(id)sender {
    [MBProgressHUD showText:@"暂不支持"];
}


//VENBindingPhoneViewController *vc = [[VENBindingPhoneViewController alloc] init];
//VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
//[self presentViewController:nav animated:YES completion:nil];


- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        NSLog(@" unionId: %@", resp.unionId);
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.unionGender);
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
        
        NSString *platform = @"";
        if (platformType == UMSocialPlatformType_WechatSession) {
            platform = @"wechat";
        } else if (platformType == UMSocialPlatformType_QQ) {
            platform = @"qq";
        }
        
        if (!resp) {
            return;
        }
        
        NSDictionary *parameters = @{@"platform" : platform,
                                     @"openid" : resp.openid,
                                     @"unionid" : resp.unionId};
        
        [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"login/oauthLogin" parameters:parameters successBlock:^(id responseObject) {
            
            if ([responseObject[@"ret"] integerValue] == 301) {
                VENBindingPhoneViewController *vc = [[VENBindingPhoneViewController alloc] init];
                vc.platformid = [NSString stringWithFormat:@"%ld", [responseObject[@"content"][@"platformid"] integerValue]];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
            } else if ([responseObject[@"ret"] integerValue] == 200) {
                [[NSUserDefaults standardUserDefaults] setObject:@"1234" forKey:@"LOGIN"];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
                if (self.loginSuccessBlock) {
                    self.loginSuccessBlock();
                }
            }
            
        } failureBlock:^(NSError *error) {
            
        }];
    }];
}

- (void)textFieldTextDidChange:(NSNotification *)notification {
    UITextField *textField = notification.object;
    
    if (textField.tag == 994) { // 手机号
        self.is11 = textField.text.length > 0 ? YES : NO;
    } else if (textField.tag == 993) { // 密码
        if (textField.text.length > 0) {
            self.is916 = YES;
        } else {
            self.is916 = NO;
        }
    }
    
    if (self.is11 && self.is916) {
        self.loginButton.backgroundColor = COLOR_THEME;
        [self.loginButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    } else {
        self.loginButton.backgroundColor = UIColorFromRGB(0xEBEBEB);
        [self.loginButton setTitleColor:UIColorFromRGB(0xB2B2B2) forState:UIControlStateNormal];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setupNavigationItemLeftBarButtonItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [button setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
}

- (void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
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
