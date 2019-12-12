//
//  VENMaterialDetailsTranslationPageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/10.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsTranslationPageViewController.h"
#import "VENMaterialDetailsTranslationPageTableHeaderView.h"
#import "VENMaterialDetailsPageModel.h"
#import "VENMaterialDetailsTranslationPageSearchWordViewController.h" // 查词

@interface VENMaterialDetailsTranslationPageViewController ()
@property (nonatomic, strong) VENMaterialDetailsPageModel *infoModel;

@end

@implementation VENMaterialDetailsTranslationPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationItem.title = @"翻译";
    
    [self setupTableView];
    [self setupToolBar];
    [self setupBottomToolBar];
    
    [self loadMaterialDetailsTranslationPageData];
}

- (void)loadMaterialDetailsTranslationPageData {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"source/translationInfo" parameters:@{@"source_period_id" : self.source_period_id} successBlock:^(id responseObject) {
        
        self.infoModel = [VENMaterialDetailsPageModel yy_modelWithJSON:responseObject[@"content"][@"info"]];
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VENMaterialDetailsTranslationPageTableHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"VENMaterialDetailsTranslationPageTableHeaderView" owner:nil options:nil].lastObject;
    headerView.titleLabel.text = self.infoModel.content;
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 390;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)setupTableView {
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - 60 - (kTabBarHeight - 49));
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = nil;
    [self.view addSubview:self.tableView];
}

#pragma mark - 查词
- (void)setupToolBar {
    UIButton *toolBarButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 54, kMainScreenHeight - kStatusBarAndNavigationBarHeight - 60 - (kTabBarHeight - 49) - 54, 54, 54)];
    [toolBarButton setImage:[UIImage imageNamed:@"icon_search_words"] forState:UIControlStateNormal];
    [toolBarButton addTarget:self action:@selector(toolBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toolBarButton];
}

- (void)toolBarButtonClick {
    VENMaterialDetailsTranslationPageSearchWordViewController *vc = [[VENMaterialDetailsTranslationPageSearchWordViewController alloc] init];
    vc.source_id = self.infoModel.source_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupBottomToolBar {
    UIView *bottomToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - kStatusBarAndNavigationBarHeight - 60 - (kTabBarHeight - 49), kMainScreenWidth, 60)];
    bottomToolBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomToolBar];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xF1F1F1);
    [bottomToolBar addSubview:lineView];
    
    CGFloat width = (kMainScreenWidth - 40 - 15) / 2;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, width, 40)];
    leftButton.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [leftButton setTitle:@"查看他人翻译" forState:UIControlStateNormal];
    [leftButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    leftButton.layer.cornerRadius = 20.0f;
    leftButton.layer.masksToBounds = YES;
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomToolBar addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(20 + width + 15, 10, (kMainScreenWidth - 40 - 15) / 2, 40)];
    rightButton.backgroundColor = UIColorFromRGB(0xFFDE02);
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    rightButton.layer.cornerRadius = 20.0f;
    rightButton.layer.masksToBounds = YES;
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomToolBar addSubview:rightButton];
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
