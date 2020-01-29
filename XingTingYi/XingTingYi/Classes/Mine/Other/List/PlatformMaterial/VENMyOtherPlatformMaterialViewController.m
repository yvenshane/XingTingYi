//
//  VENMyOtherPlatformMaterialViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/8/13.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyOtherPlatformMaterialViewController.h"
#import "VENHomePageTableViewCellTwo.h"
#import "VENMyDictationDetailsViewController.h"
#import "VENHomePageModel.h"
#import "VENMyReadingDetailsViewController.h"

@interface VENMyOtherPlatformMaterialViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataSourceMuArr;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMyOtherPlatformMaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadPlatformMaterialData:(NSString *)page {
    NSDictionary *parameters = @{@"page" : page,
                                 @"type" : @"1",
                                 @"dotype" : self.dotype};
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"user/myDictationList" parameters:parameters successBlock:^(id responseObject) {
        
        if ([page integerValue] == 1) {
            [self.tableView.mj_header endRefreshing];
            
            self.dataSourceMuArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:responseObject[@"content"][@"sourceList"]]];
            
            self.page = 1;
        } else {
            [self.tableView.mj_footer endRefreshing];
            
            [self.dataSourceMuArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:responseObject[@"content"][@"sourceList"]]];
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
    
    if ([self.dotype isEqualToString:@"1"]) {
        VENMyDictationDetailsViewController *vc = [[VENMyDictationDetailsViewController alloc] init];
        vc.source_id = model.source_id;
        vc.deleteBlock = ^{
            [self loadPlatformMaterialData:@"1"];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.dotype isEqualToString:@"2"]) {
        VENMyReadingDetailsViewController *vc = [[VENMyReadingDetailsViewController alloc] init];
        vc.source_id = model.source_id;
        vc.deleteBlock = ^{
            [self loadPlatformMaterialData:@"1"];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
    }
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
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - 40) style:UITableViewStyleGrouped];
    tableView.backgroundColor = UIColorMake(245, 245, 245);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"VENHomePageTableViewCellTwo" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadPlatformMaterialData:@"1"];
    }];
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadPlatformMaterialData:[NSString stringWithFormat:@"%ld", ++self.page]];
    }];
    
    _tableView = tableView;
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
