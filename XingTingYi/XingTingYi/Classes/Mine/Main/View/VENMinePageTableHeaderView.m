//
//  VENMinePageTableHeaderView.m
//  XingTingYi
//
//  Created by YVEN on 2019/8/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMinePageTableHeaderView.h"
#import "VENMinePageModel.h"

@interface VENMinePageTableHeaderView ()
@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIView *memberView;
@property (nonatomic, strong) UILabel *memberLabel;
@property (nonatomic, strong) UIView *radiusView;

@end

@implementation VENMinePageTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(0xFFDE02);
        
        // 设置
        UIButton *setttingButton = [[UIButton alloc] init];
        [setttingButton setImage:[UIImage imageNamed:@"icon_setting"] forState:UIControlStateNormal];
        [self addSubview:setttingButton];
        
        // 头像
        UIButton *iconButton = [[UIButton alloc] init];
//        iconButton.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        [self addSubview:iconButton];
        ViewRadius(iconButton, 35.0f);
        
        // 姓名
        UILabel *nameLabel = [[UILabel alloc] init];
//        nameLabel.text = @"labellabellabellabellabellabellabellabellabellabellabellabellabel";
        nameLabel.textColor = UIColorFromRGB(0x222222);
        nameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18.0];
        [self addSubview:nameLabel];
        
        // 描述
        UILabel *descriptionLabel = [[UILabel alloc] init];
        descriptionLabel.text = @"labellabellabellabellabellabellabellabellabellabellabellabellabel";
        descriptionLabel.textColor = UIColorFromRGB(0x222222);
        descriptionLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:descriptionLabel];
        
        // 会员
        UIView *memberView = [[UIView alloc] init];
        memberView.backgroundColor = [UIColor blackColor];
        [self addSubview:memberView];
        ViewRadius(memberView, 9.0f);
        
        UIImageView *memberImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 4.5, 10, 9)];
        memberImageView.image = [UIImage imageNamed:@"icon_member"];
        [memberView addSubview:memberImageView];
        
        UILabel *memberLabel = [[UILabel alloc] init];
//        memberLabel.text = @"猩听译会员";
        memberLabel.textColor = [UIColor whiteColor];
        memberLabel.font = [UIFont systemFontOfSize:10.0f];
        [memberView addSubview:memberLabel];
        
        // 圆角 View
        UIView *radiusView = [[UIView alloc] init];
        radiusView.backgroundColor = [UIColor whiteColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kMainScreenWidth, 28) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = radiusView.bounds;
        maskLayer.path = maskPath.CGPath;
        radiusView.layer.mask = maskLayer;
        [self addSubview:radiusView];
        
        _setttingButton = setttingButton;
        _iconButton = iconButton;
        _nameLabel = nameLabel;
        _descriptionLabel = descriptionLabel;
        _memberView = memberView;
        _memberLabel = memberLabel;
        _radiusView = radiusView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat y = kIsiPhoneX ? 35 : 20;
    
    self.setttingButton.frame = CGRectMake(kMainScreenWidth - 44 - 8, y, 44, 44);
    self.iconButton.frame = CGRectMake(20, 20 + 44, 70, 70);
    self.nameLabel.frame = CGRectMake(20 + 70 + 15, 20 + 55, kMainScreenWidth - 20 - 70 - 15 - 20, 25);
    self.descriptionLabel.frame = CGRectMake(20 + 70 + 15, 20 + 55 + 6 + 25, kMainScreenWidth - 20 - 70 - 15 - 20, 17);
    CGFloat width = [self.memberLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 12)].width;
    self.memberLabel.frame = CGRectMake(7 + 10 + 3, 3, width, 12);
    self.memberView.frame = CGRectMake(20 + 70 + 15, 20 + 55 + 6 + 25 + 12 + 17, width + 28, 18);
    self.radiusView.frame = CGRectMake(0, 176, kMainScreenWidth, 14);
}

- (void)setModel:(VENMinePageModel *)model {
    _model = model;
    
    [self.iconButton sd_setImageWithURL:[NSURL URLWithString:model.avatar] forState:UIControlStateNormal];
    self.nameLabel.text = model.nickname;
    self.descriptionLabel.text = model.sign;
    
    if ([model.type isEqualToString:@"1"]) {
        self.memberLabel.text = @"普通会员";
    } else if ([model.type isEqualToString:@"2"]) {
        self.memberLabel.text = @"猩听译会员";
    } else if ([model.type isEqualToString:@"3"]) {
        self.memberLabel.text = @"永久会员";
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
