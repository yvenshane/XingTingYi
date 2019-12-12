//
//  VENMinePageMemberCenterViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/8/29.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMinePageMemberCenterViewController.h"

@interface VENMinePageMemberCenterViewController ()
@property (nonatomic, strong) NSMutableArray *priceButtonMuArr;

@end

@implementation VENMinePageMemberCenterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xFFDE02);
    
    // nav 黑线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    // nav 黑线
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"会员中心";
    
    self.tableView.dataSource = nil;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - 60);
    [self.view addSubview:self.tableView];
    
    [self setupBottomBar];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 209)];
    backgroundView.backgroundColor = UIColorFromRGB(0xFFDE02);
    [headerView addSubview:backgroundView];
    
    CGFloat y = 12;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = UIColorFromRGB(0x222222);
    titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    NSString *count = @"3";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"您当前是普通会员，剩余可听写次数%@次", count]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xDB233A) range:NSMakeRange(16, count.length)];
    
    titleLabel.attributedText = attributedString;
    CGFloat width = [titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 16)].width;
    titleLabel.frame = CGRectMake(kMainScreenWidth / 2 - width / 2, y, width, 16);
    [headerView addSubview:titleLabel];
    
    y += 16;
    
    // card
    UIImageView *memberCarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, y + 22, kMainScreenWidth - 30, 150)];
    memberCarImageView.image = [UIImage imageNamed:@"icon_member_card"];
    memberCarImageView.layer.cornerRadius = 12.0f;
    memberCarImageView.layer.masksToBounds = YES;
    [headerView addSubview:memberCarImageView];
    
    y += 22 + 150;
    
    UIImageView *memberCarBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, y - 32 + 10, kMainScreenWidth, 32)];
    memberCarBackgroundImageView.image = [UIImage imageNamed:@"icon_card_bg"];
    [headerView addSubview:memberCarBackgroundImageView];
    
    y += 10;
    
    // description
    UILabel *titleLabal2 = [[UILabel alloc] initWithFrame:CGRectMake(25, y + 11, kMainScreenWidth - 50, 20)];
    titleLabal2.text = @"会员权益";
    titleLabal2.textColor = UIColorFromRGB(0x222222);
    titleLabal2.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16.0];
    [headerView addSubview:titleLabal2];
    
    y += 11 + 20;
    
    UILabel *discriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, y + 11, kMainScreenWidth - 50, 15)];
    discriptionLabel.text = @"· 无限听写体验";
    discriptionLabel.textColor = UIColorFromRGB(0x666666);
    discriptionLabel.font = [UIFont systemFontOfSize:12.0f];
    [headerView addSubview:discriptionLabel];
    
    y += 11 + 15;
    
    UILabel *discriptionLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, y + 8, kMainScreenWidth - 50, 15)];
    discriptionLabel2.text = @"· 终身会员用户可保存听写记录";
    discriptionLabel2.textColor = UIColorFromRGB(0x666666);
    discriptionLabel2.font = [UIFont systemFontOfSize:12.0f];
    [headerView addSubview:discriptionLabel2];
    
    y += 8 + 15;
    
    UILabel *discriptionLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(20, y + 8, kMainScreenWidth - 50, 15)];
    discriptionLabel3.text = @"· 可查看标准答案";
    discriptionLabel3.textColor = UIColorFromRGB(0x666666);
    discriptionLabel3.font = [UIFont systemFontOfSize:12.0f];
    [headerView addSubview:discriptionLabel3];
    
    y += 8 + 15;
    
    // payment
    UILabel *titleLabal3 = [[UILabel alloc] initWithFrame:CGRectMake(25, y + 26, kMainScreenWidth - 50, 20)];
    titleLabal3.text = @"选择您要购买的时长";
    titleLabal3.textColor = UIColorFromRGB(0x222222);
    titleLabal3.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16.0];
    [headerView addSubview:titleLabal3];
    
    y += 26 + 20;
    
    CGFloat buttonWidth = (kMainScreenWidth - 20 - 30) / 3.5;
    CGFloat buttonHeight = buttonWidth * 80 / 90;
    
    NSArray *arr = @[@{@"id" : @"1", @"title" : @"1个月", @"price" : @"100"},
                     @{@"id" : @"2", @"title" : @"2个月", @"price" : @"200"},
                     @{@"id" : @"3", @"title" : @"3个月", @"price" : @"300"},
                     @{@"id" : @"4", @"title" : @"4个月", @"price" : @"400"},
                     @{@"id" : @"5", @"title" : @"5个月", @"price" : @"500"},
                     @{@"id" : @"6", @"title" : @"6个月", @"price" : @"600"}];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, y + 16, kMainScreenWidth - 20, buttonHeight)];
    scrollView.contentSize = CGSizeMake(arr.count * (buttonWidth + 10), buttonHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    [headerView addSubview:scrollView];
    
    [self.priceButtonMuArr removeAllObjects];
    
    for (NSInteger i = 0; i < arr.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * (buttonWidth + 10), 0, buttonWidth, buttonHeight)];
        button.backgroundColor = i == 0 ? UIColorFromRGB(0xFFDE02) : [UIColor whiteColor];
        button.tag = i;
        button.layer.cornerRadius = 8.0f;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 1.0f;
        button.layer.borderColor = UIColorFromRGB(0xF1F1F1).CGColor;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        
        [self.priceButtonMuArr addObject:button];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = arr[i][@"title"];
        titleLabel.textColor = UIColorFromRGB(0x222222);
        titleLabel.font = [UIFont systemFontOfSize:12.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [button addSubview:titleLabel];
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.textColor = UIColorFromRGB(0x222222);
        priceLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:24.0f];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@", arr[i][@"price"]]];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Semibold" size:14.0f] range:NSMakeRange(0, 1)];
        priceLabel.attributedText = attributedString;
        [button addSubview:priceLabel];
        
        titleLabel.frame = CGRectMake(0, buttonHeight / 2 - 49 / 2, buttonWidth, 15);
        priceLabel.frame = CGRectMake(0, buttonHeight / 2 - 49 / 2 + 15 + 5, buttonWidth, 29);
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 386 + 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)setupBottomBar {
    UIView *bottomBarView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - kStatusBarAndNavigationBarHeight - 60, kMainScreenWidth, 60)];
    [self.view addSubview:bottomBarView];
    
    NSString *price = @"100";
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60 / 2 - 24 / 2, kMainScreenWidth / 2, 29)];
    priceLabel.textColor = UIColorFromRGB(0x222222);
    priceLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:24.0f];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@", price]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Semibold" size:14.0f] range:NSMakeRange(0, 1)];
    priceLabel.attributedText = attributedString;
    [bottomBarView addSubview:priceLabel];
    
    UIButton *paymentButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 160 - 20, 10, 160, 40)];
    paymentButton.backgroundColor = UIColorFromRGB(0xFFDE02);
    [paymentButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [paymentButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    paymentButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [paymentButton addTarget:self action:@selector(paymentButtonClick) forControlEvents:UIControlEventTouchUpInside];
    paymentButton.layer.cornerRadius = 20.0f;
    paymentButton.layer.masksToBounds = YES;
    [bottomBarView addSubview:paymentButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xF1F1F1);
    [bottomBarView addSubview:lineView];
}

- (void)paymentButtonClick {
    
}

- (void)buttonClick:(UIButton *)button {
    for (UIButton *button2 in self.priceButtonMuArr) {
        button2.backgroundColor = [UIColor whiteColor];
    }
    
    button.backgroundColor = UIColorFromRGB(0xFFDE02);
}

- (NSMutableArray *)priceButtonMuArr {
    if (!_priceButtonMuArr) {
        _priceButtonMuArr = [NSMutableArray array];
    }
    return _priceButtonMuArr;
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
