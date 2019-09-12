//
//  VENAudioMaterialDetailsPageHeaderView.m
//  XingTingYi
//
//  Created by YVEN on 2019/9/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENAudioMaterialDetailsPageHeaderView.h"
#import "VENAudioMaterialDetailsPageModel.h"

@implementation VENAudioMaterialDetailsPageHeaderView

- (void)setModel:(VENAudioMaterialDetailsPageModel *)model {
    _model = model;
    
    self.pictureImageView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    self.audioView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    
    self.pictureImageViewHeightLayoutConstraint.constant = kMainScreenWidth / (375.0 / 250.0);
    
    self.contentView.layer.cornerRadius = 8.0f;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderWidth = 1.0f;
    self.contentView.layer.borderColor = UIColorFromRGB(0xE8E8E8).CGColor;
    
    self.audioViewHeightLayoutConstraint.constant = (kMainScreenWidth - 40) / (335.0 / 120.0);
    self.audioView.layer.cornerRadius = 8.0f;
    self.audioView.layer.masksToBounds = YES;
    
    self.categoryView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    
    self.myDictationContentView.layer.cornerRadius = 8.0f;
    self.myDictationContentView.layer.masksToBounds = YES;
    self.myDictationContentView.layer.borderWidth = 1.0f;
    self.myDictationContentView.layer.borderColor = UIColorFromRGB(0xE8E8E8).CGColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
