//
//  VENListPickerView.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENListPickerView.h"
#import "VENListPickerViewCell.h"

@interface VENListPickerView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton *backgroundButton;
@property (nonatomic, strong) UITableView *tableView;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENListPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIButton *backgroundButton = [[UIButton alloc] init];
        backgroundButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [backgroundButton addTarget:self action:@selector(backgroundButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backgroundButton];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerNib:[UINib nibWithNibName:@"VENListPickerViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
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
    
    NSInteger count = self.dataSourceArr.count > 4 ? 4 : self.dataSourceArr.count;
    
    self.backgroundButton.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    self.tableView.frame = CGRectMake(48, kMainScreenHeight / 2 - count * 47 / 2, kMainScreenWidth - 48 - 47, count * 47);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENListPickerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleLabel.text = self.dataSourceArr[indexPath.row][@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.listPickerViewBlock(self.dataSourceArr[indexPath.row]);
    [self removeFromSuperview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 47.0f;
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
