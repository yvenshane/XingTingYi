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

@interface VENMaterialDetailsPageHeaderView ()
@property (nonatomic, strong) VENAudioPlayerView *audioPlayerView;

@end

@implementation VENMaterialDetailsPageHeaderView

- (void)setContentDict:(NSDictionary *)contentDict {
    _contentDict = contentDict;
    
    VENMaterialDetailsPageModel *infoModel = [VENMaterialDetailsPageModel yy_modelWithJSON:contentDict[@"info"]];
    
    // banner
    self.pictureImageViewHeightLayoutConstraint.constant = kMainScreenWidth / (375.0 / 250.0);
    self.pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.image]];
    
    // title
    self.titileLabel.text = infoModel.title;
    self.otherLabel.text = [NSString stringWithFormat:@"%@      %@人已浏览", infoModel.created_at, infoModel.view_count];
    
    // more
    if ([infoModel.type isEqualToString:@"1"] || [infoModel.type isEqualToString:@"2"] || [infoModel.type isEqualToString:@"3"]) {
        self.contentView.layer.cornerRadius = 8.0f;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.borderWidth = 1.0f;
        self.contentView.layer.borderColor = UIColorFromRGB(0xE8E8E8).CGColor;
        
        self.contentLabel.text = infoModel.descriptionn;
        [self.contentButton addTarget:self action:@selector(contentButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat height = [self.contentLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 70, CGFLOAT_MAX)].height;
        
        self.contentViewHeightLayoutConstraint.constant = 15 + height + 46;
        
    } else {
        self.contentView.hidden = YES;
        self.contentViewHeightLayoutConstraint.constant = 0;
        self.contentViewYLayoutConstraint.constant = 0;
    }
    
    // audio/video
    self.audioView.layer.cornerRadius = 8.0f;
    self.audioView.layer.masksToBounds = YES;
    
    self.audioViewHeightLayoutConstraint.constant = 0.0f;
    self.audioViewYLayoutConstraint.constant = 0.0f;
    self.videoViewHeightLayoutConstraint.constant = 0.0f;
    
    if (![VENEmptyClass isEmptyString:infoModel.source_path]) {
        self.audioPlayerView.audioURL = infoModel.source_path;
        
        // audio
        self.audioViewHeightLayoutConstraint.constant = (kMainScreenWidth - 40) / (335.0 / 120.0);
        self.audioPlayerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.audioView.frame), CGRectGetHeight(self.audioView.frame));
        
        // video
        if ([[infoModel.source_path substringFromIndex:infoModel.source_path.length - 1] isEqualToString:@"4"]) { // 如果是.MP4
            self.videoViewHeightLayoutConstraint.constant = (kMainScreenWidth - 40) / (335.0 / 188.0);
            self.audioViewYLayoutConstraint.constant = 20.0f;
        }
        
        AVPlayerLayer *playerLayer = [[VENAudioPlayer sharedAudioPlayer] playerLayer];
        [self.videoView.layer addSublayer:playerLayer];
        playerLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.videoView.frame), CGRectGetHeight(self.videoView.frame));
    }
    
    if (![VENEmptyClass isEmptyString:infoModel.merge_audio]) {
        self.audioPlayerView.audioURL = infoModel.merge_audio;
        
        // audio
        self.audioViewHeightLayoutConstraint.constant = (kMainScreenWidth - 40) / (335.0 / 120.0);
        self.audioPlayerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.audioView.frame), CGRectGetHeight(self.audioView.frame));
        
        // video
        if ([[infoModel.merge_audio substringFromIndex:infoModel.merge_audio.length - 1] isEqualToString:@"4"]) { // 如果是.MP4
            self.videoViewHeightLayoutConstraint.constant = (kMainScreenWidth - 40) / (335.0 / 188.0);
            self.audioViewYLayoutConstraint.constant = 20.0f;
        }
        
        AVPlayerLayer *playerLayer = [[VENAudioPlayer sharedAudioPlayer] playerLayer];
        [self.videoView.layer addSublayer:playerLayer];
        playerLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.videoView.frame), CGRectGetHeight(self.videoView.frame));
    }
    
    // 字幕
    if ([VENEmptyClass isEmptyString:infoModel.subtitles]) {
        self.subtitleView.hidden = YES;
        self.subtitleViewHeightLayoutConstraint.constant = 0.0f;
        self.subtitleViewYLayoutConstraint.constant = 0.0f;
        self.subtitleViewBottomLayoutConstraint.constant = 13.0f;
    } else {
        self.subtitleView.layer.cornerRadius = 8.0f;
        self.subtitleView.layer.shadowColor = UIColorFromRGB(0x000000).CGColor;
        self.subtitleView.layer.shadowOpacity = 0.1;
        self.subtitleView.layer.shadowRadius = 2.5;
        self.subtitleView.layer.shadowOffset = CGSizeMake(0,0);
        
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
        
        self.subtitleViewHeightLayoutConstraint.constant = 20 + height + 44;
        self.subtitleViewYLayoutConstraint.constant = 20.0f;
        self.subtitleViewBottomLayoutConstraint.constant = 30.0f;
    }
}

- (void)contentButtonClick {
    if (self.contentButtonBlock) {
        self.contentButtonBlock();
    }
}

#pragma mark - 音频播放器
- (VENAudioPlayerView *)audioPlayerView {
    if (!_audioPlayerView) {
        _audioPlayerView = [[[NSBundle mainBundle] loadNibNamed:@"VENAudioPlayerView" owner:nil options:nil] firstObject];
        [self.audioView addSubview:_audioPlayerView];
    }
    return _audioPlayerView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
