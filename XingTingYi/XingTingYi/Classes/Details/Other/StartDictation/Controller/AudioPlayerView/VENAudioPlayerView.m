//
//  VENAudioPlayerView.m
//  XingTingYi
//
//  Created by YVEN on 2019/10/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENAudioPlayerView.h"

@interface VENAudioPlayerView ()
@property (weak, nonatomic) IBOutlet UISlider *progressBarSlider;
@property (weak, nonatomic) IBOutlet UIButton *minTimeButton; // 00:00
@property (weak, nonatomic) IBOutlet UILabel *maxTimeLabel; // 02:00
@property (weak, nonatomic) IBOutlet UIImageView *startImageView;
@property (weak, nonatomic) IBOutlet UIImageView *endImageView;

@property (weak, nonatomic) IBOutlet UIButton *forwardButton; // ⏩
@property (weak, nonatomic) IBOutlet UIButton *retreatButton; // 快退
@property (weak, nonatomic) IBOutlet UIButton *startButton; // 起
@property (weak, nonatomic) IBOutlet UIButton *endButton; // 终

@property (nonatomic, assign) float startTime; // 起
@property (nonatomic, assign) float endTime; // 终

@property (nonatomic, assign) float playProgress;
@property (nonatomic, assign) BOOL isPause;
@property (nonatomic, assign) BOOL isLoop;

@end

