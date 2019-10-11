//
//  VENFontStyleSettingsTableViewCell.m
//  XingTingYi
//
//  Created by YVEN on 2019/9/29.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENFontStyleSettingsTableViewCell.h"

@interface VENFontStyleSettingsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (nonatomic, strong) NSMutableArray <UIButton *> *buttonsMuArr;

@end

@implementation VENFontStyleSettingsTableViewCell

- (void)setFontSizeArr:(NSArray *)fontSizeArr {
    _fontSizeArr = fontSizeArr;
    
    for (UIView *subviews in self.buttonsView.subviews) {
        [subviews removeFromSuperview];
    }
    [self.buttonsMuArr removeAllObjects];
    
    CGFloat buttonWidth = (kMainScreenWidth - 40) / fontSizeArr.count;
    
    for (NSInteger i = 0; i < fontSizeArr.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * buttonWidth, 0, buttonWidth, 40)];
        [button setTitle:fontSizeArr[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsView addSubview:button];
        [self.buttonsMuArr addObject:button];
    }
}

- (void)setCurrentFontSize:(CGFloat)currentFontSize {
    if ([VENEmptyClass isEmptyArray:self.fontSizeArr]) {
        return;
    }
    
    for (NSInteger i = 0; i < self.buttonsMuArr.count; i++) {
        if ([self.buttonsMuArr[i] isKindOfClass:[UIButton class]]) {
            if (self.buttonsMuArr[i].selected) {
                self.buttonsMuArr[i].selected = NO;
                self.buttonsMuArr[i].backgroundColor = UIColorFromRGB(0xFFFFFF);
                self.buttonsMuArr[i].layer.borderColor = UIColorFromRGB(0xFFFFFF).CGColor;
            }
        }
    }
    
    [self.fontSizeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj floatValue] == currentFontSize) {
            self.buttonsMuArr[idx].selected = YES;
            self.buttonsMuArr[idx].backgroundColor = UIColorFromRGB(0xF8F8F8);
            self.buttonsMuArr[idx].layer.borderWidth = 1.0f;
            self.buttonsMuArr[idx].layer.borderColor = UIColorFromRGB(0xE8E8E8).CGColor;
            
            *stop = YES;
        }
    }];
}

- (void)buttonClick:(UIButton *)button {
    for (UIButton *button2 in self.buttonsMuArr) {
        if (button2.selected) {
            button2.selected = NO;
            button2.backgroundColor = UIColorFromRGB(0xFFFFFF);
            button2.layer.borderColor = UIColorFromRGB(0xFFFFFF).CGColor;
        }
    }
    
    button.selected = YES;
    button.backgroundColor = UIColorFromRGB(0xF8F8F8);
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = UIColorFromRGB(0xE8E8E8).CGColor;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTextStyle" object:nil userInfo:@{@"FontSize" : self.fontSizeArr[button.tag]}];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.buttonsView.layer.cornerRadius = 2.0f;
    self.buttonsView.layer.masksToBounds = YES;
    self.buttonsView.layer.borderWidth = 1.0f;
    self.buttonsView.layer.borderColor = UIColorFromRGB(0xE8E8E8).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSMutableArray *)buttonsMuArr {
    if (!_buttonsMuArr) {
        _buttonsMuArr = [NSMutableArray array];
    }
    return _buttonsMuArr;
}

@end
