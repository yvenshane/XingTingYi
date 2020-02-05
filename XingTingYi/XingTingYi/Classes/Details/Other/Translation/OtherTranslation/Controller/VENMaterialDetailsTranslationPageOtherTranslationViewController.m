//
//  VENMaterialDetailsTranslationPageOtherTranslationViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/16.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsTranslationPageOtherTranslationViewController.h"
#import "VENMaterialDetailsTranslationPageOtherTranslationTableViewCell.h"
#import "VENMaterialDetailsTranslationPageOtherTranslationModel.h"

@interface VENMaterialDetailsTranslationPageOtherTranslationViewController ()
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataSourceMuArr;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMaterialDetailsTranslationPageOtherTranslationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"他人的翻译";
    
    [self setupTableView];
    
    [self loadOtherTranslationDataWithPage:@"1"];
}

- (void)loadOtherTranslationDataWithPage:(NSString *)page {
    NSString *url = @"";
    if (self.isExcellentCourse) {
        url = @"goodCourse/myCourseOtherTranslation";
    } else {
        url = @"source/otherTranslation";
    }
    
    NSDictionary *parameters = @{@"source_period_id" : self.source_period_id,
                                 @"page" : page};
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:url parameters:parameters successBlock:^(id responseObject) {
        
        if ([page integerValue] == 1) {
            [self.tableView.mj_header endRefreshing];

            self.dataSourceMuArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[VENMaterialDetailsTranslationPageOtherTranslationModel class] json:responseObject[@"content"][@"otherTranslation"]]];

            self.page = 1;
        } else {
            [self.tableView.mj_footer endRefreshing];

            [self.dataSourceMuArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VENMaterialDetailsTranslationPageOtherTranslationModel class] json:responseObject[@"content"][@"otherTranslation"]]];
        }
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMaterialDetailsTranslationPageOtherTranslationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENMaterialDetailsTranslationPageOtherTranslationModel *model = self.dataSourceMuArr[indexPath.row];
    
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    cell.avatarImageView.layer.cornerRadius = 15.0f;
    cell.avatarImageView.layer.masksToBounds = YES;
    cell.nameLabel.text = model.nickname;
    cell.timeLabel.text = model.created_at;
    cell.contentLabel.text = model.content;
    [cell.likeButton setTitle:[NSString stringWithFormat:@" %@", model.praiseNum] forState:UIControlStateNormal];
    cell.likeButton.selected = [model.is_praise isEqualToString:@"2"] ? YES : NO;
    cell.likeButton.tag = indexPath.row;
    [cell.likeButton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
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
    [self.tableView registerNib:[UINib nibWithNibName:@"VENMaterialDetailsTranslationPageOtherTranslationTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadOtherTranslationDataWithPage:@"1"];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadOtherTranslationDataWithPage:[NSString stringWithFormat:@"%ld", ++self.page]];
    }];
}

- (void)likeButtonClick:(UIButton *)button {
    VENMaterialDetailsTranslationPageOtherTranslationModel *model = self.dataSourceMuArr[button.tag];
    
    NSString *url = @"";
    if (self.isExcellentCourse) {
        url = @"goodCourse/myCourseOtherTranslationPraise";
    } else {
        url = @"source/otherTranslationPraise";
    }
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:url parameters:@{@"id" : model.id} successBlock:^(id responseObject) {
        
        if (button.selected) {
            button.selected = NO;
            [button setTitle:[NSString stringWithFormat:@" %ld", [button.titleLabel.text integerValue] - 1] forState:UIControlStateNormal];
        } else {
            button.selected = YES;
            [button setTitle:[NSString stringWithFormat:@" %ld", [button.titleLabel.text integerValue] + 1] forState:UIControlStateNormal];
        }
        
    } failureBlock:^(NSError *error) {
        
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
