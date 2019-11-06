//
//  VENHomePageTableViewCell.m
//  XingTingYi
//
//  Created by YVEN on 2019/7/15.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageTableViewCell.h"
#import "VENHomePageModel.h"

@implementation VENHomePageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    ViewRadius(self.iconImageView, 4);
}

- (void)setModel:(VENHomePageModel *)model {
    _model = model;
    
    
    self.iconImageView.contentMode = UIViewContentModeScaleToFill;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.titleLabel.text = model.name;
    self.discriptionLabel.text = model.descriptionn;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
