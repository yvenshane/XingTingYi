//
//  VENAudioPlayerView.h
//  XingTingYi
//
//  Created by YVEN on 2019/10/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENAudioPlayerView : UIView
@property (nonatomic, copy) NSString *audioURL;

- (AVPlayerLayer *)playerLayer;

@end

NS_ASSUME_NONNULL_END
