//
//  VENMinePageMyTidingsViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/31.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMinePageMyTidingsViewController.h"
#import "VENDynamicCirclePageListTableViewCell.h"
#import "VENDynamicCirclePageListModel.h"
#import "VENDynamicCirclePageDetailsViewController.h"
#import "VENDynamicCirclePageReleaseDynamicViewController.h"

@interface VENMinePageMyTidingsViewController ()
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataSourceMuArr;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMinePageMyTidingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的动态";
    
    [self setupRightButton];
    [self setupTableView];
    
    [self loadDynamicCirclePageListData:@"1"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMyTidingsListPage) name:@"RefreshMyTidingsListPage" object:nil];
}

- (void)refreshMyTidingsListPage {
    [self loadDynamicCirclePageListData:@"1"];
}

- (void)loadDynamicCirclePageListData:(NSString *)page {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"user/myCircle" parameters:@{@"page" : page} successBlock:^(id responseObject) {
        
        if ([page integerValue] == 1) {
            [self.tableView.mj_header endRefreshing];
            
            self.dataSourceMuArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[VENDynamicCirclePageListModel class] json:responseObject[@"content"][@"friendCircle"]]];
            
            self.page = 1;
        } else {
            [self.tableView.mj_footer endRefreshing];
            
            [self.dataSourceMuArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VENDynamicCirclePageListModel class] json:responseObject[@"content"][@"friendCircle"]]];
        }
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENDynamicCirclePageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSourceMuArr[indexPath.row];
    
    cell.deleteButton.hidden = NO;
    cell.deleteButton.tag = indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VENDynamicCirclePageListModel *model = self.dataSourceMuArr[indexPath.row];
    
    VENDynamicCirclePageDetailsViewController *vc = [[VENDynamicCirclePageDetailsViewController alloc] init];
    vc.navigationItem.title = @"我的动态";
    vc.isMine = YES;
    vc.id = model.id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

// 删除动态
- (void)deleteButtonClick:(UIButton *)button {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要删除此动态吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *determineAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        VENDynamicCirclePageListModel *model = self.dataSourceMuArr[button.tag];
        
        [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"user/delCircle" parameters:@{@"id" : model.id} successBlock:^(id responseObject) {
            
            [self loadDynamicCirclePageListData:@"1"];
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshDynamicCircleListPage" object:nil userInfo:@{@"sort_id" : model.id}];
            
        } failureBlock:^(NSError *error) {
            
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:determineAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setupTableView {
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight);
    [self.tableView registerNib:[UINib nibWithNibName:@"VENDynamicCirclePageListTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDynamicCirclePageListData:@"1"];
    }];
    
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDynamicCirclePageListData:[NSString stringWithFormat:@"%ld", ++self.page]];
    }];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - 发布动态
- (void)setupRightButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 44)];
    [button setTitle:@"发布动态" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button addTarget:self action:@selector(releaseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)releaseButtonClick {
    VENDynamicCirclePageReleaseDynamicViewController *vc = [[VENDynamicCirclePageReleaseDynamicViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
