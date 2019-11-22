//
//  VENAudioPlayerView.m
//  XingTingYi
//
//  Created by YVEN on 2019/10/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENAudioPlayerView.h"

@interface VENAudioPlayerView ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (weak, nonatomic) IBOutlet UISlider *progressBarSlider;
@property (weak, nonatomic) IBOutlet UIButton *minTimeButton; // 00:00
@property (weak, nonatomic) IBOutlet UILabel *maxTimeLabel; // 02:00
@property (weak, nonatomic) IBOutlet UIButton *playButton; // ▶️/⏸
@property (weak, nonatomic) IBOutlet UIImageView *startImageView;
@property (weak, nonatomic) IBOutlet UIImageView *endImageView;

@property (nonatomic, assign) Float64 startTime; // 起
@property (nonatomic, assign) Float64 endTime; // 终

@property (nonatomic, assign) CGFloat playProgress;
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
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width,         image.size.height)];
    [path addClip];
    [image drawAtPoint:CGPointZero];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 进度条滑块
    [self.progressBarSlider setThumbImage:newImage forState:UIControlStateNormal];
    // 进度条拖动监控
    [self.progressBarSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setAudioURL:(NSString *)audioURL {
    
    if ([VENEmptyClass isEmptyString:audioURL]) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:audioURL];
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    
    __weak typeof(self) weakSelf = self;
    // 监听播放进度
    [player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        CMTime currentTime = self.player.currentTime;
        weakSelf.progressBarSlider.value = CMTimeGetSeconds(currentTime);
        [weakSelf.minTimeButton setTitle:[NSString stringWithFormat:@"%@", [weakSelf convertTime:CMTimeGetSeconds(currentTime)]] forState:UIControlStateNormal];
        
        NSUInteger value = (NSUInteger)(CMTimeGetSeconds(time) + 0.5);
        
        NSLog(@"%lu - %f - %f", (unsigned long)value, self.startTime, self.endTime);
        
        if (self.isLoop) {
            
            if (value > self.endTime) {
                [self.player seekToTime:CMTimeMake(self.startTime, 1)];
            }
            
            
            
//            if (CMTimeGetSeconds(time) > self.endTime) {
//                [self.player seekToTime:CMTimeMake(self.startTime, 1)];
//            }
            
            
            
//            if (CMTimeGetSeconds(time) < self.startTime && CMTimeGetSeconds(time) > ) {
//
//            }
            
//            else {
//
//            }
        }
    }];
    
    // 监听播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    // 进度条最大值
    self.progressBarSlider.maximumValue = CMTimeGetSeconds(playerItem.asset.duration);
    // 最小进度
    [self.minTimeButton setTitle:@"00:00" forState:UIControlStateNormal];
    // 最大进度
    self.maxTimeLabel.text = [self convertTime:CMTimeGetSeconds(playerItem.asset.duration)];
    
    _player = player;
    _playerItem = playerItem;
}

#pragma mark - 播放完成
- (void)didPlayToEndTime:(NSNotification *)notification {
    if (self.isLoop) {
        [self.player seekToTime:CMTimeMake(self.startTime, 1)];
        [self.player play];
    } else {
        // 还原播放按钮
        self.playButton.selected = NO;
        self.isPause = NO;
        self.playProgress = 0;
    }
}

#pragma mark - 进度条监控
- (void)sliderValueChanged:(UISlider *)slider {
    NSUInteger value = (NSUInteger)(slider.value + 0.5);
    if (self.isLoop) {
        if (value > self.startTime && value < self.endTime) {
            self.playProgress = value;
            [self.minTimeButton setTitle:[self convertTime:value] forState:UIControlStateNormal];
            [self.player seekToTime:CMTimeMake(value, 1)];
        } else {
//            [MBProgressHUD showText:@"定点循环播放状态下无法操作进度条哦~"];
        }
    } else {
        self.playProgress = value;
        [self.minTimeButton setTitle:[self convertTime:value] forState:UIControlStateNormal];
        [self.player seekToTime:CMTimeMake(value, 1)];
    }
}

#pragma mark - 播放/暂停
- (IBAction)playButtonClick:(UIButton *)button {
    if (button.selected) {
        button.selected = NO;
        self.isPause = YES;
        [self.player pause];
    } else {
        button.selected = YES;
        if (!self.isPause) {
            // 从第0秒开始播放
            if (self.playProgress > 0) {
                [self.player seekToTime:CMTimeMake(self.playProgress, 1)];
            } else {
                [self.player seekToTime:CMTimeMake(0, 1)];
            }
        }
        [self.player play];
    }
}

