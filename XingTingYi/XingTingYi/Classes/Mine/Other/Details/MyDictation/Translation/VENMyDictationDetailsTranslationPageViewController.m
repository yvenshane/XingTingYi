//
//  VENMyDictationDetailsTranslationPageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2020/1/2.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyDictationDetailsTranslationPageViewController.h"
#import "VENMaterialDetailsTranslationPageSearchWordViewController.h"
#import "VENMaterialDetailsTranslationPageOtherTranslationViewController.h"

@interface VENMyDictationDetailsTranslationPageViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextView *translationContentTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UITextField *grammarTextField;
@property (weak, nonatomic) IBOutlet UITextField *wordsTextField;
@property (weak, nonatomic) IBOutlet UIView *bottomToolBarView;

@end

@implementation VENMyDictationDetailsTranslationPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"翻译";
    
    self.contentTextView.editable = NO;
    self.translationContentTextView.delegate = self;
    
    self.grammarTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 54)];
    self.grammarTextField.leftViewMode = UITextFieldViewModeAlways;
    self.wordsTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 54)];
    self.wordsTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [self setupToolBar];
    [self setupBottomToolBar];
    
    [self loadMyDictationDetailsTranslationPageData];
}

- (void)loadMyDictationDetailsTranslationPageData {
    
    NSDictionary *parameters = @{@"source_id" : self.source_id,
                                 @"source_period_id" : self.source_period_id,
                                 @"type" : self.type};
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"user/reTranslationInfo" parameters:parameters successBlock:^(id responseObject) {
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[responseObject[@"content"][@"dictationInfo"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        self.contentTextView.attributedText = attributedString;
        
        NSString *content = responseObject[@"content"][@"info"][@"content"];
        if (![VENEmptyClass isEmptyString:content]) {
            self.placeholderLabel.hidden = YES;
        }
        self.translationContentTextView.text = content;
        self.grammarTextField.text = responseObject[@"content"][@"info"][@"grammar"];
        self.wordsTextField.text = responseObject[@"content"][@"info"][@"words"];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 查词
- (void)setupToolBar {
    UIButton *toolBarButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 54, kMainScreenHeight - kStatusBarAndNavigationBarHeight - 60 - (kTabBarHeight - 49) - 54, 54, 54)];
    [toolBarButton setImage:[UIImage imageNamed:@"icon_search_words"] forState:UIControlStateNormal];
    [toolBarButton addTarget:self action:@selector(toolBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toolBarButton];
}

- (void)toolBarButtonClick {
    VENMaterialDetailsTranslationPageSearchWordViewController *vc = [[VENMaterialDetailsTranslationPageSearchWordViewController alloc] init];
//    vc.source_id = self.infoModel.source_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupBottomToolBar {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xF1F1F1);
    [self.bottomToolBarView addSubview:lineView];
    
    CGFloat width = (kMainScreenWidth - 40 - 15) / 2;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, width, 40)];
    leftButton.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [leftButton setTitle:@"查看他人翻译" forState:UIControlStateNormal];
    [leftButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    leftButton.layer.cornerRadius = 20.0f;
    leftButton.layer.masksToBounds = YES;
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomToolBarView addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(20 + width + 15, 10, (kMainScreenWidth - 40 - 15) / 2, 40)];
    rightButton.backgroundColor = UIColorFromRGB(0xFFDE02);
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    rightButton.layer.cornerRadius = 20.0f;
    rightButton.layer.masksToBounds = YES;
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomToolBarView addSubview:rightButton];
}

// 查看他人翻译
- (void)leftButtonClick:(UIButton *)button {
    VENMaterialDetailsTranslationPageOtherTranslationViewController *vc = [[VENMaterialDetailsTranslationPageOtherTranslationViewController alloc] init];
//    vc.source_period_id = self.source_period_id;
    [self.navigationController pushViewController:vc animated:YES];
}

// 保存
- (void)rightButtonClick:(UIButton *)button {
    
    NSDictionary *parameters = @{@"source_id" : self.source_id,
                                 @"source_period_id" : self.source_period_id,
                                 @"content" : self.translationContentTextView.text,
                                 @"grammar" : self.grammarTextField.text,
                                 @"words" : self.wordsTextField.text,
                                 @"type" : self.type};

    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"user/reTranslation" parameters:parameters successBlock:^(id responseObject) {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyOtherDetailPage" object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(NSError *error) {

    }];
}

#pragma mark - UITextView
- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length > 0 ? YES : NO;
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
