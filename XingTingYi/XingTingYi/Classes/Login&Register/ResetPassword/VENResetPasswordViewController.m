//
//  VENResetPasswordViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/7.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENResetPasswordViewController.h"
#import "VENVerificationCodeButton.h"
#import "VENSetPasswordPageViewController.h"

@interface VENResetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;

@end

@implementation VENResetPasswordViewController

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
    
    VENVerificationCodeButton *verificationCodeButton = [[VENVerificationCodeButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 30 - 90, 192, 90, 36)];
    [verificationCodeButton addTarget:self action:@selector(verificationCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:verificationCodeButton];
    
    [self setupNavigationItemLeftBarButtonItem];
}

- (void)verificationCodeButtonClick:(VENVerificationCodeButton *)button {
//    [[VENApiManager sharedManager] getVerificationCodeWithParameters:@{@"tel" : self.phoneNumberTextField.text} successBlock:^(id  _Nonnull responseObject) {
//        [button countingDownWithCount:60];
//    }];
}

#pragma mark - 下一步
- (IBAction)nextStepButtonClick:(id)sender {
    
    NSDictionary *parameters = @{@"tel" : self.phoneNumberTextField.text,
                                 @"code" : self.verificationCodeTextField.text};
    
//    [[VENApiManager sharedManager] resetPasswordWithParameters:parameters successBlock:^(id  _Nonnull responseObject) {
//           [self dismissViewControllerAnimated:YES completion:nil];
//    }];
    
    VENSetPasswordPageViewController *vc = [[VENSetPasswordPageViewController alloc] init];
    vc.pushType = @"ForgetPassword";
    VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
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
