//
//  VENMinePageMyNewWordBookSearchPageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/30.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMinePageMyNewWordBookSearchPageViewController.h"
#import "VENMinePageMyNewWordBookSearchPageTableViewCell.h"
#import "VENMinePageMyNewWordBookSearchPageModel.h"
#import "VENChooseCategoryView.h"
#import "VENMinePageMyNewWordBookDetailsPageViewController.h"

@interface VENMinePageMyNewWordBookSearchPageViewController ()
@property (nonatomic, strong) UITextField *inputTextField;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataSourceMuArr;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMinePageMyNewWordBookSearchPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationView];
    [self setupTableView];
}

- (void)loadSearchPageDataWithPage:(NSString *)page {
    NSDictionary *parameters = @{@"name" : self.inputTextField.text,
                                 @"page" : page};
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"user/searchWords" parameters:parameters successBlock:^(id responseObject) {
        
        if ([page integerValue] == 1) {
            [self.tableView.mj_header endRefreshing];

            self.dataSourceMuArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[VENMinePageMyNewWordBookSearchPageModel class] json:responseObject[@"content"][@"wordsList"]]];

            self.page = 1;
        } else {
            [self.tableView.mj_footer endRefreshing];

            [self.dataSourceMuArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[VENMinePageMyNewWordBookSearchPageModel class] json:responseObject[@"content"][@"wordsList"]]];
        }
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMinePageMyNewWordBookSearchPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENMinePageMyNewWordBookSearchPageModel *model = self.dataSourceMuArr[indexPath.row];
    
    cell.model = model;
    cell.addNewWordBookBlock = ^(NSString *str) {
        [self.inputTextField resignFirstResponder];
        
        VENChooseCategoryView *chooseCategoryView = [[VENChooseCategoryView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        __weak typeof(self) weakSelf = self;
        chooseCategoryView.chooseCategoryViewBlock = ^(NSDictionary *dict) {
            
            NSDictionary *parameters = @{@"words_id" : model.id,
                                         @"sort_id" : dict[@"sort_id"]};
            
            [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"user/addOtherWords" parameters:parameters successBlock:^(id responseObject) {
                
                [weakSelf loadSearchPageDataWithPage:@"1"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyNewWordsPage" object:nil];
                
            } failureBlock:^(NSError *error) {
                
            }];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:chooseCategoryView];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 113;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.inputTextField resignFirstResponder];
    
    VENMinePageMyNewWordBookSearchPageModel *model = self.dataSourceMuArr[indexPath.row];
    
    VENMinePageMyNewWordBookDetailsPageViewController *vc = [[VENMinePageMyNewWordBookDetailsPageViewController alloc] init];
    vc.isSearch = YES;
    vc.words_id = model.id;
    vc.myNewWordBookDetailsPageBlock = ^{
        [self loadSearchPageDataWithPage:@"1"];
    };
    [self.navigationController pushViewController:vc animated:YES];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"VENMinePageMyNewWordBookSearchPageTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadSearchPageDataWithPage:@"1"];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadSearchPageDataWithPage:[NSString stringWithFormat:@"%ld", ++self.page]];
    }];
}

- (void)setupNavigationView {
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kMainScreenWidth, 44)];
    self.navigationItem.titleView = navigationView;
    
    UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(3, 7, kMainScreenWidth - 24 - 60, 30)];
    inputTextField.backgroundColor = UIColorFromRGB(0xF4F4F4);
    inputTextField.placeholder = @"请输入生词进行搜索";
    inputTextField.textColor = UIColorFromRGB(0x222222);
    inputTextField.font = [UIFont systemFontOfSize:12.0f];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 12, 12)];
    iconImageView.image = [UIImage imageNamed:@"icon_search02"];
    [leftView addSubview:iconImageView];
    
    inputTextField.leftView = leftView;
    inputTextField.leftViewMode = UITextFieldViewModeAlways;
    inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    inputTextField.layer.cornerRadius = 15.0f;
    inputTextField.layer.masksToBounds = YES;
    
    [inputTextField addTarget:self action:@selector(searchTextFieldEdit:) forControlEvents:UIControlEventEditingChanged];
    [navigationView addSubview:inputTextField];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 60 - 15, 0, 45 + 3, 44)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:cancelButton];
    
    _inputTextField = inputTextField;
}

- (void)searchTextFieldEdit:(UITextField *)textField {
     UITextRange *selectedRange = textField.markedTextRange;
     if (selectedRange == nil || selectedRange.empty) {
         [self loadSearchPageDataWithPage:@"1"];
    }
}

- (void)cancelButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
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
