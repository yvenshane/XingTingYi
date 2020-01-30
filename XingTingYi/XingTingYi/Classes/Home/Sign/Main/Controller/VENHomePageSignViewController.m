//
//  VENHomePageSignViewController.m
//  XingTingYi
//
//  Created by YVEN on 2020/1/29.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENHomePageSignViewController.h"
#import "VENHomePageSignCollectionViewCell.h"
#import "VENHomePageSignModel.h"
#import "VENHomePageSignRecordPageViewController.h"

@interface VENHomePageSignViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *calendarView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSourceMuArr;
@property (nonatomic, strong) NSMutableArray *selectedDataMuArr;
@property (nonatomic, copy) NSString *selectedMonth;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
static NSString *const cellIdentifier2 = @"cellIdentifier2";
@implementation VENHomePageSignViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // nav 黑线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xFFDE02);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // nav 黑线
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"签到日历";
    self.view.backgroundColor = UIColorFromRGB(0xF8F8F8);
    
    self.signButton.layer.cornerRadius = 20.0f;
    self.signButton.layer.masksToBounds = YES;
    
    self.backgroundViewHeightLayoutConstraint.constant = kMainScreenWidth / (375.0 / 208.0);
    
    self.calendarView.layer.cornerRadius = 8.0f;
    self.calendarView.layer.masksToBounds = YES;
    
    [self setupCollectionView];
    
    [self test];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 23;
    flowLayout.itemSize = CGSizeMake(24, 24 + 15);
