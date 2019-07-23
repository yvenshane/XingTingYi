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

@interface VENHomePageViewController ()

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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // nav 黑线
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xFFDE02);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 8, 84, 28)];
    imageView.image = [UIImage imageNamed:@"icon_logo"];
    [self.navigationController.navigationBar addSubview:imageView];
    
    
    self.view.autoresizesSubviews = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VENHomePageTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"VENHomePageTableViewCellTwo" bundle:nil] forCellReuseIdentifier:cellIdentifier2];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//    }];
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        VENHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.iconImageView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        
        return cell;
    } else {
        VENHomePageTableViewCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.iconImageView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        
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
        return headView;
    } else {
        VENHomePageTableViewHeaderView *headView = [[NSBundle mainBundle] loadNibNamed:@"VENHomePageTableViewHeaderView" owner:nil options:nil].lastObject;
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
        [moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
        [moreButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        moreButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
