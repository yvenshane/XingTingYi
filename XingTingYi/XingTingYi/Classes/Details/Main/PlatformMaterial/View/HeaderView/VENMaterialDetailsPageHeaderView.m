//
//  VENMaterialDetailsPageHeaderView.m
//  XingTingYi
//
//  Created by YVEN on 2019/9/11.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsPageHeaderView.h"
#import "VENMaterialDetailsPageModel.h"
#import "VENAudioPlayerView.h"
#import "VENAudioPlayer.h"
#import "VENMaterialDetailsSubtitlesDetailsPageModel.h"

@interface VENMaterialDetailsPageHeaderView ()
@property (nonatomic, strong) VENAudioPlayerView *audioPlayerView;
@property (nonatomic, strong) NSMutableArray *dataSourceMuArr;

@end

@implementation VENMaterialDetailsPageHeaderView

- (CGFloat)getHeightFromData:(NSDictionary *)data {
    
    CGFloat viewHeight = 0;
    
    VENMaterialDetailsPageModel *infoModel = [VENMaterialDetailsPageModel yy_modelWithJSON:data[self.isPersonalMaterial ? @"sourceInfo" : @"info"]];
    
    // banner
    CGFloat bannerHeight = kMainScreenWidth / (375.0 / 250.0);
    self.pictureImageViewHeightLayoutConstraint.constant = bannerHeight;
    self.pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.image]];
    
    viewHeight += bannerHeight;
    
    // title
    self.titileLabel.text = infoModel.title;
    if ([VENEmptyClass isEmptyString:infoModel.view_count]) {
        self.otherLabel.text = infoModel.created_at;
    } else {
        self.otherLabel.text = [NSString stringWithFormat:@"%@      %@人已浏览", infoModel.created_at, infoModel.view_count];
    }
    CGFloat titleHeight = [self.titileLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 40, CGFLOAT_MAX)].height;
    
    viewHeight += 20 + titleHeight + 10 + 16 + 20;
    
    // more
    self.contentViewTopLayoutConstraint.constant = 0.0f;
    self.contentViewHeightLayoutConstraint.constant = 0.0f;
    self.contentView.hidden = YES;
    
    if (![VENEmptyClass isEmptyString:infoModel.descriptionn]) {
        self.contentView.hidden = NO;
        
        self.contentView.layer.cornerRadius = 8.0f;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.borderWidth = 1.0f;
        self.contentView.layer.borderColor = UIColorFromRGB(0xE8E8E8).CGColor;
        
        self.contentLabel.text = infoModel.descriptionn;
        [self.contentButton addTarget:self action:@selector(contentButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat height = [self.contentLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 70, CGFLOAT_MAX)].height;
        CGFloat contentViewHeight = 15 + height + 46;
        
        self.contentViewTopLayoutConstraint.constant = 20.0f;
        self.contentViewHeightLayoutConstraint.constant = contentViewHeight;
        viewHeight += contentViewHeight;
    }
    
    // audio/video
    self.audioViewHeightLayoutConstraint.constant = 0.0f;
    self.audioViewTopLayoutConstraint.constant = 0.0f;
    self.videoViewHeightLayoutConstraint.constant = 0.0f;
    
    NSString *audioURL = @"";
    
    if (![VENEmptyClass isEmptyString:infoModel.merge_audio]) {
        audioURL = infoModel.merge_audio;
    } else {
        audioURL = infoModel.source_path;
    }
    
    if (self.isPersonalMaterial) {
        if (!self.videoURL && [VENEmptyClass isEmptyArray:data[@"sourceText"]]) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, viewHeight, kMainScreenWidth - 20 * 2, 120)];
            label.backgroundColor = UIColorFromRGB(0xF8F8F8);
            label.text = @"音频素材未上传";
            label.textColor = UIColorFromRGB(0xB2B2B2);
            label.font = [UIFont systemFontOfSize:14.0f];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 8.0f;
            label.layer.masksToBounds = YES;
            [self addSubview:label];
            
            viewHeight += 120;
        } else if (self.videoURL && [VENEmptyClass isEmptyArray:data[@"sourceText"]]) {
            self.audioPlayerView.loctionAudioURL = self.videoURL;
            
            // audio
            self.audioView.layer.cornerRadius = 8.0f;
            self.audioView.layer.masksToBounds = YES;
            
            CGFloat audioHeight = (kMainScreenWidth - 40) / (335.0 / 120.0);
            self.audioViewHeightLayoutConstraint.constant = audioHeight;
            self.audioPlayerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.audioView.frame), CGRectGetHeight(self.audioView.frame));
            
            viewHeight += 30 + audioHeight;
            
            // video
            if (![infoModel.type isEqualToString:@"1"]) { // 如果是.MP4
                
                CGFloat videoHeight = (kMainScreenWidth - 40) / (335.0 / 188.0);
                
                self.videoViewHeightLayoutConstraint.constant = videoHeight;
                self.audioViewTopLayoutConstraint.constant = 20.0f;
                
                AVPlayerLayer *playerLayer = [[VENAudioPlayer sharedAudioPlayer] playerLayer];
                [self.videoView.layer addSublayer:playerLayer];
                playerLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.videoView.frame), CGRectGetHeight(self.videoView.frame));
                
                viewHeight += videoHeight + 20;
            }
        }
    } else {
        if (![VENEmptyClass isEmptyString:audioURL]) {
            self.audioPlayerView.audioURL = audioURL;
            
            // audio
            self.audioView.layer.cornerRadius = 8.0f;
            self.audioView.layer.masksToBounds = YES;
            
            CGFloat audioHeight = (kMainScreenWidth - 40) / (335.0 / 120.0);
            self.audioViewHeightLayoutConstraint.constant = audioHeight;
            self.audioPlayerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.audioView.frame), CGRectGetHeight(self.audioView.frame));
            
            if (![VENEmptyClass isEmptyArray:data[@"avInfo"]]) {
                if (![VENEmptyClass isEmptyArray:data[@"avInfo"][0][@"subtitlesList"]]) {
                    self.audioPlayerView.subtitlesButton.hidden = NO;
                    self.audioPlayerView.subtitlesButtonWidthLayoutConstraint.constant = 20.0f;
                    self.audioPlayerView.subtitlesButtonRightLayoutConstraint.constant = 15.0f;
                    [self.audioPlayerView.subtitlesButton addTarget:self action:@selector(subtitlesButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    for (NSDictionary *dict in data[@"avInfo"][0][@"subtitlesList"]) {
                        [self.dataSourceMuArr addObject:[VENMaterialDetailsSubtitlesDetailsPageModel yy_modelWithDictionary:dict]];
                    }
                }
            }
            
            viewHeight += 30 + audioHeight;
            
            // video
            if ([[audioURL substringFromIndex:audioURL.length - 1] isEqualToString:@"4"]) { // 如果是.MP4
                
                CGFloat videoHeight = (kMainScreenWidth - 40) / (335.0 / 188.0);
                
                self.videoViewHeightLayoutConstraint.constant = videoHeight;
                self.audioViewTopLayoutConstraint.constant = 20.0f;
                
                AVPlayerLayer *playerLayer = [[VENAudioPlayer sharedAudioPlayer] playerLayer];
                [self.videoView.layer addSublayer:playerLayer];
                playerLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.videoView.frame), CGRectGetHeight(self.videoView.frame));
                
                viewHeight += videoHeight + 20;
            }
        }
    }
    
    // 字幕
    self.subtitleView.hidden = YES;
    self.subtitleViewHeightLayoutConstraint.constant = 0.0f;
    self.subtitleViewTopLayoutConstraint.constant = 0.0f;
    
    if (![VENEmptyClass isEmptyString:infoModel.subtitles]) {
        self.subtitleView.hidden = NO;
        
        self.subtitleView.layer.cornerRadius = 8.0f;
        self.subtitleView.layer.masksToBounds = YES;
        self.subtitleView.layer.borderWidth = 1.0f;
        self.subtitleView.layer.borderColor = UIColorFromRGB(0xE8E8E8).CGColor;
        
//        self.subtitleView.layer.cornerRadius = 8.0f;
//        self.subtitleView.layer.masksToBounds = YES;
//        self.subtitleView.layer.shadowColor = UIColorFromRGB(0x000000).CGColor;
//        self.subtitleView.layer.shadowOpacity = 0.1;
//        self.subtitleView.layer.shadowRadius = 2.5;
//        self.subtitleView.layer.shadowOffset = CGSizeMake(0,0);
        
        NSString *lrc = [NSString stringWithContentsOfURL:[NSURL URLWithString:infoModel.subtitles] encoding:NSUTF8StringEncoding error:nil];
        
        NSArray *lrcArr = [lrc componentsSeparatedByString:@"\n"];
        
        // \\[\\d{1,2}\\:\\d{1,2}\\]
        NSString *pattern = @"\\[\\d{1,2}\\:\\d{1,2}\\.\\d{1,2}\\]";
        
        __block NSString *printStr = @"";
        
        [lrcArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
            
            if ([regularExpression numberOfMatchesInString:obj options:0 range:NSMakeRange(0, ((NSString *)obj).length)]) {
                
                NSRange minRange = [obj rangeOfString:pattern options:NSRegularExpressionSearch range:NSMakeRange(0, ((NSString *)obj).length)];
                
                printStr = [printStr stringByAppendingFormat:@"%@\n\n", [obj substringFromIndex:minRange.length]];
            }
        }];
        
        self.subtitleLabel.text = printStr;
        
        CGFloat height = [self.subtitleLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 70, CGFLOAT_MAX)].height;
        
        if (height < 17) {
            height = 17;
        }
        
        self.subtitleViewHeightLayoutConstraint.constant = 20 + height + 44;
        self.subtitleViewTopLayoutConstraint.constant = 20.0f;
        
        // 查看字幕详情
        [self.subtitleButton addTarget:self action:@selector(subtitleButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        viewHeight += 20 + height + 44;
    }
    
    viewHeight += self.isPersonalMaterial ? 0 : 30;
    
    return viewHeight;
}

