//
//  VENVideoMaterialDetailsPageHeaderView.m
//  XingTingYi
//
//  Created by YVEN on 2019/9/11.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsPageHeaderView.h"
#import "VENMaterialDetailsPageModel.h"
#import "VENAudioPlayerView.h"

@interface VENMaterialDetailsPageHeaderView ()
@property (nonatomic, strong) VENAudioPlayerView *audioPlayerView;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

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
    self.contentView.layer.cornerRadius = 8.0f;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderWidth = 1.0f;
    self.contentView.layer.borderColor = UIColorFromRGB(0xE8E8E8).CGColor;
    
    self.contentLabel.text = infoModel.descriptionn;
    
    // audio
    self.audioViewHeightLayoutConstraint.constant = (kMainScreenWidth - 40) / (335.0 / 120.0);
    self.audioView.layer.cornerRadius = 8.0f;
    self.audioView.layer.masksToBounds = YES;
    
    self.audioPlayerView.audioURL = infoModel.source_path;
    self.audioPlayerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.audioView.frame), CGRectGetHeight(self.audioView.frame));
    
    // video
    self.audioViewYLayoutConstraint.constant = 0.0f;
    self.videoViewHeightLayoutConstraint.constant = 0.0f;
    
    if (![VENEmptyClass isEmptyString:infoModel.source_path]) {
        if ([[infoModel.source_path substringFromIndex:infoModel.source_path.length - 1] isEqualToString:@"4"]) { // 如果是.MP4
            self.audioViewYLayoutConstraint.constant = 20.0f;
            self.videoViewHeightLayoutConstraint.constant = (kMainScreenWidth - 40) / (335.0 / 188.0);
        }
    }
    
    self.playerLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.videoView.frame), CGRectGetHeight(self.videoView.frame));
}

#pragma mark - 音频播放器
- (VENAudioPlayerView *)audioPlayerView {
    if (!_audioPlayerView) {
        _audioPlayerView = [[[NSBundle mainBundle] loadNibNamed:@"VENAudioPlayerView" owner:nil options:nil] firstObject];
        [self.audioView addSubview:_audioPlayerView];
    }
    return _audioPlayerView;
}

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [self.audioPlayerView playerLayer];
        [self.videoView.layer addSublayer:_playerLayer];
    }
    return _playerLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
