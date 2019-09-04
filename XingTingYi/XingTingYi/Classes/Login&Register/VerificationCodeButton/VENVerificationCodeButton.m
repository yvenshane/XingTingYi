//
//  VENVerificationCodeButton.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/6/23.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENVerificationCodeButton.h"

@interface VENVerificationCodeButton ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;

@end

@implementation VENVerificationCodeButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        
        ViewBorderRadius(self, 18.0f, 1, UIColorFromRGB(0x222222));
    }
    return self;
}

- (void)countingDownWithCount:(NSInteger)count {
    _count = count;
    self.enabled = NO;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerSelector) userInfo: nil repeats:YES];
    
    _timer = timer;
}

- (void)timerSelector {
    if (self.count != 1){
        self.count -=1;
        self.enabled = NO;
        [self setTitle:[NSString stringWithFormat:@"%lds", self.count] forState:UIControlStateNormal];
    } else {
        self.enabled = YES;
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.timer invalidate];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
