//
//  VENDynamicCirclePageDetailsViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/9/6.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENDynamicCirclePageDetailsViewController.h"
#import "VENDynamicCirclePageListTableViewCell.h"
#import "VENDynamicCirclePageDetailsCommentTableViewCell.h"
#import "VENDynamicCirclePageListModel.h"
#import "VENDynamicCirclePageDetailsModel.h"
#import "VENDynamicCirclePageReleaseDynamicViewController.h"

@interface VENDynamicCirclePageDetailsViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backgroundButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIView *inputBackgroundView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableVieww;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottomLayoutConstraint;

@property (nonatomic, strong) VENDynamicCirclePageListModel *model;
@property (nonatomic, strong) NSMutableArray *dataSourceMuArr;
@property (nonatomic, copy) NSString *reply_user_id;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENDynamicCirclePageDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO; //关闭
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES; //开启
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.inputView.layer.cornerRadius = 4.0f;
    self.inputView.layer.masksToBounds = YES;
    
    self.sendButton.layer.cornerRadius = 4.0f;
    self.sendButton.layer.masksToBounds = YES;
    
    self.inputTextField.delegate = self;
    self.reply_user_id = @"0"; // 默认为回复楼主
    
    [self setupNavigationItemLeftBarButtonItem];
    [self setupTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self loadDynamicCirclePageDetailsData];
}

- (void)loadDynamicCirclePageDetailsData {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"circle/friendCircleInfo" parameters:@{@"id" : self.id} successBlock:^(id responseObject) {
        
        self.model = [VENDynamicCirclePageListModel yy_modelWithJSON:responseObject[@"content"][@"circleInfo"]];
        self.dataSourceMuArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[VENDynamicCirclePageDetailsModel class] json:responseObject[@"content"][@"commentList"]]];
        
        [self.tableVieww reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return self.dataSourceMuArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENDynamicCirclePageDetailsCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSourceMuArr[indexPath.row];
    cell.userNameClickBlock = ^(NSDictionary *dict) {
        self.inputTextField.placeholder = [NSString stringWithFormat:@"回复 %@：", dict[@"name"]];
        self.reply_user_id = dict[@"id"];
        [self.inputTextField becomeFirstResponder];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VENDynamicCirclePageDetailsModel *model = self.dataSourceMuArr[indexPath.row];
    self.inputTextField.placeholder = [NSString stringWithFormat:@"回复 %@：", model.username];
    self.reply_user_id = model.user_id;
    [self.inputTextField becomeFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 27;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        VENDynamicCirclePageListTableViewCell *headerView = [[UINib nibWithNibName:@"VENDynamicCirclePageListTableViewCell" bundle:nil] instantiateWithOwner:nil options:nil].lastObject;
        headerView.lineImageView.hidden = YES;
        headerView.model = self.model;
        
        if (self.isMine) {
            headerView.deleteButton.hidden = NO;
            [headerView.deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        }
        
        __weak typeof(self) weakSelf = self;
        headerView.moreButtonClickBlock = ^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"屏蔽此人" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf shieldWithType:@"2" andID:self.model.user_id];
            }];
            UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"屏蔽此条动态" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf shieldWithType:@"1" andID:self.model.id];
            }];
            UIAlertAction *alertAction3 = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                VENDynamicCirclePageReleaseDynamicViewController *vc = [[VENDynamicCirclePageReleaseDynamicViewController alloc] init];
                vc.type = @"report";
                vc.circle_id = self.model.id;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            UIAlertAction *alertAction4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:alertAction];
            [alert addAction:alertAction2];
            [alert addAction:alertAction3];
            [alert addAction:alertAction4];
            
            [weakSelf presentViewController:alert animated:YES completion:nil];
        };
        
        return headerView;
    } else {
        UIView *headerView = [[UIView alloc] init];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(66, 0, kMainScreenWidth - 66 - 20, 10)];
        view.backgroundColor = self.dataSourceMuArr.count > 0 ? UIColorFromRGB(0xF8F8F8) : [UIColor whiteColor];
        [headerView addSubview:view];
                
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = view.bounds;
        maskLayer.path = maskPath.CGPath;
        view.layer.mask = maskLayer;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(66 + 23 + 14, 13 - 13)];
        [path addLineToPoint:CGPointMake(66 + 23 + 7, 6 - 13)];
        [path addLineToPoint:CGPointMake(66 + 23 + 0, 13 - 13)];

        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = self.dataSourceMuArr.count > 0 ? UIColorFromRGB(0xF8F8F8).CGColor : [UIColor whiteColor].CGColor;
