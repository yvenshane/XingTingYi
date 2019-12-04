//
//  VENLabelPickerViewOne.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/2.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENLabelPickerViewOne.h"
#import "VENListPickerViewCell.h"
#import "VENLabelPickerViewThree.h"

@interface VENLabelPickerViewOne () <UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIButton *backgroundButton;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGFloat magicX;
@property (nonatomic, assign) CGFloat magicY;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) NSMutableArray *selectedMuArr;

@end

@implementation VENLabelPickerViewOne

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
    titleLabel.text = @"选择标签";
    titleLabel.textColor = UIColorFromRGB(0x222222);
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20.0f];
    CGFloat width = [titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 24.0f)].width;
    titleLabel.frame = CGRectMake(20, 17, width, 24);
    [self.headerView addSubview:titleLabel];
    
    CGFloat width3 = kMainScreenWidth - 30 * 2;
    
    // close
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(width3 - 57, -5, 57, 57)];
    [closeButton setImage:[UIImage imageNamed:@"icon_close02"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:closeButton];
    
    self.magicX = 20;
    self.magicY = 63;
    
    for (NSInteger i = 0; i < dataSourceArr.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor whiteColor];
        button.tag = i;
        [button setTitle:[NSString stringWithFormat:@"%@", dataSourceArr[i][@"name"]] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        button.titleLabel.textAlignment = NSTextAlignmentLeft;
        [button addTarget:self action:@selector(labelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderWidth = 0.5f;
        button.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
        [button sizeToFit];
        
        if ((self.magicX + 8 + CGRectGetWidth(button.frame) + 14) > width3) {
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
    CGFloat width4 = (width3 - 20 - 20 - 5) / 4;
    CGFloat y = dataSourceArr.count > 0 ? self.magicY + 36 + 10 : self.magicY;;
    
    UIButton *addEditButton = [[UIButton alloc] initWithFrame:CGRectMake(20, y, 115, 36)];
    addEditButton.backgroundColor = [UIColor whiteColor];
    [addEditButton setTitle:@"添加/编辑标签" forState:UIControlStateNormal];
    [addEditButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    addEditButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [addEditButton addTarget:self action:@selector(addEditButtonClick) forControlEvents:UIControlEventTouchUpInside];
    addEditButton.layer.borderWidth = 1.0f;
    addEditButton.layer.borderColor = UIColorFromRGB(0x222222).CGColor;
    addEditButton.layer.cornerRadius = 18.0f;
    addEditButton.layer.masksToBounds = YES;
    [self.headerView addSubview:addEditButton];
    
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(20, y + 36 + 30, width4 * 4, 40)];
    confirmButton.backgroundColor = UIColorFromRGB(0xFFDE02);
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    confirmButton.layer.cornerRadius = 20.0f;
    confirmButton.layer.masksToBounds = YES;
    [confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:confirmButton];
    
    self.headerViewHeight = y + 40 + 20 + 36 + 30;
    
    self.tableView.frame = CGRectMake(30, kMainScreenHeight / 2 - self.headerViewHeight / 2, kMainScreenWidth - 30 * 2, self.headerViewHeight);
    
    [self.tableView reloadData];
}

// 标签点击
- (void)labelButtonClick:(UIButton *)button {
    if (button.selected) {
        button.selected = NO;
        
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        [self.selectedMuArr removeObject:self.dataSourceArr[button.tag]];
    } else {
        button.selected = YES;
        
        button.backgroundColor = UIColorFromRGB(0x222222);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.selectedMuArr addObject:self.dataSourceArr[button.tag]];
    }
}

// 添加/编辑标签
- (void)addEditButtonClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddEditDictationTag" object:nil];
}

// 确定按钮
- (void)confirmButtonClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ConfirmButtonClick" object:nil userInfo:@{@"selectedMuArr" : self.selectedMuArr}];
}

// 关闭弹窗
- (void)closeButtonClick {
    [self removeFromSuperview];
}

- (void)backgroundButtonClick {
    [self.inputTextField resignFirstResponder];
}

- (NSMutableArray *)selectedMuArr {
    if (!_selectedMuArr) {
        _selectedMuArr = [NSMutableArray array];
    }
    return _selectedMuArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
