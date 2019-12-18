//
//  VENVideoMaterialDetailsPageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/9/10.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsPageViewController.h"
#import "VENMaterialDetailsPageHeaderView.h"
#import "VENMaterialDetailsPageFooterView.h"
#import "VENMaterialDetailsPageTableViewCell.h"
#import "VENMaterialDetailsPageTableViewCellTwo.h"
#import "VENMaterialDetailsPageModel.h"
#import "VENBaseWebViewController.h"
#import "VENMaterialDetailsArticleCorrectionPageViewController.h" // 文章纠错
#import "VENMaterialDetailsStartDictationPageViewController.h" // 开始听写
#import "VENMaterialDetailsMakeSubtitlesPageViewController.h" // 制作字幕
#import "VENMaterialDetailsReadAloudPageViewController.h" // 朗读
#import "VENMaterialDetailsTranslationPageViewController.h" // 翻译
#import "VENAudioPlayer.h"
#import "VENMinePageMyNewWordBookViewController.h" // 添加生词

@interface VENMaterialDetailsPageViewController ()
@property (nonatomic, strong) UIView *navigationView;

@property (nonatomic, copy) NSDictionary *contentDict;
@property (nonatomic, strong) VENMaterialDetailsPageModel *infoModel;
@property (nonatomic, copy) NSArray *avInfoArr;
@property (nonatomic, copy) NSArray *textInfoArr;

@property (nonatomic, copy) NSString *categoryViewContent;
@property (nonatomic, copy) NSString *categoryViewTitle;
@property (nonatomic, copy) NSString *numberOfLines;

@property (nonatomic, assign) BOOL isTextInfo; // 切换分段听写/朗读翻译
@property (nonatomic, assign) BOOL isShowTextInfo;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
static NSString *const cellIdentifier2 = @"cellIdentifier2";
@implementation VENMaterialDetailsPageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTableView];
    [self setupNavigationView];
    
    [self loadVideoMaterialDetailsPageData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shrinkButtonClick:) name:@"ShrinkButtonClick" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDetailPage:) name:@"RefreshDetailPage" object:nil];
}