//        layer.strokeColor = [UIColor blueColor].CGColor;
        layer.path = path.CGPath;
        [headerView.layer addSublayer:layer];
        
        return headerView;
    }
}

- (void)shieldWithType:(NSString *)type andID:(NSString *)idd {
    NSDictionary *parameters = @{@"type" : type,
                                 [type isEqualToString:@"1"] ? @"circle_id" : @"shield_id" : idd};
    
    __weak typeof(self) weakSelf = self;
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"circle/shield" parameters:parameters successBlock:^(id responseObject) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyTidingsListPage" object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshDynamicCircleListPage" object:nil userInfo:@{@"sort_id" : weakSelf.model.id}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshDynamicCircleListPage" object:nil userInfo:@{@"sort_id" : @"0"}];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 240;
    } else {
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return [[UIView alloc] init];
    } else {
        UIView *footerView = [[UIView alloc] init];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(66, 0, kMainScreenWidth - 66 - 20, 10)];
        view.backgroundColor = self.dataSourceMuArr.count > 0 ? UIColorFromRGB(0xF8F8F8) : [UIColor whiteColor];
        [footerView addSubview:view];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(4, 4)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = view.bounds;
        maskLayer.path = maskPath.CGPath;
        view.layer.mask = maskLayer;
        
        return footerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    } else {
        return 20.0f;
    }
}

#pragma mark - tableView
- (void)setupTableView {
    self.tableVieww.backgroundColor = [UIColor whiteColor];
    [self.tableVieww registerNib:[UINib nibWithNibName:@"VENDynamicCirclePageDetailsCommentTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableVieww.delegate = self;
    self.tableVieww.dataSource = self;
    self.tableVieww.separatorStyle = UITableViewCellSeparatorStyleNone;
}

// 键盘弹起 收起
- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification {
    NSDictionary *userInfoDict = notification.userInfo;
    CGRect keyboardFrame = [[userInfoDict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (keyboardFrame.origin.y == kMainScreenHeight) {
        self.inputViewBottomLayoutConstraint.constant = 0;
        self.backgroundButton.hidden = YES;
        
        if ([VENEmptyClass isEmptyString:self.inputTextField.text]) {
            self.inputTextField.placeholder = @"你想说点什么...";
            self.reply_user_id = @"0";
        }
    } else {
        self.inputViewBottomLayoutConstraint.constant = kIsiPhoneX ? keyboardFrame.size.height - 34 : keyboardFrame.size.height;
        self.backgroundButton.hidden = NO;
    }
}

#pragma mark - 发送
- (IBAction)sendButtonClick:(id)sender {
    NSDictionary *parameters = @{@"circle_id" : self.id,
                                 @"reply_user_id" : self.reply_user_id,
                                 @"content" : self.inputTextField.text};
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"circle/doComment" parameters:parameters successBlock:^(id responseObject) {
        
        [self.view endEditing:YES];
        self.inputTextField.text = @"";
        self.inputTextField.placeholder = @"你想说点什么...";
        self.reply_user_id = @"0";
        
        [self loadDynamicCirclePageDetailsData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (IBAction)backgroundButtonClick:(id)sender {
    [self.view endEditing:YES];
}

// 删除动态
- (void)deleteButtonClick {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要删除此动态吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *determineAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"user/delCircle" parameters:@{@"id" : self.model.id} successBlock:^(id responseObject) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyTidingsListPage" object:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshDynamicCircleListPage" object:nil userInfo:@{@"sort_id" : self.model.id}];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshDynamicCircleListPage" object:nil userInfo:@{@"sort_id" : @"0"}];
            
        } failureBlock:^(NSError *error) {
            
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:determineAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - back
- (void)setupNavigationItemLeftBarButtonItem {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [button setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    
    // 防止返回手势失效
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

- (void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
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
