//
//  VENMinePageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/7/15.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMinePageViewController.h"
#import "VENMinePageTableViewCell.h"
#import "VENMinePageTableHeaderView.h"
#import "VENSettingViewController.h"
#import "VENMyOtherViewController.h"

@interface VENMinePageViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray *cellArr;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMinePageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"VENMinePageTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //
    //    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMinePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.iconImageView.image = [UIImage imageNamed:self.cellArr[indexPath.row][@"icon"]];
    cell.titleLabel.text = self.cellArr[indexPath.row][@"title"];
    cell.descriptionLabel.hidden = indexPath.row == 5 ? NO : YES;
    
    NSString *str = @"11";
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"会员剩余天数%@天", str]];
    [mutableAttributedString setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(6, str.length)];
    
    cell.descriptionLabel.attributedText = mutableAttributedString;
    cell.iconImageViewCenterYLayoutConstraint.constant = indexPath.row == 0 ? -7 : 0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 4) {
        
    } else if (indexPath.row == 5) {
        
    } else if (indexPath.row == 6) {
        
    } else {
        VENMyOtherViewController *vc = [[VENMyOtherViewController alloc] init];
        
        if (indexPath.row == 0) {
            vc.navigationItem.title = @"我的听写";
        } else if (indexPath.row == 1) {
            vc.navigationItem.title = @"我的朗读";
        } else if (indexPath.row == 2) {
            vc.navigationItem.title = @"我的翻译";
        } else {
            vc.navigationItem.title = @"我的字幕";
        }
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? 40 : 54;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VENMinePageTableHeaderView *headerView = [[VENMinePageTableHeaderView alloc] init];
    [headerView.setttingButton addTarget:self action:@selector(setttingButton) forControlEvents:UIControlEventTouchUpInside];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 190;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)setttingButton {
    VENSettingViewController *vc = [[VENSettingViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray *)cellArr {
    if (!_cellArr) {
        _cellArr = @[@{@"icon" : @"icon_mine_01", @"title" : @"我的听写"},
                     @{@"icon" : @"icon_mine_02", @"title" : @"我的朗读"},
                     @{@"icon" : @"icon_mine_03", @"title" : @"我的翻译"},
                     @{@"icon" : @"icon_mine_04", @"title" : @"我的字幕"},
                     @{@"icon" : @"icon_mine_05", @"title" : @"我的生词本"},
                     @{@"icon" : @"icon_mine_06", @"title" : @"会员中心"},
                     @{@"icon" : @"icon_mine_07", @"title" : @"我的动态"}];
    }
    return _cellArr;
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
