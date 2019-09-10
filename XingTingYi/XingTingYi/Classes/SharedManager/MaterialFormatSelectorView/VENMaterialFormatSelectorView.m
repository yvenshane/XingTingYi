//
//  VENMaterialFormatSelectorView.m
//  XingTingYi
//
//  Created by YVEN on 2019/9/10.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialFormatSelectorView.h"

@interface VENMaterialFormatSelectorView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton *backgroundButton;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UITableView *tableView;

@end

static const NSTimeInterval kAnimationDuration = 0.3;
static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMaterialFormatSelectorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIButton *backgroundButton = [[UIButton alloc] init];
        backgroundButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [backgroundButton addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backgroundButton];
        
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [backgroundButton addSubview:backgroundView];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc] init];
        [backgroundView addSubview:tableView];
        
        _backgroundButton = backgroundButton;
        _backgroundView = backgroundView;
        _tableView = tableView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundButton.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * 420 / 375);
    
    [self show];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    cell.textLabel.text = @"1231231";
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (void)show {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VENMaterialFormatSelectorView" object:nil userInfo:@{@"type" : @"show"}];
    
    self.backgroundView.frame = CGRectMake(0, -(kMainScreenWidth * 420 / 375), kMainScreenWidth, kMainScreenWidth * 420 / 375);
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.backgroundView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenWidth * 420 / 375);
    } completion:nil];
}

- (void)hidden {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VENMaterialFormatSelectorView" object:nil userInfo:@{@"type" : @"hidden"}];
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.backgroundView.frame = CGRectMake(0, -(kMainScreenWidth * 420 / 375), kMainScreenWidth, kMainScreenWidth * 420 / 375);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
