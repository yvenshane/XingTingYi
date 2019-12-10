//
//  VENMaterialDetailsPageTableViewCellTwo.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/9.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsPageTableViewCellTwo.h"

@implementation VENMaterialDetailsPageTableViewCellTwo

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundVieww.layer.cornerRadius = 8.0f;
    self.backgroundVieww.layer.masksToBounds = YES;
    
    self.contentView.layer.shadowColor = UIColorFromRGB(0x000000).CGColor;
    self.contentView.layer.shadowOpacity = 0.1;
    self.contentView.layer.shadowRadius = 2.5;
    self.contentView.layer.shadowOffset = CGSizeMake(0,0);
    
    [self.buttonOne addTarget:self action:@selector(buttonOneClick) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonTwo addTarget:self action:@selector(buttonTwoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonThree addTarget:self action:@selector(buttonThreeClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonOneClick {
    if (self.buttonOneBlock) {
        self.buttonOneBlock();
    }
}

- (void)buttonTwoClick {
    if (self.buttonTwoBlock) {
        self.buttonTwoBlock();
    }
}

- (void)buttonThreeClick {
    if (self.buttonThreeBlock) {
        self.buttonThreeBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
