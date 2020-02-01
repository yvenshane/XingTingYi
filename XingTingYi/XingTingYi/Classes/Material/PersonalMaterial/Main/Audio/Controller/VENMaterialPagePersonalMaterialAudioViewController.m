//
//  VENMaterialPagePersonalMaterialAudioViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/7/31.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialPagePersonalMaterialAudioViewController.h"
#import "VENHomePageTableViewCellTwo.h"
#import "VENHomePageModel.h"
#import "VENMaterialPageAddPersonalMaterialViewController.h"
#import "VENPersonalMaterialDetailPageViewController.h"

@interface VENMaterialPagePersonalMaterialAudioViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataSourceMuArr;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMaterialPagePersonalMaterialAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPersonalMaterialAudioPage) name:@"RefreshPersonalMaterialAudioPage" object:nil];
}

- (void)loadPersonalMaterialAudioPageData:(NSString *)page {
    
    NSDictionary *parameters = @{@"page" : page,
                                 @"type" : @"1"};
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"userSource/userSource" parameters:parameters successBlock:^(id responseObject) {
        
        if ([page integerValue] == 1) {
            [self.tableView.mj_header endRefreshing];
            
            self.dataSourceMuArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:responseObject[@"content"][@"userSourceList"]]];
            
            self.page = 1;
        } else {
            [self.tableView.mj_footer endRefreshing];
            
            [self.dataSourceMuArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:responseObject[@"content"][@"userSourceList"]]];
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
    
    VENPersonalMaterialDetailPageViewController *vc = [[VENPersonalMaterialDetailPageViewController alloc] init];
    vc.source_id = model.id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  80 + 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, kMainScreenWidth - 40, 48)];
    addButton.backgroundColor = UIColorFromRGB(0xFFDE02);
    [addButton setTitle:@"添加个人素材" forState:UIControlStateNormal];
    [addButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addButton];
    
    ViewRadius(addButton, 24.0f);
    
    return headerView;
}

- (void)addButtonClick {
    VENMaterialPageAddPersonalMaterialViewController *vc = [[VENMaterialPageAddPersonalMaterialViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30 + 48 + 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - 40 - kTabBarHeight) style:UITableViewStyleGrouped]; 
    tableView.backgroundColor = UIColorMake(245, 245, 245);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"VENHomePageTableViewCellTwo" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadPersonalMaterialAudioPageData:@"1"];
    }];
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadPersonalMaterialAudioPageData:[NSString stringWithFormat:@"%ld", ++self.page]];
    }];
    
    _tableView = tableView;
}

#pragma mark - NSNotificationCenter
- (void)refreshPersonalMaterialAudioPage {
    [self.tableView.mj_header beginRefreshing];
}

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
