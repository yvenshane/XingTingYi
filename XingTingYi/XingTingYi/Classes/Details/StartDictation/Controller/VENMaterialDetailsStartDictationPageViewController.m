//
//  VENVideoMaterialDetailsStartDictationPageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/10/10.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsStartDictationPageViewController.h"
#import "LMTextStyle.h"
#import "UIFont+LMText.h"
#import "LMTextHTMLParser.h"
#import "VENStyleSettingsController.h"
#import "VENBottomToolsBarView.h"
#import "VENAudioPlayerView.h"
#import "VENMaterialDetailsPageModel.h"
#import "VENLabelPickerViewOne.h"
#import "VENLabelPickerViewTwo.h"

@interface VENMaterialDetailsStartDictationPageViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *topAudioPlayerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topAudioPlayerViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *audioPlayerViewTopLayoutConstraint;

@property (nonatomic, strong) VENStyleSettingsController *styleSettingsViewController;
@property (nonatomic, strong) LMTextStyle *currentTextStyle;
@property (nonatomic, strong) VENBottomToolsBarView *bottomToolsBarView;
@property (nonatomic, strong) VENAudioPlayerView *audioPlayerView;

@property (nonatomic, strong) VENMaterialDetailsPageModel *avInfoModel;
@property (nonatomic, strong) VENMaterialDetailsPageModel *dictationInfoModel;
@property (nonatomic, strong) NSMutableArray *dictationTagMuArr;

@property (nonatomic, strong) VENLabelPickerViewOne *labelPickerViewOne;
@property (nonatomic, strong) VENLabelPickerViewTwo *labelPickerViewTwo;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, copy) NSString *time;

@end

@implementation VENMaterialDetailsStartDictationPageViewController {
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
    // 顶部播放器试图
    self.topAudioPlayerView.backgroundColor = [UIColor whiteColor];
    self.topAudioPlayerView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.03].CGColor;
    self.topAudioPlayerView.layer.shadowOffset = CGSizeMake(0,4);
    self.topAudioPlayerView.layer.shadowOpacity = 1;
    self.topAudioPlayerView.layer.shadowRadius = 8;
    [self.topAudioPlayerView addSubview:self.audioPlayerView];
    
    self.topAudioPlayerViewHeightLayoutConstraint.constant = (kMainScreenWidth - 40) / (335.0 / 120.0) + 15 + 20;
    
    // 底部按钮视图
    [self.bottomView addSubview:self.bottomToolsBarView];
    
    [self setCurrentTextStyle:[LMTextStyle textStyleWithType:LMTextStyleFormatNormal]];
    [self updateTextStyleTypingAttributes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTextStyle:) name:@"ChangeTextStyle" object:nil];
    
    [self setupRightButton];
    [self setupNavigationView];
    
    [self loadMaterialDetailsStartDictationPageData];
    [self loadMaterialDetailsStartDictationPageLabelListData];
    
    // 开始听写计时
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteDictationTag:) name:@"DeleteDictationTag" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDictationTag:) name:@"AddDictationTag" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editDictationTag:) name:@"EditDictationTag" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addEditDictationTag:) name:@"AddEditDictationTag" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveDictationTag) name:@"SaveDictationTag" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmButtonClick:) name:@"ConfirmButtonClick" object:nil];
}

