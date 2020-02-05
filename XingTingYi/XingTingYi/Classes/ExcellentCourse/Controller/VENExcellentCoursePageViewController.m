//
//  VENExcellentCoursePageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2020/2/4.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENExcellentCoursePageViewController.h"
#import "VENExcellentCoursePageTableViewCell.h"
#import "VENMaterialSortSelectorView.h"
#import "VENExcellentCoursePageModel.h"
#import "VENExcellentCourseDetailsPageViewController.h"

@interface VENExcellentCoursePageViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *middleImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, weak) VENMaterialSortSelectorView *materialSortSelectorView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *sourceCategoryArr;
@property (nonatomic, copy) NSString *category_one_id;
@property (nonatomic, copy) NSString *category_two_id;
@property (nonatomic, copy) NSString *category_three_id;

@property (nonatomic, copy) NSArray *typeListArr;

@property (nonatomic, copy) NSString *orderTime;
@property (nonatomic, copy) NSString *orderNum;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataSourceMuArr;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENExcellentCoursePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"精品课程";
    
    self.category_one_id = @"";
    self.category_two_id = @"";
    self.category_three_id = @"";
    self.orderTime = @"0";
    self.orderNum = @"0";
    
    [self setupCategoryView];
    [self setupTableView];
    
    [self loadMaterialSortSelectorData];
    [self loadExcellentCoursePageData:@"1"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter:) name:@"ExcellentCourseSortSelectorView" object:nil];
}

#pragma mark - 素材分类数据
- (void)loadMaterialSortSelectorData {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypeGET urlString:@"source/sourceCategory" parameters:nil successBlock:^(id responseObject) {
        
        self.sourceCategoryArr = responseObject[@"content"][@"sourceCategory"];
        self.typeListArr = responseObject[@"content"][@"typeList"];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 平台素材列表数据
- (void)loadExcellentCoursePageData:(NSString *)page {
    NSDictionary *parameters = @{@"page" : page,
                                 @"category_one_id" : self.category_one_id,
                                 @"category_two_id" : self.category_two_id,
                                 @"category_three_id" : self.category_three_id,
                                 @"orderTime" : self.orderTime,
                                 @"orderNum" : self.orderNum};

    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"goodCourse/goodCourseList" parameters:parameters successBlock:^(id responseObject) {

        if ([page integerValue] == 1) {
            [self.tableView.mj_header endRefreshing];

            self.dataSourceMuArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[VENExcellentCoursePageModel class] json:responseObject[@"content"][@"goodCourseList"]]];

            self.page = 1;
        } else {
            [self.tableView.mj_footer endRefreshing];

            [self.dataSourceMuArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VENExcellentCoursePageModel class] json:responseObject[@"content"][@"goodCourseList"]]];
        }

        [self.tableView reloadData];

    } failureBlock:^(NSError *error) {

    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENExcellentCoursePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENExcellentCoursePageModel *model = self.dataSourceMuArr[indexPath.row];
    
    cell.iconImageView.contentMode = UIViewContentModeScaleToFill;
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    cell.titleLabel.text = model.title;
    cell.dateLabel.text = [NSString stringWithFormat:@"%@已更新", model.updated_at];
    cell.numberLabel.text = [NSString stringWithFormat:@"%@人已购买", model.buynum];
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.price];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VENExcellentCoursePageModel *model = self.dataSourceMuArr[indexPath.row];
    
    VENExcellentCourseDetailsPageViewController *vc = [[VENExcellentCourseDetailsPageViewController alloc] init];
    vc.id = model.id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark - TableView
- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 48, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - 48 - kTabBarHeight) style:UITableViewStyleGrouped];
    tableView.backgroundColor = UIColorMake(245, 245, 245);
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"VENExcellentCoursePageTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadExcellentCoursePageData:@"1"];
    }];
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadExcellentCoursePageData:[NSString stringWithFormat:@"%ld", ++self.page]];
    }];
    
    _tableView = tableView;
}

