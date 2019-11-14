//
//  VENSettingPersonalInformationNickNameViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/8/15.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENSettingPersonalInformationNickNameViewController.h"
#import "VENSettingTableViewCell.h"

@interface VENSettingPersonalInformationNickNameViewController () <UITableViewDelegate, UITableViewDataSource>

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENSettingPersonalInformationNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.rightImageView.hidden = YES;
    cell.titleLabel.hidden = YES;
    
    cell.descriptionTextField.text = self.content;
    cell.descriptionTextField.placeholder = @"请输入";
    cell.descriptionTextField.textColor = UIColorFromRGB(0x222222);
    
    cell.descriptionTextFieldLeftLayoutConstraint.constant = 20.0;
    
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
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 26, kMainScreenWidth - 40, 48)];
    saveButton.backgroundColor = UIColorFromRGB(0xFFDE02);
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:saveButton];
    ViewRadius(saveButton, 24.0f);
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 48 + 26;
}

- (void)setupTableView {
    self.tableView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    [self.tableView registerNib:[UINib nibWithNibName:@"VENSettingTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)saveButtonClick {
    VENSettingTableViewCell *cell = (VENSettingTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if ([VENEmptyClass isEmptyString:cell.descriptionTextField.text]) {
        return;
    }
    
    NSString *name = [self.navigationItem.title isEqualToString:@"昵称"] ? @"nickname" : @"sign";
    
    NSDictionary *parameters = @{@"name" : name,
                                 @"value" : cell.descriptionTextField.text};
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"user/updateUserData" parameters:parameters successBlock:^(id responseObject) {
        
        if (self.modifyNickNameBlock) {
            self.modifyNickNameBlock(cell.descriptionTextField.text);
        }
        
        if (self.modifySignatureBlock) {
            self.modifySignatureBlock(cell.descriptionTextField.text);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
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
