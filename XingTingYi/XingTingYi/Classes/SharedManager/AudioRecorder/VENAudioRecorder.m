//
//  VENAudioRecorder.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import "VENAudioPlayer.h"

@interface VENAudioRecorder ()
@property (nonatomic, strong) AVAudioRecorder *audioRecorder; // 录音器

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
        
        NSMutableDictionary *audioSetting = [NSMutableDictionary dictionary];
        // 设置录音格式 kAudioFormatMPEGLayer3设置貌似是没用的 默认设置就行
        //[audioSetting setObject:@(kAudioFormatMPEGLayer3) forKey:AVFormatIDKey];
        // 设置录音采样率，8000 44100 96000，对于一般录音已经够了
        [audioSetting setObject:@(22150) forKey:AVSampleRateKey];
        // 设置通道 1 2
        [audioSetting setObject:@(1) forKey:AVNumberOfChannelsKey];
        // 每个采样点位数,分为8、16、24、32
        [audioSetting setObject:@(16) forKey:AVLinearPCMBitDepthKey];
        // 是否使用浮点数采样 如果不是MP3需要用Lame转码为mp3的一定记得设置NO！(不然转码之后的声音一直都是杂音)
        [audioSetting setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
        // 录音质量
        [audioSetting setObject:@(AVAudioQualityHigh) forKey:AVEncoderAudioQualityKey];
        
        
        // 在Documents目录下创建一个名为FileData的文件夹
        self.path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Cache/AudioData"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = FALSE;
        BOOL isDirExist = [fileManager fileExistsAtPath:self.path isDirectory:&isDir];
        if (!(isDirExist && isDir)) {
            BOOL bCreateDir = [fileManager createDirectoryAtPath:self.path withIntermediateDirectories:YES attributes:nil error:nil];
            if (!bCreateDir) {
                NSLog(@"创建文件夹失败！");
            }
            NSLog(@"创建文件夹成功，文件路径%@", self.path);
        }
        
        // 每次启动后都保存一个新的文件中
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        
        // 想要录制MP3格式的 这里 MP3 必须大写 ！！！！(苹果的所有后缀名都是大写，所以这是个坑)
        self.path = [self.path stringByAppendingFormat:@"/%@.MP3", dateStr];
        NSLog(@"%@", self.path);
        
        // 创建录音对象
        self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:self.path] settings:audioSetting error:nil];
    }
    return self;
}

#pragma mark - 开始录音
- (void)beginReadAloud {
    if (self.audioRecorder) {
        [[VENAudioPlayer sharedAudioPlayer] stop];
        [self.audioRecorder stop];
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
    if ([[VENAudioPlayer sharedAudioPlayer] isPlaying]) return;
    [[VENAudioPlayer sharedAudioPlayer] playWithURL:[NSURL fileURLWithPath:self.path]];
    [[VENAudioPlayer sharedAudioPlayer] play];
}

// 获取当前时间戳
- (NSString *)getCurrentTimestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0]; // 获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;// *1000 是精确到毫秒(13位),不乘就是精确到秒(10位)
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

@end
