//
//  VENSettingModifyPasswordViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/8/13.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENSettingModifyPasswordViewController.h"
#import "VENSettingTableViewCell.h"

@interface VENSettingModifyPasswordViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, copy) NSArray *placeholderArr;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENSettingModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"修改密码";

    [self setupTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.rightImageView.hidden = YES;
    cell.titleLabel.text = self.titleArr[indexPath.row];
    cell.descriptionTextField.placeholder = self.placeholderArr[indexPath.row];
    cell.descriptionTextField.textColor = UIColorFromRGB(0x222222);
    cell.descriptionTextField.secureTextEntry = YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 10 : 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 26, kMainScreenWidth - 40, 48)];
    confirmButton.backgroundColor = UIColorFromRGB(0xFFDE02);
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:confirmButton];
    ViewRadius(confirmButton, 24.0f);
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 48 + 26;
}

- (void)confirmButtonClick {
    
    VENSettingTableViewCell *cell = (VENSettingTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    VENSettingTableViewCell *cell2 = (VENSettingTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    VENSettingTableViewCell *cell3 = (VENSettingTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    NSDictionary *parameters = @{@"password" : cell.descriptionTextField.text,
                                 @"newPwd" : cell2.descriptionTextField.text,
                                 @"reNewPwd" : cell3.descriptionTextField.text};
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"user/modifyPwd" parameters:parameters successBlock:^(id responseObject) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)setupTableView {
    self.tableView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    [self.tableView registerNib:[UINib nibWithNibName:@"VENSettingTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"原密码", @"新密码", @"重复密码"];
    }
    return _titleArr;
}

- (NSArray *)placeholderArr {
    if (!_placeholderArr) {
        _placeholderArr = @[@"请输入原密码", @"请输入新密码", @"请重复输入新密码"];
    }
    return _placeholderArr;
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
