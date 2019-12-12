//
//  VENMinePageMyNewWordBookViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/11.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMinePageMyNewWordBookViewController.h"
#import "VENChooseCategoryView.h"

@interface VENMinePageMyNewWordBookViewController ()

@end

@implementation VENMinePageMyNewWordBookViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // nav 黑线
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的生词本";
    
    [self setupRightButtons];
}

#pragma mark - right buttons
- (void)setupRightButtons {
    UIButton *categoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 44)];
    [categoryButton setImage:[UIImage imageNamed:@"icon_mine_sx"] forState:UIControlStateNormal];
    [categoryButton addTarget:self action:@selector(categoryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:categoryButton];
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 44)];
    [searchButton setImage:[UIImage imageNamed:@"icon_mine_search"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    self.navigationItem.rightBarButtonItems = @[barButtonItem, barButtonItem2];
}

- (void)searchButtonClick {
    
}

- (void)categoryButtonClick {
    VENChooseCategoryView *chooseCategoryView = [[VENChooseCategoryView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight)];
//    [[UIApplication sharedApplication].keyWindow addSubview:chooseCategoryView];
    [self.view addSubview:chooseCategoryView];
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