//    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
//    flowLayout.headerReferenceSize = CGSizeMake(kMainScreenWidth, 54);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake((kMainScreenWidth - 40) / 2 - 335 / 2, 102, 335, 220) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerNib:[UINib nibWithNibName:@"VENHomePageSignCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
//            [collectionView registerNib:[UINib nibWithNibName:@"VENMaterialSortSelectorViewCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifier2];
    [self.calendarView addSubview:collectionView];
    
    _collectionView = collectionView;
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceMuArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VENHomePageSignCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell.numberButton setTitle:self.dataSourceMuArr[indexPath.row] forState:UIControlStateNormal];
    
    if ([self.dataSourceMuArr[indexPath.row] isEqualToString:@"-"]) {
        cell.numberButton.hidden = YES;
    } else {
        cell.numberButton.hidden = NO;
        
        NSString *date =
        [[[NSString stringWithFormat:@"%@%02d", self.selectedMonth, [self.dataSourceMuArr[indexPath.row] integerValue]] stringByReplacingOccurrencesOfString:@"年" withString:@"-"] stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
        
        cell.numberButton.backgroundColor = UIColorFromRGB(0xF8F8F8);
        cell.numberButton.userInteractionEnabled = NO;
        cell.signLabel.hidden = YES;
        
        for (VENHomePageSignModel *model in self.selectedDataMuArr) {
            if ([model.formatTime isEqualToString:date]) {
                cell.numberButton.backgroundColor = UIColorFromRGB(0xFFDE02);
                cell.numberButton.userInteractionEnabled = YES;
                
                if ([model.status integerValue] == 2) {
                    cell.signLabel.hidden = NO;
                }
            }
        }
        
        // 打卡记录
        cell.numberButtonClickBlock = ^{
            VENHomePageSignRecordPageViewController *vc = [[VENHomePageSignRecordPageViewController alloc] init];
            vc.date = date;
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
    
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//
//}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//
//    VENMaterialSortSelectorViewCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifier2 forIndexPath:indexPath];
//    headerView.titleLabel.text = self.dataSourceArr[indexPath.section][@"name"];
//
//    return headerView;
//}

#pragma mark - 签到
- (IBAction)signButtonClick:(id)sender {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypeGET urlString:@"user/signLog" parameters:nil successBlock:^(id responseObject) {
        
        [self test];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 上个月
- (IBAction)lastMonth:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd"];
    
    NSInteger year = [[self.selectedMonth substringWithRange:NSMakeRange(0,4)] integerValue];
    NSInteger month = [[self.selectedMonth substringWithRange:NSMakeRange(5,2)] integerValue];
    
    if (month == 1) {
        month = 12;
        year -= 1;
    } else {
        month -= 1;
    }
    
    NSString *monthStr = [NSString stringWithFormat:@"%ld年%02d月", year, month];
    self.dateLabel.text = monthStr;
    self.selectedMonth = monthStr;
    
    NSString *yearStr = [NSString stringWithFormat:@"%@01", monthStr];
    
    NSDate *date = [dateFormatter dateFromString:yearStr];
    
    [self logCalendarWith:date];
}

#pragma mark - 下个月
- (IBAction)nextMonth:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd"];
    
    NSInteger year = [[self.selectedMonth substringWithRange:NSMakeRange(0,4)] integerValue];
    NSInteger month = [[self.selectedMonth substringWithRange:NSMakeRange(5,2)] integerValue];
    
    if (month == 12) {
        month = 1;
        year += 1;
    } else {
        month += 1;
    }
    
    NSString *monthStr = [NSString stringWithFormat:@"%ld年%02d月", year, month];
    self.dateLabel.text = monthStr;
    self.selectedMonth = monthStr;
    
    NSString *yearStr = [NSString stringWithFormat:@"%@01", monthStr];
    
    NSDate *date = [dateFormatter dateFromString:yearStr];
    
    [self logCalendarWith:date];
}

- (NSMutableArray *)dataSourceMuArr {
    if (!_dataSourceMuArr) {
        _dataSourceMuArr = [NSMutableArray array];
    }
    return _dataSourceMuArr;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)test {
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypeGET urlString:@"user/signLogList" parameters:nil successBlock:^(id responseObject) {
        
        self.selectedDataMuArr = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[VENHomePageSignModel class] json:responseObject[@"content"][@"signLog"]]];
        
        if ([responseObject[@"content"][@"status"] integerValue] == 2) {
            [self.signButton setTitle:@"今日已签到" forState:UIControlStateNormal];
            self.signButton.alpha = 0.1526;
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd"];
        
        NSString *month = [[dateFormatter stringFromDate:[NSDate date]] substringToIndex:8];
        
        self.dateLabel.text = month;
        self.selectedMonth = month;
        
        NSString *year = [NSString stringWithFormat:@"%@01", month];
        
        NSDate *date = [dateFormatter dateFromString:year];
        
        [self logCalendarWith:date];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)logCalendarWith:(NSDate *)date {
    NSInteger year = [self convertDateToYear:date];
    NSInteger month = [self convertDateToMonth:date];
    NSInteger day = [self convertDateToDay:date];
    NSInteger firstWeekDay = [self convertDateToFirstWeekDay:date];
    NSInteger totalDays = [self convertDateToTotalDays:date];
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMM"];
    
    NSString *date2 = [dateFormatter stringFromDate:[NSDate date]];
    
    if ([date2 isEqualToString:[NSString stringWithFormat:@"%ld%02d", year, month]]) {
        self.nextButton.selected = YES;
        self.nextButton.userInteractionEnabled = NO;
    } else {
        self.nextButton.selected = NO;
        self.nextButton.userInteractionEnabled = YES;
    }
    
    
    
    NSInteger count = firstWeekDay + totalDays;
    
    [self.dataSourceMuArr removeAllObjects];
    
    for (NSInteger i = 1; i < count + 1; i++) {
        if (i > firstWeekDay) {
            [self.dataSourceMuArr addObject:[NSString stringWithFormat:@"%ld", i - firstWeekDay]];
        } else {
            [self.dataSourceMuArr addObject:@"-"];
        }
    }
    
    [self.collectionView reloadData];
}

//根据date获取偏移指定天数的date
- (NSDate *)getDateFrom:(NSDate *)date offsetDays:(NSInteger)offsetDays {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    [lastMonthComps setDay:offsetDays];  //year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:date options:0];
    return newdate;
}

//根据date获取偏移指定月数的date
- (NSDate *)getDateFrom:(NSDate *)date offsetMonths:(NSInteger)offsetMonths {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    [lastMonthComps setMonth:offsetMonths];  //year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:date options:0];
    return newdate;
}

//根据date获取偏移指定年数的date
- (NSDate *)getDateFrom:(NSDate *)date offsetYears:(NSInteger)offsetYears {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    [lastMonthComps setYear:offsetYears];  //year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:date options:0];
    return newdate;
}

//根据date获取日
- (NSInteger)convertDateToDay:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay) fromDate:date];
    return [components day];
}

//根据date获取月
- (NSInteger)convertDateToMonth:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitMonth) fromDate:date];
    return [components month];
}

//根据date获取年
- (NSInteger)convertDateToYear:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear) fromDate:date];
    return [components year];
}

//根据date获取当月周几 (美国时间周日-周六为 1-7,改为0-6方便计算)
- (NSInteger)convertDateToWeekDay:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday fromDate:date];
    NSInteger weekDay = [components weekday] - 1;
    weekDay = MAX(weekDay, 0);
    return weekDay;
}

//根据date获取当月周几
- (NSInteger)convertDateToFirstWeekDay:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;  //美国时间周日为星期的第一天，所以周日-周六为1-7，改为0-6方便计算
}

//根据date获取当月总天数
- (NSInteger)convertDateToTotalDays:(NSDate *)date {
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

@end