// 进入听写数据
- (void)loadMaterialDetailsStartDictationPageData {
    NSDictionary *parameters = @{@"source_id" : self.source_id,
                                 @"source_period_id" : self.source_period_id};
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"source/dictationInfo" parameters:parameters successBlock:^(id responseObject) {
        
        self.avInfoModel = [VENMaterialDetailsPageModel yy_modelWithJSON:responseObject[@"content"][@"avInfo"]];
        self.audioPlayerView.audioURL = self.avInfoModel.path;
        self.dictationInfoModel = [VENMaterialDetailsPageModel yy_modelWithJSON:responseObject[@"content"][@"dictationInfo"]];
        
        // 顶部 title
        if (self.isSectionDictation) {
            self.titleView.hidden = NO;
            self.titleLabel.text = self.avInfoModel.subtitle;
            
            CGFloat height = [self.titleLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 20 * 2, CGFLOAT_MAX)].height;
            
            self.audioPlayerViewTopLayoutConstraint.constant = height + 15;
        } else {
            self.titleView.hidden = YES;
            self.audioPlayerViewTopLayoutConstraint.constant = 0.0f;
        }
        
        // textView 赋值
        if (![VENEmptyClass isEmptyString:self.dictationInfoModel.content]) {
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[self.dictationInfoModel.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            
            self.contentTextView.attributedText = attributedString;
            self.placeholderLabel.hidden = YES;
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

// 标签
- (void)loadMaterialDetailsStartDictationPageLabelListData {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypeGET urlString:@"source/dictationTagList" parameters:nil successBlock:^(id responseObject) {
        
        self.dictationTagMuArr = [NSMutableArray arrayWithArray:responseObject[@"content"][@"dictationTag"]];
        
    } failureBlock:^(NSError *error) {
        
    }];
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
        
        [_bottomToolsBarView.playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomToolsBarView.forwardButton addTarget:self action:@selector(forwardButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomToolsBarView.retreatButton addTarget:self action:@selector(retreatButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomToolsBarView.loopButton addTarget:self action:@selector(loopButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomToolsBarView.startButton addTarget:self action:@selector(startButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomToolsBarView.endButton addTarget:self action:@selector(endButtonClick) forControlEvents:UIControlEventTouchUpInside];
        // 字号/颜色
        [_bottomToolsBarView.textStyleSettingButton addTarget:self action:@selector(textStyleSettingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomToolsBarView;
}

- (void)playButtonClick:(UIButton *)button {
    button.selected = !self.audioPlayerView.playButton.selected;
    [self.audioPlayerView playButtonClick:self.audioPlayerView.playButton];
}

- (void)forwardButtonClick {
    [self.audioPlayerView forwardButtonClick];
}

- (void)retreatButtonClick {
    [self.audioPlayerView retreatButtonClick];
}

- (void)loopButtonClick:(UIButton *)button {
    [self.audioPlayerView loopButtonClick:self.audioPlayerView.loopButton];
}

- (void)startButtonClick {
    [self.audioPlayerView startButtonClick];
}

- (void)endButtonClick {
    [self.audioPlayerView endButtonClick];
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
    [button addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)saveButtonClick {
    [self.contentTextView resignFirstResponder];
    [[UIApplication sharedApplication].keyWindow addSubview:self.labelPickerViewOne];
}

- (VENLabelPickerViewTwo *)labelPickerViewTwo {
    if (!_labelPickerViewTwo) {
        _labelPickerViewTwo = [[VENLabelPickerViewTwo alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        _labelPickerViewTwo.dataSourceArr = self.dictationTagMuArr;
        _labelPickerViewTwo.labelPickerViewBlock = ^(NSDictionary *dict) {
        };
    }
    return _labelPickerViewTwo;
}

- (VENLabelPickerViewOne *)labelPickerViewOne {
    if (!_labelPickerViewOne) {
        _labelPickerViewOne = [[VENLabelPickerViewOne alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        _labelPickerViewOne.dataSourceArr = self.dictationTagMuArr;
        
    }
    return _labelPickerViewOne;
}

#pragma mark - 删除标签
- (void)deleteDictationTag:(NSNotification *)noti {
    for (NSDictionary *dict in self.dictationTagMuArr.copy) {
        if ([[dict[@"id"] stringValue] isEqualToString:[noti.userInfo[@"id"] stringValue]]) {
            [self.dictationTagMuArr removeObject:dict];
            self.labelPickerViewTwo.dataSourceArr = self.dictationTagMuArr;
        }
    }
}

#pragma mark - 增加标签
- (void)addDictationTag:(NSNotification *)noti {
    [self.labelPickerViewTwo removeFromSuperview];
    self.labelPickerViewTwo = nil;
    
    [self.dictationTagMuArr addObject:noti.userInfo];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.labelPickerViewTwo];
}

#pragma mark - 编辑标签
- (void)editDictationTag:(NSNotification *)noti {
    for (NSInteger i = 0; i < self.dictationTagMuArr.count; i++) {
        if ([[self.dictationTagMuArr[i][@"id"] stringValue] isEqualToString:[noti.userInfo[@"id"] stringValue]]) {
            [self.dictationTagMuArr removeObject:self.dictationTagMuArr];
            [self.dictationTagMuArr setObject:noti.userInfo atIndexedSubscript:i];
            self.labelPickerViewTwo.dataSourceArr = self.dictationTagMuArr;
        }
    }
}

#pragma mark - 增加/编辑标签
- (void)addEditDictationTag:(NSNotification *)noti {
    
    [self.labelPickerViewOne removeFromSuperview];
    self.labelPickerViewOne = nil;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.labelPickerViewTwo];
}

#pragma mark - 保存
- (void)saveDictationTag {
    [self.labelPickerViewTwo removeFromSuperview];
    self.labelPickerViewTwo = nil;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.labelPickerViewOne];
}

#pragma mark - 确定按钮
- (void)confirmButtonClick:(NSNotification *)noti {
    NSMutableArray *tempMuArr = [NSMutableArray array];
    for (NSDictionary *dict in noti.userInfo[@"selectedMuArr"]) {
        [tempMuArr addObject:dict[@"id"]];
    }
    
    NSDictionary *parameters = @{@"id" : self.source_period_id,
                                 @"content" : [self exportHTML],
                                 @"time" : self.time,
                                 @"dictation_tag" : [tempMuArr componentsJoinedByString:@","]};

    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"source/dictation" parameters:parameters successBlock:^(id responseObject) {

        [self.timer invalidate];
        self.timer = nil;
        
        [self.labelPickerViewOne removeFromSuperview];
        self.labelPickerViewOne = nil;
        
        [self.navigationController popViewControllerAnimated:YES];

    } failureBlock:^(NSError *error) {

    }];
}

#pragma mark - NavigationView
- (void)setupNavigationView {
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
    navigationView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = navigationView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"开始听写";
    titleLabel.textColor = UIColorFromRGB(0x222222);
    titleLabel.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightMedium];
    CGFloat width = [titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 22.0f)].width;
    titleLabel.frame = CGRectMake((kMainScreenWidth - 140) / 2 - width / 2, 3.5, width, 22);
    [navigationView addSubview:titleLabel];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"学习时间 00:00:00";
    timeLabel.textColor = UIColorFromRGB(0x999999);
    timeLabel.font = [UIFont systemFontOfSize:12.0f];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat width2 = [timeLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 15.0f)].width + 10;
    timeLabel.frame = CGRectMake((kMainScreenWidth - 140) / 2 - width2 / 2, 3.5 + 22, width2, 15);
    [navigationView addSubview:timeLabel];
    
    _timeLabel = timeLabel;
}

#pragma mark - 转换成 HTML
- (NSString *)exportHTML {
    NSString *content = [LMTextHTMLParser HTMLFromAttributedString:self.contentTextView.attributedText];
    return content;
}

#pragma mark - 音频播放器
- (VENAudioPlayerView *)audioPlayerView {
    if (!_audioPlayerView) {
        _audioPlayerView = [[[NSBundle mainBundle] loadNibNamed:@"VENAudioPlayerView" owner:nil options:nil] firstObject];
        _audioPlayerView.frame = CGRectMake(20, 15, kMainScreenWidth - 40, (kMainScreenWidth - 40) / (335.0 / 120.0) - 14);
        
        __weak typeof(self) weakSelf = self;
        _audioPlayerView.palyButtonBlock = ^(BOOL isPlay) {
            weakSelf.bottomToolsBarView.playButton.selected = isPlay;
        };
    }
    return _audioPlayerView;
}

// 开始听写计时
- (void)timerAction {
    NSInteger time = [self.time integerValue];
    self.time = [NSString stringWithFormat:@"%ld", (long)++time];
    self.timeLabel.text = [NSString stringWithFormat:@"学习时间 %@", [self getMMSSFromSS:self.time]];
}

-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld", seconds / 3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld", (seconds % 3600) / 60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld", seconds % 60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@", str_hour, str_minute, str_second];
    
    return format_time;
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
