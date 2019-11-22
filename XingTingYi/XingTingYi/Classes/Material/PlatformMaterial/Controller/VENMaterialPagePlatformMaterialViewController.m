//
//  VENMaterialPagePlatformMaterialViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/7/31.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialPagePlatformMaterialViewController.h"
#import "VENHomePageTableViewCellTwo.h"
#import "VENMaterialSortSelectorView.h"
#import "VENMaterialFormatSelectorView.h"
#import "VENVideoMaterialDetailsPageViewController.h"
#import "VENAudioMaterialDetailsPageViewController.h"
#import "VENHomePageModel.h"

@interface VENMaterialPagePlatformMaterialViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, weak) VENMaterialSortSelectorView *materialSortSelectorView;
@property (nonatomic, weak) VENMaterialFormatSelectorView *materialFormatSelectorView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *sourceCategoryArr;
@property (nonatomic, copy) NSString *category_one_id;
@property (nonatomic, copy) NSString *category_two_id;
@property (nonatomic, copy) NSString *category_three_id;

@property (nonatomic, copy) NSArray *typeListArr;
@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataSourceMuArr;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMaterialPagePlatformMaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter:) name:@"MaterialSortSelectorView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter2:) name:@"VENMaterialFormatSelectorView" object:nil];
    
    self.category_one_id = @"";
    self.category_two_id = @"";
    self.category_three_id = @"";
    self.type = @"";
    
    [self setupCategoryView];
    [self setupTableView];
    
    [self loadMaterialSortSelectorData];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)notificationCenter:(NSNotification *)noti {
    if ([noti.userInfo[@"type"] isEqualToString:@"show"]) {
        self.leftImageView.image = [UIImage imageNamed:@"icon_up"];
    } else {
        self.leftImageView.image = [UIImage imageNamed:@"icon_down"];
    }
}

- (void)notificationCenter2:(NSNotification *)noti {
    if ([noti.userInfo[@"type"] isEqualToString:@"show"]) {
        self.rightImageView.image = [UIImage imageNamed:@"icon_up"];
    } else {
        self.rightImageView.image = [UIImage imageNamed:@"icon_down"];
    }
}

#pragma mark - 素材分类数据
- (void)loadMaterialSortSelectorData {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"source/sourceCategory" parameters:nil successBlock:^(id responseObject) {
        
        self.sourceCategoryArr = responseObject[@"content"][@"sourceCategory"];
        self.typeListArr = responseObject[@"content"][@"typeList"];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 平台素材列表数据
- (void)loadPlatformMaterialPageData:(NSString *)page {
    
    NSDictionary *parameters = @{@"page" : page,
                                 @"type" : self.type,
                                 @"category_one_id" : self.category_one_id,
                                 @"category_two_id" : self.category_two_id,
                                 @"category_three_id" : self.category_three_id};
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"source/sourceList" parameters:parameters successBlock:^(id responseObject) {
        
        if ([page integerValue] == 1) {
            [self.tableView.mj_header endRefreshing];
            
            self.dataSourceMuArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:responseObject[@"content"][@"sourcelist"]]];
            
            self.page = 1;
        } else {
            [self.tableView.mj_footer endRefreshing];
            
            [self.dataSourceMuArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VENHomePageModel class] json:responseObject[@"content"][@"sourcelist"]]];
        }
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {

    }];
}

