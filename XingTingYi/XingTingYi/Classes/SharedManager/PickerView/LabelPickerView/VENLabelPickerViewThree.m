//
//  VENLabelPickerViewThree.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/2.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENLabelPickerViewThree.h"

@interface VENLabelPickerViewThree () <UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIButton *backgroundButton;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *inputTextField;

@end

@implementation VENLabelPickerViewThree

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIButton *backgroundButton = [[UIButton alloc] init];
        backgroundButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [backgroundButton addTarget:self action:@selector(backgroundButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backgroundButton];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [backgroundButton addSubview:tableView];
        ViewRadius(tableView, 8.0f);
        
        _backgroundButton = backgroundButton;
        _tableView = tableView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundButton.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    self.tableView.frame = CGRectMake(30, kMainScreenHeight / 2 - 196 / 2, kMainScreenWidth - 30 * 2, 196);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    
    // title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"编辑标签";
    titleLabel.textColor = UIColorFromRGB(0x222222);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20.0f];
    CGFloat width = [titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 24.0f)].width;
    titleLabel.frame = CGRectMake(20, 17, width, 24);
    [headerView addSubview:titleLabel];
    
    CGFloat width2 = kMainScreenWidth - 30 * 2;
    
    // close
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(width2 - 57, -5, 57, 57)];
    [closeButton setImage:[UIImage imageNamed:@"icon_close02"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:closeButton];
    
    CGFloat y = 17 + 25;
    
    UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, y + 18, width2 - 20 * 2, 48)];
    inputTextField.backgroundColor = UIColorFromRGB(0xF8F8F8);
    inputTextField.placeholder = @"请输入标签名称";
    inputTextField.text = [self.labelDict[@"name"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    inputTextField.textColor = UIColorFromRGB(0x222222);
    inputTextField.font = [UIFont systemFontOfSize:16.0f];
    inputTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 48)];
    inputTextField.leftViewMode = UITextFieldViewModeAlways;
    inputTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 48)];
    inputTextField.rightViewMode = UITextFieldViewModeAlways;
    inputTextField.layer.cornerRadius = 24.0f;
    inputTextField.layer.masksToBounds = YES;
    inputTextField.delegate = self;
    [headerView addSubview:inputTextField];
    _inputTextField = inputTextField;
    
    CGFloat width3 = (width2 - 20 * 2 - 15) / 2;
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(20, y + 25 + 48 + 18, width3, 40)];
    deleteButton.backgroundColor = [UIColor whiteColor];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    deleteButton.layer.cornerRadius = 18.0f;
    deleteButton.layer.masksToBounds = YES;
    deleteButton.layer.borderWidth = 1.0f;
    deleteButton.layer.borderColor = UIColorFromRGB(0x979797).CGColor;
    [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:deleteButton];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(20 + 15 + width3, y + 25 + 48 + 18, width3, 40)];
    saveButton.backgroundColor = UIColorFromRGB(0xFFDE02);
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    saveButton.layer.cornerRadius = 18.0f;
    saveButton.layer.masksToBounds = YES;
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:saveButton];
    
    return headerView;
}

- (void)deleteButtonClick {
    
    NSDictionary *parameters = @{@"id" : self.labelDict[@"id"]};
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"source/delDictationTag" parameters:parameters successBlock:^(id responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteDictationTag" object:nil userInfo:parameters];
        
        [self removeFromSuperview];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)saveButtonClick {
    NSDictionary *parameters = @{@"id" : self.labelDict[@"id"],
                                 @"name" : self.inputTextField.text};
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"source/modifyDictationTag" parameters:parameters successBlock:^(id responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"EditDictationTag" object:nil userInfo:parameters];
        
        [self removeFromSuperview];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 196.0f;
}

// 关闭弹窗
- (void)closeButtonClick {
    [self removeFromSuperview];
}

- (void)backgroundButtonClick {
    [self.inputTextField resignFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
