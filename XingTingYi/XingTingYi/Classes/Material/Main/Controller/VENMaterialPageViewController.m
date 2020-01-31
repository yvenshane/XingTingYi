//
//  VENMaterialPageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/7/15.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialPageViewController.h"
#import "VENHomePageTableViewCellTwo.h"
#import "VENMaterialPagePlatformMaterialViewController.h"
#import "VENMaterialPagePersonalMaterialViewController.h"

@interface VENMaterialPageViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *lineView2;

@property (nonatomic, strong) UIView *selectorView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL isRefresh;

@end


@implementation VENMaterialPageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // nav 黑线
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // nav 黑线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationView];
    [self setupContentView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!(scrollView.isDragging || scrollView.isDecelerating || scrollView.isTracking)) {
        return;
    }
    
    // 获取滚动视图的内容的偏移量 x
    CGFloat offsetX = scrollView.contentOffset.x;
//    NSLog(@"%f____%f", offsetX, kMainScreenWidth);
    // 需要将偏移量交给分类视图!
//    _categoryView.offset_X = offsetX / 3;
    
    // 计算滚动
    //    NSInteger idx = offsetX / 4 / _categoryView.btnsArr[0].bounds.size.width + 0.5;
    
    
    if (offsetX == 0) {
        self.leftButton.selected = YES;
        self.rightButton.selected = NO;
        
        self.lineView.hidden = NO;
        self.lineView2.hidden = YES;
        
    } else if (offsetX == kMainScreenWidth) {
        self.leftButton.selected = NO;
        self.rightButton.selected = YES;
        
        self.lineView.hidden = YES;
        self.lineView2.hidden = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 滚动 加载数据
    if (offsetX / kMainScreenWidth == 1) {
        if (!self.isRefresh) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPersonalMaterialAudioPage" object:nil];
            self.isRefresh = YES;
        }
    }
}

- (void)setupContentView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - kTabBarHeight)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake(kMainScreenWidth * 2, kMainScreenHeight - kStatusBarAndNavigationBarHeight - kTabBarHeight);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    // 平台素材
    VENMaterialPagePlatformMaterialViewController *vc = [[VENMaterialPagePlatformMaterialViewController alloc] init];
    [self addChildViewController:vc];
    [scrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - kTabBarHeight);
    [vc didMoveToParentViewController:self];
    
    // 个人素材
    VENMaterialPagePersonalMaterialViewController *vc2 = [[VENMaterialPagePersonalMaterialViewController alloc] init];
    [self addChildViewController:vc2];
    [scrollView addSubview:vc2.view];
    vc2.view.frame = CGRectMake(kMainScreenWidth, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - kTabBarHeight);
    [vc2 didMoveToParentViewController:self];
    
    _scrollView = scrollView;
}

#pragma mark - NavigationView
- (void)setupNavigationView {
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
    self.navigationItem.titleView = navigationView;
    
    CGFloat width = 80;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 - width - 9, 11 + 16, 74, 5)];
    lineView.backgroundColor = UIColorFromRGB(0xFFDE02);
    [navigationView addSubview:lineView];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 - width - 11.5, 0, width, 44)];
    [leftButton setTitle:@"平台素材" forState:UIControlStateNormal];
    [leftButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [leftButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateSelected];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightMedium];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.selected = YES;
    [navigationView addSubview:leftButton];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 + 14, 11 + 16, 74, 5)];
    lineView2.backgroundColor = UIColorFromRGB(0xFFDE02);
    lineView2.hidden = YES;
    [navigationView addSubview:lineView2];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 + 11.5, 0, width, 44)];
    [rightButton setTitle:@"个人素材" forState:UIControlStateNormal];
    [rightButton setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    [rightButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateSelected];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightMedium];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:rightButton];
    
    _leftButton = leftButton;
    _rightButton = rightButton;
    _lineView = lineView;
    _lineView2 = lineView2;
}

- (void)leftButtonClick:(UIButton *)button {
    if (!button.selected) {
        button.selected = !button.selected;
        
        self.rightButton.selected = NO;
        self.lineView.hidden = NO;
        self.lineView2.hidden = YES;
        
        CGRect rect = CGRectMake(0, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        [self.scrollView scrollRectToVisible:rect animated:YES];
    }
}

- (void)rightButtonClick:(UIButton *)button {
    if (!button.selected) {
        button.selected = !button.selected;
        
        self.leftButton.selected = NO;
        self.lineView.hidden = YES;
        self.lineView2.hidden = NO;
        
        CGRect rect = CGRectMake(self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        [self.scrollView scrollRectToVisible:rect animated:YES];
        
        if (!self.isRefresh) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPersonalMaterialAudioPage" object:nil];
            self.isRefresh = YES;
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
