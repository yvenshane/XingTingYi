//
//  VENHomePageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/7/15.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageViewController.h"
#import "VENHomePageTableViewCell.h"
#import "VENHomePageTableViewCellTwo.h"
#import "VENHomePageTableViewHeaderView.h"
#import "VENHomePageTableViewHeaderViewTwo.h"
#import "VENHomePageNewsViewController.h"
#import "VENHomePageRecommendMaterialViewController.h"
#import "VENHomePageModel.h"
#import "VENBaseWebViewController.h"

@interface VENHomePageViewController ()
@property (nonatomic, strong) VENHomePageModel *model;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
static NSString *const cellIdentifier2 = @"cellIdentifier2";
static NSString *const cellIdentifier3 = @"cellIdentifier3";
@implementation VENHomePageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // nav 黑线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xFFDE02);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // nav 黑线
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.autoresizesSubviews = YES;
    
    // logo
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 44)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 84, 28)];
    imageView.image = [UIImage imageNamed:@"icon_logo"];
    [titleView addSubview:imageView];
    self.navigationItem.titleView = titleView;
    
    [self setupTableView];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadHomePageData {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypeGET urlString:@"base/homePage" parameters:nil successBlock:^(id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        
        self.model = [VENHomePageModel yy_modelWithJSON:responseObject[@"content"]];
        
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.model.introduce.count;
    } else if (section == 1) {
        return self.model.news.count;
    } else {
        
        return self.model.source.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        VENHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = [VENHomePageModel yy_modelWithJSON:self.model.introduce[indexPath.row]];

        return cell;
    } else {
        VENHomePageTableViewCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == 1) {
            cell.model = [VENHomePageModel yy_modelWithJSON:self.model.news[indexPath.row]];
        } else {
            cell.model = [VENHomePageModel yy_modelWithJSON:self.model.source[indexPath.row]];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat aspectRatio = 315.0 / 157.0;
        return (kMainScreenWidth - 60) / aspectRatio + 30 + 20 + 25 + 10 + 36;
    } else {
        return  80 + 30;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        VENHomePageTableViewHeaderViewTwo *headView = [[VENHomePageTableViewHeaderViewTwo alloc] init];
        headView.model = self.model;
        headView.moreButtonClickBlock = ^(NSString *str) {
            VENBaseWebViewController *vc = [[VENBaseWebViewController alloc] init];
            vc.HTMLString = self.model.aboutUs[0][@"content"];
            vc.navigationItemTitle = @"关于我们";
            [self presentViewController:vc animated:YES completion:nil];
        };
        
        return headView;
    } else {
        VENHomePageTableViewHeaderView *headView = [[NSBundle mainBundle] loadNibNamed:@"VENHomePageTableViewHeaderView" owner:nil options:nil].lastObject;
        
        if (section == 1) {
            headView.titleLabel.text = @"新闻资讯";
        } else {
            headView.titleLabel.text = @"推荐素材";
        }
        
        return headView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10 + kMainScreenHeight / (667.0 / 170.0) + 30 + 25 + 20 + 60 + 20 + 40 + 40 + 25;
    } else {
        return 80;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor whiteColor];
    
    if (section != 0) {
        UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 15, kMainScreenWidth - 40, 40)];
        moreButton.backgroundColor = UIColorFromRGB(0xF8F8F8);
        moreButton.tag = section;
        [moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
        [moreButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        moreButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:moreButton];
    }
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    } else if (section == 1) {
        return 55;
    } else {
        return 55 + 40;
    }
}

- (void)setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"VENHomePageTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"VENHomePageTableViewCellTwo" bundle:nil] forCellReuseIdentifier:cellIdentifier2];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadHomePageData];
    }];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - 查看更多
- (void)moreButtonClick:(UIButton *)button {
    if (button.tag == 1) {
        VENHomePageNewsViewController *vc = [[VENHomePageNewsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        VENHomePageRecommendMaterialViewController *vc = [[VENHomePageRecommendMaterialViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
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
