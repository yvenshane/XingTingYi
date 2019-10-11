//
//  VENVideoMaterialDetailsStartDictationPageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/10/10.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENVideoMaterialDetailsStartDictationPageViewController.h"
#import "LMTextStyle.h"
#import "UIFont+LMText.h"
#import "LMTextHTMLParser.h"
#import "VENStyleSettingsController.h"
#import "VENBottomToolsBarView.h"

@interface VENVideoMaterialDetailsStartDictationPageViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomLayoutConstraint;

@property (nonatomic, strong) VENStyleSettingsController *styleSettingsViewController;
@property (nonatomic, strong) LMTextStyle *currentTextStyle;
@property (nonatomic, strong) VENBottomToolsBarView *bottomToolsBarView;

@end

@implementation VENVideoMaterialDetailsStartDictationPageViewController {
    NSRange _lastSelectedRange;
    BOOL _keepCurrentTextStyle;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    // 禁用IQKeyboard
    [[IQKeyboardManager sharedManager] setEnable:NO];
    // 禁用IQKeyboard 的 Toolbar
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 启用IQKeyboard
    [[IQKeyboardManager sharedManager] setEnable:YES];
    // 启用IQKeyboard 的 Toolbar
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // textView Delegate
    self.contentTextView.delegate = self;
    // 底部按钮视图
    [self.bottomView addSubview:self.bottomToolsBarView];
    
    [self setCurrentTextStyle:[LMTextStyle textStyleWithType:LMTextStyleFormatNormal]];
    [self updateTextStyleTypingAttributes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTextStyle:) name:@"ChangeTextStyle" object:nil];
    
    [self setupRightButton];
}

#pragma mark - Keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.bottomViewBottomLayoutConstraint.constant = keyboardSize.height;
    
    self.bottomToolsBarView.keyboardButton.selected = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.bottomViewBottomLayoutConstraint.constant = 0.0f;
    
    self.bottomToolsBarView.keyboardButton.selected = NO;
}

#pragma mark - <UITextViewDelegate>
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        if (self.placeholderLabel.hidden == NO) {
            self.placeholderLabel.hidden = YES;
        }
    } else {
        self.placeholderLabel.hidden = NO;
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    
    if (_lastSelectedRange.location != textView.selectedRange.location) {
        
        if (_keepCurrentTextStyle) {
            // 如果当前行的内容为空，TextView 会自动使用上一行的 typingAttributes，所以在删除内容时，保持 typingAttributes 不变
            [self updateTextStyleTypingAttributes];
            _keepCurrentTextStyle = NO;
        } else {
            self.currentTextStyle = [self textStyleForSelection];
            [self updateTextStyleTypingAttributes];
            [self reloadSettingsView];
        }
    }
    _lastSelectedRange = textView.selectedRange;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    _lastSelectedRange = NSMakeRange(range.location + text.length - range.length, 0);
    if (text.length == 0 && range.length > 0) {
        _keepCurrentTextStyle = YES;
    }
    return YES;
}

#pragma mark - settings
- (VENStyleSettingsController *)styleSettingsViewController {
    if (!_styleSettingsViewController) {
        _styleSettingsViewController = [[VENStyleSettingsController alloc] init];
        _styleSettingsViewController.textStyle = self.currentTextStyle;
    }
    return _styleSettingsViewController;
}

- (void)reloadSettingsView {
    self.styleSettingsViewController.textStyle = self.currentTextStyle;
    [self.styleSettingsViewController reload];
}

- (LMTextStyle *)textStyleForSelection {
    LMTextStyle *textStyle = [[LMTextStyle alloc] init];
    UIFont *font = self.contentTextView.typingAttributes[NSFontAttributeName];
    textStyle.fontSize = font.fontSize;
    textStyle.textColor = self.contentTextView.typingAttributes[NSForegroundColorAttributeName] ?: textStyle.textColor;
    return textStyle;
}

#pragma mark - noti
- (void)changeTextStyle:(NSNotification *)noti {
    
    for (NSString *key in noti.userInfo) {
        if ([key isEqualToString:@"TextColor"]) {
            self.currentTextStyle.textColor = noti.userInfo[@"TextColor"];
        } else {
            self.currentTextStyle.fontSize = [noti.userInfo[@"FontSize"] floatValue];
        }
    }
    
    // 设置新输入的文本属性的键值对 字体/颜色
    [self updateTextStyleTypingAttributes];
    // 设置选中的文本属性的键值对 字体/颜色
    [self updateTextStyleForSelection];
}

- (void)updateTextStyleTypingAttributes {
    NSMutableDictionary *typingAttributes = [self.contentTextView.typingAttributes mutableCopy];
    typingAttributes[NSFontAttributeName] = self.currentTextStyle.font;
    typingAttributes[NSForegroundColorAttributeName] = self.currentTextStyle.textColor;
    self.contentTextView.typingAttributes = typingAttributes;
}

- (void)updateTextStyleForSelection {
    if (self.contentTextView.selectedRange.length > 0) {
        [self.contentTextView.textStorage addAttributes:self.contentTextView.typingAttributes range:self.contentTextView.selectedRange];
    }
}

#pragma mark - 底部按钮视图
- (VENBottomToolsBarView *)bottomToolsBarView {
    if (!_bottomToolsBarView) {
        _bottomToolsBarView = [[[NSBundle mainBundle] loadNibNamed:@"VENBottomToolsBarView" owner:nil options:nil] firstObject];
        _bottomToolsBarView.frame = CGRectMake(0, 0, kMainScreenWidth, 40);
        _bottomToolsBarView.textView = self.contentTextView;
        
        // 字号/颜色
        [_bottomToolsBarView.textStyleSettingButton addTarget:self action:@selector(textStyleSettingButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _bottomToolsBarView;
}

- (void)textStyleSettingButtonClick:(UIButton *)button {
    // 键盘弹起时才能改变文字字号/颜色
    if (self.bottomViewBottomLayoutConstraint.constant > 0) {
        
        [self.bottomToolsBarView.keyboardButton setImage:[UIImage imageNamed:@"icon_keyboard"] forState:UIControlStateSelected];
        
        CGRect rect = CGRectMake(0, 0, kMainScreenWidth, 140);
        UIView *inputView = [[UIView alloc] initWithFrame:rect];
        self.styleSettingsViewController.view.frame = rect;
        [inputView addSubview:self.styleSettingsViewController.view];
        self.contentTextView.inputView = inputView;
        
        [self.contentTextView reloadInputViews];
    }
}

#pragma mark - right button
- (void)setupRightButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)backButtonClick {
    NSLog(@"%@", [self exportHTML]);
}

- (NSString *)exportHTML {
    NSString *content = [LMTextHTMLParser HTMLFromAttributedString:self.contentTextView.attributedText];
    return content;
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
