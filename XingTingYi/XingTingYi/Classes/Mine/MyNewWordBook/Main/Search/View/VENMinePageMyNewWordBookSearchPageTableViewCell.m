//
//  VENMinePageMyNewWordBookSearchPageTableViewCell.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/30.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMinePageMyNewWordBookSearchPageTableViewCell.h"
#import "VENMinePageMyNewWordBookSearchPageModel.h"

@implementation VENMinePageMyNewWordBookSearchPageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.addNewWordBookButton.layer.cornerRadius = 15.0f;
    self.addNewWordBookButton.layer.masksToBounds = YES;
}

- (void)setModel:(VENMinePageMyNewWordBookSearchPageModel *)model {
    _model = model;
    
    self.titleLabel.text = model.name;
    self.pronunciationLabel.text = model.pronunciation_words;
    self.paraphraseLabel.text = model.paraphrase;
    self.descriptionLabel.text = [NSString stringWithFormat:@"本条生词由 %@ 制作", model.nickname];
    
    if ([model.is_exist isEqualToString:@"1"]) {
        self.addNewWordBookButton.backgroundColor = UIColorFromRGB(0xFFDE02);
        [self.addNewWordBookButton setTitle:@"添加到生词本" forState:UIControlStateNormal];
        [self.addNewWordBookButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    } else {
        self.addNewWordBookButton.backgroundColor = UIColorFromRGB(0xE8E8E8);
        [self.addNewWordBookButton setTitle:@"已添加生词" forState:UIControlStateNormal];
        [self.addNewWordBookButton setTitleColor:UIColorFromRGB(0xB2B2B2) forState:UIControlStateNormal];
    }
    
    [self.addNewWordBookButton addTarget:self action:@selector(addNewWordBookButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addNewWordBookButtonClick {
    if ([self.model.is_exist isEqualToString:@"1"]) {
        if (self.addNewWordBookBlock) {
            self.addNewWordBookBlock(@"");
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
