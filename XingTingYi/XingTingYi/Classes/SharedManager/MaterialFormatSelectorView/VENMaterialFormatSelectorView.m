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
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc] init];
        [backgroundButton addSubview:tableView];
        
        _backgroundButton = backgroundButton;
        _tableView = tableView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundButton.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    [self show];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.typeListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = self.typeListArr[indexPath.row][@"name"];
    
    if ([self.type isEqualToString:[NSString stringWithFormat:@"%@", self.typeListArr[indexPath.row][@"id"]]]) {
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14.0];
    } else {
        cell.textLabel.textColor = UIColorFromRGB(0x666666);
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectRowBlock) {
        self.didSelectRowBlock([NSString stringWithFormat:@"%@", self.typeListArr[indexPath.row][@"id"]]);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (void)show {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VENMaterialFormatSelectorView" object:nil userInfo:@{@"type" : @"show"}];
    
    self.tableView.frame = CGRectMake(0, -(self.typeListArr.count * 54 + kStatusBarHeight + 47), kMainScreenWidth, self.typeListArr.count * 54);
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, self.typeListArr.count * 54);
    } completion:nil];
}

- (void)hidden {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VENMaterialFormatSelectorView" object:nil userInfo:@{@"type" : @"hidden"}];
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.tableView.frame = CGRectMake(0, -(self.typeListArr.count * 54 + kStatusBarHeight + 47), kMainScreenWidth, self.typeListArr.count * 54);
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
