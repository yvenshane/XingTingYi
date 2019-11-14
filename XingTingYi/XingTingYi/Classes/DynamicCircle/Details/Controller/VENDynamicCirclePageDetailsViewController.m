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
