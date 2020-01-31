//
//  VENMaterialPageAddPersonalMaterialViewController.m
//  XingTingYi
//
//  Created by YVEN on 2020/1/31.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialPageAddPersonalMaterialViewController.h"
#import "VENBaseCategoryView.h"

@interface VENMaterialPageAddPersonalMaterialViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) VENBaseCategoryView *categoryView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger pageIdx;

@end

@implementation VENMaterialPageAddPersonalMaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"添加素材";
    
    [self setupCategoryView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UploadMaterialSuccess:) name:@"UploadMaterialSuccess" object:nil];
}

- (void)UploadMaterialSuccess:(NSNotification *)noti {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    NSString *type = noti.userInfo[@"type"];
    
    if ([type isEqualToString:@"1"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPersonalMaterialAudioPage" object:nil];
    } else if ([type isEqualToString:@"2"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPersonalMaterialVideoPage" object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPersonalMaterialTextPage" object:nil];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!(scrollView.isDragging || scrollView.isDecelerating || scrollView.isTracking)) {
        return;
    }
    
    // 获取滚动视图的内容的偏移量 x
    CGFloat offsetX = scrollView.contentOffset.x;
//    NSLog(@"%f____%f", offsetX, kMainScreenWidth);
    // 需要将偏移量交给分类视图!
    _categoryView.offset_X = offsetX / 2;
    
    // 计算滚动
    //    NSInteger idx = offsetX / 4 / _categoryView.btnsArr[0].bounds.size.width + 0.5;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    _pageIdx = offsetX / kMainScreenWidth;
    
    // 滚动 加载数据
    if (_pageIdx == 1) {
        
    } else if (_pageIdx == 2) {
        
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
    if (_pageIdx == 1) {
        
    } else if (_pageIdx == 2) {
        
    }
}

- (void)setupCategoryView {
    VENBaseCategoryView *categoryV = [[VENBaseCategoryView alloc] initWithFrame:CGRectZero andTitles:@[@"音频/视频素材", @"文本素材"]];
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
    
    NSArray<NSString *> *vcNamesArr = @[@"VENMaterialPageAddPersonalAudioVideoMaterialViewController", @"VENMaterialPageAddPersonalTextMaterialViewController"];
    
    NSMutableArray<UIView *> *vcViewsArrM = [NSMutableArray array];
    
    [vcNamesArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 2.1 创建vc对象
        Class cls = NSClassFromString(obj);
        UIViewController *vc = [[cls alloc] init];
        
        // 2.2 建立控制器的父子关系
        [self addChildController:vc intoView:scrollV];
        
        // 2.3添加控制器的视图到view中
        [vcViewsArrM addObject:vc.view];
        
    }];
    
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
