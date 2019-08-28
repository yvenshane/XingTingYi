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

@interface VENSettingPersonalInformationViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, copy) NSArray *titleArr;
@property (nonatomic, copy) NSString *birthday;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENSettingPersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"个人资料";
    
    self.tableView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    [self.tableView registerNib:[UINib nibWithNibName:@"VENSettingTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    //    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //
    //    }];
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
    
    cell.iconImageView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    
    if (indexPath.row == 0) {
        cell.descriptionTextField.hidden = YES;
        cell.iconImageView.hidden = NO;
        cell.rightImageView.hidden = YES;
    } else {
        cell.descriptionTextField.hidden = NO;
        cell.iconImageView.hidden = YES;
        cell.rightImageView.hidden = NO;
    }
    
    if (indexPath.row == 1 || indexPath.row == 4) {
        cell.descriptionTextField.text = @"请填写";
    } else {
        cell.descriptionTextField.text = @"请选择";
    }
    
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
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        VENDatePickerView *datePickerView = [[VENDatePickerView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        datePickerView.title = @"生日";
        datePickerView.date = self.birthday;
        
        datePickerView.datePickerViewBlock = ^(NSString *str) {
            self.birthday = str;
            
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:datePickerView];
    } else if (indexPath.row == 4) {
        VENSettingPersonalInformationNickNameViewController *vc = [[VENSettingPersonalInformationNickNameViewController alloc] init];
        vc.navigationItem.title = @"签名";
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        VENListPickerView *listPickerView = [[VENListPickerView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        listPickerView.dataSourceArr = @[@{@"id" : @"1", @"name" : @"男"}, @{@"id" : @"2", @"name" : @"女"}];
        listPickerView.listPickerViewBlock = ^(NSDictionary *dict) {
            
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

- (NSArray *)titleArr {
    if (!_titleArr) {
        _titleArr = @[@"个人头像", @"昵称", @"生日", @"性别", @"签名", @"日语等级", @"英语等级"];
    }
    return _titleArr;
}

#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
//    self.iconImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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
