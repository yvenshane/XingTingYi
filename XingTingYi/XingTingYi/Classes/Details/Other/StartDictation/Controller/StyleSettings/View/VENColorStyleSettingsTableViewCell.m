//
//  VENColorStyleSettingsTableViewCell.m
//  XingTingYi
//
//  Created by YVEN on 2019/9/29.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENColorStyleSettingsTableViewCell.h"

@interface VENColorStyleSettingsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (nonatomic, strong) NSMutableArray <UIButton *> *buttonsMuArr;

@end

@implementation VENColorStyleSettingsTableViewCell

- (void)setColorArr:(NSArray *)colorArr {
    _colorArr = colorArr;
    
    for (UIView *subviews in self.buttonsView.subviews) {
        [subviews removeFromSuperview];
    }
    [self.buttonsMuArr removeAllObjects];
    
    CGFloat buttonWidth = (kMainScreenWidth - 40) / colorArr.count;
    
    for (NSInteger i = 0; i < colorArr.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * buttonWidth, 0, buttonWidth, 40)];
        [button setImage:[self drawImageWithColor:colorArr[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.buttonsView addSubview:button];
        [self.buttonsMuArr addObject:button];
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    if ([VENEmptyClass isEmptyArray:self.colorArr]) {
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
    
    [self.colorArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqual:selectedColor]) {
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTextStyle" object:nil userInfo:@{@"TextColor" : self.colorArr[button.tag]}];
}

- (UIImage *)drawImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 16.0f, 16.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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
