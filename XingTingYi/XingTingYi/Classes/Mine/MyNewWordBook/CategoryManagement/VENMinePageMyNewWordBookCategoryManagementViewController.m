//
//  VENMinePageMyNewWordBookCategoryManagementViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/11.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMinePageMyNewWordBookCategoryManagementViewController.h"
#import "VENAddCategoryView.h"
#import "VENEditCategoryView.h"

@interface VENMinePageMyNewWordBookCategoryManagementViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView2;
@property (nonatomic, strong) UITableView *tableView3;

@property (nonatomic, copy) NSArray *dataSourceArr;
@property (nonatomic, assign) NSInteger indexPathRow;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMinePageMyNewWordBookCategoryManagementViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // nav 黑线
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"分类管理";
    
    UITableView *tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth / 3, kMainScreenHeight - kStatusBarAndNavigationBarHeight) style:UITableViewStyleGrouped];
    tableView2.backgroundColor = UIColorFromRGB(0xF8F8F8);
    tableView2.tag = 998;
    tableView2.delegate = self;
    tableView2.dataSource = self;
    tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView2];
    
    UITableView *tableView3 = [[UITableView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3, 0, kMainScreenWidth / 3 * 2, kMainScreenHeight - kStatusBarAndNavigationBarHeight) style:UITableViewStyleGrouped];
    tableView3.backgroundColor = [UIColor whiteColor];
    tableView3.tag = 999;
    tableView3.delegate = self;
    tableView3.dataSource = self;
    tableView3.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView3];
    
    _tableView2 = tableView2;
    _tableView3 = tableView3;
    
    [self loadChooseCategoryView];
}

- (void)loadChooseCategoryView {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"source/wordsCategoryList" parameters:nil successBlock:^(id responseObject) {
        
        self.dataSourceArr = responseObject[@"content"][@"wordsCategory"];
        
        [self.tableView2 reloadData];
        [self.tableView3 reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 998) {
        return self.dataSourceArr.count;
    } else {
        if (self.indexPathRow) {
            NSArray *arr = self.dataSourceArr[self.indexPathRow - 1][@"son"];
            return arr.count + 1;
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
        
        if ([self.id isEqualToString:self.dataSourceArr[indexPath.row][@"id"]]) {
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
        UILabel *plusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 19, 16, 16)];
        plusLabel.backgroundColor = UIColorFromRGB(0xFFDE02);
        plusLabel.text = @" ➕";
        plusLabel.textColor = UIColorFromRGB(0x222222);
        plusLabel.font = [UIFont systemFontOfSize:8.0f];
        plusLabel.textAlignment = NSTextAlignmentCenter;
        plusLabel.layer.cornerRadius = 8.0f;
        plusLabel.layer.masksToBounds = YES;
        [cell.contentView addSubview:plusLabel];
        
        UILabel *addLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + 16 + 10, 18.5, kMainScreenWidth / 3 * 2 - 20 * 2 - 16 - 10, 17)];
        addLabel.text = @"添加二级分类";
        addLabel.textColor = UIColorFromRGB(0x222222);
        addLabel.font = [UIFont systemFontOfSize:14.0f];
        [cell.contentView addSubview:addLabel];
        
        UIImageView *editImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth / 3 * 2 - 12 - 20, 20, 12, 12)];
        editImageView.image = [UIImage imageNamed:@"icon_words_edit"];
        [cell.contentView addSubview:editImageView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 53, kMainScreenWidth / 3 * 2 - 20 - 15, 1)];
        lineView.backgroundColor = UIColorFromRGB(0xF1F1F1);
        [cell.contentView addSubview:lineView];
        
        NSArray *arr = self.dataSourceArr[self.indexPathRow - 1][@"son"];
        
        if (indexPath.row == arr.count) {
            plusLabel.hidden = NO;
            addLabel.hidden = NO;
            editImageView.hidden = YES;
        } else {
            plusLabel.hidden = YES;
            addLabel.hidden = YES;
            editImageView.hidden = NO;
            
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.textLabel.text = self.dataSourceArr[self.indexPathRow - 1][@"son"][indexPath.row][@"name"];
            cell.textLabel.textColor = UIColorFromRGB(0x222222);
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 998) {
        self.id = self.dataSourceArr[indexPath.row][@"id"];
        self.indexPathRow = indexPath.row + 1;
        
        [self.tableView2 reloadData];
        [self.tableView3 reloadData];
    } else {
        NSArray *arr = self.dataSourceArr[self.indexPathRow - 1][@"son"];
        
        if (indexPath.row == arr.count) {
            VENAddCategoryView *addCategoryView = [[VENAddCategoryView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
            addCategoryView.pid = self.id;
            addCategoryView.addCategoryViewBlock = ^{
                [self loadChooseCategoryView];
            };
            [[UIApplication sharedApplication].keyWindow addSubview:addCategoryView];
        } else {
            VENEditCategoryView *editCategoryView = [[VENEditCategoryView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
            editCategoryView.id = arr[indexPath.row][@"id"];
            editCategoryView.idName = arr[indexPath.row][@"name"];
            editCategoryView.editCategoryViewBlock = ^{
                [self loadChooseCategoryView];
            };
            [[UIApplication sharedApplication].keyWindow addSubview:editCategoryView];
        }
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