#pragma mark - TableView
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 48, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - 48 - kTabBarHeight) style:UITableViewStyleGrouped];
    tableView.backgroundColor = UIColorMake(245, 245, 245);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"VENHomePageTableViewCellTwo" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadPlatformMaterialPageData:@"1"];
    }];
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadPlatformMaterialPageData:[NSString stringWithFormat:@"%ld", ++self.page]];
    }];
    
    _tableView = tableView;
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
    
    if ([model.type isEqualToString:@"1"]) { // 音频
        VENAudioMaterialDetailsPageViewController *vc = [[VENAudioMaterialDetailsPageViewController alloc] init];
        vc.id = model.id;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.type isEqualToString:@"2"]) { // 视频
        VENVideoMaterialDetailsPageViewController *vc = [[VENVideoMaterialDetailsPageViewController alloc] init];
        vc.id = model.id;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.type isEqualToString:@"3"]) { // 文本
        
    } else if ([model.type isEqualToString:@"4"]) { // 音频文本
        
    } else { // 视频文本
        
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

#pragma mark - CategoryView
- (void)setupCategoryView {
    UIView *categoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 48)];
    categoryView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:categoryView];
    categoryView.layer.zPosition = 3;
    
    // left button
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth / 2, 47)];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [categoryView addSubview:leftButton];
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.text = @"素材分类";
    leftLabel.textColor = UIColorFromRGB(0x222222);
    leftLabel.font = [UIFont systemFontOfSize:14.0f];
    CGFloat width = [leftLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 17.0f)].width;
    CGFloat totalWidth = width + 10 + 8;
    leftLabel.frame = CGRectMake(kMainScreenWidth / 2 / 2 - totalWidth / 2, 48 / 2 - 17 / 2, width, 17);
    [categoryView addSubview:leftLabel];
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 / 2 - totalWidth / 2 + width + 10, 48 / 2 - 6 / 2, 8, 6)];
    leftImageView.image = [UIImage imageNamed:@"icon_down"];
    [categoryView addSubview:leftImageView];
    
    // right button
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2, 0, kMainScreenWidth / 2, 47)];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [categoryView addSubview:rightButton];
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.text = @"素材格式";
    rightLabel.textColor = UIColorFromRGB(0x222222);
    rightLabel.font = [UIFont systemFontOfSize:14.0f];
    CGFloat width2 = [rightLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 17.0f)].width;
    CGFloat totalWidth2 = width2 + 10 + 8;
    rightLabel.frame = CGRectMake(kMainScreenWidth / 2 / 2 - totalWidth2 / 2 + kMainScreenWidth / 2, 48 / 2 - 17 / 2, width2, 17);
    [categoryView addSubview:rightLabel];
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 / 2 - totalWidth2 / 2 + width2 + 10 + kMainScreenWidth / 2, 48 / 2 - 6 / 2, 8, 6)];
    rightImageView.image = [UIImage imageNamed:@"icon_down"];
    [categoryView addSubview:rightImageView];
    
    // bottom line
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 47, kMainScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xF1F1F1);
    [categoryView addSubview:lineView];
    
    // middle line
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 - 0.5, 48 / 2 - 14 / 2, 1, 14)];
    lineView2.backgroundColor = UIColorFromRGB(0xF1F1F1);
    [categoryView addSubview:lineView2];
    
    _leftImageView = leftImageView;
    _rightImageView = rightImageView;
}

#pragma mark - 素材分类
- (void)leftButtonClick:(UIButton *)button {
    if (self.materialFormatSelectorView) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"VENMaterialFormatSelectorView" object:nil userInfo:@{@"type" : @"hidden"}];
        [self.materialFormatSelectorView hidden];
    }
    
    if (!self.materialSortSelectorView) {
        VENMaterialSortSelectorView *materialSortSelectorView = [[VENMaterialSortSelectorView alloc] initWithFrame:CGRectMake(0, 48, kMainScreenWidth, kMainScreenHeight)];
        materialSortSelectorView.layer.zPosition = 2;
        
        materialSortSelectorView.category_one_id = self.category_one_id;
        materialSortSelectorView.category_two_id = self.category_two_id;
        materialSortSelectorView.category_three_id = self.category_three_id;
        materialSortSelectorView.sourceCategoryArr = self.sourceCategoryArr;
        
        __weak typeof(self) weakSelf = self;
        materialSortSelectorView.didSelectItemBlock = ^(NSDictionary *dict) {
            self.category_one_id = dict[@"category_one_id"];
            self.category_two_id = dict[@"category_two_id"];
            self.category_three_id = dict[@"category_three_id"];
            
            [weakSelf.materialSortSelectorView hidden];
            
            [self loadPlatformMaterialPageData:@"1"];
        };
        
        [self.view addSubview:materialSortSelectorView];
        
        _materialSortSelectorView = materialSortSelectorView;
    } else {
        [self.materialSortSelectorView hidden];
    }
}

#pragma mark - 素材格式
- (void)rightButtonClick:(UIButton *)button {
    if (self.materialSortSelectorView) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MaterialSortSelectorView" object:nil userInfo:@{@"type" : @"hidden"}];
        [self.materialSortSelectorView hidden];
    }
    
    if (!self.materialFormatSelectorView) {
        VENMaterialFormatSelectorView *materialFormatSelectorView = [[VENMaterialFormatSelectorView alloc] initWithFrame:CGRectMake(0, 48, kMainScreenWidth, kMainScreenHeight)];
        materialFormatSelectorView.layer.zPosition = 2;
        
        materialFormatSelectorView.type = self.type;
        materialFormatSelectorView.typeListArr = self.typeListArr;
        
        __weak typeof(self) weakSelf = self;
        materialFormatSelectorView.didSelectRowBlock = ^(NSString *str) {
            self.type = str;
            
            [weakSelf.materialFormatSelectorView hidden];
            
            [self loadPlatformMaterialPageData:@"1"];
        };
        
        [self.view addSubview:materialFormatSelectorView];
        
        _materialFormatSelectorView = materialFormatSelectorView;
    } else {
        [self.materialFormatSelectorView hidden];
    }
}

#pragma mark - dealloc
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
