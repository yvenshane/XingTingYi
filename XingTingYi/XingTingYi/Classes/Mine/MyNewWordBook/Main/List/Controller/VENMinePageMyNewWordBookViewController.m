//
//  VENMinePageMyNewWordBookViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/11.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMinePageMyNewWordBookViewController.h"
#import "VENChooseCategoryViewTwo.h"
#import "VENMinePageMyNewWordBookTableViewCell.h"
#import "VENMinePageMyNewWordBookModel.h"
#import "VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController.h"
#import "VENMinePageMyNewWordBookDetailsPageViewController.h"
#import "VENMinePageMyNewWordBookSearchPageViewController.h"

@interface VENMinePageMyNewWordBookViewController ()
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataSourceMuArr;

@property (nonatomic, strong) VENChooseCategoryViewTwo *chooseCategoryView;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *sort_id;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMinePageMyNewWordBookViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // nav 黑线
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.origin isEqualToString:@"PersonalCenter"]) {
        self.navigationItem.title = @"我的生词本";
        [self setupRightButtons];
    } else {
        self.navigationItem.title = @"添加生词";
    }
    
    [self setupTableView];
    [self setupBottomBar];
    
    [self.tableView.mj_header beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMyNewWordsPage) name:@"RefreshMyNewWordsPage" object:nil];
}

- (void)loadMinePageMyNewWordBookDataWithPage:(NSString *)page {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *url = @"";
    
    if ([self.origin isEqualToString:@"PersonalCenter"]) {
        [parameters setObject:page forKey:@"page"];
        if (![VENEmptyClass isEmptyString:self.pid]) {
            [parameters setObject:self.pid forKey:@"pid"];
        }
        if (![VENEmptyClass isEmptyString:self.sort_id]) {
            [parameters setObject:self.sort_id forKey:@"sort_id"];
        }
        
        url = @"user/myWordsList";
    } else {
        [parameters setObject:page forKey:@"page"];
        [parameters setObject:self.source_id forKey:@"source_id"];
        
        if (self.isPersonalMaterial) {
            url = @"userSource/userSourceWordList";
        } else {
            url = @"source/sourceWordList";
        }
    }
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:url parameters:parameters successBlock:^(id responseObject) {
        
        if ([page integerValue] == 1) {
            [self.tableView.mj_header endRefreshing];
            
            self.dataSourceMuArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[VENMinePageMyNewWordBookModel class] json:responseObject[@"content"][@"wordsList"]]];
            
            self.page = 1;
        } else {
            [self.tableView.mj_footer endRefreshing];
            
            [self.dataSourceMuArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VENMinePageMyNewWordBookModel class] json:responseObject[@"content"][@"wordsList"]]];
        }
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMinePageMyNewWordBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENMinePageMyNewWordBookModel *model = self.dataSourceMuArr[indexPath.row];
    
    cell.titleLabel.text = model.name;
    cell.titleLabel2.text = model.pronunciation_words;
    cell.discriptionLabel.text = model.paraphrase;
    
    if ([self.origin isEqualToString:@"PersonalCenter"]) {
        cell.editImageView.hidden = YES;
        cell.titleLabel2RightLayoutConstraint.constant = 20.0f;
        cell.discriptionLabelRightLayoutConstraint.constant = 20.0f;
    } else {
        cell.editImageView.hidden = NO;
        cell.titleLabel2RightLayoutConstraint.constant = 52.0f;
        cell.discriptionLabelRightLayoutConstraint.constant = 52.0f;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.origin isEqualToString:@"PersonalCenter"]) {
        VENMinePageMyNewWordBookModel *model = self.dataSourceMuArr[indexPath.row];
        
        VENMinePageMyNewWordBookDetailsPageViewController *vc = [[VENMinePageMyNewWordBookDetailsPageViewController alloc] init];
        vc.words_id = model.id;
        vc.indexPathRow = indexPath.row;
        vc.dataSourceArr = self.dataSourceMuArr;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        VENMinePageMyNewWordBookModel *model = self.dataSourceMuArr[indexPath.row];
        
        VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController *vc = [[VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController alloc] init];
        vc.isPersonalMaterial = self.isPersonalMaterial;
        vc.isEdit = YES;
        vc.words_id = model.id;
        vc.source_id = self.source_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 86;
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
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - (kTabBarHeight - 49) - kStatusBarAndNavigationBarHeight - 48);
    [self.tableView registerNib:[UINib nibWithNibName:@"VENMinePageMyNewWordBookTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadMinePageMyNewWordBookDataWithPage:@"1"];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMinePageMyNewWordBookDataWithPage:[NSString stringWithFormat:@"%ld", ++self.page]];
    }];
}

- (void)setupBottomBar {
    UIView *bottomBarView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - kStatusBarAndNavigationBarHeight - 48 - (kTabBarHeight - 49), kMainScreenWidth, 48)];
    [self.view addSubview:bottomBarView];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 48)];
    addButton.backgroundColor = UIColorFromRGB(0xFFDE02);
    [addButton setTitle:@"添加生词" forState:UIControlStateNormal];
    [addButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomBarView addSubview:addButton];
}

- (void)addButtonClick {
    VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController *vc = [[VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController alloc] init];
    vc.origin = self.origin;
    vc.source_id = self.source_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshMyNewWordsPage {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - right buttons
- (void)setupRightButtons {
    UIButton *categoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 44)];
    [categoryButton setImage:[UIImage imageNamed:@"icon_mine_sx"] forState:UIControlStateNormal];
    [categoryButton addTarget:self action:@selector(categoryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:categoryButton];
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 44)];
    [searchButton setImage:[UIImage imageNamed:@"icon_mine_search"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    self.navigationItem.rightBarButtonItems = @[barButtonItem, barButtonItem2];
}

#pragma mark - 搜索
- (void)searchButtonClick {
    VENMinePageMyNewWordBookSearchPageViewController *vc = [[VENMinePageMyNewWordBookSearchPageViewController alloc] init];
    VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 分类
- (void)categoryButtonClick {
    if (_chooseCategoryView) {
        [self.chooseCategoryView removeFromSuperview];
//        self.chooseCategoryView = nil;
    }
    
    __weak typeof(self) weakSelf = self;
    self.chooseCategoryView.chooseCategoryViewTwoBlock = ^(NSDictionary *dict) {
        weakSelf.pid = dict[@"pid"];
        weakSelf.sort_id = dict[@"sort_id"];
        
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self.view addSubview:self.chooseCategoryView];
}

- (VENChooseCategoryViewTwo *)chooseCategoryView {
    if (!_chooseCategoryView) {
        _chooseCategoryView = [[VENChooseCategoryViewTwo alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight)];
    }
    return _chooseCategoryView;
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
