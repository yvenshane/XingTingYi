//
//  VENVideoMaterialDetailsPageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/9/10.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsPageViewController.h"
#import "VENMaterialDetailsPageHeaderView.h"
#import "VENMaterialDetailsPageFooterView.h"
#import "VENMaterialDetailsPageModel.h"
#import "VENMaterialDetailsStartDictationPageViewController.h"
#import "VENBaseWebViewController.h"

@interface VENMaterialDetailsPageViewController ()
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) VENMaterialDetailsPageModel *infoModel;
@property (nonatomic, copy) NSArray *avInfoArr;
@property (nonatomic, copy) NSDictionary *contentDict;

@property (nonatomic, copy) NSString *categoryViewContent;
@property (nonatomic, copy) NSString *categoryViewTitle;
@property (nonatomic, copy) NSString *numberOfLines;

@end

@implementation VENMaterialDetailsPageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTableView];
    [self setupNavigationView];
    [self setupBottomToolBar];
    
    [self loadVideoMaterialDetailsPageData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shrinkButtonClick:) name:@"ShrinkButtonClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDetailPage:) name:@"RefreshDetailPage" object:nil];
}

- (void)loadVideoMaterialDetailsPageData {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"source/sourceInfo" parameters:@{@"id" : self.id} successBlock:^(id responseObject) {
        
        self.infoModel = [VENMaterialDetailsPageModel yy_modelWithJSON:responseObject[@"content"][@"info"]];
        self.avInfoArr = [NSArray yy_modelArrayWithClass:[VENMaterialDetailsPageModel class] json:responseObject[@"content"][@"avInfo"]];
        self.contentDict = responseObject[@"content"];
        
        VENMaterialDetailsPageModel *avInfoModel = self.avInfoArr[0];
        
        if (![VENEmptyClass isEmptyString:avInfoModel.dictationInfo[@"id"]]) {
            [self.leftButton setTitle:@"继续听写" forState:UIControlStateNormal];
        } else {
            [self.leftButton setTitle:@"开始听写" forState:UIControlStateNormal];
        }
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VENMaterialDetailsPageHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"VENVideoMaterialDetailsPageHeaderView" owner:nil options:nil].lastObject;
    headerView.contentDict = self.contentDict;
    [headerView.contentButton addTarget:self action:@selector(contentButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 965;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    VENMaterialDetailsPageFooterView *footerView = [[NSBundle mainBundle] loadNibNamed:@"VENMaterialDetailsPageFooterView" owner:nil options:nil].lastObject;
    footerView.categoryViewContent = self.categoryViewContent;
    footerView.categoryViewTitle = self.categoryViewTitle;
    footerView.numberOfLines = self.numberOfLines ? : @"3";
    footerView.contentDict = self.contentDict;
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    return 475;
}

- (void)setupTableView {
    self.tableView.dataSource = nil;
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 60 - (kTabBarHeight - 49));
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)setupBottomToolBar {
    UIView *bottomToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - 60 - (kTabBarHeight - 49), kMainScreenWidth, 60)];
    bottomToolBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomToolBar];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xF1F1F1);
    [bottomToolBar addSubview:lineView];
    
    CGFloat width = (kMainScreenWidth - 40 - 15) / 2;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, width, 40)];
    leftButton.backgroundColor = UIColorFromRGB(0xFFDE02);
    [leftButton setTitle:@"开始听写" forState:UIControlStateNormal];
    [leftButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    leftButton.layer.cornerRadius = 20.0f;
    leftButton.layer.masksToBounds = YES;
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomToolBar addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(20 + width + 15, 10, (kMainScreenWidth - 40 - 15) / 2, 40)];
    rightButton.backgroundColor = UIColorFromRGB(0x222222);
    [rightButton setTitle:@"制作字幕" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    rightButton.layer.cornerRadius = 20.0f;
    rightButton.layer.masksToBounds = YES;
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomToolBar addSubview:rightButton];
    
    _leftButton = leftButton;
}

#pragma mark - 开始听写
- (void)leftButtonClick:(UIButton *)button {
    VENMaterialDetailsPageModel *model = self.avInfoArr[0];
    
    VENMaterialDetailsStartDictationPageViewController *vc = [[VENMaterialDetailsStartDictationPageViewController alloc] init];
    vc.source_id = self.infoModel.id;
    vc.source_period_id = model.id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 制作字幕
- (void)rightButtonClick:(UIButton *)button {
    
}

#pragma mark - 导航栏
- (void)setupNavigationView {
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.view addSubview:navigationView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(22, kStatusBarHeight, 44, 44)];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
    
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 44 - 11, kStatusBarHeight, 44, 44)];
    [moreButton setImage:[UIImage imageNamed:@"icon_more3"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:moreButton];
    
    _navigationView = navigationView;
}

- (void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreButtonClick {
    
}

#pragma mark - 简介
- (void)contentButtonClick {
    VENBaseWebViewController *vc = [[VENBaseWebViewController alloc] init];
    vc.HTMLString = self.infoModel.descriptionn;
    vc.navigationItem.title = @"简介";
    vc.isPresent = YES;
    VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.navigationView.backgroundColor = [UIColor colorWithRed:255.0f / 255.0f green:255.0f / 255.0f blue:255.0f / 255.0f alpha:scrollView.contentOffset.y / kStatusBarAndNavigationBarHeight];
}

#pragma mark - NSNotificationCenter
- (void)refreshDetailPage:(NSNotification *)noti {
    self.categoryViewContent = noti.userInfo[@"content"];
    self.categoryViewTitle = noti.userInfo[@"title"];
    
    [self.tableView reloadData];
}

- (void)shrinkButtonClick:(NSNotification *)noti {
    UIButton *button = noti.userInfo[@"button"];
    
    if (button.selected) {
        self.numberOfLines = @"0";
    } else {
        self.numberOfLines = @"3";
    }
    
    [self.tableView reloadData];
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