- (void)loadVideoMaterialDetailsPageData {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"source/sourceInfo" parameters:@{@"id" : self.id} successBlock:^(id responseObject) {
        
        self.contentDict = responseObject[@"content"];
        
        self.infoModel = [VENMaterialDetailsPageModel yy_modelWithJSON:responseObject[@"content"][@"info"]];
        self.avInfoArr = [NSArray yy_modelArrayWithClass:[VENMaterialDetailsPageModel class] json:responseObject[@"content"][@"avInfo"]];
        self.textInfoArr = [NSArray yy_modelArrayWithClass:[VENMaterialDetailsPageModel class] json:responseObject[@"content"][@"textInfo"]];
        
        if ([self.infoModel.type isEqualToString:@"1"] || [self.infoModel.type isEqualToString:@"2"] || [self.infoModel.type isEqualToString:@"3"]) {
            if (self.avInfoArr.count > 1) {
                self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - (kTabBarHeight - 49));
            } else {
                [self setupBottomToolBar];
                self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 60 - (kTabBarHeight - 49));
            }
        } else {
            self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - (kTabBarHeight - 49));
        }
        
        [self.tableView reloadData];
        
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
        if (self.avInfoArr.count > 1 || self.textInfoArr.count > 0) {
            
            if (self.avInfoArr.count > 1 && self.textInfoArr.count < 1) {
                self.isShowTextInfo = NO;
                return self.avInfoArr.count;
            } else if (self.avInfoArr.count < 1 && self.textInfoArr.count > 0) {
                self.isShowTextInfo = YES;
                return self.textInfoArr.count;
            } else {
                if (self.isTextInfo) {
                    self.isShowTextInfo = YES;
                    return self.textInfoArr.count;
                } else {
                    self.isShowTextInfo = NO;
                    return self.avInfoArr.count;
                }
            }
        } else {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isShowTextInfo) {
        VENMaterialDetailsPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        VENMaterialDetailsPageModel *avInfoModel = self.avInfoArr[indexPath.row];
        
        if (indexPath.row < 10) {
            cell.numberLabel.text = [NSString stringWithFormat:@"0%ld", (long)indexPath.row + 1];
        } else {
            cell.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
        }
        
        cell.titleLabel.text = avInfoModel.subtitle;
        
        if (![VENEmptyClass isEmptyString:avInfoModel.dictationInfo[@"id"]]) {
            [cell.leftButton setTitle:@"继续听写" forState:UIControlStateNormal];
        } else {
            [cell.leftButton setTitle:@"开始听写" forState:UIControlStateNormal];
        }
        
        if (![VENEmptyClass isEmptyArray:avInfoModel.subtitlesList]) {
            [cell.rightButton setTitle:@"修改字幕" forState:UIControlStateNormal];
        } else {
            [cell.rightButton setTitle:@"制作字幕" forState:UIControlStateNormal];
        }
        
        cell.leftButton.tag = indexPath.row;
        [cell.leftButton addTarget:self action:@selector(cellLeftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.rightButton.tag = indexPath.row;
        [cell.rightButton addTarget:self action:@selector(cellRightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    } else {
        VENMaterialDetailsPageTableViewCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        VENMaterialDetailsPageModel *textInfoModel = self.textInfoArr[indexPath.row];
        
        cell.titleLabel.text = textInfoModel.content;
        
        NSString *contentStr = textInfoModel.translation[@"content"];
        NSString *grammar = textInfoModel.translation[@"grammar"];
        NSString *words = textInfoModel.translation[@"words"];
        
        if (![VENEmptyClass isEmptyString:contentStr] && ![VENEmptyClass isEmptyString:grammar] && ![VENEmptyClass isEmptyString:words]) {
            cell.contentLabel.text = [NSString stringWithFormat:@"翻译：%@\n语法：%@\n单词：%@", contentStr, grammar, words];
        } else {
            cell.contentLabel.text = @"";
        }
        
        if (![VENEmptyClass isEmptyString:textInfoModel.read]) {
            cell.buttonOne.selected = YES;
        }
        
        cell.buttonOneBlock = ^(UIButton *button) {
            if (button.selected) {
                [[VENAudioPlayer sharedAudioPlayer] playWithURL:[NSURL URLWithString:textInfoModel.read]];
                [[VENAudioPlayer sharedAudioPlayer] play];
            }
        };
        
        cell.buttonTwoBlock = ^{
            VENMaterialDetailsReadAloudPageViewController *vc = [[VENMaterialDetailsReadAloudPageViewController alloc] init];
            vc.source_period_id = textInfoModel.id;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        cell.buttonThreeBlock = ^{
            VENMaterialDetailsTranslationPageViewController *vc = [[VENMaterialDetailsTranslationPageViewController alloc] init];
            vc.source_period_id = textInfoModel.id;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 && ![VENEmptyClass isEmptyDictionary:self.contentDict]) {
        VENMaterialDetailsPageHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"VENMaterialDetailsPageHeaderView" owner:nil options:nil].lastObject;
        headerView.contentDict = self.contentDict;
        headerView.contentButtonBlock = ^{
            VENBaseWebViewController *vc = [[VENBaseWebViewController alloc] init];
            vc.HTMLString = self.infoModel.descriptionn;
            vc.navigationItem.title = @"简介";
            vc.isPresent = YES;
            VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        };
        
        return headerView;
    } else {
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor whiteColor];
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    if (section == 0 && ![VENEmptyClass isEmptyDictionary:self.contentDict]) {
        return 965;
    } else {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0 && ![VENEmptyClass isEmptyDictionary:self.contentDict]) {
        VENMaterialDetailsPageFooterView *footerView = [[NSBundle mainBundle] loadNibNamed:@"VENMaterialDetailsPageFooterView" owner:nil options:nil].lastObject;
        footerView.categoryViewContent = self.categoryViewContent;
        footerView.categoryViewTitle = self.categoryViewTitle;
        footerView.numberOfLines = self.numberOfLines ? : @"3";
        footerView.isTextInfo = self.isTextInfo;
        
        footerView.contentDict = self.contentDict;
        
        return footerView;
    } else {
        UIView *footerView = [[UIView alloc] init];
        footerView.backgroundColor = [UIColor whiteColor];
        
        // otherView = [[NSBundle mainBundle] loadNibNamed:@"VENMaterialDetailsPageOtherView" owner:nil options:nil].lastObject;
        
        if (([self.infoModel.type isEqualToString:@"4"] || [self.infoModel.type isEqualToString:@"5"]) && self.isTextInfo) {
            CGFloat width = (kMainScreenWidth - 40 - 15) / 2;
            
            UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 15, width, 40)];
            leftButton.backgroundColor = UIColorFromRGB(0xFFDE02);
            [leftButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
            leftButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            leftButton.layer.cornerRadius = 20.0f;
            leftButton.layer.masksToBounds = YES;
            [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:leftButton];
            
            UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(20 + width + 15, 15, (kMainScreenWidth - 40 - 15) / 2, 40)];
            rightButton.backgroundColor = UIColorFromRGB(0x222222);
            [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            rightButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            rightButton.layer.cornerRadius = 20.0f;
            rightButton.layer.masksToBounds = YES;
            [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:rightButton];
        }
        return footerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    if (section == 0 && ![VENEmptyClass isEmptyDictionary:self.contentDict]) {
        return 475;
    } else {
        if (([self.infoModel.type isEqualToString:@"4"] || [self.infoModel.type isEqualToString:@"5"]) && self.isTextInfo) {
            return 85;
        }
        return 1;
    }
}

- (void)setupTableView {
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - (kTabBarHeight - 49));
    [self.tableView registerNib:[UINib nibWithNibName:@"VENMaterialDetailsPageTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"VENMaterialDetailsPageTableViewCellTwo" bundle:nil] forCellReuseIdentifier:cellIdentifier2];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (void)setupBottomToolBar {
    UIView *bottomToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - 60 - (kTabBarHeight - 49), kMainScreenWidth, 60)];
    bottomToolBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomToolBar];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xF1F1F1);
    [bottomToolBar addSubview:lineView];
    
    CGFloat width = (kMainScreenWidth - 40 - 15) / 2;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, width, 40)];
    leftButton.backgroundColor = UIColorFromRGB(0xFFDE02);
    [leftButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    leftButton.layer.cornerRadius = 20.0f;
    leftButton.layer.masksToBounds = YES;
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomToolBar addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(20 + width + 15, 10, (kMainScreenWidth - 40 - 15) / 2, 40)];
    rightButton.backgroundColor = UIColorFromRGB(0x222222);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    rightButton.layer.cornerRadius = 20.0f;
    rightButton.layer.masksToBounds = YES;
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomToolBar addSubview:rightButton];
    
    // 1音频 2视频 3文本 4音频文本 5视频文本
    if ([self.infoModel.type isEqualToString:@"1"] || [self.infoModel.type isEqualToString:@"2"]) {
        VENMaterialDetailsPageModel *avInfoModel = self.avInfoArr[0];
        
        BOOL isContinue = ![VENEmptyClass isEmptyString:avInfoModel.dictationInfo[@"id"]];
        [leftButton setTitle:isContinue ? @"继续听写" : @"开始听写" forState:UIControlStateNormal];
        BOOL isModify = ![VENEmptyClass isEmptyArray:avInfoModel.subtitlesList];
        [rightButton setTitle:isModify ? @"修改字幕" : @"制作字幕" forState:UIControlStateNormal];
    } else if ([self.infoModel.type isEqualToString:@"3"]) {
        [leftButton setTitle:@"添加生词" forState:UIControlStateNormal];
        
        if ([VENEmptyClass isEmptyString:self.infoModel.merge_audio]) {
            [rightButton setTitle:@"合成录音" forState:UIControlStateNormal];
        } else {
            [rightButton setTitle:@"再次合成录音" forState:UIControlStateNormal];
        }
    } else {
        
    }
}

