//
//  VENSettingPersonalInformationViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/8/15.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENSettingPersonalInformationViewController.h"
#import "VENSettingTableViewCell.h"
#import "VENSettingPersonalInformationNickNameViewController.h"
#import "VENDatePickerView.h"
#import "VENListPickerView.h"
#import "VENSettingPersonalInformationModel.h"

@interface VENSettingPersonalInformationViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, strong) VENSettingPersonalInformationModel *model;
@property (nonatomic, copy) NSDictionary *publicDataDict;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENSettingPersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"个人资料";
    
    [self setupTableView];
    
    [self.tableView.mj_header beginRefreshing];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 公共数据
        [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypeGET urlString:@"user/userDataParam" parameters:nil successBlock:^(id responseObject) {
            self.publicDataDict = responseObject[@"content"];
        } failureBlock:^(NSError *error) {
            
        }];
    });
}

- (void)loadSettingPersonalInformationData {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypeGET urlString:@"user/userData" parameters:nil successBlock:^(id responseObject) {
        
        self.model = [VENSettingPersonalInformationModel yy_modelWithJSON:responseObject[@"content"][@"info"]];
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.text = self.titleArr[indexPath.row];
    cell.descriptionTextField.userInteractionEnabled = NO;
    cell.descriptionTextField.textAlignment = NSTextAlignmentRight;
    
    if (indexPath.row == 0) {
        cell.descriptionTextField.hidden = YES;
        cell.iconImageView.hidden = NO;
        cell.rightImageView.hidden = YES;
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.formatAvatar] placeholderImage:[UIImage imageNamed:@"icon_default_head"]];
    } else {
        cell.descriptionTextField.hidden = NO;
        cell.iconImageView.hidden = YES;
        cell.rightImageView.hidden = NO;
        
        if (indexPath.row == 1) { // 昵称
            cell.descriptionTextField.text = self.model.nickname;
        } else if (indexPath.row == 2) { // 生日
            cell.descriptionTextField.text = self.model.birthday;
        } else if (indexPath.row == 3) { // 性别
            cell.descriptionTextField.text = self.model.sex_name;
        } else if (indexPath.row == 4) { // 签名
            cell.descriptionTextField.text = self.model.sign;
        } else if (indexPath.row == 5) { // 日语等级
            cell.descriptionTextField.text = self.model.japanese_level_name;
        } else { // 英语等级
            cell.descriptionTextField.text = self.model.english_level_name;
        }
    }
    
    cell.descriptionTextField.placeholder = indexPath.row == 1 || indexPath.row == 4 ? @"请填写" : @"请选择";
    cell.descriptionTextFieldRightLayoutConstraint.constant = 10 + 7 + 20;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *appropriateAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }];
            UIAlertAction *undeterminedAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:appropriateAction];
            [alert addAction:undeterminedAction];
            [alert addAction:cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        });
    } else if (indexPath.row == 1) {
        VENSettingPersonalInformationNickNameViewController *vc = [[VENSettingPersonalInformationNickNameViewController alloc] init];
        vc.navigationItem.title = @"昵称";
        vc.content = self.model.nickname;
        vc.modifyNickNameBlock = ^(NSString *nickName) {
            self.model.nickname = nickName;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        VENDatePickerView *datePickerView = [[VENDatePickerView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        datePickerView.title = @"生日";
        datePickerView.date = self.model.birthday;
        datePickerView.datePickerViewBlock = ^(NSString *birthday) {
            NSDictionary *parameters = @{@"name" : @"birthday",
                                         @"value" : birthday};
            [self saveSettingWithParameters:parameters];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:datePickerView];
    } else if (indexPath.row == 4) {
        VENSettingPersonalInformationNickNameViewController *vc = [[VENSettingPersonalInformationNickNameViewController alloc] init];
        vc.navigationItem.title = @"签名";
        vc.content = self.model.sign;
        vc.modifySignatureBlock = ^(NSString *signature) {
            self.model.sign = signature;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        VENListPickerView *listPickerView = [[VENListPickerView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        if (indexPath.row == 3) {
            listPickerView.dataSourceArr = self.publicDataDict[@"sex"];
        } else if (indexPath.row == 5) {
            listPickerView.dataSourceArr = self.publicDataDict[@"japan"];
        } else {
            listPickerView.dataSourceArr = self.publicDataDict[@"english"];
        }
        listPickerView.listPickerViewBlock = ^(NSDictionary *dict) {
            NSDictionary *parameters = @{};
            if (indexPath.row == 3) {
                parameters = @{@"name" : @"sex",
                               @"value" : dict[@"id"]};
            } else if (indexPath.row == 5) {
                parameters = @{@"name" : @"japanese_level",
                               @"value" : dict[@"id"]};
            } else {
                parameters = @{@"name" : @"english_level",
                               @"value" : dict[@"id"]};
            }
            [self saveSettingWithParameters:parameters];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:listPickerView];
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
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)setupTableView {
    self.tableView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    [self.tableView registerNib:[UINib nibWithNibName:@"VENSettingTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadSettingPersonalInformationData];
    }];
}

#pragma mark - 保存设置
- (void)saveSettingWithParameters:(NSDictionary *)parameters {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"user/updateUserData" parameters:parameters successBlock:^(id responseObject) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header beginRefreshing];
        });
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"个人头像", @"昵称", @"生日", @"性别", @"签名", @"日语等级", @"英语等级"];
    }
    return _titleArr;
}

#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    UIImage *tempImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [[VENNetworkingManager shareManager] uploadImageWithUrlString:@"user/uploadAvatar" parameters:nil images:@[tempImage] keyName:@"avatar" successBlock:^(id responseObject) {
        
        self.model.formatAvatar = responseObject[@"content"][@"avatar"];
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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
