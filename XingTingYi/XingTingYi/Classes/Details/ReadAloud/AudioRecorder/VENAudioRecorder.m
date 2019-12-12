//
//  VENAudioRecorder.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface VENAudioRecorder ()
@property (nonatomic, strong) AVAudioRecorder *audioRecorder; // 录音器
@property (nonatomic, strong) AVAudioPlayer *player; // 播放器
@property (nonatomic, strong) NSURL *recordFileUrl; // 文件地址

@end

@implementation VENAudioRecorder

+ (instancetype)sharedAudioRecorder {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        // 确定录音存放的位置
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"ra%@.caf", [self getCurrentTimestamp]]];
        self.recordFileUrl = [NSURL URLWithString:path];
        
        // 录音参数
        NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
        // 设置编码格式
        [recordSettings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        // 采样率
        [recordSettings setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
        // 通道数
        [recordSettings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        // 音频质量,采样质量
        [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];

        // 创建录音对象
        self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:recordSettings error:nil];
    }
    return self;
}

#pragma mark - 开始录音
- (void)beginReadAloud {
    if (self.audioRecorder) {
        [self.player stop];
        // 删除录音
        [self.audioRecorder deleteRecording];
    }
    //准备录音
    [self.audioRecorder prepareToRecord];
    //开始录音
    [self.audioRecorder record];
    // 几秒后开始录音
    // [self.audioRecorder recordAtTime:self.audioRecorder.deviceCurrentTime + 5];
    // 录音录多久
    [self.audioRecorder recordForDuration:60];
}

#pragma mark - 完成录音
- (void)finishReadAloud {
//    if (self.audioRecorder.currentTime > 2) {
//        [self.audioRecorder stop];
//    } else {
//        NSLog(@"录音时间不超过2秒，删除");
//        [self.audioRecorder stop];
//        [self.audioRecorder deleteRecording];
//    }
    
    [self.audioRecorder stop];
}

#pragma mark - 播放录音
- (void)playReadAloud {
    if ([self.player isPlaying]) return;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordFileUrl error:nil];
    
    [self.player play];
}

// 获取当前时间戳
- (NSString *)getCurrentTimestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0]; // 获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970]*1000;// *1000 是精确到毫秒(13位),不乘就是精确到秒(10位)
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

@end
