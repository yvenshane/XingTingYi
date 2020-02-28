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
@property (nonatomic, strong) NSMutableDictionary *audioSetting;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, strong) NSTimer *voiceTimer; // 录音音量计时器
@property (nonatomic, assign) NSInteger time;

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

#pragma mark - 开始录音
- (void)beginReadAloud {
    if (self.audioRecorder) {
        [self.audioPlayer stop];
        [self.audioRecorder stop];
    }
    
    // 创建文件
    [self createFile];
    
    if (self.audioRecorder) {
        // 录音时设置audioSession属性，否则不兼容Ios7
        AVAudioSession *recordSession = [AVAudioSession sharedInstance];
        [recordSession setCategory:AVAudioSessionCategoryRecord error:nil];
        [recordSession setActive:YES error:nil];
        
        if ([self.audioRecorder prepareToRecord]) {
            [self.audioRecorder record];
            
            // 开始计时
            self.voiceTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(detectionVoice) userInfo:nil repeats: YES];
            [[NSRunLoop currentRunLoop] addTimer:self.voiceTimer forMode:NSRunLoopCommonModes];
            [self.voiceTimer setFireDate:[NSDate distantPast]];
        }
    }
}

- (void)detectionVoice {
    ++self.time;
    
    if (self.time == 60) {
        if (self.recorderEndBlock) {
            self.recorderEndBlock([self finishReadAloud]);
        }
    }
    
    NSLog(@"%ld", (long)self.time);
}

- (void)createFile {
    // 在Documents目录下创建一个名为FileData的文件夹
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Cache/AudioData"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (!(isDirExist && isDir)) {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (!bCreateDir) {
            NSLog(@"创建文件夹失败！");
        }
        NSLog(@"创建文件夹成功，文件路径%@", path);
    }
    
    // 每次启动后都保存一个新的文件中
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    // 想要录制MP3格式的 这里 MP3 必须大写 ！！！！(苹果的所有后缀名都是大写，所以这是个坑)
    path = [path stringByAppendingFormat:@"/%@.MP3", dateStr];
    // 创建录音对象
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:path] settings:self.audioSetting error:nil];
    
    self.path = path;
}

#pragma mark - 完成录音
- (NSDictionary *)finishReadAloud {
    [self.audioRecorder stop];
    
    [self.voiceTimer setFireDate:[NSDate distantFuture]];
    if ([self.voiceTimer isValid]) {
        [self.voiceTimer invalidate];
    }
    self.voiceTimer = nil;
    
    NSLog(@"%@-%ld", self.path, (long)self.time);
    NSDictionary *dict = @{@"path" : self.path,
                           @"time" : [NSString stringWithFormat:@"%ld", (long)self.time]};
    
    self.time = 0; // 置为0
    
    return dict;
}

#pragma mark - 播放录音
- (void)playReadAloudWithPath:(NSString *)path {    
    if ([self.audioPlayer isPlaying]) {
        [self.audioPlayer stop];
    }
    
    if (path) {
        [self.audioPlayer playWithURL:[NSURL fileURLWithPath:path]];
        [self.audioPlayer play];
    }
}

#pragma mark - audioSetting
- (NSMutableDictionary *)audioSetting {
    if (!_audioSetting) {
        _audioSetting = [NSMutableDictionary dictionary];
        // 设置录音格式 kAudioFormatMPEGLayer3设置貌似是没用的 默认设置就行
        //[audioSetting setObject:@(kAudioFormatMPEGLayer3) forKey:AVFormatIDKey];
        // 设置录音采样率，8000 44100 96000，对于一般录音已经够了
        [_audioSetting setObject:@(22150) forKey:AVSampleRateKey];
        // 设置通道 1 2
        [_audioSetting setObject:@(1) forKey:AVNumberOfChannelsKey];
        // 每个采样点位数,分为8、16、24、32
        [_audioSetting setObject:@(16) forKey:AVLinearPCMBitDepthKey];
        // 是否使用浮点数采样 如果不是MP3需要用Lame转码为mp3的一定记得设置NO！(不然转码之后的声音一直都是杂音)
        [_audioSetting setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
        // 录音质量
        [_audioSetting setObject:@(AVAudioQualityHigh) forKey:AVEncoderAudioQualityKey];
    }
    return _audioSetting;
}

// 获取当前时间戳
- (NSString *)getCurrentTimestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0]; // 获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;// *1000 是精确到毫秒(13位),不乘就是精确到秒(10位)
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

- (VENAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        _audioPlayer = [[VENAudioPlayer alloc] init];
    }
    return _audioPlayer;
}

@end
