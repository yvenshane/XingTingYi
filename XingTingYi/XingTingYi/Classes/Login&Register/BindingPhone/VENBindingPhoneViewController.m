//
//  VENBindingPhoneViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/8.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBindingPhoneViewController.h"
#import "VENVerificationCodeButton.h"
#import "VENSetPasswordPageViewController.h"
#import "VENListPickerView.h"

@interface VENBindingPhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;

@property (nonatomic, assign) BOOL is11;
@property (nonatomic, assign) BOOL is6;

@property (weak, nonatomic) IBOutlet UILabel *otherLabel;
@property (nonatomic, copy) NSString *otherStr;

@end

@implementation VENBindingPhoneViewController

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
    
    // UITextField 监听
    self.phoneNumberTextField.tag = 998;
    self.verificationCodeTextField.tag = 997;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self setupNavigationItemLeftBarButtonItem];
    
    self.otherStr = @"86";
}

- (void)verificationCodeButtonClick:(VENVerificationCodeButton *)button {
    NSDictionary *parameters = @{@"mobile" : self.phoneNumberTextField.text,
                                 @"act" : @"bind",
                                 @"nation_code" : self.otherStr};
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"login/sendcode" parameters:parameters successBlock:^(id responseObject) {
        [button countingDownWithCount:60];
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 下一步
- (IBAction)nextStepButtonClick:(id)sender {
    NSDictionary *parameters = @{@"platformid" : self.platformid,
                                 @"mobile" : self.phoneNumberTextField.text,
                                 @"code" : self.verificationCodeTextField.text,
                                 @"nation_code" : self.otherStr};
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"login/bindMobile" parameters:parameters successBlock:^(id responseObject) {
        
        VENSetPasswordPageViewController *vc = [[VENSetPasswordPageViewController alloc] init];
        vc.platformid = self.platformid;
        vc.mobile = self.phoneNumberTextField.text;
        vc.code = self.verificationCodeTextField.text;
        vc.otherStr = self.otherStr;
        VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)textFieldTextDidChange:(NSNotification *)notification {
    UITextField *textField = notification.object;
    
    if (textField.tag == 998) { // 手机号
        self.is11 = textField.text.length > 0 ? YES : NO;
    } else if (textField.tag == 997) { // 验证码
        self.is6 = textField.text.length > 0 ? YES : NO;
    }
    
    if (self.is11 && self.is6) {
        self.nextStepButton.backgroundColor = COLOR_THEME;
        [self.nextStepButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    } else {
        self.nextStepButton.backgroundColor = UIColorFromRGB(0xEBEBEB);
        [self.nextStepButton setTitleColor:UIColorFromRGB(0xB2B2B2) forState:UIControlStateNormal];
    }
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

- (IBAction)otherButtonClick:(id)sender {
    [self.view endEditing:YES];
       
       [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypeGET urlString:@"login/nationCode" parameters:nil successBlock:^(id responseObject) {
           
           VENListPickerView *listPickerView = [[VENListPickerView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
           listPickerView.type = @"login";
           listPickerView.dataSourceArr = responseObject[@"content"][@"list"];
           __weak typeof(self) weakSelf = self;
           listPickerView.listPickerViewBlock = ^(NSDictionary *dict) {
               weakSelf.otherLabel.text = [NSString stringWithFormat:@"+%@", dict[@"code"]];
               weakSelf.otherStr = dict[@"code"];
           };
           [[UIApplication sharedApplication].keyWindow addSubview:listPickerView];
           
       } failureBlock:^(NSError *error) {
           
       }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
