//
//  VENMinePageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/7/15.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMinePageViewController.h"
#import "VENMinePageTableViewCell.h"
#import "VENMinePageTableHeaderView.h"
#import "VENSettingViewController.h"
#import "VENMyOtherViewController.h"
#import "VENMinePageMemberCenterViewController.h"
#import "VENMinePageMyNewWordBookViewController.h"
#import "VENMinePageModel.h"
#import "VENMinePageMyTidingsViewController.h"

@interface VENMinePageViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, strong) VENMinePageModel *model;
@property (nonatomic, assign) BOOL isRefresh;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMinePageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (self.isRefresh) {
        [self loadMinePageData];
        self.isRefresh = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTableView];
    
    [self loadMinePageData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutClick) name:@"Login_Out" object:nil];
    
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timered:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)timered:(NSTimer* )timer {
    if (!self.model) {
        [self loadMinePageData];
    }
}

- (void)loadMinePageData {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypeGET urlString:@"user/userCenter" parameters:nil successBlock:^(id responseObject) {
        
        self.model = [VENMinePageModel yy_modelWithJSON:responseObject[@"content"][@"userinfo"]];
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMinePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.iconImageView.image = [UIImage imageNamed:self.titleArr[indexPath.row][@"icon"]];
    cell.titleLabel.text = self.titleArr[indexPath.row][@"title"];
    cell.descriptionLabel.hidden = indexPath.row == 5 ? NO : YES;
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"会员剩余天数%@天", self.model.days]];
    [mutableAttributedString setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(6, self.model.days.length)];
    
    cell.descriptionLabel.attributedText = mutableAttributedString;
    cell.iconImageViewCenterYLayoutConstraint.constant = indexPath.row == 0 ? -7 : 0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 4) { // 我的生词本
        VENMinePageMyNewWordBookViewController *vc = [[VENMinePageMyNewWordBookViewController alloc] init];
        vc.origin = @"PersonalCenter";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 5) { // 会员中心
        VENMinePageMemberCenterViewController *vc = [[VENMinePageMemberCenterViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 6) {
        VENMinePageMyTidingsViewController *vc = [[VENMinePageMyTidingsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        VENMyOtherViewController *vc = [[VENMyOtherViewController alloc] init];
        
        // 1我的听写 2朗读 3翻译 4字幕
        if (indexPath.row == 0) {
            vc.navigationItem.title = @"我的听写";
            vc.dotype = @"1";
        } else if (indexPath.row == 1) {
            vc.navigationItem.title = @"我的朗读";
            vc.dotype = @"2";
        } else if (indexPath.row == 2) {
            vc.navigationItem.title = @"我的翻译";
            vc.dotype = @"3";
        } else {
            vc.navigationItem.title = @"我的字幕";
            vc.dotype = @"4";
        }
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? 40 : 54;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VENMinePageTableHeaderView *headerView = [[VENMinePageTableHeaderView alloc] init];
    headerView.model = self.model;
    [headerView.setttingButton addTarget:self action:@selector(setttingButton) forControlEvents:UIControlEventTouchUpInside];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 190;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)setupTableView {
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"VENMinePageTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadMinePageData];
    }];
}

- (void)setttingButton {
    VENSettingViewController *vc = [[VENSettingViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loginOutClick {
    self.isRefresh = YES;
    self.tabBarController.selectedIndex = 0;
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@{@"icon" : @"icon_mine_01", @"title" : @"我的听写"},
                     @{@"icon" : @"icon_mine_02", @"title" : @"我的朗读"},
                     @{@"icon" : @"icon_mine_03", @"title" : @"我的翻译"},
                     @{@"icon" : @"icon_mine_04", @"title" : @"我的字幕"},
                     @{@"icon" : @"icon_mine_05", @"title" : @"我的生词本"},
                     @{@"icon" : @"icon_mine_06", @"title" : @"会员中心"},
                     @{@"icon" : @"icon_mine_07", @"title" : @"我的动态"}];
    }
    return _titleArr;
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