#pragma mark - CategoryView
- (void)setupCategoryView {
    UIView *categoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 48)];
    categoryView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:categoryView];
    categoryView.layer.zPosition = 3;
    
    // left button
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth / 3, 47)];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [categoryView addSubview:leftButton];
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.text = @"课程分类";
    leftLabel.textColor = UIColorFromRGB(0x222222);
    leftLabel.font = [UIFont systemFontOfSize:14.0f];
    CGFloat width = [leftLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 17.0f)].width;
    CGFloat totalWidth = width + 10 + 8;
    leftLabel.frame = CGRectMake(kMainScreenWidth / 3 / 2 - totalWidth / 2, 48 / 2 - 17 / 2, width, 17);
    [categoryView addSubview:leftLabel];
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3 / 2 - totalWidth / 2 + width + 10, 48 / 2 - 6 / 2, 8, 6)];
    leftImageView.image = [UIImage imageNamed:@"icon_down"];
    [categoryView addSubview:leftImageView];
    
    // middle
    UIButton *middleButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3, 0, kMainScreenWidth / 3, 47)];
    [middleButton addTarget:self action:@selector(middleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [categoryView addSubview:middleButton];
    
    UILabel *middleLabel = [[UILabel alloc] init];
    middleLabel.text = @"更新时间";
    middleLabel.textColor = UIColorFromRGB(0x222222);
    middleLabel.font = [UIFont systemFontOfSize:14.0f];
    CGFloat width2 = [leftLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 17.0f)].width;
    CGFloat totalWidth2 = width2 + 10 + 8;
    middleLabel.frame = CGRectMake(kMainScreenWidth / 3 / 2 - totalWidth2 / 2 + kMainScreenWidth / 3, 48 / 2 - 17 / 2, width2, 17);
    [categoryView addSubview:middleLabel];
    
    UIImageView *middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3 / 2 - totalWidth2 / 2 + width2 + 10 + kMainScreenWidth / 3, 48 / 2 - 6 / 2, 8, 6)];
    middleImageView.image = [UIImage imageNamed:@"icon_down"];
    [categoryView addSubview:middleImageView];
    
    // right button
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3 * 2, 0, kMainScreenWidth / 3, 47)];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [categoryView addSubview:rightButton];
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.text = @"购买人数";
    rightLabel.textColor = UIColorFromRGB(0x222222);
    rightLabel.font = [UIFont systemFontOfSize:14.0f];
    CGFloat width3 = [rightLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 17.0f)].width;
    CGFloat totalWidth3 = width3 + 10 + 8;
    rightLabel.frame = CGRectMake(kMainScreenWidth / 3 / 2 - totalWidth3 / 2 + kMainScreenWidth / 3 * 2, 48 / 2 - 17 / 2, width3, 17);
    [categoryView addSubview:rightLabel];
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3 / 2 - totalWidth3 / 2 + width3 + 10 + kMainScreenWidth / 3 * 2, 48 / 2 - 6 / 2, 8, 6)];
    rightImageView.image = [UIImage imageNamed:@"icon_down"];
    [categoryView addSubview:rightImageView];
    
    // bottom line
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 47, kMainScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xF1F1F1);
    [categoryView addSubview:lineView];
    
    // middle line
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3 - 0.5, 48 / 2 - 14 / 2, 1, 14)];
    lineView2.backgroundColor = UIColorFromRGB(0xF1F1F1);
    [categoryView addSubview:lineView2];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3 * 2 - 0.5, 48 / 2 - 14 / 2, 1, 14)];
    lineView3.backgroundColor = UIColorFromRGB(0xF1F1F1);
    [categoryView addSubview:lineView3];
    
    _leftImageView = leftImageView;
    _middleImageView = middleImageView;
    _rightImageView = rightImageView;
}

#pragma mark - 课程分类
- (void)leftButtonClick:(UIButton *)button {
    if (!self.materialSortSelectorView) {
        VENMaterialSortSelectorView *materialSortSelectorView = [[VENMaterialSortSelectorView alloc] initWithFrame:CGRectMake(0, 48, kMainScreenWidth, kMainScreenHeight)];
        materialSortSelectorView.isExcellentCourse = YES;
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
            
            [self loadExcellentCoursePageData:@"1"];
        };
        
        [self.view addSubview:materialSortSelectorView];
        
        _materialSortSelectorView = materialSortSelectorView;
    } else {
        [self.materialSortSelectorView hidden];
    }
}

#pragma mark - 更新时间
- (void)middleButtonClick:(UIButton *)button {
    if (button.selected) {
        button.selected = NO;
        self.middleImageView.image = [UIImage imageNamed:@"icon_down"];
        self.orderTime = @"1";
    } else {
        button.selected = YES;
        self.middleImageView.image = [UIImage imageNamed:@"icon_up"];
        self.orderTime = @"2";
    }
    [self loadExcellentCoursePageData:@"1"];
}

#pragma mark - 购买人数
- (void)rightButtonClick:(UIButton *)button {
    if (button.selected) {
        button.selected = NO;
        self.rightImageView.image = [UIImage imageNamed:@"icon_down"];
        self.orderNum = @"1";
    } else {
        button.selected = YES;
        self.rightImageView.image = [UIImage imageNamed:@"icon_up"];
        self.orderNum = @"2";
    }
    [self loadExcellentCoursePageData:@"1"];
}

- (void)notificationCenter:(NSNotification *)noti {
    if ([noti.userInfo[@"type"] isEqualToString:@"show"]) {
        self.leftImageView.image = [UIImage imageNamed:@"icon_up"];
    } else {
        self.leftImageView.image = [UIImage imageNamed:@"icon_down"];
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

@end
