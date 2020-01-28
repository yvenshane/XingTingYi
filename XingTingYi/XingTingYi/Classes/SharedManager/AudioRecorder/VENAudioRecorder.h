//
//  VENAudioRecorder.h
//  XingTingYi
//
//  Created by YVEN on 2019/12/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^recorderEndBlock)(NSDictionary *);
@interface VENAudioRecorder : NSObject
@property (nonatomic, copy) recorderEndBlock recorderEndBlock;

+ (instancetype)sharedAudioRecorder;

- (void)beginReadAloud;
- (NSDictionary *)finishReadAloud;
- (void)playReadAloudWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
