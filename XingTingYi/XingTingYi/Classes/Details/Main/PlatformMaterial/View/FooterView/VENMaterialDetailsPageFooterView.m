//
//  VENMaterialDetailsPageFooterView.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/4.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsPageFooterView.h"
#import "VENMaterialDetailsPageModel.h"
#import "VENAudioPlayerView.h"

@interface VENMaterialDetailsPageFooterView ()
@property (nonatomic, strong) VENMaterialDetailsPageModel *infoModel;
@property (nonatomic, strong) VENAudioPlayerView *audioPlayerView;

@end

@implementation VENMaterialDetailsPageFooterView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.categoryLeftButton.tag = 998;
    self.categoryRightButton.tag = 999;

    [self.categoryLeftButton addTarget:self action:@selector(categoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.categoryRightButton addTarget:self action:@selector(categoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (CGFloat)getHeightFromData:(NSDictionary *)data {
    self.infoModel = [VENMaterialDetailsPageModel yy_modelWithJSON:data[@"info"]];
    NSArray *avInfoArr = [NSArray yy_modelArrayWithClass:[VENMaterialDetailsPageModel class] json:data[@"avInfo"]];
    NSArray *textInfoArr = [NSArray yy_modelArrayWithClass:[VENMaterialDetailsPageModel class] json:data[@"textInfo"]];
    
    VENMaterialDetailsPageModel *avInfoModel;
    if (avInfoArr.count > 0) {
        avInfoModel = avInfoArr[0];
    }
    
    CGFloat viewHeight = 0;
    
    // bottom view
    self.bottomView.hidden = YES;
    self.bottomViewHeightLayoutConstraint.constant = 0.0f;
    
    if ([self.infoModel.type isEqualToString:@"4"] || [self.infoModel.type isEqualToString:@"5"]) {
        if (avInfoArr.count < 2) {
            self.bottomView.hidden = NO;
            self.bottomViewHeightLayoutConstraint.constant = 70.0f;
            
            self.bottomViewLeftButton.layer.cornerRadius = 20.0f;
            self.bottomViewLeftButton.layer.masksToBounds = YES;
            
            self.bottomViewRightButton.layer.cornerRadius = 20.0f;
            self.bottomViewRightButton.layer.masksToBounds = YES;
            
            self.bottomViewLeftButton.tag = 996;
            self.bottomViewRightButton.tag = 997;
            
            if (![VENEmptyClass isEmptyString:avInfoModel.dictationInfo[@"content"]]) {
                [self.bottomViewLeftButton setTitle:@"继续听写" forState:UIControlStateNormal];
            } else {
                [self.bottomViewLeftButton setTitle:@"开始听写" forState:UIControlStateNormal];
            }
            
            if (![VENEmptyClass isEmptyArray:avInfoModel.subtitlesList]) {
                [self.bottomViewRightButton setTitle:@"修改字幕" forState:UIControlStateNormal];
            } else {
                [self.bottomViewRightButton setTitle:@"制作字幕" forState:UIControlStateNormal];
            }
            
            [self.bottomViewLeftButton addTarget:self action:@selector(bottomViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.bottomViewRightButton addTarget:self action:@selector(bottomViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];

            viewHeight += 70.0f;
        }
    }
    
    self.sectionDictationView.hidden = YES;
    self.sectionDictationViewHeightLayoutConstraint.constant = 0.0f;
    self.categoryButtonView.hidden = YES;
    self.categoryButtonViewHeightLayoutConstraint.constant = 0.0f;
    self.audioView.hidden = YES;
    self.audioViewHeightLayoutConstraint.constant = 0.0f;
    
    // sectionDictationView
    if (avInfoArr.count > 1 || textInfoArr.count > 0) {
        if (avInfoArr.count > 1 && textInfoArr.count > 0) {
            self.categoryButtonView.hidden = NO;
            self.categoryButtonViewHeightLayoutConstraint.constant = 83.0f;
            viewHeight += 83.0f;
            
        } else if (avInfoArr.count > 1 && textInfoArr.count < 1) {
            self.sectionDictationView.hidden = NO;
            self.sectionDictationViewHeightLayoutConstraint.constant = 83.0f;
            viewHeight += 83.0f;
            
            self.sectionDictationTitleLabel.text = @"分段听写";
        } else {
            if (![self.infoModel.type isEqualToString:@"3"]) {
                self.sectionDictationView.hidden = NO;
                self.sectionDictationViewHeightLayoutConstraint.constant = 83.0f;
                viewHeight += 83.0f;
                
                self.sectionDictationTitleLabel.text = @"朗读翻译";
            }
        }
    }
    
    if (self.isTextInfo) {
        self.categoryLeftLabel.textColor = UIColorFromRGB(0x999999);
        self.categoryLeftView.hidden = YES;
        
        self.categoryRightLabel.textColor = UIColorFromRGB(0x222222);
        self.categoryRightView.hidden = NO;
    } else {
        self.categoryLeftLabel.textColor = UIColorFromRGB(0x222222);
        self.categoryLeftView.hidden = NO;
        
        self.categoryRightLabel.textColor = UIColorFromRGB(0x999999);
        self.categoryRightView.hidden = YES;
    }
    
    return viewHeight;
}

- (void)categoryButtonClick:(UIButton *)button {
    if (button.tag == 998) {
        self.categoryLeftLabel.textColor = UIColorFromRGB(0x222222);
        self.categoryLeftView.hidden = NO;
        
        self.categoryRightLabel.textColor = UIColorFromRGB(0x999999);
        self.categoryRightView.hidden = YES;
        
        self.audioView.hidden = YES;
        self.audioViewHeightLayoutConstraint.constant = 0;
        
        if (self.categoryButtonBlock) {
            self.categoryButtonBlock(button.tag, NO);
        }
    } else {
        self.categoryLeftLabel.textColor = UIColorFromRGB(0x999999);
        self.categoryLeftView.hidden = YES;
        
        self.categoryRightLabel.textColor = UIColorFromRGB(0x222222);
        self.categoryRightView.hidden = NO;
        
        if (![VENEmptyClass isEmptyString:self.infoModel.merge_audio]) {
            self.audioView.hidden = NO;
            self.audioViewHeightLayoutConstraint.constant = (kMainScreenWidth - 40) / (335.0 / 120.0);
            
            [self.audioPlayerView removeFromSuperview];
            
            self.audioPlayerView = [[[NSBundle mainBundle] loadNibNamed:@"VENAudioPlayerView" owner:nil options:nil] firstObject];
            self.audioPlayerView.audioURL = self.infoModel.source_path;
            self.audioPlayerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.audioView.frame), CGRectGetHeight(self.audioView.frame));
            [self.audioView addSubview:self.audioPlayerView];
        }
        
        if (self.categoryButtonBlock) {
            self.categoryButtonBlock(button.tag, ![VENEmptyClass isEmptyString:self.infoModel.merge_audio] ? YES : NO);
        }
    }
}

- (void)bottomViewButtonClick:(UIButton *)button {
    if (self.bottomViewButtonBlock) {
        self.bottomViewButtonBlock(button.tag);
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
