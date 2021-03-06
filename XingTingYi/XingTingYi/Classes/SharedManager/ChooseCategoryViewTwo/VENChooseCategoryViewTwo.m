//
//  VENChooseCategoryViewTwo.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/27.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENChooseCategoryViewTwo.h"
#import "VENMinePageMyNewWordBookCategoryManagementViewController.h"

@interface VENChooseCategoryViewTwo () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton *backgroundButton;
@property (nonatomic, strong) UIView *topBarView;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UILabel *subtitleLabel2;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *tableView2;

@property (nonatomic, copy) NSArray *dataSourceArr;
@property (nonatomic, assign) NSInteger indexPathRow;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENChooseCategoryViewTwo

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIButton *backgroundButton = [[UIButton alloc] init];
        backgroundButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [backgroundButton addTarget:self action:@selector(backgroundButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backgroundButton];
        
        // topBarView
        UIView *topBarView = [[UIView alloc] init];
        topBarView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topBarView];
        
        // XXX > xxx
        UILabel *subtitleLabel = [[UILabel alloc] init];
        subtitleLabel.textColor = UIColorFromRGB(0x666666);
        subtitleLabel.font = [UIFont systemFontOfSize:14.0f];
        [topBarView addSubview:subtitleLabel];
        
        UIImageView *rightImageView = [[UIImageView alloc] init];
        rightImageView.image = [UIImage imageNamed:@"icon_right"];
        rightImageView.hidden = YES;
        [topBarView addSubview:rightImageView];
        
        UILabel *subtitleLabel2 = [[UILabel alloc] init];
        subtitleLabel2.textColor = UIColorFromRGB(0x666666);
        subtitleLabel2.font = [UIFont systemFontOfSize:14.0f];
        [topBarView addSubview:subtitleLabel2];
        
        UIButton *categoryManagementButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 15 - 76, 11, 76, 32)];
        categoryManagementButton.backgroundColor = UIColorFromRGB(0xFFDE02);
        [categoryManagementButton setTitle:@"分类管理" forState:UIControlStateNormal];
        [categoryManagementButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        categoryManagementButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [categoryManagementButton addTarget:self action:@selector(editCategoryButtonClick) forControlEvents:UIControlEventTouchUpInside];
        categoryManagementButton.layer.cornerRadius = 16.0f;
        categoryManagementButton.layer.masksToBounds = YES;
        [topBarView addSubview:categoryManagementButton];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(0xF1F1F1);
        [self addSubview:lineView];
        
        // 选项
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.backgroundColor = UIColorFromRGB(0xF8F8F8);
        tableView.tag = 998;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [backgroundButton addSubview:tableView];
        
        UITableView *tableView2 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView2.backgroundColor = [UIColor whiteColor];
        tableView2.tag = 999;
        tableView2.delegate = self;
        tableView2.dataSource = self;
        tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
        [backgroundButton addSubview:tableView2];
        
        _backgroundButton = backgroundButton;
        _topBarView = topBarView;
        _subtitleLabel = subtitleLabel;
        _rightImageView = rightImageView;
        _subtitleLabel2 = subtitleLabel2;
        _lineView = lineView;
        _tableView = tableView;
        _tableView2 = tableView2;
        
        [self loadChooseCategoryView];
    }
    return self;
}

