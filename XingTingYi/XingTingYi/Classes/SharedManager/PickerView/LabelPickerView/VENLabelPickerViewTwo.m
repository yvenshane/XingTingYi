//
//  VENLabelPickerViewTwo.m
//  XingTingYi
//
//  Created by YVEN on 2019/11/28.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENLabelPickerViewTwo.h"
#import "VENListPickerViewCell.h"
#import "VENLabelPickerViewThree.h"

@interface VENLabelPickerViewTwo () <UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIButton *backgroundButton;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGFloat magicX;
@property (nonatomic, assign) CGFloat magicY;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, strong) UITextField *inputTextField;

@end

@implementation VENLabelPickerViewTwo

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
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView ? : [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.headerViewHeight ? : CGFLOAT_MIN;
}

- (void)setDataSourceArr:(NSMutableArray *)dataSourceArr {
    _dataSourceArr = dataSourceArr;
    
    self.headerView = [[UIView alloc] init];
    
    // title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"添加/编辑标签";
    titleLabel.textColor = UIColorFromRGB(0x222222);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20.0f];
    CGFloat width = [titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 24.0f)].width;
    titleLabel.frame = CGRectMake(20, 17, width, 24);
    [self.headerView addSubview:titleLabel];
    
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.text = @"单击标签进行编辑或删除";
    descriptionLabel.textColor = UIColorFromRGB(0x999999);
    descriptionLabel.font = [UIFont systemFontOfSize:14.0f];
    CGFloat width2 = [descriptionLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 17.0f)].width;
    descriptionLabel.frame = CGRectMake(20, 46.5, width2, 17);
    [self.headerView addSubview:descriptionLabel];
    
    CGFloat width3 = kMainScreenWidth - 30 * 2;
    
    // close
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(width3 - 57, -5, 57, 57)];
    [closeButton setImage:[UIImage imageNamed:@"icon_close02"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:closeButton];
    
    self.magicX = 20;
    self.magicY = 65 + 20;
    
    for (NSInteger i = 0; i < dataSourceArr.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor whiteColor];
        button.tag = i;
        [button setTitle:[NSString stringWithFormat:@"%@   ", dataSourceArr[i][@"name"]] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        button.titleLabel.textAlignment = NSTextAlignmentLeft;
        [button addTarget:self action:@selector(labelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderWidth = 0.5f;
        button.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
        [button sizeToFit];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(button.frame) + 4, 13, 10, 10)];
        imageView.image = [UIImage imageNamed:@"icon_label_edit"];
        [button addSubview:imageView];
        
        if ((self.magicX + 8 + CGRectGetWidth(button.frame) + 14 + 14) > width3) {
            self.magicX = 20;
            self.magicY = self.magicY + 36 + 10;
        }
        
        button.frame = CGRectMake(self.magicX, self.magicY, CGRectGetWidth(button.frame) + 8 + 14, 36);
        button.layer.cornerRadius = 18.0f;
        button.layer.masksToBounds = YES;
        [self.headerView addSubview:button];
        
        self.magicX += CGRectGetWidth(button.frame) + 8;
    }
    
    // input
    CGFloat width4 = (width3 - 20 -20 - 5) / 4;
    CGFloat y = dataSourceArr.count > 0 ? self.magicY + 36 + 20 : self.magicY;;
    
    UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, y, width4 * 3, 36)];
    inputTextField.backgroundColor = UIColorFromRGB(0xF8F8F8);
    inputTextField.placeholder = @"请输入标签名称";
    inputTextField.textColor = UIColorFromRGB(0x222222);
    inputTextField.font = [UIFont systemFontOfSize:14.0f];
    inputTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 36)];
    inputTextField.leftViewMode = UITextFieldViewModeAlways;
    inputTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 36)];
    inputTextField.rightViewMode = UITextFieldViewModeAlways;
    inputTextField.layer.cornerRadius = 18.0f;
    inputTextField.layer.masksToBounds = YES;
    inputTextField.delegate = self;
    [self.headerView addSubview:inputTextField];
    _inputTextField = inputTextField;
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(20 + width4 * 3 + 5, y, width4, 36)];
    addButton.backgroundColor = UIColorFromRGB(0xFFDE02);
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    [addButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    addButton.layer.cornerRadius = 18.0f;
    addButton.layer.masksToBounds = YES;
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:addButton];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(20, y + 36 + 20, width4 * 4, 40)];
    saveButton.backgroundColor = UIColorFromRGB(0xFFDE02);
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    saveButton.layer.cornerRadius = 20.0f;
    saveButton.layer.masksToBounds = YES;
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:saveButton];
    
    self.headerViewHeight = y + 36 + 20 + 40 + 20;
    
    self.tableView.frame = CGRectMake(30, kMainScreenHeight / 2 - self.headerViewHeight / 2, kMainScreenWidth - 30 * 2, self.headerViewHeight);
    
    [self.tableView reloadData];
}

// 标签点击
- (void)labelButtonClick:(UIButton *)button {
    
    [self.inputTextField resignFirstResponder];
    
    VENLabelPickerViewThree *labelPickerViewThree = [[VENLabelPickerViewThree alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    labelPickerViewThree.labelDict = self.dataSourceArr[button.tag];
    [[UIApplication sharedApplication].keyWindow addSubview:labelPickerViewThree];
}

// 关闭弹窗
- (void)closeButtonClick {
    [self removeFromSuperview];
}

// 添加按钮
- (void)addButtonClick {
    NSDictionary *parameters = @{@"id" : @"0",
                                 @"name" : self.inputTextField.text};
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"source/modifyDictationTag" parameters:parameters successBlock:^(id responseObject) {
        
        NSDictionary *dict = @{@"id" : responseObject[@"content"][@"id"],
                               @"name" : self.inputTextField.text};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddDictationTag" object:nil userInfo:dict];
        
        self.inputTextField.text = @"";
        
    } failureBlock:^(NSError *error) {
        
    }];
}

// 保存
- (void)saveButtonClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveDictationTag" object:nil];
}

- (void)backgroundButtonClick {
    [self.inputTextField resignFirstResponder];
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    self.tableView.frame = CGRectMake(30, (kMainScreenHeight - 300) / 2 - self.headerViewHeight / 2, kMainScreenWidth - 30 * 2, self.headerViewHeight);
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//        self.tableView.frame = CGRectMake(30, kMainScreenHeight / 2 - self.headerViewHeight / 2, kMainScreenWidth - 30 * 2, self.headerViewHeight);
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
