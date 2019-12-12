//
//  VENAudioRecorder.h
//  XingTingYi
//
//  Created by YVEN on 2019/12/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VENAudioRecorder : NSObject
+ (instancetype)sharedAudioRecorder;

- (void)beginReadAloud;
- (void)finishReadAloud;
- (void)playReadAloud;

@end

NS_ASSUME_NONNULL_END
