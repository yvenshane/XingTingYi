//
//  VENHomePageNewsViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/9/6.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageNewsViewController.h"
#import "VENHomePageTableViewCellTwo.h"
#import "VENHomePageModel.h"
#import "VENBaseWebViewController.h"

@interface VENHomePageNewsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataSourceMuArr;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENHomePageNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"新闻资讯";
    
    [self setupTableView];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadHomePageNewsDataWithPage:(NSString *)page {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"base/newsList" parameters:@{@"page" : page} successBlock:^(id responseObject) {
        
        if ([page integerValue] == 1) {
            [self.tableView.mj_header endRefreshing];
            
            self.dataSourceMuArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:responseObject[@"content"][@"newsList"]]];
            
            self.page = 1;
        } else {
            [self.tableView.mj_footer endRefreshing];
            
            [self.dataSourceMuArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:responseObject[@"content"][@"newsList"]]];
        }
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENHomePageTableViewCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSourceMuArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VENHomePageModel *model = self.dataSourceMuArr[indexPath.row];
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"base/newsInfo" parameters:@{@"id" : model.id} successBlock:^(id responseObject) {
        
        UIView *headerView = [[UIView alloc] init];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = responseObject[@"content"][@"title"];
        titleLabel.textColor = UIColorFromRGB(0x222222);
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20.0f];
        CGFloat width = kMainScreenWidth - 40;
        CGFloat height = [titleLabel sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height;
        titleLabel.frame = CGRectMake(20, 5, width, height);
        [headerView addSubview:titleLabel];
        
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.text = responseObject[@"content"][@"created_at"];
        dateLabel.textColor = UIColorFromRGB(0x999999);
        dateLabel.font = [UIFont systemFontOfSize:13.0f];
        CGFloat height2 = [dateLabel sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height;
        dateLabel.frame = CGRectMake(20, 5 + height + 10, width, height2);
        [headerView addSubview:dateLabel];
        
        VENBaseWebViewController *vc = [[VENBaseWebViewController alloc] init];
        vc.isPush = YES;
        vc.headerView = headerView;
        vc.headerViewHeight = 5 + height + 10 + height2 + 20;
        vc.HTMLString = responseObject[@"content"][@"content"];
        [self.navigationController pushViewController:vc animated:YES];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  80 + 30;
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
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"VENHomePageTableViewCellTwo" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadHomePageNewsDataWithPage:@"1"];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadHomePageNewsDataWithPage:[NSString stringWithFormat:@"%ld", ++self.page]];
    }];
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