#pragma mark - 开始听写/继续听写/添加生词
- (void)leftButtonClick:(UIButton *)button {
    if ([self.infoModel.type isEqualToString:@"1"] || [self.infoModel.type isEqualToString:@"2"]) { // 开始听写/继续听写
        VENMaterialDetailsPageModel *model = self.avInfoArr[0];
        
        VENMaterialDetailsStartDictationPageViewController *vc = [[VENMaterialDetailsStartDictationPageViewController alloc] init];
        vc.source_id = self.infoModel.id;
        vc.source_period_id = model.id;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.infoModel.type isEqualToString:@"3"]) { // 添加生词
        VENMaterialDetailsPageModel *model = self.textInfoArr[0];
        
        VENMinePageMyNewWordBookViewController *vc = [[VENMinePageMyNewWordBookViewController alloc] init];
        vc.source_id = model.source_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - cell 开始听写
- (void)cellLeftButtonClick:(UIButton *)button {
    VENMaterialDetailsPageModel *model = self.avInfoArr[button.tag];
    
    VENMaterialDetailsStartDictationPageViewController *vc = [[VENMaterialDetailsStartDictationPageViewController alloc] init];
    vc.source_id = self.infoModel.id;
    vc.source_period_id = model.id;
    vc.isSectionDictation = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 制作字幕/合成录音
- (void)rightButtonClick:(UIButton *)button {
    if ([self.infoModel.type isEqualToString:@"1"] || [self.infoModel.type isEqualToString:@"2"]) { // 制作字幕
        VENMaterialDetailsPageModel *model = self.avInfoArr[0];
        
        VENMaterialDetailsMakeSubtitlesPageViewController *vc = [[VENMaterialDetailsMakeSubtitlesPageViewController alloc] init];
        vc.source_period_id = model.id;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.infoModel.type isEqualToString:@"3"]) { // 合成录音
        NSDictionary *parameters = @{@"source_id" : self.infoModel.id,
                                     @"type" : @"1"};
        
        [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"qiniu/mergeAudioInfo" parameters:parameters successBlock:^(id responseObject) {
            
            [self loadVideoMaterialDetailsPageData];
            
        } failureBlock:^(NSError *error) {
            
        }];
    }
}

#pragma mark - cell 制作字幕
- (void)cellRightButtonClick:(UIButton *)button {
    VENMaterialDetailsPageModel *model = self.avInfoArr[button.tag];
    
    VENMaterialDetailsMakeSubtitlesPageViewController *vc = [[VENMaterialDetailsMakeSubtitlesPageViewController alloc] init];
    vc.source_period_id = model.id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 导航栏
- (void)setupNavigationView {
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.view addSubview:navigationView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(22, kStatusBarHeight, 44, 44)];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
    
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth - 44 - 11, kStatusBarHeight, 44, 44)];
    [moreButton setImage:[UIImage imageNamed:@"icon_more3"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:moreButton];
    
    _navigationView = navigationView;
}

