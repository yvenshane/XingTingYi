//
//  VENMaterialDetailsMakeSubtitlesPageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/5.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsMakeSubtitlesPageViewController.h"
#import "VENBottomToolsBarView.h"
#import "VENAudioPlayerView.h"
#import "VENMaterialDetailsPageModel.h"
#import "VENAudioPlayer.h"
#import "VENMaterialDetailPagePopupView.h"

@interface VENMaterialDetailsMakeSubtitlesPageViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *topAudioPlayerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topAudioPlayerViewHeightLayoutConstraint;

@property (nonatomic, strong) VENBottomToolsBarView *bottomToolsBarView;
@property (nonatomic, strong) VENAudioPlayerView *audioPlayerView;

@property (nonatomic, strong) VENMaterialDetailsPageModel *sourceInfoModel;
@property (nonatomic, copy) NSArray *subtitlesListArr;

@end

@implementation VENMaterialDetailsMakeSubtitlesPageViewController

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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.audioPlayerView.audioPlayer stop];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setupRightButton];
    [self setupNavigationView];
    
    [self loadMaterialDetailsMakeSubtitlesPageData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.audioPlayerView.frame = CGRectMake(20, 15, kMainScreenWidth - 40, (kMainScreenWidth - 40) / (335.0 / 120.0) - 14);
    self.bottomToolsBarView.frame = CGRectMake(0, 0, kMainScreenWidth, 40);
}

