//
//  VENMaterialDetailsTranslationPageSearchWordTableViewCell.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/10.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsTranslationPageSearchWordTableViewCell.h"

@implementation VENMaterialDetailsTranslationPageSearchWordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.addButton.layer.cornerRadius = 15.0f;
    self.addButton.layer.masksToBounds = YES;
    
    self.backgroundVieww.layer.cornerRadius = 8.0f;
    self.backgroundVieww.layer.masksToBounds = NO;
    
    self.backgroundVieww.layer.shadowColor = UIColorFromRGB(0x222222).CGColor;
    self.backgroundVieww.layer.shadowOpacity = 0.1;
    self.backgroundVieww.layer.shadowRadius = 2.5;
    self.backgroundVieww.layer.shadowOffset = CGSizeMake(0,0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
