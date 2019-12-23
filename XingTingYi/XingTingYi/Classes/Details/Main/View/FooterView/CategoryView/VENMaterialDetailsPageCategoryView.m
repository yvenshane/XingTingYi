//
//  VENMaterialDetailsPageCategoryView.m
//  XingTingYi
//
//  Created by YVEN on 2019/11/22.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsPageCategoryView.h"

@interface VENMaterialDetailsPageCategoryView ()
@property (nonatomic, strong) NSMutableArray <UIButton *>* buttonMuArr;

@end

@implementation VENMaterialDetailsPageCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setTitleArr:(NSArray *)titleArr {
    _titleArr = titleArr;
    
    [self.buttonMuArr removeAllObjects];
    
    CGFloat width = kMainScreenWidth / titleArr.count;
    
    for (NSInteger i = 0; i < titleArr.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * width, 0, width, 25)];
        button.tag = i;
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightMedium];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        CGFloat buttonWidth = [button.titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 22)].width;
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width / 2 - buttonWidth / 2, 20, buttonWidth, 5)];
        lineImageView.backgroundColor = UIColorFromRGB(0xFFDE02);
        lineImageView.hidden = NO;
        [button addSubview:lineImageView];
        
        if (i != 0) {
            [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium];
            lineImageView.hidden = YES;
        }
        
        [self.buttonMuArr addObject:button];
    }
}

- (void)buttonClick:(UIButton *)button {
    for (UIButton *button2 in self.buttonMuArr) {
        [button2 setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        button2.titleLabel.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium];

        for (UIImageView *imageView in button2.subviews) {
            if ([imageView isKindOfClass:[UIImageView class]]) {
                imageView.hidden = YES;
            }
        }
    }

    [button setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightMedium];

    for (UIImageView *imageView in button.subviews) {
        if ([imageView isKindOfClass:[UIImageView class]]) {
            imageView.hidden = NO;
        }
    }

    if (self.buttonClickBlock) {
        self.buttonClickBlock(button);
    }
}

- (NSMutableArray *)buttonMuArr {
    if (!_buttonMuArr) {
        _buttonMuArr = [NSMutableArray array];
    }
    return _buttonMuArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
