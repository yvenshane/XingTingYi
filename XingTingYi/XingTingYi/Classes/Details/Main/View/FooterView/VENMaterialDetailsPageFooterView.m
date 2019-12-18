//
//  VENMaterialDetailsPageFooterView.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/4.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsPageFooterView.h"
#import "VENMaterialDetailsPageModel.h"
#import "VENMaterialDetailsPageCategoryView.h"
#import "VENMaterialDetailsPageMyDictationView.h"
#import "VENAudioPlayerView.h"

@interface VENMaterialDetailsPageFooterView ()
@property (nonatomic, strong) VENMaterialDetailsPageCategoryView *categoryVieww;
@property (nonatomic, strong) VENMaterialDetailsPageMyDictationView *myDictationVieww;
@property (nonatomic, strong) VENAudioPlayerView *audioPlayerView;

@end

@implementation VENMaterialDetailsPageFooterView

- (void)setContentDict:(NSDictionary *)contentDict {
    _contentDict = contentDict;
    
    VENMaterialDetailsPageModel *infoModel = [VENMaterialDetailsPageModel yy_modelWithJSON:contentDict[@"info"]];
    NSArray *avInfoArr = [NSArray yy_modelArrayWithClass:[VENMaterialDetailsPageModel class] json:contentDict[@"avInfo"]];
    NSArray *textInfoArr = [NSArray yy_modelArrayWithClass:[VENMaterialDetailsPageModel class] json:contentDict[@"textInfo"]];
    
    VENMaterialDetailsPageModel *avInfoModel;
    if (avInfoArr.count > 0) {
        avInfoModel = avInfoArr[0];
    }
    
    // category view
    self.categoryContentView.layer.cornerRadius = 8.0f;
    self.categoryContentView.layer.masksToBounds = YES;
    
    self.categoryViewHeightLayoutConstraint.constant = 0.0f;
    self.categoryContentViewHeightLayoutConstraint.constant = 0.0f;
    
    if (![VENEmptyClass isEmptyString:infoModel.notice] && ![VENEmptyClass isEmptyString:infoModel.words] && ![VENEmptyClass isEmptyString:infoModel.answer]) {
        self.categoryViewHeightLayoutConstraint.constant = 45.0f;
        self.categoryVieww.categoryViewTitle = self.categoryViewTitle;
        self.categoryVieww.titleArr = @[@"提示词", @"生词汇总", @"标准答案"];
        
        __weak typeof(self) weakSelf = self;
        self.categoryVieww.buttonClickBlock = ^(UIButton *button) {
            
            weakSelf.lockButton.hidden = YES;
            weakSelf.categoryContentLabel.hidden = NO;
            
            NSString *tempStr = @"";
            
            if (button.tag == 0) {
                tempStr = infoModel.notice;
            } else if (button.tag == 1) {
                tempStr = infoModel.words;
            } else {
                tempStr = infoModel.answer;
            }
            
            NSDictionary *userInfo = @{@"type" : @"3",
                                       @"content" : tempStr,
                                       @"title" : button.titleLabel.text};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshDetailPage" object:nil userInfo:userInfo];
        };

        self.categoryContentLabel.text = [VENEmptyClass isEmptyString:self.categoryViewContent] ? infoModel.notice : self.categoryViewContent;
        CGFloat height = [self.categoryContentLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 20 * 2 - 15 * 2, CGFLOAT_MAX)].height;

        self.categoryContentViewHeightLayoutConstraint.constant = height + 15 * 2;
        
        if ([self.categoryViewTitle isEqualToString:@"标准答案"]) {
            if ([VENEmptyClass isEmptyString:avInfoModel.dictationInfo[@"id"]]) {
                self.lockButton.hidden = NO;
                self.categoryContentLabel.hidden = YES;
                self.categoryContentViewHeightLayoutConstraint.constant = 120;
            }
        }
    }
    
    // my dictation view
    if (![VENEmptyClass isEmptyString:avInfoModel.dictationInfo[@"content"]]) {
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[avInfoModel.dictationInfo[@"content"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        self.myDictationVieww.numberOfLines = self.numberOfLines;
        self.myDictationVieww.contentLabel.numberOfLines = [self.numberOfLines integerValue];
        self.myDictationVieww.contentLabel.attributedText = attributedString;
        [self.myDictationView addSubview:self.myDictationVieww];
        
        CGFloat height = [self.myDictationVieww.contentLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 35 * 2, CGFLOAT_MAX)].height;
        
        self.myDictationViewHeightLayoutConstraint.constant = 23.5 + 20 + 15 + 40 + height + 36;
    } else {
        self.myDictationViewHeightLayoutConstraint.constant = 0.0f;
    }
    
    // bottom view
    if ([infoModel.type isEqualToString:@"1"] || [infoModel.type isEqualToString:@"2"] || [infoModel.type isEqualToString:@"3"]) {
        self.bottomView.hidden = YES;
        self.bottomViewHeightLayoutConstraint.constant = 0.0f;
    } else {
        if (avInfoArr.count > 1) {
            self.bottomView.hidden = YES;
            self.bottomViewHeightLayoutConstraint.constant = 0.0f;
        } else {
            self.bottomView.hidden = NO;
            self.bottomViewHeightLayoutConstraint.constant = 70.0f;
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
            
            if (self.isTextInfo) {
                
                self.categoryLeftLabel.textColor = UIColorFromRGB(0x999999);
                self.categoryLeftView.hidden = YES;
                
                self.categoryRightLabel.textColor = UIColorFromRGB(0x222222);
                self.categoryRightView.hidden = NO;
                
                if (![VENEmptyClass isEmptyString:infoModel.source_path]) {
                    self.audioPlayerView.audioURL = infoModel.source_path;
                    
                    // audio
                    self.audioView.hidden = NO;
                    self.audioViewHeightLayoutConstraint.constant = (kMainScreenWidth - 40) / (335.0 / 120.0) + 25;
                    self.audioPlayerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.audioView.frame), CGRectGetHeight(self.audioView.frame) - 25);
                }
            }
            
        } else if (avInfoArr.count > 1 && textInfoArr.count < 1) {
            self.sectionDictationView.hidden = NO;
            self.sectionDictationViewHeightLayoutConstraint.constant = 83.0f;
            
            self.sectionDictationTitleLabel.text = @"分段听写";
        } else {
            if (![infoModel.type isEqualToString:@"3"]) {
                self.sectionDictationView.hidden = NO;
                self.sectionDictationViewHeightLayoutConstraint.constant = 83.0f;
                
                self.sectionDictationTitleLabel.text = @"朗读翻译";
            }
        }
    }
    
    [self.categoryLeftButton addTarget:self action:@selector(categoryLeftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.categoryRightButton addTarget:self action:@selector(categoryRightButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)categoryLeftButtonClick {
    NSDictionary *userInfo = @{@"type" : @"2",
                               @"content" : @"left"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshDetailPage" object:nil userInfo:userInfo];
}

- (void)categoryRightButtonClick {
    NSDictionary *userInfo = @{@"type" : @"2",
                               @"content" : @"right"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshDetailPage" object:nil userInfo:userInfo];
}

#pragma mark - 分类视图
- (VENMaterialDetailsPageCategoryView *)categoryVieww {
    if (!_categoryVieww) {
        _categoryVieww = [[VENMaterialDetailsPageCategoryView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 25)];
        [self.categoryView addSubview:_categoryVieww];
    }
    return _categoryVieww;
}

#pragma mark - 我的听写视图
- (VENMaterialDetailsPageMyDictationView *)myDictationVieww {
    if (!_myDictationVieww) {
        _myDictationVieww = [[NSBundle mainBundle] loadNibNamed:@"VENMaterialDetailsPageMyDictationView" owner:nil options:nil].lastObject;
        _myDictationVieww.frame = CGRectMake(0, 0, kMainScreenWidth, 200);
    }
    return _myDictationVieww;
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
