//
//  VENMaterialDetailsTranslationPageSearchWordViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/10.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsTranslationPageSearchWordViewController.h"
#import "VENMaterialDetailsTranslationPageSearchWordTableViewCell.h"
#import "VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController.h"

@interface VENMaterialDetailsTranslationPageSearchWordViewController ()
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSString *translation;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMaterialDetailsTranslationPageSearchWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"查词";
    
    [self setupTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [VENEmptyClass isEmptyString:self.keyword] ? 0 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMaterialDetailsTranslationPageSearchWordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.text = self.keyword;
    cell.interpretationLabel.text = self.translation;
    
    [cell.addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, kMainScreenWidth - 20 * 2, 60)];
    searchTextField.backgroundColor = UIColorFromRGB(0xF5F5F5);
    searchTextField.font = [UIFont systemFontOfSize:16.0f];
    searchTextField.placeholder = @"请输入要查询的单词";
    searchTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 60)];
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTextField.layer.cornerRadius = 8.0f;
    searchTextField.layer.masksToBounds = YES;
    [searchTextField addTarget:self action:@selector(searchTextFieldEdit:) forControlEvents:UIControlEventEditingChanged];
    [headerView addSubview:searchTextField];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)addButtonClick {
    VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController *vc = [[VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController alloc] init];
    vc.keyword = self.keyword;
    vc.translation = self.translation;
    vc.source_id = self.source_id;
    vc.isExcellentCourse = self.isExcellentCourse;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)searchTextFieldEdit:(UITextField *)textField {
     UITextRange *selectedRange = textField.markedTextRange;
     if (selectedRange == nil || selectedRange.empty) {
         [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"youdao/searchWords" parameters:@{@"content" : textField.text} successBlock:^(id responseObject) {
             self.keyword = textField.text;
             self.translation = responseObject[@"content"][@"translation"];
             
             [self.tableView reloadData];
             
         } failureBlock:^(NSError *error) {
             
         }];
    }
}

- (void)setupTableView {
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - (kTabBarHeight - 49));
    [self.tableView registerNib:[UINib nibWithNibName:@"VENMaterialDetailsTranslationPageSearchWordTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
