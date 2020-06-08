//
//  VENDynamicCirclePageListViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/8/30.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENDynamicCirclePageListViewController.h"
#import "VENDynamicCirclePageListTableViewCell.h"
#import "VENDynamicCirclePageListModel.h"
#import "VENDynamicCirclePageReleaseDynamicViewController.h"

@interface VENDynamicCirclePageListViewController ()
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataSourceMuArr;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENDynamicCirclePageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    
    [self loadDynamicCirclePageListData:@"1"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDynamicCircleListPage:) name:@"RefreshDynamicCircleListPage" object:nil];
}

- (void)loadDynamicCirclePageListData:(NSString *)page {
    NSDictionary *parameters = @{@"sort_id" : self.sort_id,
                                 @"page" : page};
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"circle/friendCircleList" parameters:parameters successBlock:^(id responseObject) {
        
        if ([page integerValue] == 1) {
            [self.tableView.mj_header endRefreshing];
            
            self.dataSourceMuArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[VENDynamicCirclePageListModel class] json:responseObject[@"content"][@"circleList"]]];
            
            self.page = 1;
        } else {
            [self.tableView.mj_footer endRefreshing];
            
            [self.dataSourceMuArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VENDynamicCirclePageListModel class] json:responseObject[@"content"][@"circleList"]]];
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
    
    VENDynamicCirclePageListModel *model = self.dataSourceMuArr[indexPath.row];
    cell.model = model;
    
    __weak typeof(self) weakSelf = self;
    cell.moreButtonClickBlock = ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"屏蔽此人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf shieldWithType:@"2" andID:model.user_id];
        }];
        UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"屏蔽此条动态" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf shieldWithType:@"1" andID:model.id];
        }];
        UIAlertAction *alertAction3 = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            VENDynamicCirclePageReleaseDynamicViewController *vc = [[VENDynamicCirclePageReleaseDynamicViewController alloc] init];
            vc.type = @"report";
            vc.circle_id = model.id;
            vc.hidesBottomBarWhenPushed = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DynamicCirclePageListPush" object:nil userInfo:@{@"vc" : vc}];
        }];
        UIAlertAction *alertAction4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:alertAction];
        [alert addAction:alertAction2];
        [alert addAction:alertAction3];
        [alert addAction:alertAction4];
        
        [weakSelf presentViewController:alert animated:YES completion:nil];
    };
    
    return cell;
}

- (void)shieldWithType:(NSString *)type andID:(NSString *)idd {
    NSDictionary *parameters = @{@"type" : type,
                                 [type isEqualToString:@"1"] ? @"circle_id" : @"shield_id" : idd};
    
    __weak typeof(self) weakSelf = self;
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"circle/shield" parameters:parameters successBlock:^(id responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyTidingsListPage" object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshDynamicCircleListPage" object:nil userInfo:@{@"sort_id" : self.sort_id}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshDynamicCircleListPage" object:nil userInfo:@{@"sort_id" : @"0"}];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VENDynamicCirclePageListModel *model = self.dataSourceMuArr[indexPath.row];
    if (self.listViewSelectBlock) {
        self.listViewSelectBlock(model.id);
    }
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

- (void)setupTableView {
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - kTabBarHeight);
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

- (void)refreshDynamicCircleListPage:(NSNotification *)noti {
    if ([noti.userInfo[@"sort_id"] isEqualToString:self.sort_id]) {
        [self loadDynamicCirclePageListData:@"1"];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIView *)listView {
    return self.view;
}

//可选使用，列表显示的时候调用
- (void)listDidAppear {
    
}

//可选使用，列表消失的时候调用
- (void)listDidDisappear {
    
}

@end
