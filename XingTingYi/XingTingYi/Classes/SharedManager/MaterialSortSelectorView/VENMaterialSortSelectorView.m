//
//  VENMaterialSortSelectorView.m
//  XingTingYi
//
//  Created by YVEN on 2019/9/9.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialSortSelectorView.h"
#import "VENMaterialSortSelectorViewCollectionViewCell.h"
#import "VENMaterialSortSelectorViewCollectionReusableView.h"

@interface VENMaterialSortSelectorView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIButton *backgroundButton;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *buttonsView;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

static const NSTimeInterval kAnimationDuration = 0.3;
static NSString *const cellIdentifier = @"cellIdentifier";
static NSString *const cellIdentifier2 = @"cellIdentifier2";
@implementation VENMaterialSortSelectorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIButton *backgroundButton = [[UIButton alloc] init];
        backgroundButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [backgroundButton addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backgroundButton];
        
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [backgroundButton addSubview:backgroundView];
        
        UIView *buttonsView = [[UIView alloc] init];
        buttonsView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [backgroundView addSubview:buttonsView];
        
        NSArray *titlesArr = @[@"考试日语", @"新闻日语", @"生活日语"];
        
        for (NSInteger i = 0; i < 3; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, i * 54, 80, 54)];
            [button setTitle:titlesArr[i] forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
            
            UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 17, 2, 20)];
            lineImageView.backgroundColor = UIColorFromRGB(0xFFDE02);
            [button addSubview:lineImageView];
            
            if (i == 0) {
                button.backgroundColor = [UIColor whiteColor];
                button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14.0];
                lineImageView.hidden = NO;
            } else {
                button.backgroundColor = [UIColor clearColor];
                button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
                lineImageView.hidden = YES;
            }
            
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [buttonsView addSubview:button];
        }
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.itemSize = CGSizeMake((kMainScreenWidth - 80 - 50 - 10) / 2, 40);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 25, 0, 25);
        flowLayout.headerReferenceSize = CGSizeMake(kMainScreenWidth, 54);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerNib:[UINib nibWithNibName:@"VENMaterialSortSelectorViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
        [collectionView registerNib:[UINib nibWithNibName:@"VENMaterialSortSelectorViewCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifier2];
        [backgroundView addSubview:collectionView];
        
        _backgroundButton = backgroundButton;
        _backgroundView = backgroundView;
        _buttonsView = buttonsView;
        _collectionView = collectionView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundButton.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    self.buttonsView.frame = CGRectMake(0, 0, 80, kMainScreenWidth * 420 / 375);
    self.collectionView.frame = CGRectMake(80, 0, kMainScreenWidth - 80, kMainScreenWidth * 420 / 375);
    
    [self show];
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VENMaterialSortSelectorViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    VENMaterialSortSelectorViewCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifier2 forIndexPath:indexPath];
    
    return headerView;
}

- (void)show {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MaterialSortSelectorView" object:nil userInfo:@{@"type" : @"show"}];
    
    self.backgroundView.frame = CGRectMake(0, -(kMainScreenWidth * 420 / 375), kMainScreenWidth, kMainScreenWidth * 420 / 375);
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.backgroundView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * 420 / 375);
    } completion:nil];
}

- (void)hidden {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MaterialSortSelectorView" object:nil userInfo:@{@"type" : @"hidden"}];
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.backgroundView.frame = CGRectMake(0, -(kMainScreenWidth * 420 / 375), kMainScreenWidth, kMainScreenWidth * 420 / 375);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)buttonClick:(UIButton *)button {
    
    for (UIButton *subview in self.buttonsView.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            subview.backgroundColor = [UIColor clearColor];
            subview.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            
            for (UIImageView *lineImageView in subview.subviews) {
                if ([lineImageView isKindOfClass:[UIImageView class]]) {
                    lineImageView.hidden = YES;
                }
            }
        }
    }
    
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14.0];
    
    for (UIImageView *lineImageView in button.subviews) {
        if ([lineImageView isKindOfClass:[UIImageView class]]) {
            lineImageView.hidden = NO;
        }
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
