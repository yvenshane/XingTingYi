//
//  VENAudioPlayer.h
//  XingTingYi
//
//  Created by YVEN on 2019/12/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENAudioPlayer : NSObject
@property (nonatomic, strong) AVPlayerLayer *playerLayer; // 视频层
@property (nonatomic, assign) CGFloat currentTime; // 当前时间
@property (nonatomic, assign) CGFloat durationTime; // 总时长
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, copy) void (^playingUIHander)(float currentTime);
@property (nonatomic, copy) void (^playerLoadSuceessHander)(float audioDuration); // 加载成功
@property (nonatomic, copy) void (^playerLoadFailHander)(void); // 加载失败
@property (nonatomic, copy) void (^playerEndHander)(void); // 播放完成
@property (nonatomic, copy) void (^playerSeekToTimeHander)(void);

+ (instancetype)sharedAudioPlayer;

- (void)playWithURL:(NSURL *)url;
- (void)play;
- (void)pause;
- (void)stop;

- (void)playAtTime:(NSTimeInterval)time;
- (void)playTimeAddTime:(NSTimeInterval)time; // 前进或后退time秒

@end

NS_ASSUME_NONNULL_END
