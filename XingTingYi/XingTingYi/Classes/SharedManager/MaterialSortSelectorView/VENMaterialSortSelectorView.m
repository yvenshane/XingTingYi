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

@property (nonatomic, copy) NSArray *dataSourceArr;

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

- (void)setSourceCategoryArr:(NSArray *)sourceCategoryArr {
    _sourceCategoryArr = sourceCategoryArr;
    
    for (NSInteger i = 0; i < sourceCategoryArr.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, i * 54, 80, 54)];
        button.backgroundColor = [UIColor clearColor];
        button.tag = i;
        [button setTitle:sourceCategoryArr[i][@"name"] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 17, 2, 20)];
        lineImageView.backgroundColor = UIColorFromRGB(0xFFDE02);
        lineImageView.hidden = YES;
        [button addSubview:lineImageView];
        
        if ([VENEmptyClass isEmptyString:[NSString stringWithFormat:@"%@", self.category_one_id]]) {
            if (i == 0) {
                button.backgroundColor = [UIColor whiteColor];
                button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14.0];
                lineImageView.hidden = NO;
                
                self.dataSourceArr = sourceCategoryArr[0][@"son"];
                self.category_one_id = sourceCategoryArr[0][@"id"];
            }
        } else {
            if (sourceCategoryArr[i][@"id"] == self.category_one_id) {
                button.backgroundColor = [UIColor whiteColor];
                button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14.0];
                lineImageView.hidden = NO;
                
                self.dataSourceArr = sourceCategoryArr[i][@"son"];
                self.category_one_id = sourceCategoryArr[i][@"id"];
            }
        }
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonsView addSubview:button];
    }
    
    [self.collectionView reloadData];
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
    return self.dataSourceArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *tempArr = self.dataSourceArr[section][@"son"];
    return tempArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VENMaterialSortSelectorViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = self.dataSourceArr[indexPath.section][@"son"][indexPath.row][@"name"];
    
    if (self.dataSourceArr[indexPath.section][@"son"][indexPath.row][@"id"] == self.category_three_id) {
        cell.titleLabel.backgroundColor = UIColorFromRGB(0xFFDE02);
        cell.titleLabel.textColor = UIColorFromRGB(0x222222);
    } else {
        cell.titleLabel.backgroundColor = UIColorFromRGB(0xF8F8F8);
        cell.titleLabel.textColor = UIColorFromRGB(0x666666);
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectItemBlock) {
        self.didSelectItemBlock(@{@"category_one_id" : self.category_one_id,
                                  @"category_two_id" : self.dataSourceArr[indexPath.section][@"id"],
                                  @"category_three_id" : self.dataSourceArr[indexPath.section][@"son"][indexPath.row][@"id"]});
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    VENMaterialSortSelectorViewCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifier2 forIndexPath:indexPath];
    headerView.titleLabel.text = self.dataSourceArr[indexPath.section][@"name"];
    
    return headerView;
}

- (void)show {
    if (self.isExcellentCourse) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ExcellentCourseSortSelectorView" object:nil userInfo:@{@"type" : @"show"}];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MaterialSortSelectorView" object:nil userInfo:@{@"type" : @"show"}];
    }
    
    self.backgroundView.frame = CGRectMake(0, -(kMainScreenWidth * 420 / 375), kMainScreenWidth, kMainScreenWidth * 420 / 375);
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.backgroundView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * 420 / 375);
    } completion:nil];
}

- (void)hidden {
    if (self.isExcellentCourse) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ExcellentCourseSortSelectorView" object:nil userInfo:@{@"type" : @"hidden"}];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MaterialSortSelectorView" object:nil userInfo:@{@"type" : @"hidden"}];
    }
    
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
    
    self.dataSourceArr = self.sourceCategoryArr[button.tag][@"son"];
    self.category_one_id = self.sourceCategoryArr[button.tag][@"id"];
    [self.collectionView reloadData];
    
    if ([button.titleLabel.text isEqualToString:@"全部"]) {
        if (self.didSelectItemBlock) {
            self.didSelectItemBlock(@{@"category_one_id" : @"",
                                      @"category_two_id" : @"",
                                      @"category_three_id" : @""});
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
