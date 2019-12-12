//
//  VENEditCategoryView.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENEditCategoryView.h"

@interface VENEditCategoryView () <UITextFieldDelegate>
@property (nonatomic, strong) UIButton *backgroundButton;
@property (nonatomic, strong) UIView *backgroundVieww;
@property (nonatomic, copy) UITextField *inputTextField;

@end

@implementation VENEditCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIButton *backgroundButton = [[UIButton alloc] init];
        backgroundButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [backgroundButton addTarget:self action:@selector(backgroundButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backgroundButton];
        
        UIView *backgroundVieww = [[UIView alloc] init];
        backgroundVieww.backgroundColor = [UIColor whiteColor];
        [self addSubview:backgroundVieww];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, kMainScreenWidth - 20 - 57, 24)];
        titleLabel.text = @"编辑分类";
        titleLabel.textColor = UIColorFromRGB(0x222222);
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20.0f];
        [backgroundVieww addSubview:titleLabel];
        
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 57, 6, 57, 57)];
        [closeButton setImage:[UIImage imageNamed:@"icon_close02"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(backgroundButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [backgroundVieww addSubview:closeButton];
        
        UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 60, kMainScreenWidth - 20 * 2, 60)];
        inputTextField.placeholder = @"请输入分类名称";
        inputTextField.font = [UIFont systemFontOfSize:16.0f];
        inputTextField.delegate = self;
        [inputTextField addTarget:self action:@selector(inputTextFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [inputTextField addTarget:self action:@selector(inputTextFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        [backgroundVieww addSubview:inputTextField];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 60 + 60, kMainScreenWidth - 20 * 2, 0.5)];
        lineView.backgroundColor = UIColorFromRGB(0xF1F1F1);
        [backgroundVieww addSubview:lineView];
        
        CGFloat width = (kMainScreenWidth - 20 * 2 - 15) / 2;
        
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 155, width, 48)];
        deleteButton.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [deleteButton setTitle:@"删除分类" forState:UIControlStateNormal];
        [deleteButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        deleteButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        deleteButton.layer.cornerRadius = 24.0f;
        deleteButton.layer.masksToBounds = YES;
        [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [backgroundVieww addSubview:deleteButton];
        
        UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(20 + width + 15, 155, width, 48)];
        saveButton.backgroundColor = UIColorFromRGB(0xFFDE02);
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [saveButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        saveButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        saveButton.layer.cornerRadius = 24.0f;
        saveButton.layer.masksToBounds = YES;
        [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [backgroundVieww addSubview:saveButton];
        
        _backgroundButton = backgroundButton;
        _backgroundVieww = backgroundVieww;
        _inputTextField = inputTextField;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.inputTextField.text = self.idName;
    
    self.backgroundButton.frame = CGRectMake(0, 0, kMainScreenWidth, CGRectGetHeight(self.frame));
    self.backgroundVieww.frame = CGRectMake(0, kMainScreenHeight - 223, kMainScreenWidth, 223);
}

- (void)inputTextFieldEditingDidEnd:(UITextField *)text {
    self.backgroundVieww.frame = CGRectMake(0, kMainScreenHeight - 223, kMainScreenWidth, 223);
}

- (void)inputTextFieldEditingDidBegin:(UITextField *)text {
    self.backgroundVieww.frame = CGRectMake(0, kMainScreenHeight - 600, kMainScreenWidth, 223);
}

- (void)deleteButtonClick {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"user/delCategory" parameters:@{@"id" : self.id} successBlock:^(id responseObject) {

        if (self.editCategoryViewBlock) {
            self.editCategoryViewBlock();
        }

        [self removeFromSuperview];

    } failureBlock:^(NSError *error) {

    }];
}

- (void)saveButtonClick {
    NSDictionary *parameters = @{@"id" : self.id,
                                 @"name" : self.inputTextField.text};

    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"user/editCategory" parameters:parameters successBlock:^(id responseObject) {

        if (self.editCategoryViewBlock) {
            self.editCategoryViewBlock();
        }

        [self removeFromSuperview];

    } failureBlock:^(NSError *error) {

    }];
}

- (void)backgroundButtonClick {
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
