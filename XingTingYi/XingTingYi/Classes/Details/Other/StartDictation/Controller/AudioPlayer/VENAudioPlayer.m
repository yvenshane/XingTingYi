//
//  VENAudioPlayer.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENAudioPlayer.h"

@interface VENAudioPlayer ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (strong, nonatomic) id playTimeObserver;

@property (nonatomic, assign) BOOL isEnterBackground;

@end

@implementation VENAudioPlayer

+ (instancetype)sharedAudioPlayer {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)applicationDidEnterBackground {
    self.isEnterBackground = YES;
    self.playerLayer.player = nil;
}

- (void)applicationWillEnterForeground {
    self.isEnterBackground = YES;
    self.playerLayer.player = self.player;
}

- (void)playWithURL:(NSURL *)url {
    self.isEnterBackground = NO;
    self.durationTime = 0;
    
    [self removeObserveAndNotification];
    [self setPlayUIWithPlayTime:0];
    
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = @"AVLayerVideoGravityResize";
    
    [self addObserverAndNotification];
}

- (void)play {
    AVAudioSession *playerSession = [AVAudioSession sharedInstance];
    [playerSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [playerSession setActive:YES error:nil];
    
    [self.player play];
}

- (void)pause {
    [self.player pause];
}

- (void)stop {
    [self.player pause];
    [self.playerItem seekToTime:kCMTimeZero];
}

- (CGFloat)currentTime {
    return CMTimeGetSeconds(self.player.currentTime);
}

- (BOOL)isPlaying {
    return (self.player.rate >= 1);
}

- (void)playAtTime:(NSTimeInterval)time {
    [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale) toleranceBefore:CMTimeMake(1, 1000) toleranceAfter:CMTimeMake(1, 1000) completionHandler:^(BOOL finished) {
        if (self.playerSeekToTimeHander) {
            self.playerSeekToTimeHander();
        }
    }];
}

- (void)playTimeAddTime:(NSTimeInterval)time {
    [self playAtTime:CMTimeGetSeconds(self.player.currentTime) + time];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
 
    AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue]; // 获取更改后的状态
        if (status == AVPlayerStatusReadyToPlay) {
            CMTime duration = item.duration; // 获取视频长度
            self.durationTime = CMTimeGetSeconds(duration);
            // 设置视频时间
            if (!self.isEnterBackground && self.playerLoadSuceessHander) {
                self.playerLoadSuceessHander(self.durationTime);
            }
        } else if (status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed - %@", item.error.description);
            if (self.playerLoadFailHander) {
                self.playerLoadFailHander();
            }
        } else {
            NSLog(@"AVPlayerStatusUnknown");
            if (self.playerLoadFailHander) {
                self.playerLoadFailHander();
            }
        }
        
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //        NSTimeInterval timeInterval = [self availableDurationRanges]; // 缓冲时间
        //        CGFloat totalDuration = CMTimeGetSeconds(_playerItem.duration); // 总时间
        //        [self.loadedProgress setProgress:timeInterval / totalDuration animated:YES]; // 更新缓冲条
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) { //监听播放器在缓冲数据的状态
        NSLog(@"缓冲不足暂停了");
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        NSLog(@"缓冲达到可播放程度了");
        // 由于 AVPlayer 缓存不足就会自动暂停，所以缓存充足了需要手动播放，才能继续播放
        [self.player play];
    }
}

// 观察播放进度
- (void)monitoringPlayback:(AVPlayerItem *)item {
    __weak typeof(self)WeakSelf = self;
    // CMTimeMake(1, 3.0)
    self.playTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float currentPlayTime = (double)item.currentTime.value / item.currentTime.timescale;
        [WeakSelf setPlayUIWithPlayTime:currentPlayTime];
    }];
}

- (void)setPlayUIWithPlayTime:(float)currentTime {
    if (self.playingUIHander) {
        self.playingUIHander(currentTime);
    }
}

// 播放完成后
- (void)playbackFinished:(NSNotification *)notification {
    NSLog(@"视频播放完成通知");
    self.playerItem = [notification object];
//    [self.playerItem seekToTime:kCMTimeZero]; // item 跳转到初始
//    [self.player play]; // 循环播放
    if (self.playerEndHander) {
        self.playerEndHander();
    }
}

- (void)addObserverAndNotification {
    [self.playerItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil]; // 观察status属性，
    [self monitoringPlayback:self.playerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)removeObserveAndNotification {
    if (self.playerItem == nil || self.player == nil) {
        return;
    }
    
    @try {
        [self.playerItem removeObserver:self forKeyPath:@"status" context:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"多次删除kvo 报错了");
    }
    
    [self.player removeTimeObserver:self.playTimeObserver]; // 移除playTimeObserver
    [self.playerItem cancelPendingSeeks];
    [self.playerItem.asset cancelLoading];
    [self.playerLayer removeFromSuperlayer];
    self.player = nil;
    self.playerItem = nil;
    self.playerLayer = nil;
    self.playTimeObserver = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)dealloc {
    [self removeObserveAndNotification];
}

@end
