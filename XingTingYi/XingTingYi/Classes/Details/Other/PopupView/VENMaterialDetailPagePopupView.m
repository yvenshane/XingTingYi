//
//  VENMaterialDetailPagePopupView.m
//  XingTingYi
//
//  Created by YVEN on 2020/2/5.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailPagePopupView.h"

@implementation VENMaterialDetailPagePopupView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.backgroundButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    self.avatarImageView.layer.cornerRadius = 20.0f;
    self.avatarImageView.layer.masksToBounds = YES;
    
    self.backgroundImageView.layer.cornerRadius = 4.0f;
    self.backgroundImageView.layer.masksToBounds = YES;
    
    self.backgroundView.layer.cornerRadius = 8.0f;
    self.backgroundView.layer.masksToBounds = YES;
}

- (void)setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    
    self.signDayLabel.text = [NSString stringWithFormat:@"%@天日签", [formatter stringFromDate:date]];

    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:dataDict[@"bg_img"]]];
    
    NSString *days = [NSString stringWithFormat:@"%ld", [dataDict[@"days"] integerValue]];
    NSString *word = [NSString stringWithFormat:@"%ld", [dataDict[@"dictationNum"] integerValue]];
    NSString *subtitle = [NSString stringWithFormat:@"%ld", [dataDict[@"subtitlesNum"] integerValue]];
    NSString *read = [NSString stringWithFormat:@"%ld", [dataDict[@"readNum"] integerValue]];
    NSString *translation = [NSString stringWithFormat:@"%ld", [dataDict[@"translationNum"] integerValue]];
    NSString *addWords = [NSString stringWithFormat:@"%ld", [dataDict[@"wordsNum"] integerValue]];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"今天我在猩听译平台学习了%@分钟", days]];
    [attributedString setAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFFDE02)} range:NSMakeRange(12, days.length)];
    self.titleLabel.attributedText = attributedString;
    
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"我已经听写了%@篇文章", word]];
    [attributedString2 setAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFFDE02)} range:NSMakeRange(6, word.length)];
    self.wordLabel.attributedText = attributedString2;
    
    NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"制作了%@个字幕", subtitle]];
    [attributedString3 setAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFFDE02)} range:NSMakeRange(3, subtitle.length)];
    self.subtitleLabel.attributedText = attributedString3;
    
    NSMutableAttributedString *attributedString4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"朗读了%@篇文章", read]];
    [attributedString4 setAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFFDE02)} range:NSMakeRange(3, read.length)];
    self.readingLabel.attributedText = attributedString4;
    
    NSMutableAttributedString *attributedString5 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"翻译了%@篇文章", translation]];
    [attributedString5 setAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFFDE02)} range:NSMakeRange(3, translation.length)];
    self.translationLabel.attributedText = attributedString5;
    
    NSMutableAttributedString *attributedString6 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"添加了%@个生词", addWords]];
    [attributedString6 setAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xFFDE02)} range:NSMakeRange(3, addWords.length)];
    self.addWordsLabel.attributedText = attributedString6;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:dataDict[@"avatar"]]];
    self.nameLabel.text = dataDict[@"nickname"];
}

- (IBAction)closeButtonClick:(id)sender {
    if (self.closeButtonBlock) {
        [self removeFromSuperview];
        
        self.closeButtonBlock();
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