- (void)contentButtonClick {
    if (self.contentButtonBlock) {
        self.contentButtonBlock();
    }
}

- (void)subtitleButtonClick {
    if (self.subtitleButtonBlock) {
        self.subtitleButtonBlock();
    }
}

- (void)subtitlesButtonClick:(UIButton *)button {
    if (self.subtitlesButtonBlock) {
        self.subtitlesButtonBlock(button);
    }
}

- (NSMutableArray *)dataSourceMuArr {
    if (!_dataSourceMuArr) {
        _dataSourceMuArr = [NSMutableArray array];
    }
    return _dataSourceMuArr;
}

#pragma mark - 音频播放器
- (VENAudioPlayerView *)audioPlayerView {
    if (!_audioPlayerView) {
        _audioPlayerView = [[[NSBundle mainBundle] loadNibNamed:@"VENAudioPlayerView" owner:nil options:nil] firstObject];
        [self.audioView addSubview:_audioPlayerView];
        
        __weak typeof(self) weakSelf = self;
        _audioPlayerView.playProgressBlock = ^(float time) {
            
            NSString *timeStr = [NSString stringWithFormat:@"[%@]", [weakSelf convertTime:time]];

            for (NSInteger i = 0; i < weakSelf.dataSourceMuArr.count; i++) {
                VENMaterialDetailsSubtitlesDetailsPageModel *model = weakSelf.dataSourceMuArr[i];
                if ([[NSString stringWithFormat:@"[%@]", model.time] isEqualToString:timeStr]) {
                    
                    if (weakSelf.popupViewBlock) {
                        weakSelf.popupViewBlock(model.content);
                    }
                    
                }
            }
        };
    }
    return _audioPlayerView;
}

- (NSString *)convertTime:(CGFloat)second {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (second / 3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    
    return [formatter stringFromDate:date];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
