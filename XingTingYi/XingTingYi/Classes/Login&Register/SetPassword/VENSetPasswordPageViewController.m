//
//  VENSetPasswordPageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/9/3.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENSetPasswordPageViewController.h"

@interface VENSetPasswordPageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (nonatomic, assign) BOOL is916;
@property (nonatomic, assign) BOOL is9162;

@end

@implementation VENSetPasswordPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 去除导航栏半透明效果 使背景色为白色
    self.navigationController.navigationBar.translucent = NO;
    // 去除导航栏底部横线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    
    if ([self.pushType isEqualToString:@"ForgetPassword"]) {
        self.titleLabel.text = @"设置新密码";
        [self.commitButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    
    self.commitButton.layer.cornerRadius = 24.0f;
    self.commitButton.layer.masksToBounds = YES;
    
    // UITextField 监听
    self.passwordTextField.tag = 996;
    self.confirmPasswordTextField.tag = 995;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self setupNavigationItemLeftBarButtonItem];
}

#pragma mark - 注册
- (IBAction)commitButtonClick:(id)sender {
    NSDictionary *parameters = @{@"mobile" : self.mobile,
                                 @"code" : self.code,
                                 @"password" : self.passwordTextField.text,
                                 @"repassword" : self.confirmPasswordTextField.text};
    NSString *urlString = @"";
    if ([self.pushType isEqualToString:@"ForgetPassword"]) {
        urlString = @"login/resetPassTwo";
    } else {
        urlString = @"login/registerTwo";
    }
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:urlString parameters:parameters successBlock:^(id responseObject) {
        
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)textFieldTextDidChange:(NSNotification *)notification {
    UITextField *textField = notification.object;
    
    if (textField.tag == 996) { // 密码
        if (textField.text.length >= 9 && textField.text.length <= 16) {
            self.is916 = YES;
        } else {
            self.is916 = NO;
        }
    } else { // 重复密码
        if (textField.text.length >= 9 && textField.text.length <= 16) {
            self.is9162 = YES;
        } else {
            self.is9162 = NO;
        }
    }
    
    if ((self.is916 && self.is9162) && [self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        self.commitButton.backgroundColor = COLOR_THEME;
        [self.commitButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    } else {
        self.commitButton.backgroundColor = UIColorFromRGB(0xEBEBEB);
        [self.commitButton setTitleColor:UIColorFromRGB(0xB2B2B2) forState:UIControlStateNormal];
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
