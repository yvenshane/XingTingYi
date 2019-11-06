//
//  VENBaseWebViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/21.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseWebViewController.h"
#import <WebKit/WebKit.h>

@interface VENBaseWebViewController () <UITableViewDelegate, WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) CGFloat webViewContentHeight;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!self.isPush) {
        [self setupNavigationBar];
    } else {
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        [leftButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(backEvent) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    }
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.headerViewHeight ? : CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.webView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.webViewContentHeight;
}

#pragma mark - TableView
- (UITableView *)tableView {
    if (!_tableView) {
        CGFloat y = self.isPush ? 0 : kStatusBarAndNavigationBarHeight;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, kMainScreenWidth, kMainScreenHeight - kStatusBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
//        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        // 解决 iOS 11 执行 reloadData 方法上移问题 (已知在部分页面 estimatedRowHeight = 0 会使 cellForRowAtIndexPath 方法从 index.row = 4 开始)
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        // 解决 iPhone X TableHeaderView 下移的问题
        if (@available(iOS 11.0, *)) {
          _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
          self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.body.scrollWidth"completionHandler:^(id _Nullable result,NSError * _Nullable error) {
        NSLog(@"scrollWidth高度：%.2f",[result floatValue]);
        CGFloat ratio =  CGRectGetWidth(self.webView.frame) / [result floatValue];

        [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error) {
            NSLog(@"scrollHeight高度：%.2f",[result floatValue]);
            NSLog(@"scrollHeight计算高度：%.2f",[result floatValue] * ratio);
            CGFloat newHeight = [result floatValue] * ratio;

            [self resetWebViewFrameWithHeight:newHeight];
        }];
    }];
}

#pragma mark - WebView
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.navigationDelegate = self;
        [_webView loadHTMLString:self.HTMLString baseURL:nil];
    }
    return _webView;
}

- (void)resetWebViewFrameWithHeight:(CGFloat)height {
    if (height != self.webViewContentHeight) {
        if (height >= CGRectGetHeight(self.view.frame)) {
            [self.webView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        } else {
            [self.webView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), height)];
        }
        
        self.webViewContentHeight = height;
        [self.tableView reloadData];
    }
}

#pragma mark - Navigation
- (void)setupNavigationBar {
    UIView *navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kStatusBarAndNavigationBarHeight)];
    navigationBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationBar];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, kStatusBarHeight, 44, 44)];
    [closeButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationBar addSubview:closeButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = [VENEmptyClass isEmptyString:self.navigationItemTitle] ? @"猩听译" : self.navigationItemTitle;
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    titleLabel.textColor = UIColorFromRGB(0x1A1A1A);
    CGFloat width = [titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 22.0f)].width;
    titleLabel.frame = CGRectMake(kMainScreenWidth / 2 - width / 2, kStatusBarHeight + 22 / 2, width, 22);
    [navigationBar addSubview:titleLabel];
}

- (void)closeButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backEvent {
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)webViewContentHeight {
    if (!_webViewContentHeight) {
        _webViewContentHeight = CGFLOAT_MIN;
    }
    return _webViewContentHeight;
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
