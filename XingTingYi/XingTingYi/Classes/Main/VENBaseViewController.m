//
//  VENBaseViewController.m
//  
//
//  Created by YVEN.
//  Copyright © 2019年 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseViewController.h"

@interface VENBaseViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation VENBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    
    // 不允许 viewController 自动调整，我们自己布局；如果设置为YES，视图会自动下移 64 像素
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 判断是否有上级页面，有的话再调用
    if ([self.navigationController.viewControllers indexOfObject:self] > 0) {
        [self setupNavigationItemLeftBarButtonItem];
    }
    
    // 解决 自定义 View 高度少 64/88 问题
    self.view.autoresizesSubviews = NO;
}

#pragma mark - TableView
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorMake(245, 245, 245);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        // 解决 iOS 11 执行 reloadData 方法上移问题 (已知在部分页面 estimatedRowHeight = 0 会使 cellForRowAtIndexPath 方法从 index.row = 4 开始)
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        // 解决多余 cell 问题
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

#pragma mark - NavigationItem LeftBarButtonItem
- (void)setupNavigationItemLeftBarButtonItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [button setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    
    // 防止返回手势失效
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

- (void)backButtonClick {
    if (self.isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