- (void)loadChooseCategoryView {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"source/wordsCategoryList" parameters:nil successBlock:^(id responseObject) {
        
        self.dataSourceArr = responseObject[@"content"][@"wordsCategory"];
        
//        for (NSDictionary *dict in self.dataSourceArr) {
//            for (NSDictionary *dict2 in dict[@"son"]) {
//                if ([dict2[@"id"] isEqualToString:self.sort_id]) {
//                    self.subtitleLabel.text = dict[@"name"];
//                    self.subtitleLabel2.text = dict2[@"name"];
//                }
//            }
//        }
//
//        [self setNeedsLayout];
//        [self layoutIfNeeded];
        
        [self.tableView reloadData];
        [self.tableView2 reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundButton.frame = CGRectMake(0, 0, kMainScreenWidth, CGRectGetHeight(self.frame));
    
    self.topBarView.frame = CGRectMake(0, 0, kMainScreenWidth, 54);
                                       
    CGFloat width = [self.subtitleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 17.0f)].width;
    self.subtitleLabel.frame = CGRectMake(20, 18.5, width, 17);
    self.rightImageView.frame = CGRectMake(20 + width + 15, 21, 7, 12);
    self.rightImageView.hidden = [VENEmptyClass isEmptyString:self.pid] ? YES : NO;
    CGFloat width2 = [self.subtitleLabel2 sizeThatFits:CGSizeMake(CGFLOAT_MAX, 17.0f)].width;
    self.subtitleLabel2.frame = CGRectMake(20 + width + 15 + 7 + 15, 18.5, width2, 17);
    self.lineView.frame = CGRectMake(0, 54, kMainScreenWidth, 1);
    self.tableView.frame = CGRectMake(0, 54, kMainScreenWidth / 2, 260);
    self.tableView2.frame = CGRectMake(kMainScreenWidth / 2, 54, kMainScreenWidth / 2, 260);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 998) {
        return self.dataSourceArr.count;
    } else {
        if (self.indexPathRow) {
            NSArray *arr = self.dataSourceArr[self.indexPathRow - 1][@"son"];
            return arr.count;
        } else {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView.tag == 998) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 17, 3, 20)];
        lineView.backgroundColor = UIColorFromRGB(0xFFDE02);
        [cell.contentView addSubview:lineView];
        
        cell.textLabel.text = self.dataSourceArr[indexPath.row][@"name"];
        
        if ([self.pid isEqualToString:self.dataSourceArr[indexPath.row][@"id"]]) {
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14.0];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            lineView.hidden = NO;
        } else {
            cell.textLabel.textColor = UIColorFromRGB(0x666666);
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.contentView.backgroundColor = UIColorFromRGB(0xF8F8F8);
            lineView.hidden = YES;
        }
    } else {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 53, kMainScreenWidth / 3 * 2 - 20 - 15, 1)];
        lineView.backgroundColor = UIColorFromRGB(0xF1F1F1);
        [cell.contentView addSubview:lineView];
        
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = self.dataSourceArr[self.indexPathRow - 1][@"son"][indexPath.row][@"name"];
        
        if ([self.sort_id isEqualToString:self.dataSourceArr[self.indexPathRow - 1][@"son"][indexPath.row][@"id"]]) {
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14.0];
        } else {
            cell.textLabel.textColor = UIColorFromRGB(0x666666);
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 998) {
        self.pid = self.dataSourceArr[indexPath.row][@"id"];
        self.indexPathRow = indexPath.row + 1;
        self.subtitleLabel.text = self.dataSourceArr[indexPath.row][@"name"];
        self.subtitleLabel2.text = @"";
    } else {
        if (self.chooseCategoryViewTwoBlock) {
            self.subtitleLabel2.text = self.dataSourceArr[self.indexPathRow - 1][@"son"][indexPath.row][@"name"];
            
            self.sort_id = self.dataSourceArr[self.indexPathRow - 1][@"son"][indexPath.row][@"id"];
            
            self.chooseCategoryViewTwoBlock(@{@"pid" : self.pid,
                                              @"sort_id" : self.sort_id});
        }
        [self removeFromSuperview];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self.tableView reloadData];
    [self.tableView2 reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - 编辑分类
- (void)editCategoryButtonClick {
    VENMinePageMyNewWordBookCategoryManagementViewController *vc = [[VENMinePageMyNewWordBookCategoryManagementViewController alloc] init];
    [[self getCurrentTopVC].navigationController pushViewController:vc animated:YES];
}

- (void)backgroundButtonClick {
    [self removeFromSuperview];
}

#pragma mark - 获取当前屏幕显示的rootViewController
- (UIViewController *)getCurrentTopVC {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return [self getTopViewController:result];
}

- (UIViewController *)getTopViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [self getTopViewController:[(UITabBarController *)viewController selectedViewController]];
        
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [self getTopViewController:[(UINavigationController *)viewController topViewController]];
        
    } else if (viewController.presentedViewController) {
        return [self getTopViewController:viewController.presentedViewController];
        
    } else {
        return viewController;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
