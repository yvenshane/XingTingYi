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
@property (nonatomic, strong) VENMaterialDetailsTranslationPageSearchWordAddNewWordsTableHeaderView *headerView;

@property (nonatomic, copy) NSString *sort_id;
@property (nonatomic, copy) NSString *sort_name;

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
    
    headerView.categoryLabel.text = [VENEmptyClass isEmptyString:self.sort_name] ? @"请选择" : self.sort_name;
    
    if ([headerView.categoryLabel.text isEqualToString:@"请选择"]) {
        headerView.categoryLabel.textColor = UIColorFromRGB(0xB2B2B2);
    } else {
        headerView.categoryLabel.textColor = UIColorFromRGB(0x222222);
    }
    
    _headerView = headerView;
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 487;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    
    if (self.isEdit) {
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 25, kMainScreenWidth - 40, 48)];
        deleteButton.backgroundColor = [UIColor whiteColor];
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [deleteButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        deleteButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        deleteButton.layer.cornerRadius = 24.0f;
        deleteButton.layer.masksToBounds = YES;
        deleteButton.layer.borderWidth = 1.0f;
        deleteButton.layer.borderColor = UIColorFromRGB(0x222222).CGColor;
        [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:deleteButton];
        
        UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 25, kMainScreenWidth - 40, 48)];
        saveButton.backgroundColor = UIColorFromRGB(0xFFDE02);
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [saveButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        saveButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        saveButton.layer.cornerRadius = 24.0f;
        saveButton.layer.masksToBounds = YES;
        [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:saveButton];
    } else {
        UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 25, kMainScreenWidth - 40, 48)];
        commitButton.backgroundColor = UIColorFromRGB(0xFFDE02);
        [commitButton setTitle:@"提交" forState:UIControlStateNormal];
        [commitButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        commitButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        commitButton.layer.cornerRadius = 24.0f;
        commitButton.layer.masksToBounds = YES;
        [commitButton addTarget:self action:@selector(commitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:commitButton];
    }
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 25 + 48;
}

#pragma mark - 选择分类
- (void)categoryButtonClick {    
    VENChooseCategoryView *chooseCategoryView = [[VENChooseCategoryView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight)];
    chooseCategoryView.chooseCategoryViewBlock = ^(NSDictionary *dict) {
        self.sort_id = dict[@"sort_id"];
        self.sort_name = dict[@"sort_name"];
        
        [self.tableView reloadData];
    };
    [self.view addSubview:chooseCategoryView];
}

#pragma mark - 删除/保存/提交
- (void)deleteButtonClick {
    
}

- (void)saveButtonClick {
    
}

- (void)commitButtonClick {
    NSDictionary *parameters = @{@"source_id" : self.source_id,
                                 @"words_id" : @"0",
                                 @"name" : self.keyword,
                                 @"sort_id" : self.sort_id,
                                 @"paraphrase" : self.translation,
                                 @"sentences" : self.headerView.textViewOne.text,
                                 @"associate" : self.headerView.textViewTwo.text};
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"source/subWords" parameters:parameters successBlock:^(id responseObject) {
        
    } failureBlock:^(NSError *error) {
        
    }];
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
