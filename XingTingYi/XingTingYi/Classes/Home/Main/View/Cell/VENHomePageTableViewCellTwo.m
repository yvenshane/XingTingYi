//
//  VENHomePageTableViewCellTwo.m
//  XingTingYi
//
//  Created by YVEN on 2019/7/19.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageTableViewCellTwo.h"
#import "VENHomePageModel.h"

@implementation VENHomePageTableViewCellTwo

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    ViewRadius(self.iconImageView, 4);
}

- (void)setModel:(VENHomePageModel *)model {
    _model = model;
    
    self.iconImageView.contentMode = UIViewContentModeScaleToFill;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.titleLabel.text = model.title;
    self.dateLabel.text = model.created_at;
    
    if ([model.type isEqualToString:@"1"]) {
        self.tagImageView.image = [UIImage imageNamed:@"icon_tag_audio"];
    } else if ([model.type isEqualToString:@"2"]) {
        self.tagImageView.image = [UIImage imageNamed:@"icon_tag_video"];
    } else if ([model.type isEqualToString:@"3"]) {
        self.tagImageView.image = [UIImage imageNamed:@"icon_tag_text"];
    }  else if ([model.type isEqualToString:@"4"]) {
        self.tagImageView.image = [UIImage imageNamed:@"icon_tag_audio_text"];
    }  else if ([model.type isEqualToString:@"5"]) {
        self.tagImageView.image = [UIImage imageNamed:@"icon_tag_video_text"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
