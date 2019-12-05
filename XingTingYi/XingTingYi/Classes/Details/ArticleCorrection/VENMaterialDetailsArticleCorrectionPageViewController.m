//
//  VENMaterialDetailsArticleCorrectionPageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/5.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsArticleCorrectionPageViewController.h"

@interface VENMaterialDetailsArticleCorrectionPageViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@end

@implementation VENMaterialDetailsArticleCorrectionPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"文章纠错";
    self.view.backgroundColor = UIColorFromRGB(0xF8F8F8);
    
    self.titleTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.contentTextView.delegate = self;
    
    self.submitButton.layer.cornerRadius = 24.0f;
    self.submitButton.layer.masksToBounds = YES;
    [self.submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UITextView
- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length > 0 ? YES : NO;
}

- (void)submitButtonClick {
    NSDictionary *parameters = @{@"source_id" : self.source_id,
                                 @"linkstyle" : self.titleTextField.text,
                                 @"content" : self.contentTextView.text,
                                 @"type" : self.type};
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"source/reportError" parameters:parameters successBlock:^(id responseObject) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(NSError *error) {
        
    }];
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
