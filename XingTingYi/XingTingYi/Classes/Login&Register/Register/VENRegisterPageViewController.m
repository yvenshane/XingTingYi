//
//  VENRegisterPageViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/7.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENRegisterPageViewController.h"
#import "VENBaseWebViewController.h"
#import "VENVerificationCodeButton.h"
#import "VENSetPasswordPageViewController.h"

@interface VENRegisterPageViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;
@property (weak, nonatomic) IBOutlet UIButton *userAgreementButton;

@property (nonatomic, assign) BOOL is11;
@property (nonatomic, assign) BOOL is6;

@end

@implementation VENRegisterPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 去除导航栏半透明效果 使背景色为白色
    self.navigationController.navigationBar.translucent = NO;
    // 去除导航栏底部横线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
    self.nextStepButton.layer.cornerRadius = 24.0f;
    self.nextStepButton.layer.masksToBounds = YES;
    
    // 用户协议
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"点击下一步表示同意《用户注册协议》"];
    [attributedString setAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xA5A7A8)} range:NSMakeRange(0, 9)];
    [attributedString setAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0x0A0B0B)} range:NSMakeRange(9, 8)];
    [self.userAgreementButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    [self.userAgreementButton addTarget:self action:@selector(userAgreementButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 验证码
    VENVerificationCodeButton *verificationCodeButton = [[VENVerificationCodeButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 30 - 90, 192, 90, 36)];
    [verificationCodeButton addTarget:self action:@selector(verificationCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:verificationCodeButton];
    
    // UITextField 监听
    self.phoneNumberTextField.tag = 998;
    self.verificationCodeTextField.tag = 997;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self setupNavigationItemLeftBarButtonItem];
}

- (void)verificationCodeButtonClick:(VENVerificationCodeButton *)button {
    NSDictionary *parameters = @{@"mobile" : self.phoneNumberTextField.text,
                                 @"act" : @"reg"};
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"login/sendcode" parameters:parameters successBlock:^(id responseObject) {
        [button countingDownWithCount:60];
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 下一步
- (IBAction)nextStepButtonClick:(id)sender {
    NSDictionary *parameters = @{@"mobile" : self.phoneNumberTextField.text,
                                 @"code" : self.verificationCodeTextField.text};
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"login/registerOne" parameters:parameters successBlock:^(id responseObject) {
        
        VENSetPasswordPageViewController *vc = [[VENSetPasswordPageViewController alloc] init];
        vc.mobile = self.phoneNumberTextField.text;
        vc.code = self.verificationCodeTextField.text;
        VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 用户注册协议
- (void)userAgreementButtonClick {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"base/agreement" parameters:nil successBlock:^(id responseObject) {
        
        VENBaseWebViewController *vc = [[VENBaseWebViewController alloc] init];
        vc.HTMLString = responseObject[@"content"][@"info"][@"content"];
        vc.navigationItem.title = @"用户注册协议";
        vc.isPresent = YES;
        VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)textFieldTextDidChange:(NSNotification *)notification {
    UITextField *textField = notification.object;
    
    if (textField.tag == 998) { // 手机号
        self.is11 = textField.text.length == 11 ? YES : NO;
    } else if (textField.tag == 997) { // 验证码
        self.is6 = textField.text.length == 6 ? YES : NO;
    }
    
    if (self.is11 && self.is6) {
        self.nextStepButton.backgroundColor = COLOR_THEME;
        [self.nextStepButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    } else {
        self.nextStepButton.backgroundColor = UIColorFromRGB(0xEBEBEB);
        [self.nextStepButton setTitleColor:UIColorFromRGB(0xB2B2B2) forState:UIControlStateNormal];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupNavigationItemLeftBarButtonItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [button setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
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