@implementation VENAudioPlayerView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.layer.cornerRadius = 8.0f;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    // 根据颜色绘制图片
    UIImage *image = [self createImageWithColor:UIColorFromRGB(0xFFDE02) frame:CGRectMake(0, 0, 11, 11)];
    
    // 切圆角
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    [path addClip];
    [image drawAtPoint:CGPointZero];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 进度条滑块
    [self.progressBarSlider setThumbImage:newImage forState:UIControlStateNormal];
    // 进度条拖动监控
    [self.progressBarSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.forwardButton addTarget:self action:@selector(forwardButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.retreatButton addTarget:self action:@selector(retreatButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.loopButton addTarget:self action:@selector(loopButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.startButton addTarget:self action:@selector(startButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.endButton addTarget:self action:@selector(endButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setLoctionAudioURL:(NSURL *)loctionAudioURL {
    if (!loctionAudioURL) {
        return;
    }
    
    [self.audioPlayer playWithURL:loctionAudioURL];
    
    __weak typeof(self) weakSelf = self;
    
    [self.audioPlayer setPlayingUIHander:^(float currentTime) {
        // 进度条
        weakSelf.progressBarSlider.value = currentTime;
        // 播放时间
        [weakSelf.minTimeButton setTitle:[NSString stringWithFormat:@"%@", [weakSelf convertTime:currentTime]] forState:UIControlStateNormal];
        
        if (weakSelf.isLoop) {
            if (currentTime > weakSelf.endTime) {
                [weakSelf.audioPlayer playAtTime:weakSelf.startTime];
            }
        }
    }];
    
    // 播放完成
    self.audioPlayer.playerEndHander = ^{
        if (weakSelf.isLoop) {
            [weakSelf.audioPlayer playAtTime:weakSelf.startTime];
            [weakSelf.audioPlayer play];
        } else {
            // 还原播放按钮
            weakSelf.playButton.selected = NO;
            weakSelf.isPause = NO;
            weakSelf.playProgress = 0;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"playDidFinish" object:nil];
        }
    };
    
    // 加载成功
    self.audioPlayer.playerLoadSuceessHander = ^(float audioDuration) {
        // 进度条最大值
        weakSelf.progressBarSlider.maximumValue = audioDuration;
        // 最大进度
        weakSelf.maxTimeLabel.text = [weakSelf convertTime:audioDuration];
    };
}

- (void)setAudioURL:(NSString *)audioURL {
    
    if ([VENEmptyClass isEmptyString:audioURL]) {
        return;
    }
    
    [self.audioPlayer playWithURL:[NSURL URLWithString:audioURL]];
    
    __weak typeof(self) weakSelf = self;
    
    [self.audioPlayer setPlayingUIHander:^(float currentTime) {
        // 进度条
        weakSelf.progressBarSlider.value = currentTime;
        // 播放时间
        [weakSelf.minTimeButton setTitle:[NSString stringWithFormat:@"%@", [weakSelf convertTime:currentTime]] forState:UIControlStateNormal];
        
        if (weakSelf.isLoop) {
            if (currentTime > weakSelf.endTime) {
                [weakSelf.audioPlayer playAtTime:weakSelf.startTime];
            }
        }
        
        if (weakSelf.playProgressBlock) {
            weakSelf.playProgressBlock(currentTime);
        }
    }];
    
    // 播放完成
    self.audioPlayer.playerEndHander = ^{
        if (weakSelf.isLoop) {
            [weakSelf.audioPlayer playAtTime:weakSelf.startTime];
            [weakSelf.audioPlayer play];
        } else {
            // 还原播放按钮
            weakSelf.playButton.selected = NO;
            weakSelf.isPause = NO;
            weakSelf.playProgress = 0;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"playDidFinish" object:nil];
        }
    };
    
    // 加载成功
    self.audioPlayer.playerLoadSuceessHander = ^(float audioDuration) {
        // 进度条最大值
        weakSelf.progressBarSlider.maximumValue = audioDuration;
        // 最大进度
        weakSelf.maxTimeLabel.text = [weakSelf convertTime:audioDuration];
    };
}

#pragma mark - 进度条监控
- (void)sliderValueChanged:(UISlider *)slider {
    NSInteger value = slider.value;
    
    if (self.isLoop) {
        if (value > self.startTime && value < self.endTime) {
            self.playProgress = value;
            [self.minTimeButton setTitle:[self convertTime:value] forState:UIControlStateNormal];
            [self.audioPlayer playAtTime:value];
        } else {
//            [MBProgressHUD showText:@"定点循环播放状态下无法操作进度条哦~"];
        }
    } else {
        self.playProgress = value;
        [self.minTimeButton setTitle:[self convertTime:value] forState:UIControlStateNormal];
        [self.audioPlayer playAtTime:value];
    }
}

#pragma mark - 播放/暂停
- (void)playButtonClick:(UIButton *)button {
    if (button.selected) {
        button.selected = NO;
        self.isPause = YES;
        [self.audioPlayer pause];
    } else {
        button.selected = YES;
        if (!self.isPause) {
            // 从第0秒开始播放
            if (self.playProgress > 0) {
                [self.audioPlayer playAtTime:self.playProgress];
            } else {
                [self.audioPlayer playAtTime:0];
            }
        }
        [self.audioPlayer play];
    }
    
    if (self.palyButtonBlock) {
        self.palyButtonBlock(button.selected);
    }
}

#pragma mark - 快进
- (void)forwardButtonClick {
    CGFloat willPlayTime = [self.audioPlayer currentTime] + 3;
    
    if (self.isLoop) {
        // 快进时间 > 循环开始时间 = 循环开始时间
        if (willPlayTime > self.endTime) {
            self.playProgress = self.endTime;
            [self.audioPlayer playAtTime:self.endTime];
        } else { // 快进时间 <= 循环开始时间 = 快进时间
            self.playProgress = willPlayTime;
            [self.audioPlayer playAtTime:willPlayTime];
        }
    } else {
        self.playProgress = willPlayTime;
        [self.audioPlayer playAtTime:willPlayTime];
    }
}

#pragma mark - 快退
- (void)retreatButtonClick {
    CGFloat willPlayTime = [self.audioPlayer currentTime] - 3;
    
    if (self.isLoop) {
        // 快退时间 < 循环结束时间 = 循环结束时间
        if (willPlayTime < self.startTime) {
            self.playProgress = self.startTime;
            [self.audioPlayer playAtTime:self.startTime];
        } else { // 快退时间 >= 循环结束时间 = 快退时间
            self.playProgress = willPlayTime;
            [self.audioPlayer playAtTime:willPlayTime];
        }
    } else {
        self.playProgress = willPlayTime;
        [self.audioPlayer playAtTime:willPlayTime];
    }
}

#pragma mark - 循环
- (void)loopButtonClick:(UIButton *)button {
    if (button.selected) {
        button.selected = NO;
        self.isLoop = NO;
        [MBProgressHUD showText:@"取消定点循环播放"];
        
        // 还原起始位置
        self.startImageView.frame = CGRectMake(9, 15, 12, 15);
        self.endImageView.frame = CGRectMake(self.frame.size.width - 21, 15, 12, 15);
        
        self.startTime = 0;
        self.endTime = [self.audioPlayer durationTime];
    } else {
        button.selected = YES;
        self.isLoop = YES;
        [self.audioPlayer playAtTime:self.startTime];
        [MBProgressHUD showText:@"设置定点循环播放成功"];
    }
}

#pragma mark - 开始
- (void)startButtonClick {
    CGFloat progress = (self.bounds.size.width - 15.0 * 2.0) / [self.audioPlayer durationTime];
    CGFloat x = [self.audioPlayer currentTime] * progress;
    
    if ([self.audioPlayer currentTime] < self.endTime) {
        self.startTime = [self.audioPlayer currentTime];
        self.startImageView.frame = CGRectMake(x + 9.0, 15, 12, 15);
    } else {
        [MBProgressHUD showText:@"结束时间必须大于开始时间哦~"];
    }
}

#pragma mark - 结束
- (void)endButtonClick {
    CGFloat progress = (self.bounds.size.width - 15.0 * 2.0) / [self.audioPlayer durationTime];
    CGFloat x = [self.audioPlayer currentTime] * progress;
    
    if ([self.audioPlayer currentTime] > self.startTime) {
        self.endTime = [self.audioPlayer currentTime];
        self.endImageView.frame = CGRectMake(x + 9.0, 15, 12, 15);
    } else {
        [MBProgressHUD showText:@"结束时间必须大于开始时间哦~"];
    }
}

// 绘制图片
- (UIImage *)createImageWithColor:(UIColor *)color frame:(CGRect)rect {
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

// 时间转字符串
- (NSString *)convertTime:(float)second {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (second / 3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    
    return [formatter stringFromDate:date];
}

- (float)startTime {
    if (!_startTime) {
        _startTime = 0.0;
    }
    return _startTime;
}

- (float)endTime {
    if (!_endTime) {
        _endTime = [self.audioPlayer durationTime];
    }
    return _endTime;
}

- (VENAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        _audioPlayer = [[VENAudioPlayer alloc] init];
    }
    return _audioPlayer;
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    
    [self.audioPlayer pause];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
