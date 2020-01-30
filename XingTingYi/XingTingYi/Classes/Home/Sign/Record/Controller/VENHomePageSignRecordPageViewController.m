//
//  VENHomePageSignRecordPageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2020/1/30.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageSignRecordPageViewController.h"
#import "VENHomePageSignRecordPageModel.h"
#import "VENHomePageSignRecordPageTableViewCell.h"

@interface VENHomePageSignRecordPageViewController ()
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataSourceMuArr;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENHomePageSignRecordPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"打卡记录";
    
    [self setupTableView];
       
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadHomePageSignRecordPageDataWith:(NSString *)page {
    
    NSDictionary *parameters = @{@"apge" : page,
                                 @"learn_time" : self.date};
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"user/learnLog" parameters:parameters successBlock:^(id responseObject) {
        
        if ([page integerValue] == 1) {
            [self.tableView.mj_header endRefreshing];

            self.dataSourceMuArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[VENHomePageSignRecordPageModel class] json:responseObject[@"content"][@"learnLogList"]]];

            self.page = 1;
        } else {
            [self.tableView.mj_footer endRefreshing];

            [self.dataSourceMuArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VENHomePageSignRecordPageModel class] json:responseObject[@"content"][@"learnLogList"]]];
        }
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENHomePageSignRecordPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENHomePageSignRecordPageModel *model = self.dataSourceMuArr[indexPath.row];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"今天我在猩听译平台听写了%@分钟", model.days];
    cell.contentLabel.text = [NSString stringWithFormat:@"我已经听写了%@篇文章，制作了%@个字幕，朗读了%@篇文章，翻译了%@篇文章，添加了%@个生词", model.dictationNum, model.subtitles, model.readNum, model.translationNum, model.wordsNum];
    cell.dateLabel.text = model.created_at;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125;
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
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - (kTabBarHeight - 49));
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"VENHomePageSignRecordPageTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadHomePageSignRecordPageDataWith:@"1"];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadHomePageSignRecordPageDataWith:[NSString stringWithFormat:@"%ld", ++self.page]];
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
