//
//  VENBaseWebViewController.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/21.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENBaseWebViewController.h"

@interface VENBaseWebViewController () <UITableViewDelegate, UIWebViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) CGFloat height;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!self.isPush) {
        [self setupNavigationBar];
    }
    
    [self setupTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)setupTableView {
    
    CGFloat y = self.isPush ? 0 : kStatusBarAndNavigationBarHeight;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, kMainScreenWidth, kMainScreenHeight - kStatusBarHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    tableView.tableHeaderView = headerView;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 1)];
    webView.delegate = self;
    webView.scrollView.scrollEnabled = NO;
    
    [webView loadHTMLString:self.HTMLString baseURL:nil];
    [headerView addSubview:webView];
    
    self.tableView = tableView;
    self.headerView = headerView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat webViewHeight = [webView.scrollView contentSize].height;
    
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    webView.frame = newFrame;
    
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, kMainScreenWidth, webViewHeight + self.height);
    self.tableView.tableHeaderView = self.headerView;
}

- (void)setupNavigationBar {
    UIView *navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kStatusBarAndNavigationBarHeight)];
    navigationBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationBar];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(10, kStatusBarHeight, 44, 44)];
    [closeButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationBar addSubview:closeButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = [VENEmptyClass isEmptyString:self.navigationItemTitle] ? @"美妆故事" : self.navigationItemTitle;
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    titleLabel.textColor = UIColorFromRGB(0x1A1A1A);
    CGFloat width = [self label:titleLabel setWidthToHeight:22.0f];
    titleLabel.frame = CGRectMake(kMainScreenWidth / 2 - width / 2, kStatusBarHeight + 22 / 2, width, 22);
    [navigationBar addSubview:titleLabel];
}

- (void)closeButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)label:(UILabel *)label setWidthToHeight:(CGFloat)Height {
    CGSize size = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, Height)];
    return size.width;
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
