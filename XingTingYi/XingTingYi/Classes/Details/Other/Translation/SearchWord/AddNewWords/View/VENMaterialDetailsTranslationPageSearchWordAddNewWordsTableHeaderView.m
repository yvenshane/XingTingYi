//
//  VENMaterialDetailsTranslationPageSearchWordAddNewWordsTableHeaderView.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/11.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsTranslationPageSearchWordAddNewWordsTableHeaderView.h"
#import "VENAudioRecorder.h"
#import "VENAudioPlayer.h"

@interface VENMaterialDetailsTranslationPageSearchWordAddNewWordsTableHeaderView () <UITextViewDelegate>
@property (nonatomic, strong) VENAudioRecorder *audioRecorder;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, assign) BOOL isPlayFile;

@property (nonatomic, strong) VENAudioPlayer *audioPlayer;

@end

@implementation VENMaterialDetailsTranslationPageSearchWordAddNewWordsTableHeaderView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.nnewWordsTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 48)];
    self.nnewWordsTextField.rightViewMode = UITextFieldViewModeAlways;
    
    self.translateTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 48)];
    self.translateTextField.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *toolsBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20 + 30 + 20 + 10 + 30, 48)];
    
    UIButton *recordButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(toolsBarView.frame) - 30 - 20, 9, 30, 30)];
    [recordButton setImage:[UIImage imageNamed:@"icon_article_pop_reading"] forState:UIControlStateNormal];
    [recordButton setImage:[UIImage imageNamed:@"icon_article_pop_suspend"] forState:UIControlStateSelected];
    [recordButton addTarget:self action:@selector(recordButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolsBarView addSubview:recordButton];
    
    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 9, 30, 30)];
    [playButton setImage:[UIImage imageNamed:@"icon_article_pop_play"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    playButton.hidden = self.isEdit ? NO : YES;
    [toolsBarView addSubview:playButton];
    
    _recordButton = recordButton;
    _playButton = playButton;
    
    self.pronunciationTextField.rightView = toolsBarView;
    self.pronunciationTextField.rightViewMode = UITextFieldViewModeAlways;
    
    self.textViewOne.delegate = self;
    self.textViewOne.tag = 998;
    self.textViewTwo.delegate = self;
    self.textViewTwo.tag = 999;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        if (textView.tag == 998) {
            self.placeholderLabelOne.hidden = YES;
        } else {
            self.placeholderLabelTwo.hidden = YES;
        }
    } else {
        if (textView.tag == 998) {
            self.placeholderLabelOne.hidden = NO;
        } else {
            self.placeholderLabelTwo.hidden = NO;
        }
    }
}

- (void)playButtonClick:(UIButton *)button {
    if ([VENEmptyClass isEmptyString:self.path]) {
        [self.audioRecorder playReadAloudWithPath:self.path];
    } else {
        if (self.isPlayFile) {
            [self.audioRecorder playReadAloudWithPath:self.path];
        } else {
            [self.audioPlayer playWithURL:[NSURL URLWithString:self.path]];
            [self.audioPlayer play];
        }
    }
}

- (void)recordButtonClick:(UIButton *)button {
    if (button.selected) {
        button.selected = NO;
        self.playButton.hidden = NO;
        
        self.path = [self.audioRecorder finishReadAloud][@"path"]; // 完成录音
        
        if (self.addNewWordsBlock) {
            self.addNewWordsBlock(self.path);
        }
        
    } else {
        button.selected = YES;
        self.playButton.hidden = YES;
        
        [self.audioRecorder beginReadAloud]; // 开始录音
        
        self.isPlayFile = YES;
    }
}

#pragma mark - 录音器
- (VENAudioRecorder *)audioRecorder {
    if (!_audioRecorder) {
        _audioRecorder = [VENAudioRecorder sharedAudioRecorder];
    }
    return _audioRecorder;
}

- (VENAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        _audioPlayer = [[VENAudioPlayer alloc] init];
    }
    return _audioPlayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
