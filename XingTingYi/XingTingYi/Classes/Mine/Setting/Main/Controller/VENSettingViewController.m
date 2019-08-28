//
//  VENSettingViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/8/13.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENSettingViewController.h"
#import "VENSettingTableViewCell.h"
#import "VENSettingModifyPasswordViewController.h"
#import "VENSettingPersonalInformationViewController.h"

@interface VENSettingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray *titleArr;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"设置";
    
    self.tableView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    [self.tableView registerNib:[UINib nibWithNibName:@"VENSettingTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //
    //    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 2 : 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.text = self.titleArr[indexPath.section][indexPath.row];
    cell.descriptionTextField.userInteractionEnabled = NO;
    cell.descriptionTextField.textAlignment = NSTextAlignmentRight;
    
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            cell.descriptionTextField.text = [NSString stringWithFormat:@"%ldM", [SDImageCache sharedImageCache].getSize];
            cell.descriptionTextFieldRightLayoutConstraint.constant = 10 + 7 + 20;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            VENSettingPersonalInformationViewController *vc = [[VENSettingPersonalInformationViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            VENSettingModifyPasswordViewController *vc = [[VENSettingModifyPasswordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        if (indexPath.row == 0) {
            
        } else if (indexPath.row == 1) {
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [MBProgressHUD showText:@"清除缓存成功"];
                [self.tableView reloadData];
            }];
        }
    }
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
    if (section == 1) {
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = UIColorFromRGB(0xF8F8F8);
        
        UIButton *signoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, kMainScreenWidth, 54)];
        signoutButton.backgroundColor = [UIColor whiteColor];
        [signoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [signoutButton setTitleColor:UIColorFromRGB(0xEF142D) forState:UIControlStateNormal];
        signoutButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [signoutButton addTarget:self action:@selector(signoutButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:signoutButton];
        
        return footerView;
    } else {
        return [[UIView alloc] init];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0 ? 5 : 54 + 10;
}

- (void)signoutButtonClick {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"您确定要退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleDestructive handler:nil];
    UIAlertAction *determineAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [determineAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    
    [alert addAction:cancelAction];
    [alert addAction:determineAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@[@"个人资料", @"修改密码"], @[@"用户协议", @"清除缓存", @"关于我们", @"意见反馈"]];
    }
    return _titleArr;
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
