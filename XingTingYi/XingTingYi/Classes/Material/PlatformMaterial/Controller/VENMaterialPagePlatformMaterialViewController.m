//
//  VENMaterialPagePlatformMaterialViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/7/31.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialPagePlatformMaterialViewController.h"
#import "VENHomePageTableViewCellTwo.h"

@interface VENMaterialPagePlatformMaterialViewController () <UITableViewDelegate, UITableViewDataSource>

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMaterialPagePlatformMaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupSelectorView];
    [self setupTableView];
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
    
    //    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //
    //    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENHomePageTableViewCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.iconImageView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    cell.tagImageView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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

#pragma mark - SelectorView
- (void)setupSelectorView {
    UIView *selectorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 48)];
    [self.view addSubview:selectorView];
    
    // left button
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth / 2, 47)];
    [selectorView addSubview:leftButton];
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.text = @"素材分类";
    leftLabel.textColor = UIColorFromRGB(0x222222);
    leftLabel.font = [UIFont systemFontOfSize:14.0f];
    CGFloat width = [leftLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 17.0f)].width;
    CGFloat totalWidth = width + 10 + 8;
    leftLabel.frame = CGRectMake(kMainScreenWidth / 2 / 2 - totalWidth / 2, 48 / 2 - 17 / 2, width, 17);
    [selectorView addSubview:leftLabel];
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 / 2 - totalWidth / 2 + width + 10, 48 / 2 - 6 / 2, 8, 6)];
    leftImageView.image = [UIImage imageNamed:@"icon_down"];
    [selectorView addSubview:leftImageView];
    
    // right button
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2, 0, kMainScreenWidth / 2, 47)];
    [selectorView addSubview:rightButton];
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.text = @"素材格式";
    rightLabel.textColor = UIColorFromRGB(0x222222);
    rightLabel.font = [UIFont systemFontOfSize:14.0f];
    CGFloat width2 = [rightLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 17.0f)].width;
    CGFloat totalWidth2 = width2 + 10 + 8;
    rightLabel.frame = CGRectMake(kMainScreenWidth / 2 / 2 - totalWidth2 / 2 + kMainScreenWidth / 2, 48 / 2 - 17 / 2, width2, 17);
    [selectorView addSubview:rightLabel];
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 / 2 - totalWidth2 / 2 + width2 + 10 + kMainScreenWidth / 2, 48 / 2 - 6 / 2, 8, 6)];
    rightImageView.image = [UIImage imageNamed:@"icon_down"];
    [selectorView addSubview:rightImageView];
    
    // bottom line
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 47, kMainScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xF1F1F1);
    [selectorView addSubview:lineView];
    
    // middle line
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2 - 0.5, 48 / 2 - 14 / 2, 1, 14)];
    lineView2.backgroundColor = UIColorFromRGB(0xF1F1F1);
    [selectorView addSubview:lineView2];
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