#pragma mark - 返回
- (void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
    [[VENAudioPlayer sharedAudioPlayer] stop];
}

#pragma mark - 纠错
- (void)moreButtonClick {
    VENMaterialDetailsArticleCorrectionPageViewController *vc = [[VENMaterialDetailsArticleCorrectionPageViewController alloc] init];
    vc.source_id = self.infoModel.id;
    vc.type = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.navigationView.backgroundColor = [UIColor colorWithRed:255.0f / 255.0f green:255.0f / 255.0f blue:255.0f / 255.0f alpha:scrollView.contentOffset.y / kStatusBarAndNavigationBarHeight];
}

#pragma mark - NSNotificationCenter
- (void)refreshDetailPage:(NSNotification *)noti {
    if (![VENEmptyClass isEmptyDictionary:noti.userInfo]) {
        if ([noti.userInfo[@"type"] isEqualToString:@"3"]) {
            self.categoryViewContent = noti.userInfo[@"content"];
            self.categoryViewTitle = noti.userInfo[@"title"];
        } else {
            if ([noti.userInfo[@"content"] isEqualToString:@"left"]) {
                self.isTextInfo = NO;
            } else {
                self.isTextInfo = YES;
            }
        }
        
        [self.tableView reloadData];
    } else {
        [self loadVideoMaterialDetailsPageData];
    }
}

- (void)shrinkButtonClick:(NSNotification *)noti {
    UIButton *button = noti.userInfo[@"button"];
    self.numberOfLines = button.selected ? @"0" : @"3";
    
    [self.tableView reloadData];
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
