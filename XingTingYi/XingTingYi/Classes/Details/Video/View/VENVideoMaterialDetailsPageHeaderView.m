//
//  VENVideoMaterialDetailsPageHeaderView.m
//  XingTingYi
//
//  Created by YVEN on 2019/9/11.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENVideoMaterialDetailsPageHeaderView.h"
#import "VENVideoMaterialDetailsPageModel.h"
#import "VENAudioPlayerView.h"
#import "VENMaterialDetailsPageCategoryView.h"

@interface VENVideoMaterialDetailsPageHeaderView ()
@property (nonatomic, strong) VENAudioPlayerView *audioPlayerView;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) VENMaterialDetailsPageCategoryView *materialDetailsPageCategoryView;

@property (nonatomic, copy) NSString *contentStr;

@end

@implementation VENVideoMaterialDetailsPageHeaderView

- (void)setModel:(VENVideoMaterialDetailsPageModel *)model {
    _model = model;
    
    self.pictureImageViewHeightLayoutConstraint.constant = kMainScreenWidth / (375.0 / 250.0);
    self.pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    
    self.titileLabel.text = model.title;
    self.otherLabel.text = [NSString stringWithFormat:@"%@      %@人已浏览", model.created_at, model.view_count];
    
    self.contentView.layer.cornerRadius = 8.0f;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderWidth = 1.0f;
    self.contentView.layer.borderColor = UIColorFromRGB(0xE8E8E8).CGColor;
    
    self.contentLabel.text = model.descriptionn;
    
    self.audioViewHeightLayoutConstraint.constant = (kMainScreenWidth - 40) / (335.0 / 120.0);
    self.audioView.layer.cornerRadius = 8.0f;
    self.audioView.layer.masksToBounds = YES;
    
    self.audioPlayerView.audioURL = model.source_path;
    self.audioPlayerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.audioView.frame), CGRectGetHeight(self.audioView.frame));
    
    self.videoViewHeightLayoutConstraint.constant = (kMainScreenWidth - 40) / (335.0 / 188.0);
    
    self.playerLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.videoView.frame), CGRectGetHeight(self.videoView.frame));
    
    self.materialDetailsPageCategoryView.titleArr = @[@"提示词", @"生词汇总", @"标准答案"];
    
    model.words = @"21312313132132131231231231231213123131321321312312312312312131231313213213123123123123121312313132132131231231231231";
    
    model.answer = @"一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二一二";
    
    __weak typeof(self) weakSelf = self;
    self.materialDetailsPageCategoryView.buttonClickBlock = ^(NSInteger buttonTag) {
        if (buttonTag == 0) {
            weakSelf.contentStr = model.notice;
        } else if (buttonTag == 1) {
            weakSelf.contentStr = model.words;
        } else {
            weakSelf.contentStr = model.answer;
        }
        
        weakSelf.categoryContentLabel.text = weakSelf.contentStr;
        
        CGFloat height = [weakSelf.categoryContentLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 20 * 2 - 15 * 2, 16)].height;
        
        weakSelf.categoryViewHeightLayoutConstraint.constant = 25 + 20 + 15 * 2 + height;
    };
    
    self.categoryContentView.layer.cornerRadius = 8.0f;
    self.categoryContentView.layer.masksToBounds = YES;
    
    self.categoryContentLabel.text = model.notice;
    
    CGFloat height = [self.categoryContentLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 20 * 2 - 15 * 2, 16)].height;
    
    self.categoryViewHeightLayoutConstraint.constant = 25 + 20 + 15 * 2 + height;
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

#pragma mark - 分类试图
- (VENMaterialDetailsPageCategoryView *)materialDetailsPageCategoryView {
    if (!_materialDetailsPageCategoryView) {
        _materialDetailsPageCategoryView = [[VENMaterialDetailsPageCategoryView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 25)];
        [self.categoryView addSubview:_materialDetailsPageCategoryView];
    }
    return _materialDetailsPageCategoryView;
}

- (NSString *)contentStr {
    if (!_contentStr) {
        _contentStr = self.model.notice;
    }
    return _contentStr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