// 进入制作字幕
- (void)loadMaterialDetailsMakeSubtitlesPageData {
    NSString *url = @"";
    NSDictionary *parameters = @{};
    
    if (self.isPersonalMaterial) {
        url = @"userSource/userSubtitlesInfo";
        parameters = @{@"source_id" : self.source_period_id};
    } else {
        if (self.isExcellentCourse) {
            url = @"goodCourse/myCourseSubtitlesInfo";
        } else {
            url = @"source/subtitlesInfo";
        }
        parameters = @{@"source_period_id" : self.source_period_id};
    }
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:url parameters:parameters successBlock:^(id responseObject) {
        
        self.sourceInfoModel = [VENMaterialDetailsPageModel yy_modelWithJSON:responseObject[@"content"][@"sourceInfo"]];
        self.subtitlesListArr = responseObject[@"content"][@"subtitlesList"];
        
        if (self.isPersonalMaterial) {
            self.audioPlayerView.loctionAudioURL = self.videoURL;
        } else {
            self.audioPlayerView.audioURL = self.sourceInfoModel.path;
        }
        
        NSString *tempStr = @"";
        for (NSDictionary *dict in self.subtitlesListArr) {
            NSString *content = dict[@"content"];
            NSString *time = [NSString stringWithFormat:@"[%@]", dict[@"time"]];
            
            tempStr = [tempStr stringByAppendingString:[NSString stringWithFormat:@"%@%@\n\n", content, time]];
        }
        
        self.placeholderLabel.hidden = YES;
        self.contentTextView.attributedText = [self handleString:tempStr];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - Keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.bottomViewBottomLayoutConstraint.constant = -keyboardSize.height;
    
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

#pragma mark - 底部按钮视图
- (VENBottomToolsBarView *)bottomToolsBarView {
    if (!_bottomToolsBarView) {
        _bottomToolsBarView = [[[NSBundle mainBundle] loadNibNamed:@"VENBottomToolsBarView" owner:nil options:nil] firstObject];
        _bottomToolsBarView.textView = self.contentTextView;
        
        [_bottomToolsBarView.textStyleSettingButton setImage:[UIImage imageNamed:@"icon_timestamp"] forState:UIControlStateNormal];
        
        [_bottomToolsBarView.playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomToolsBarView.forwardButton addTarget:self action:@selector(forwardButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomToolsBarView.retreatButton addTarget:self action:@selector(retreatButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomToolsBarView.loopButton addTarget:self action:@selector(loopButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomToolsBarView.startButton addTarget:self action:@selector(startButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomToolsBarView.endButton addTarget:self action:@selector(endButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomToolsBarView.textStyleSettingButton addTarget:self action:@selector(timeStampButtonClick) forControlEvents:UIControlEventTouchUpInside];
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

// 时间戳
- (void)timeStampButtonClick {
    self.placeholderLabel.hidden = YES;
    
    NSMutableString *contentStr = [[NSMutableString alloc] initWithString:self.contentTextView.text];
    
    // 播放进度 时间戳
    float currentTime = [self.audioPlayerView.audioPlayer currentTime];
    NSString *timeStr = [NSString stringWithFormat:@"[%@]\n\n", [self convertTime:currentTime]];
    
    // 光标位置
    NSInteger location = self.contentTextView.selectedRange.location;
    
    // 时间戳插入光标位置
    [contentStr insertString:timeStr atIndex:location];
    
    self.contentTextView.attributedText = [self handleString:contentStr];
}

- (NSMutableAttributedString *)handleString:(NSString *)str {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]} range:NSMakeRange(0, str.length)];
    
    // [00:00]
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\[\\d{2}:\\d{2}])" options:0 error:nil];
    
    NSArray *matches = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    
    // 将时间戳 着色
    for(NSTextCheckingResult *result in [matches objectEnumerator]) {
        [attributedString addAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xEF142D)} range:[result range]];
    }
    
    return attributedString;
}

- (NSString *)convertTime:(CGFloat)second {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (second / 3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    
    return [formatter stringFromDate:date];
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
    
    [self.contentTextView endEditing:YES];
    
    NSMutableString *contentStr = [[NSMutableString alloc] initWithString:self.contentTextView.text];
    
    // 字符串转数组 元素:XXXX[00:00]
    NSMutableArray *tempMuArray = [NSMutableArray arrayWithArray:[contentStr componentsSeparatedByString:@"\n\n"]];
    
    // 移除数组中 空字符串
    for (NSString *tempStr in tempMuArray.copy) {
        if ([VENEmptyClass isEmptyString:tempStr]) {
            [tempMuArray removeObject:tempStr];
        }
    }
    
    NSMutableString *tempMuStr = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < tempMuArray.count; i++) {
        NSString *tempStr = tempMuArray[i];
        
        // [00:00]
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\[\\d{2}:\\d{2}])" options:0 error:nil];
        
        NSArray *matches = [regex matchesInString:tempStr options:0 range:NSMakeRange(0, tempStr.length)];
        
        for(NSTextCheckingResult *result in [matches objectEnumerator]) {
            NSRange range = [result range];
            
            // [00:00]
            NSString *timeStr = [tempStr substringWithRange:range];
            // XXXX
            NSString *words = [tempStr substringWithRange:NSMakeRange(0, range.location)];
            
            // [00:00]XXXX\n
            [tempMuStr insertString:timeStr atIndex:tempMuStr.length];
            [tempMuStr insertString:words atIndex:tempMuStr.length];
            
            if (i != tempMuArray.count - 1) {
                [tempMuStr insertString:@"\n" atIndex:tempMuStr.length];
            }
        }
    }
//    self.contentTextView.text = tempMuStr;
    
    NSDictionary *parameters = @{};
    
    NSString *url = @"";
    
    if (self.isPersonalMaterial) {
        url = @"userSource/userSubtitles";
        parameters = @{@"source_id" : self.source_period_id,
                       @"content" : tempMuStr};
    } else {
        if (self.isExcellentCourse) {
            url = @"goodCourse/myCourseSubtitles";
        } else {
            url = @"source/subtitles";
        }
        parameters = @{@"source_period_id" : self.source_period_id,
                       @"content" : tempMuStr};
    }
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:url parameters:parameters successBlock:^(id responseObject) {

        // 签到
        [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"user/signDays" parameters:nil successBlock:^(id responseObject) {
            
            VENMaterialDetailPagePopupView *popupView = [[NSBundle mainBundle] loadNibNamed:@"VENMaterialDetailPagePopupView" owner:nil options:nil].lastObject;
            popupView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
            popupView.dataDict = responseObject[@"content"][@"signInfo"];
            popupView.closeButtonBlock = ^{
                [self.navigationController popViewControllerAnimated:YES];
            };
            [[UIApplication sharedApplication].keyWindow addSubview:popupView];
            
        } failureBlock:^(NSError *error) {
            
        }];
        
    } failureBlock:^(NSError *error) {

    }];
}

#pragma mark - NavigationView
- (void)setupNavigationView {
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
    navigationView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = navigationView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"制作字幕";
    titleLabel.textColor = UIColorFromRGB(0x222222);
    titleLabel.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightMedium];
    CGFloat width = [titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 22.0f)].width;
    titleLabel.frame = CGRectMake((kMainScreenWidth - 140) / 2 - width / 2, 11, width, 22);
    [navigationView addSubview:titleLabel];
}

#pragma mark - 音频播放器
- (VENAudioPlayerView *)audioPlayerView {
    if (!_audioPlayerView) {
        _audioPlayerView = [[[NSBundle mainBundle] loadNibNamed:@"VENAudioPlayerView" owner:nil options:nil] firstObject];
        
        __weak typeof(self) weakSelf = self;
        _audioPlayerView.palyButtonBlock = ^(BOOL isPlay) {
            weakSelf.bottomToolsBarView.playButton.selected = isPlay;
        };
    }
    return _audioPlayerView;
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
