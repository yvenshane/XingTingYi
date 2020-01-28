//
//  VENMyOtherViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/8/13.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyOtherViewController.h"
#import "VENBaseCategoryView.h"

#import "VENMyOtherPlatformMaterialViewController.h"
#import "VENMyOtherCourseMaterialViewController.h"
#import "VENMyOtherPersonalMaterialViewController.h"

@interface VENMyOtherViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) VENBaseCategoryView *categoryView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger pageIdx;

@end

@implementation VENMyOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupCategoryView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!(scrollView.isDragging || scrollView.isDecelerating || scrollView.isTracking)) {
        return;
    }
    
    // 获取滚动视图的内容的偏移量 x
    CGFloat offsetX = scrollView.contentOffset.x;
//    NSLog(@"%f____%f", offsetX, kMainScreenWidth);
    // 需要将偏移量交给分类视图!
    _categoryView.offset_X = offsetX / 3;
    
    // 计算滚动
    //    NSInteger idx = offsetX / 4 / _categoryView.btnsArr[0].bounds.size.width + 0.5;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    _pageIdx = offsetX / kMainScreenWidth;
    
    // 滚动 加载数据
    if (_pageIdx == 0) {
        
    }
}

- (void)categoryViewValueChanged:(VENBaseCategoryView *)sender {
    
    // 1.获取页码数
    NSUInteger pageNumber = sender.pageNumber;
    _pageIdx = pageNumber;
    // 2.让scrollView滚动
    CGRect rect = CGRectMake(_scrollView.bounds.size.width * pageNumber, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
    [_scrollView scrollRectToVisible:rect animated:YES];
    
    // 点击 加载数据
    if (_pageIdx == 0) {
        
    }
}

- (void)setupCategoryView {
    VENBaseCategoryView *categoryV = [[VENBaseCategoryView alloc] initWithFrame:CGRectZero andTitles:@[@"平台素材", @"课程素材", @"个人素材"]];
    categoryV.backgroundColor = [UIColor whiteColor];
    [categoryV addTarget:self action:@selector(categoryViewValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:categoryV];
    
    [categoryV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(0);
        make.width.mas_equalTo(kMainScreenWidth);
        make.height.mas_equalTo(40);
    }];
    
    UIScrollView *scrollV = [self setupContentView];
    [self.view addSubview:scrollV];
    
    [scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(categoryV);
        make.top.equalTo(categoryV.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    _categoryView = categoryV;
    _scrollView = scrollV;
}

// 负责创建底部滚动视图的方法
- (UIScrollView *)setupContentView {
    
    UIScrollView *scrollV = [[UIScrollView alloc] init];
    scrollV.backgroundColor = [UIColor whiteColor];
    scrollV.pagingEnabled = YES;
    scrollV.delegate = self;
    scrollV.showsHorizontalScrollIndicator = NO;
    
    NSMutableArray<UIView *> *vcViewsArrM = [NSMutableArray array];
    
    VENMyOtherPlatformMaterialViewController *vc = [[VENMyOtherPlatformMaterialViewController alloc] init];
    vc.dotype = self.dotype;
    [self addChildController:vc intoView:scrollV];
    [vcViewsArrM addObject:vc.view];
    
    VENMyOtherCourseMaterialViewController *vc2 = [[VENMyOtherCourseMaterialViewController alloc] init];
    vc2.dotype = self.dotype;
    [self addChildController:vc2 intoView:scrollV];
    [vcViewsArrM addObject:vc2.view];
    
    VENMyOtherPersonalMaterialViewController *vc3 = [[VENMyOtherPersonalMaterialViewController alloc] init];
    vc3.dotype = self.dotype;
    [self addChildController:vc3 intoView:scrollV];
    [vcViewsArrM addObject:vc3.view];
    
    [vcViewsArrM mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    [vcViewsArrM mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(scrollV);
        // 确定内容的高度
        make.bottom.top.equalTo(scrollV);
        
    }];
    
    return scrollV;
}

- (void)addChildController:(UIViewController *)childController intoView:(UIView *)view  {
    
    // 添加子控制器 － 否则响应者链条会被打断，导致事件无法正常传递，而且错误非常难改！
    [self addChildViewController:childController];
    
    // 添加子控制器的视图
    [view addSubview:childController.view];
    
    // 完成子控制器的添加
    [childController didMoveToParentViewController:self];
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