#pragma mark - 快进
- (IBAction)forwardButtonClick:(id)sender {
    
    // 获取当前播放进度
    /*
        或用 avPlayerItem.currentTime.value/avPlayerItem.currentTime.timescale;
    */
    
    CMTime currentTime = self.player.currentTime;
    float currentSecond = CMTimeGetSeconds(currentTime);
    
    CGFloat willPlayTime = currentSecond + 10;
    
    if (self.isLoop) {
        // 快进时间 > 循环开始时间 = 循环开始时间
        if (willPlayTime > self.endTime) {
            self.playProgress = self.endTime;
            [self.player seekToTime:CMTimeMake(self.endTime, 1)];
        } else { // 快进时间 <= 循环开始时间 = 快进时间
            self.playProgress = willPlayTime;
            [self.player seekToTime:CMTimeMake(willPlayTime, 1)];
        }
    } else {
        self.playProgress = willPlayTime;
        [self.player seekToTime:CMTimeMake(willPlayTime, 1)];
    }
}

#pragma mark - 快退
- (IBAction)retreatButtonClick:(id)sender {
    CMTime currentTime = self.player.currentTime;
    float currentSecond = CMTimeGetSeconds(currentTime);
    
    CGFloat willPlayTime = currentSecond - 10;
    
    if (self.isLoop) {
        // 快退时间 < 循环结束时间 = 循环结束时间
        if (willPlayTime < self.startTime) {
            self.playProgress = self.startTime;
            [self.player seekToTime:CMTimeMake(self.startTime, 1)];
        } else { // 快退时间 >= 循环结束时间 = 快退时间
            self.playProgress = willPlayTime;
            [self.player seekToTime:CMTimeMake(willPlayTime, 1)];
        }
    } else {
        self.playProgress = willPlayTime;
        [self.player seekToTime:CMTimeMake(willPlayTime, 1)];
    }
}

#pragma mark - 循环
- (IBAction)loopButtonClick:(UIButton *)button {
    if (!button.selected) {
        button.selected = YES;
        self.isLoop = YES;
        [self.player seekToTime:CMTimeMake(self.startTime, 1)];
        [MBProgressHUD showText:@"设置定点循环播放成功"];
    } else {
        button.selected = NO;
        self.isLoop = NO;
        [MBProgressHUD showText:@"取消定点循环播放"];
        
        // 还原起始位置
        self.startImageView.frame = CGRectMake(9, 15, 12, 15);
        self.endImageView.frame = CGRectMake(self.frame.size.width - 21, 15, 12, 15);
    }
}

#pragma mark - 开始
- (IBAction)startButtonClick:(id)sender {
    CGFloat progress = (self.bounds.size.width - 15.0 * 2.0) / CMTimeGetSeconds(self.playerItem.asset.duration);
    CGFloat x = CMTimeGetSeconds(self.player.currentTime) * progress;
    
    if (CMTimeGetSeconds(self.player.currentTime) < self.endTime) {
        
        NSUInteger value = (NSUInteger)(CMTimeGetSeconds(self.player.currentTime) + 0.5);
        
        self.startTime = value;
        self.startImageView.frame = CGRectMake(x + 9.0, 15, 12, 15);
    } else {
        [MBProgressHUD showText:@"结束时间必须大于开始时间哦~"];
    }
}

#pragma mark - 结束
- (IBAction)endButtonClick:(id)sender {
    CGFloat progress = (self.bounds.size.width - 15.0 * 2.0) / CMTimeGetSeconds(self.playerItem.asset.duration);
    CGFloat x = CMTimeGetSeconds(self.player.currentTime) * progress;
    
    if (CMTimeGetSeconds(self.player.currentTime) > self.startTime) {
        
        NSUInteger value = (NSUInteger)(CMTimeGetSeconds(self.player.currentTime) + 0.5);
        
        self.endTime = value;
        self.endImageView.frame = CGRectMake(x + 9.0, 15, 12, 15);
    } else {
        [MBProgressHUD showText:@"结束时间必须大于开始时间哦~"];
    }
}

#pragma mark - 视频
- (AVPlayerLayer *)playerLayer {
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
//    AVLayerVideoGravityResizeAspect
//    AVLayerVideoGravityResizeAspectFill
//    AVLayerVideoGravityResize
    
    playerLayer.videoGravity = AVLayerVideoGravityResize;
    playerLayer.cornerRadius = 4.0f;
    playerLayer.masksToBounds = YES;
    
    return playerLayer;
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

- (CGFloat)startTime {
    if (!_startTime) {
        _startTime = 0.0;
    }
    return _startTime;
}

- (CGFloat)endTime {
    if (!_endTime) {
        _endTime = CMTimeGetSeconds(self.playerItem.asset.duration);
    }
    return _endTime;
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    
    self.playerItem = nil;
    self.player = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
