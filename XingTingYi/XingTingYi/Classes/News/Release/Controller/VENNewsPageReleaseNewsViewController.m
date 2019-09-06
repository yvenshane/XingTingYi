//
//  VENNewsPageReleaseNewsViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/9/4.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENNewsPageReleaseNewsViewController.h"
#import "VENSettingTableViewCell.h"
#import "VENNewsPageReleaseNewsCollectionViewCell.h"
#import "VENListPickerView.h"

@interface VENNewsPageReleaseNewsViewController () <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray <UIImage *>* pictureMuArr;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UICollectionView *collectionVieww;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIButton *commitButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) CGFloat itemsWidth;
@property (nonatomic, assign) CGFloat collectionViewwHeight;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENNewsPageReleaseNewsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // nav 黑线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // nav 黑线
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"发布动态圈";
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight)];
    [self.view addSubview:scrollView];
    
    CGFloat y = 0;
    
    UIButton *selectorButton = [[UIButton alloc] initWithFrame:CGRectMake(0, y, kMainScreenWidth, 48)];
    [selectorButton addTarget:self action:@selector(selectorButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:selectorButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 48 / 2 - 17 / 2, kMainScreenWidth - 20 - 36, 17)];
    titleLabel.text = @"添加分类";
    titleLabel.textColor = UIColorFromRGB(0x222222);
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [selectorButton addSubview:titleLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth - 20 - 6, 48 / 2 - 10 / 2, 6, 10)];
    arrowImageView.image = [UIImage imageNamed:@"icon_right"];
    [selectorButton addSubview:arrowImageView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 48, kMainScreenWidth - 40, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xF1F1F1);
    [selectorButton addSubview:lineView];
    
    y += 48;
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, y + 16, kMainScreenWidth - 40, 148)];
    textView.font = [UIFont systemFontOfSize:15.0f];
    textView.delegate = self;
    [scrollView addSubview:textView];
    
    UILabel *placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, y + 24, kMainScreenWidth - 40, 17)];
    placeholderLabel.text = @"有什么最新的动态快来告诉大家～";
    placeholderLabel.textColor = UIColorFromRGB(0xCCCCCC);
    placeholderLabel.font = [UIFont systemFontOfSize:15.0f];
    [scrollView addSubview:placeholderLabel];
    
    y += 16 + 148;
    
    self.itemsWidth = (kMainScreenWidth - 20 * 2 - 5 * 2) / 3;
    self.collectionViewwHeight = self.itemsWidth;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.itemSize = CGSizeMake(self.itemsWidth, self.itemsWidth);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, y + 16, kMainScreenWidth - 40, self.collectionViewwHeight) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerNib:[UINib nibWithNibName:@"VENNewsPageReleaseNewsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    [scrollView addSubview:collectionView];
    
    y += 16 + self.collectionViewwHeight;
    
    UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(20, y + 40, kMainScreenWidth - 40, 48)];
    commitButton.backgroundColor = UIColorFromRGB(0xFFDE02);
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    commitButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    commitButton.layer.cornerRadius = 24.0f;
    commitButton.layer.masksToBounds = YES;
    [scrollView addSubview:commitButton];
    
    y += 40 + 48;
    
    scrollView.contentSize = CGSizeMake(kMainScreenWidth, y);
    
    _scrollView = scrollView;
    _collectionVieww = collectionView;
    _commitButton = commitButton;
    _placeholderLabel = placeholderLabel;
    _titleLabel = titleLabel;
}

- (void)selectorButtonClick {
    VENListPickerView *listPickerView = [[VENListPickerView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    listPickerView.dataSourceArr = @[@{@"id" : @"1", @"name" : @"考试打卡"},
                                     @{@"id" : @"2", @"name" : @"生活趣事"},
                                     @{@"id" : @"3", @"name" : @"日语学习"},
                                     @{@"id" : @"4", @"name" : @"每日新闻"}];
    listPickerView.listPickerViewBlock = ^(NSDictionary *dict) {
        
    };
    [[UIApplication sharedApplication].keyWindow addSubview:listPickerView];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.pictureMuArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VENNewsPageReleaseNewsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.pictureImageView.image = self.pictureMuArr[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pictureMuArr.count < 9) {
        [self.pictureMuArr addObject:[UIImage imageNamed:@"icon_add_photo"]];
        
        if (self.pictureMuArr.count != 0 && self.pictureMuArr.count % 3 == 1) {
            self.collectionViewwHeight += self.itemsWidth + 5;
            self.collectionVieww.frame = CGRectMake(20, 48 + 16 + 148 + 16, kMainScreenWidth - 40, self.collectionViewwHeight);
            self.commitButton.frame = CGRectMake(20, 48 + 16 + 148 + 16 + self.collectionViewwHeight + 40, kMainScreenWidth - 40, 48);
            self.scrollView.contentSize = CGSizeMake(kMainScreenWidth, 48 + 16 + 148 + 16 + self.collectionViewwHeight + 40 + 48 + 40);
        }
        
        [collectionView reloadData];
    }
}

#pragma mark - UITextView
- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length > 0 ? YES : NO;
}

- (NSMutableArray *)pictureMuArr {
    if (!_pictureMuArr) {
        _pictureMuArr = [NSMutableArray arrayWithArray:@[[UIImage imageNamed:@"icon_add_photo"]]];
    }
    return _pictureMuArr;
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
