//
//  VENHomePageRecommendMaterialViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/9/6.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageRecommendMaterialViewController.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXCategoryListContainerView.h"
#import "VENHomePageRecommendMaterialListViewController.h"

@interface VENHomePageRecommendMaterialViewController () <JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) NSMutableArray *idsArr;
@property (nonatomic, strong) NSMutableArray *titlesArr;

@end

@implementation VENHomePageRecommendMaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"推荐素材";
    
    __weak typeof(self) weakSelf = self;
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"base/sourceType" parameters:nil successBlock:^(id responseObject) {
        
        for (NSDictionary *dict in responseObject[@"content"]) {
            [weakSelf.idsArr addObject: dict[@"id"]];
            [weakSelf.titlesArr addObject: dict[@"name"]];
        }
        
        JXCategoryTitleView *categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
        categoryView.delegate = self;
        categoryView.titles = self.titlesArr;
        categoryView.titleColor = UIColorFromRGB(0x999999);
        categoryView.titleSelectedColor = UIColorFromRGB(0x222222);
        categoryView.titleFont = [UIFont systemFontOfSize:15.0f weight:UIFontWeightMedium];
        categoryView.titleSelectedFont = [UIFont systemFontOfSize:18.0f weight:UIFontWeightMedium];
        categoryView.titleColorGradientEnabled = YES;
        [self.view addSubview:categoryView];
        
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = UIColorFromRGB(0xFFDE02);
        lineView.indicatorWidth = 20.0f;
        lineView.indicatorHeight = 3.0f;
        categoryView.indicators = @[lineView];
        
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight - 1, kMainScreenWidth, 1)];
        lineView2.backgroundColor = UIColorFromRGB(0xF1F1F1);
        [self.view addSubview:lineView2];
        
        JXCategoryListContainerView *listContainerView = [[JXCategoryListContainerView alloc] initWithDelegate:self];
        listContainerView.frame = CGRectMake(0, 40, kMainScreenWidth, kMainScreenHeight - 40);
        [self.view addSubview:listContainerView];
        //关联cotentScrollView，关联之后才可以互相联动！！！
        categoryView.contentScrollView = listContainerView.scrollView;
        
        weakSelf.listContainerView = listContainerView;
        
    } failureBlock:^(NSError *error) {
        
    }];
}

//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    
}

//点击选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.listContainerView didClickSelectedItemAtIndex:index];
}

//滚动选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    
}

//正在滚动中的回调
- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

//返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 7;
}

//返回遵从`JXCategoryListContentViewDelegate`协议的实例
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    
    VENHomePageRecommendMaterialListViewController *vc = [[VENHomePageRecommendMaterialListViewController alloc] init];
    vc.type = self.idsArr[index];
    return vc;
}

- (NSMutableArray *)titlesArr {
    if (!_titlesArr) {
        _titlesArr = [NSMutableArray array];
    }
    return _titlesArr;
}

- (NSMutableArray *)idsArr {
    if (!_idsArr) {
        _idsArr = [NSMutableArray array];
    }
    return _idsArr;
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
