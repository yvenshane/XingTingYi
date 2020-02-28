//
//  VENAudioPlayerView.h
//  XingTingYi
//
//  Created by YVEN on 2019/10/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VENAudioPlayer.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^palyButtonBlock)(BOOL);
typedef void (^playProgressBlock)(float);
@interface VENAudioPlayerView : UIView
@property (nonatomic, copy) NSString *audioURL;
@property (nonatomic, strong) NSURL *loctionAudioURL;

@property (weak, nonatomic) IBOutlet UIButton *playButton; // ▶️/⏸
@property (weak, nonatomic) IBOutlet UIButton *loopButton; // 循环
@property (nonatomic, copy) palyButtonBlock palyButtonBlock;
@property (nonatomic, copy) playProgressBlock playProgressBlock;

@property (weak, nonatomic) IBOutlet UIButton *subtitlesButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subtitlesButtonWidthLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subtitlesButtonRightLayoutConstraint;

@property (nonatomic, strong) VENAudioPlayer *audioPlayer;

- (void)playButtonClick:(UIButton *)button;
- (void)forwardButtonClick;
- (void)retreatButtonClick;
- (void)loopButtonClick:(UIButton *)button;
- (void)startButtonClick;
- (void)endButtonClick;

@end

NS_ASSUME_NONNULL_END
