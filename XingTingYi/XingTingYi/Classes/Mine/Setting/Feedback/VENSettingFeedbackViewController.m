//
//  VENSettingFeedbackViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/8/28.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENSettingFeedbackViewController.h"

@interface VENSettingFeedbackViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *determineButton;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIView *feedbackSuccessView;

@end

@implementation VENSettingFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"意见反馈";
    self.view.backgroundColor = UIColorFromRGB(0xF8F8F8);
    
    self.determineButton.layer.cornerRadius = 24.0f;
    self.determineButton.layer.masksToBounds = YES;
    
    self.contentTextView.delegate = self;
}

#pragma mark - UITextView
- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length > 0 ? YES : NO;
}

- (IBAction)determineButtonClick:(id)sender {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"user/suggest" parameters:@{@"content" : self.contentTextView.text} successBlock:^(id responseObject) {
        
        [self.contentTextView resignFirstResponder];
        self.feedbackSuccessView.hidden = NO;
        [self setupRightButton];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)setupRightButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
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
