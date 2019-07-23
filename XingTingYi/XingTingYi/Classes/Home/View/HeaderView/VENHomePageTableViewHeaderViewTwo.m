//
//  VENHomePageTableViewHeaderViewTwo.m
//  XingTingYi
//
//  Created by YVEN on 2019/7/22.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageTableViewHeaderViewTwo.h"
#import "VENHomePageBannerCollectionViewCell.h"

@interface VENHomePageTableViewHeaderViewTwo () <TYCyclePagerViewDelegate, TYCyclePagerViewDataSource>
@property (nonatomic, strong) UIImageView *bannerBackgroundImageView;
@property (nonatomic, strong) TYCyclePagerView *pagerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UILabel *titleLabel2;
@property (nonatomic, strong) UIView *lineView2;

@end

static NSString *const bannerCellIdentifier = @"bannerCellIdentifier";
@implementation VENHomePageTableViewHeaderViewTwo

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *bannerBackgroundImageView = [[UIImageView alloc] init];
        bannerBackgroundImageView.image = [UIImage imageNamed:@"icon_home_bg"];
        [self addSubview:bannerBackgroundImageView];
        
        TYCyclePagerView *pagerView = [[TYCyclePagerView alloc] init];
        pagerView.isInfiniteLoop = YES;
        pagerView.autoScrollInterval = 3.0;
        pagerView.dataSource = self;
        pagerView.delegate = self;
        [pagerView registerNib:[UINib nibWithNibName:@"VENHomePageBannerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:bannerCellIdentifier];
        [self addSubview:pagerView];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(0xFFDE02);
        [self addSubview:lineView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"关于我们";
        titleLabel.textColor = UIColorFromRGB(0x222222);
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        UILabel *descriptionLabel = [[UILabel alloc] init];
        descriptionLabel.text = @"LabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabelLabel";
        descriptionLabel.textColor = UIColorFromRGB(0x666666);
        descriptionLabel.font = [UIFont systemFontOfSize:13.0f];
        descriptionLabel.numberOfLines = 3;
        [self addSubview:descriptionLabel];
        
        UIButton *moreButton = [[UIButton alloc] init];
        [moreButton setTitle:@"查看更多介绍" forState:UIControlStateNormal];
        [moreButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        moreButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:moreButton];
        ViewBorderRadius(moreButton, 20, 1, UIColorFromRGB(0xE8E8E8));
        
        UIView *lineView2 = [[UIView alloc] init];
        lineView2.backgroundColor = UIColorFromRGB(0xFFDE02);
        [self addSubview:lineView2];
        
        UILabel *titleLabel2 = [[UILabel alloc] init];
        titleLabel2.text = @"系统介绍";
        titleLabel2.textColor = UIColorFromRGB(0x222222);
        titleLabel2.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18.0];
        titleLabel2.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel2];
        
        _bannerBackgroundImageView = bannerBackgroundImageView;
        _pagerView = pagerView;
        _lineView = lineView;
        _titleLabel = titleLabel;
        _descriptionLabel = descriptionLabel;
        _moreButton = moreButton;
        _lineView2 = lineView2;
        _titleLabel2 = titleLabel2;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bannerBackgroundImageView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight / (667.0 / 114.0));
    self.pagerView.frame = CGRectMake(0, 10, kMainScreenWidth, kMainScreenHeight / (667.0 / 170.0));
    CGFloat y = 10 + kMainScreenHeight / (667.0 / 170.0) + 30;
    self.titleLabel.frame = CGRectMake(20, y, kMainScreenWidth - 40, 25);
    y += 18;
    self.lineView.frame = CGRectMake(kMainScreenWidth / 2 - 73.5 / 2, y, 73.5, 5);
    y += 5 + 20;
    self.descriptionLabel.frame = CGRectMake(20, y, kMainScreenWidth - 40, 60);
    y += 60 + 20;
    self.moreButton.frame = CGRectMake(kMainScreenWidth / 2 - 129 / 2, y, 129, 40);
    y += 40 + 40;
    self.titleLabel2.frame = CGRectMake(20, y, kMainScreenWidth - 40, 25);
    y += 18;
    self.lineView2.frame = CGRectMake(kMainScreenWidth / 2 - 73.5 / 2, y, 73.5, 5);
    
    
    
    
    
}

#pragma mark - TYCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return 5;
}

- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    VENHomePageBannerCollectionViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:bannerCellIdentifier forIndex:index];
    
    cell.bannerImageView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    cell.bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    return cell;
}

- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(kMainScreenWidth - 40, CGRectGetHeight(pageView.frame));
    layout.itemSpacing = 10;
    layout.layoutType = TYCyclePagerTransformLayoutNormal;
    layout.itemHorizontalCenter = YES;
    return layout;
}

- (void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index {
    
}

@end
