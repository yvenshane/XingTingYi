//
//  VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/11.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController.h"
#import "VENMaterialDetailsTranslationPageSearchWordAddNewWordsTableHeaderView.h"
#import "VENChooseCategoryView.h"

@interface VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController ()

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"添加生词";
    
    [self setupTableView];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VENMaterialDetailsTranslationPageSearchWordAddNewWordsTableHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"VENMaterialDetailsTranslationPageSearchWordAddNewWordsTableHeaderView" owner:nil options:nil].lastObject;
    headerView.nnewWordsTextField.text = self.keyword;
    headerView.nnewWordsTextField.userInteractionEnabled = NO;
    headerView.translateTextField.text = self.translation;
    headerView.translateTextField.userInteractionEnabled = NO;
    [headerView.categoryButton addTarget:self action:@selector(categoryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 438;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    
    UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 25, kMainScreenWidth - 40, 48)];
    commitButton.backgroundColor = UIColorFromRGB(0xFFDE02);
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    commitButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    commitButton.layer.cornerRadius = 24.0f;
    commitButton.layer.masksToBounds = YES;
    [commitButton addTarget:self action:@selector(commitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:commitButton];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 25 + 48;
}

- (void)categoryButtonClick {    
    VENChooseCategoryView *chooseCategoryView = [[VENChooseCategoryView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    [[UIApplication sharedApplication].keyWindow addSubview:chooseCategoryView];
}

- (void)commitButtonClick {
    
}

- (void)setupTableView {
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - (kTabBarHeight - 49));
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = nil;
    [self.view addSubview:self.tableView];
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
