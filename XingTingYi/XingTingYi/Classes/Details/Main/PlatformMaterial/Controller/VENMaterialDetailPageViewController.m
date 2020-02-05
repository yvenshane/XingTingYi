//
//  VENMaterialDetailPageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/18.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailPageViewController.h"
#import "VENMaterialDetailsPageHeaderView.h"
#import "VENMaterialDetailsPageFooterView.h"
#import "VENMaterialDetailsPageTableViewCell.h"
#import "VENMaterialDetailsPageTableViewCellTwo.h"
#import "VENMaterialDetailsPageModel.h"
#import "VENBaseWebViewController.h" // H5
#import "VENMaterialDetailsArticleCorrectionPageViewController.h" // 文章纠错
#import "VENMaterialDetailsStartDictationPageViewController.h" // 开始听写
#import "VENMaterialDetailsMakeSubtitlesPageViewController.h" // 制作字幕
#import "VENMaterialDetailsReadAloudPageViewController.h" // 朗读
#import "VENMaterialDetailsTranslationPageViewController.h" // 翻译
#import "VENMinePageMyNewWordBookViewController.h" // 添加生词
#import "VENAudioPlayer.h" // 播放器
#import "VENMaterialDetailsPageCategoryView.h" // 提示词/生词汇总/标准答案
#import "VENMaterialDetailsPageMyDictationView.h" // 我的听写
#import "VENMaterialDetailsSubtitlesDetailsPageViewController.h" // 字幕详情
#import "VENMaterialDetailsSubtitlesPopupView.h"

@interface VENMaterialDetailPageViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIView *navigationView; // 导航栏
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIView *categoryView;
@property (weak, nonatomic) IBOutlet UIView *categoryViewBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *categoryContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *categoryLockButton;
@property (weak, nonatomic) IBOutlet UIView *myDictationView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *tableContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myDictationViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footerViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableContentViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomLayoutConstraint;

@property (nonatomic, copy) NSDictionary *contentDict; // 总数据源
@property (nonatomic, strong) VENMaterialDetailsPageModel *infoModel;
@property (nonatomic, copy) NSArray *avInfoArr; // 听写
@property (nonatomic, copy) NSArray *textInfoArr; // 朗读

@property (nonatomic, assign) BOOL isTextInfo;

@property (nonatomic, strong) UILabel *cellLabelOne;
@property (nonatomic, strong) UILabel *cellLabelTwo;
@property (nonatomic, strong) UILabel *cellLabelThree;

@property (nonatomic, strong) VENMaterialDetailsSubtitlesPopupView *popupView;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
static NSString *const cellIdentifier2 = @"cellIdentifier2";
@implementation VENMaterialDetailPageViewController

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
    
    self.tableView.frame = CGRectZero;
    
    [self setupNavigationView];
    
    self.scrollView.delegate = self;
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    [self loadVideoMaterialDetailsPageData];
}

- (void)loadVideoMaterialDetailsPageData {
    NSString *url = @"";
    NSDictionary *parameters = @{};
    
    if (self.isExcellentCourse) {
        url = @"goodCourse/myGoodCourseInfo";
        parameters = @{@"source_id" : self.id};
    } else {
        url = @"source/sourceInfo";
        parameters = @{@"id" : self.id};
    }
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:url parameters:parameters successBlock:^(id responseObject) {
        
        self.contentDict = responseObject[@"content"];
        
        self.infoModel = [VENMaterialDetailsPageModel yy_modelWithJSON:responseObject[@"content"][@"info"]];
        self.avInfoArr = [NSArray yy_modelArrayWithClass:[VENMaterialDetailsPageModel class] json:responseObject[@"content"][@"avInfo"]];
        self.textInfoArr = [NSArray yy_modelArrayWithClass:[VENMaterialDetailsPageModel class] json:responseObject[@"content"][@"textInfo"]];
        
        // tableView height
        if (self.avInfoArr.count > 1 && self.textInfoArr.count > 0) {
            if (self.isTextInfo) {
                CGFloat height = [self getTextInfoHeight];
                self.tableContentViewHeightLayoutConstraint.constant = height + 60;
                self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, height + 60);
            } else {
                if (self.avInfoArr.count > 1) {
                    CGFloat height = [self getAvInfoHeight];
                    self.tableContentViewHeightLayoutConstraint.constant = height;
                    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, height);
                } else {
                    self.tableContentViewHeightLayoutConstraint.constant = 0;
                    self.tableView.frame = CGRectZero;
                }
            }
        } else if (self.avInfoArr.count > 1 && self.textInfoArr.count < 1) {
            CGFloat height = [self getAvInfoHeight];
            self.tableContentViewHeightLayoutConstraint.constant = height;
            self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, height);
        } else if (self.avInfoArr.count < 2 && self.textInfoArr.count > 0) {
            CGFloat height = [self getTextInfoHeight];
//            if ([self.infoModel.type isEqualToString:@"3"]) {
//                self.tableContentViewHeightLayoutConstraint.constant = height;
//                self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, height);
//            } else {
//                self.tableContentViewHeightLayoutConstraint.constant = height + 60;
//                self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, height + 60);
//            }
            
            self.tableContentViewHeightLayoutConstraint.constant = height + 60;
            self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, height + 60);
        } else {
            self.tableContentViewHeightLayoutConstraint.constant = 30;
            self.tableView.frame = CGRectZero;
        }
        
        // bottomView
        if ([self.infoModel.type isEqualToString:@"1"] || [self.infoModel.type isEqualToString:@"2"] || [self.infoModel.type isEqualToString:@"3"]) {
            if (self.avInfoArr.count > 1) {
                self.scrollViewBottomLayoutConstraint.constant = 0;
            } else {
                [self setupBottomToolBar];
                self.scrollViewBottomLayoutConstraint.constant = (kTabBarHeight - 49) + 60;
            }
        } else {
            self.scrollViewBottomLayoutConstraint.constant = 0;
        }
        
        // headerView
        [self setupHeaderView];
        // footerView
        [self setupCategoryView];
        // myDictationView
        [self setupMyDictationView];
        // footerView
        [self setupFooterView];
        // tableView
        [self setupTableView];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.avInfoArr.count > 1 && self.textInfoArr.count > 0) {
        if (self.isTextInfo) {
            return self.textInfoArr.count;
        } else {
            if (self.avInfoArr.count > 1) {
                return self.avInfoArr.count;
            } else {
                return 0;
            }
        }
    } else if (self.avInfoArr.count > 1 && self.textInfoArr.count < 1) {
        return self.avInfoArr.count;
    } else if (self.avInfoArr.count < 2 && self.textInfoArr.count > 0) {
        self.isTextInfo = YES;
        return self.textInfoArr.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isTextInfo) {
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
            vc.isExcellentCourse = self.isExcellentCourse;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        cell.buttonThreeBlock = ^{
            VENMaterialDetailsTranslationPageViewController *vc = [[VENMaterialDetailsTranslationPageViewController alloc] init];
            vc.source_period_id = textInfoModel.id;
            vc.isExcellentCourse = self.isExcellentCourse;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isTextInfo) {
        VENMaterialDetailsPageModel *avInfoModel = self.avInfoArr[indexPath.row];
        
        if (!avInfoModel.cellHeight) {
            return [self getAvInfoHeight];
        } else {
            return avInfoModel.cellHeight;
        }
    } else {
        VENMaterialDetailsPageModel *textInfoModel = self.textInfoArr[indexPath.row];

        if (!textInfoModel.cellHeight) {
            return [self getTextInfoHeight] + 60;
        } else {
            return textInfoModel.cellHeight;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.isTextInfo) {
        if ([self.infoModel.type isEqualToString:@"4"] || [self.infoModel.type isEqualToString:@"5"]) {
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - 60 - (kTabBarHeight - 49), kMainScreenWidth, 60)];
            footerView.backgroundColor = [UIColor whiteColor];

            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 1)];
            lineView.backgroundColor = UIColorFromRGB(0xF1F1F1);
            [footerView addSubview:lineView];

            CGFloat width = (kMainScreenWidth - 40 - 15) / 2;

            UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, width, 40)];
            leftButton.backgroundColor = UIColorFromRGB(0xFFDE02);
            [leftButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
            leftButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            leftButton.layer.cornerRadius = 20.0f;
            leftButton.layer.masksToBounds = YES;
            [leftButton addTarget:self action:@selector(addNewWords) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:leftButton];

            UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(20 + width + 15, 10, (kMainScreenWidth - 40 - 15) / 2, 40)];
            rightButton.backgroundColor = UIColorFromRGB(0x222222);
            [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            rightButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
            rightButton.layer.cornerRadius = 20.0f;
            rightButton.layer.masksToBounds = YES;
            [rightButton addTarget:self action:@selector(syntheticRecording) forControlEvents:UIControlEventTouchUpInside];
            [footerView addSubview:rightButton];

            [leftButton setTitle:@"添加生词" forState:UIControlStateNormal];

            if ([VENEmptyClass isEmptyString:self.infoModel.merge_audio]) {
                [rightButton setTitle:@"合成录音" forState:UIControlStateNormal];
            } else {
                [rightButton setTitle:@"再次合成录音" forState:UIControlStateNormal];
            }

            return footerView;
        } else {
            return [[UIView alloc] init];
        }
    } else {
        return [[UIView alloc] init];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.isTextInfo) {
        if ([self.infoModel.type isEqualToString:@"4"] || [self.infoModel.type isEqualToString:@"5"]) {
            return 60.0f;
        } else {
            return CGFLOAT_MIN;
        }
    } else {
        return CGFLOAT_MIN;
    }
}

- (void)setupBottomToolBar {
    UIView *bottomToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight - 60 - (kTabBarHeight - 49), kMainScreenWidth, 60 + (kTabBarHeight - 49))];
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
    [bottomToolBar addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(20 + width + 15, 10, (kMainScreenWidth - 40 - 15) / 2, 40)];
    rightButton.backgroundColor = UIColorFromRGB(0x222222);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    rightButton.layer.cornerRadius = 20.0f;
    rightButton.layer.masksToBounds = YES;
    [bottomToolBar addSubview:rightButton];
    
    // 1音频 2视频 3文本 4音频文本 5视频文本
    if ([self.infoModel.type isEqualToString:@"1"] || [self.infoModel.type isEqualToString:@"2"]) {
        VENMaterialDetailsPageModel *avInfoModel = self.avInfoArr[0];
        
        BOOL isContinue = ![VENEmptyClass isEmptyString:avInfoModel.dictationInfo[@"id"]];
        [leftButton setTitle:isContinue ? @"继续听写" : @"开始听写" forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(startDictation) forControlEvents:UIControlEventTouchUpInside];
        
        BOOL isModify = ![VENEmptyClass isEmptyArray:avInfoModel.subtitlesList];
        [rightButton setTitle:isModify ? @"修改字幕" : @"制作字幕" forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(makeSubtitles) forControlEvents:UIControlEventTouchUpInside];
    } else if ([self.infoModel.type isEqualToString:@"3"]) {
        [leftButton setTitle:@"添加生词" forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(addNewWords) forControlEvents:UIControlEventTouchUpInside];
        
        if ([VENEmptyClass isEmptyString:self.infoModel.merge_audio]) {
            [rightButton setTitle:@"合成录音" forState:UIControlStateNormal];
        } else {
            [rightButton setTitle:@"再次合成录音" forState:UIControlStateNormal];
        }
        
        [rightButton addTarget:self action:@selector(syntheticRecording) forControlEvents:UIControlEventTouchUpInside];
    } else {
        
    }
}

#pragma mark - 开始听写/继续听写
- (void)startDictation {
    VENMaterialDetailsPageModel *model = self.avInfoArr[0];
    
    VENMaterialDetailsStartDictationPageViewController *vc = [[VENMaterialDetailsStartDictationPageViewController alloc] init];
    vc.source_id = self.infoModel.id;
    vc.source_period_id = model.id;
    vc.isExcellentCourse = self.isExcellentCourse;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - cell 开始听写
- (void)cellLeftButtonClick:(UIButton *)button {
    VENMaterialDetailsPageModel *model = self.avInfoArr[button.tag];
    
    VENMaterialDetailsStartDictationPageViewController *vc = [[VENMaterialDetailsStartDictationPageViewController alloc] init];
    vc.source_id = self.infoModel.id;
    vc.source_period_id = model.id;
    vc.isSectionDictation = YES;
    vc.isExcellentCourse = self.isExcellentCourse;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 制作字幕
- (void)makeSubtitles {
    VENMaterialDetailsPageModel *model = self.avInfoArr[0];
    
    VENMaterialDetailsMakeSubtitlesPageViewController *vc = [[VENMaterialDetailsMakeSubtitlesPageViewController alloc] init];
    vc.source_period_id = model.id;
    vc.isExcellentCourse = self.isExcellentCourse;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - cell 制作字幕
- (void)cellRightButtonClick:(UIButton *)button {
    VENMaterialDetailsPageModel *model = self.avInfoArr[button.tag];
    
    VENMaterialDetailsMakeSubtitlesPageViewController *vc = [[VENMaterialDetailsMakeSubtitlesPageViewController alloc] init];
    vc.source_period_id = model.id;
    vc.isExcellentCourse = self.isExcellentCourse;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 添加生词
- (void)addNewWords {
    VENMaterialDetailsPageModel *model = self.textInfoArr[0];
    
    VENMinePageMyNewWordBookViewController *vc = [[VENMinePageMyNewWordBookViewController alloc] init];
    vc.source_id = model.source_id;
    vc.isExcellentCourse = self.isExcellentCourse;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 合成录音
- (void)syntheticRecording {
    NSDictionary *parameters = @{@"source_id" : self.infoModel.id,
                                 @"type" : @"1"};
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"qiniu/mergeAudioInfo" parameters:parameters successBlock:^(id responseObject) {
        
        [self loadVideoMaterialDetailsPageData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - tableView
- (void)setupTableView {
    self.tableView.autoresizingMask = UIViewAutoresizingNone;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"VENMaterialDetailsPageTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"VENMaterialDetailsPageTableViewCellTwo" bundle:nil] forCellReuseIdentifier:cellIdentifier2];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableContentView addSubview:self.tableView];
}

#pragma mark - footerView
- (void)setupFooterView {
    VENMaterialDetailsPageFooterView *footerView = [[NSBundle mainBundle] loadNibNamed:@"VENMaterialDetailsPageFooterView" owner:nil options:nil].lastObject;
    CGFloat footerViewHeight = [footerView getHeightFromData:self.contentDict];
    self.footerViewHeightLayoutConstraint.constant = footerViewHeight;
    
    __weak typeof(self) weakSelf = self;
    footerView.categoryButtonBlock = ^(NSInteger tag, BOOL isShowAudioView) {
        if (tag == 998) {
            weakSelf.isTextInfo = NO;
            
            CGFloat height = [weakSelf getAvInfoHeight];
            weakSelf.tableContentViewHeightLayoutConstraint.constant = height;
            weakSelf.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, height);
            
            [weakSelf.tableView reloadData];
            
//            weakSelf.footerViewHeightLayoutConstraint.constant = height;
        } else {
            weakSelf.isTextInfo = YES;
            
            CGFloat height = [weakSelf getTextInfoHeight];
            weakSelf.tableContentViewHeightLayoutConstraint.constant = height + 60;
            weakSelf.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, height + 60);
            
            [weakSelf.tableView reloadData];
            
//            weakSelf.footerViewHeightLayoutConstraint.constant = isShowAudioView ? height + (kMainScreenWidth - 40) / (335.0 / 120.0) + 25 : height;
        }
    };
    
    footerView.bottomViewButtonBlock = ^(NSInteger tag) {
        if (tag == 996) { // 开始听写
            VENMaterialDetailsPageModel *model = self.avInfoArr[0];
            
            VENMaterialDetailsStartDictationPageViewController *vc = [[VENMaterialDetailsStartDictationPageViewController alloc] init];
            vc.source_id = self.infoModel.id;
            vc.source_period_id = model.id;
            vc.isExcellentCourse = self.isExcellentCourse;
            [self.navigationController pushViewController:vc animated:YES];
        } else { // 制作字幕
            VENMaterialDetailsPageModel *model = self.avInfoArr[0];
            
            VENMaterialDetailsMakeSubtitlesPageViewController *vc = [[VENMaterialDetailsMakeSubtitlesPageViewController alloc] init];
            vc.source_period_id = model.id;
            vc.isExcellentCourse = self.isExcellentCourse;
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    
    [self.footerView addSubview:footerView];
}

#pragma mark - MyDictationView
- (void)setupMyDictationView {
    self.myDictationViewHeightLayoutConstraint.constant = 0.0f;
    
    VENMaterialDetailsPageModel *avInfoModel;
    if (self.avInfoArr.count > 0) {
        avInfoModel = self.avInfoArr[0];
    }
    
    if (![VENEmptyClass isEmptyString:avInfoModel.dictationInfo[@"content"]]) {
        VENMaterialDetailsPageMyDictationView *myDictationView = [[NSBundle mainBundle] loadNibNamed:@"VENMaterialDetailsPageMyDictationView" owner:nil options:nil].lastObject;
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[avInfoModel.dictationInfo[@"content"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        myDictationView.contentLabel.attributedText = attributedString;
        
        __weak typeof(self) weakSelf = self;
        myDictationView.myDictationViewBlock = ^(CGFloat height) {
            weakSelf.myDictationViewHeightLayoutConstraint.constant = 135 + height;
        };
        [self.myDictationView addSubview:myDictationView];
        
        CGFloat height = [myDictationView.contentLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 35 * 2, CGFLOAT_MAX)].height;
        myDictationView.frame = CGRectMake(0, 0, kMainScreenWidth, 135 + height);
        self.myDictationViewHeightLayoutConstraint.constant = 135 + height;
    }
}

#pragma mark - CategoryView
- (void)setupCategoryView {
    self.categoryViewHeightLayoutConstraint.constant = 0.0f;
    
    VENMaterialDetailsPageModel *avInfoModel;
    if (self.avInfoArr.count > 0) {
        avInfoModel = self.avInfoArr[0];
    }
        
    if (![VENEmptyClass isEmptyString:self.infoModel.notice] && ![VENEmptyClass isEmptyString:self.infoModel.words] && ![VENEmptyClass isEmptyString:self.infoModel.answer]) {
        // button
        VENMaterialDetailsPageCategoryView *categoryVieww = [[VENMaterialDetailsPageCategoryView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 25)];
        categoryVieww.titleArr = @[@"提示词", @"生词汇总", @"标准答案"];
        __weak typeof(self) weakSelf = self;
        categoryVieww.buttonClickBlock = ^(UIButton *button) {
            
            weakSelf.categoryLockButton.hidden = YES;
            weakSelf.categoryContentLabel.hidden = NO;
            
            if (button.tag == 0) {
                weakSelf.categoryContentLabel.text = weakSelf.infoModel.notice;
            } else if (button.tag == 1) {
                weakSelf.categoryContentLabel.text = weakSelf.infoModel.words;
            } else {
                weakSelf.categoryContentLabel.text = weakSelf.infoModel.answer;
            }
            
            CGFloat height = [weakSelf.categoryContentLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 20 * 2 - 15 * 2, CGFLOAT_MAX)].height;
            weakSelf.categoryViewHeightLayoutConstraint.constant = 45 + height + 15 * 2;
            
            if ([button.titleLabel.text isEqualToString:@"标准答案"]) {
                if ([VENEmptyClass isEmptyString:avInfoModel.dictationInfo[@"id"]]) {
                    weakSelf.categoryLockButton.hidden = NO;
                    weakSelf.categoryContentLabel.hidden = YES;
                    weakSelf.categoryViewHeightLayoutConstraint.constant = 45 + 120;
                }
            }
        };
        [self.categoryView addSubview:categoryVieww];
        
        // content
        self.categoryViewBackgroundView.layer.cornerRadius = 8.0f;
        self.categoryViewBackgroundView.layer.masksToBounds = YES;
        
        self.categoryViewBackgroundView.hidden = NO;
        
        weakSelf.categoryContentLabel.text = self.infoModel.notice;
        CGFloat height = [weakSelf.categoryContentLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 20 * 2 - 15 * 2, CGFLOAT_MAX)].height;
        weakSelf.categoryViewHeightLayoutConstraint.constant = 45 + height + 15 * 2;
    }
}

#pragma mark - headerView
- (void)setupHeaderView {
    VENMaterialDetailsPageHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"VENMaterialDetailsPageHeaderView" owner:nil options:nil].lastObject;
    self.headerViewHeightLayoutConstraint.constant = [headerView getHeightFromData:self.contentDict];
    [self.headerView addSubview:headerView];
    
    headerView.contentButtonBlock = ^{
        VENBaseWebViewController *vc = [[VENBaseWebViewController alloc] init];
        vc.HTMLString = self.infoModel.descriptionn;
        vc.navigationItem.title = @"简介";
        vc.isPresent = YES;
        VENNavigationController *nav = [[VENNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    };
    
    // 查看字幕详情
    headerView.subtitleButtonBlock = ^{
        VENMaterialDetailsPageModel *model = self.avInfoArr[0];
        
        VENMaterialDetailsSubtitlesDetailsPageViewController *vc = [[VENMaterialDetailsSubtitlesDetailsPageViewController alloc] init];
        vc.audioURL = self.infoModel.source_path;
        vc.subtitles = self.infoModel.subtitles;
        vc.subtitlesList = model.subtitlesList;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    // 播放器字幕按钮
    headerView.subtitlesButtonBlock = ^(UIButton *button) {
        if (button.selected) {
            button.selected = NO;
            self.popupView.hidden = YES;
        } else {
            button.selected = YES;
            self.popupView.hidden = NO;
        }
    };
    
    // popupView
    headerView.popupViewBlock = ^(NSString *content) {
        self.popupView.contentLabel.text = content;
    };
}

- (VENMaterialDetailsSubtitlesPopupView *)popupView {
    if (!_popupView) {
        _popupView = [[[NSBundle mainBundle] loadNibNamed:@"VENMaterialDetailsSubtitlesPopupView" owner:nil options:nil] firstObject];
        _popupView.frame = CGRectMake(0, kMainScreenHeight - 64 - 10 - (kTabBarHeight - 49) - kStatusBarAndNavigationBarHeight, kMainScreenWidth, 64);
        _popupView.hidden = YES;
        [self.view addSubview:_popupView];
    }
    return _popupView;
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

#pragma mark - TableView Height
- (CGFloat)getAvInfoHeight {
    CGFloat tableViewHeight = 0;
    for (VENMaterialDetailsPageModel *avInfoModel in self.avInfoArr) {
        self.cellLabelOne.text = avInfoModel.subtitle;

        CGFloat labelHeight = [self.cellLabelOne sizeThatFits:CGSizeMake(kMainScreenWidth - 40 - 75 - 35, CGFLOAT_MAX)].height;
        CGFloat height = 5 + 25 + 20 + 1 + 44 + 15 + labelHeight;

        avInfoModel.cellHeight = height;
        tableViewHeight += height;
    }
    return tableViewHeight;
}

- (CGFloat)getTextInfoHeight {
    CGFloat tableViewHeight = 0;
    for (VENMaterialDetailsPageModel *textInfoModel in self.textInfoArr) {
        self.cellLabelTwo.text = textInfoModel.content;
        
        NSString *contentStr = textInfoModel.translation[@"content"];
        NSString *grammar = textInfoModel.translation[@"grammar"];
        NSString *words = textInfoModel.translation[@"words"];
        
        if (![VENEmptyClass isEmptyString:contentStr] && ![VENEmptyClass isEmptyString:grammar] && ![VENEmptyClass isEmptyString:words]) {
            self.cellLabelThree.text = [NSString stringWithFormat:@"翻译：%@\n语法：%@\n单词：%@", contentStr, grammar, words];
        } else {
            self.cellLabelThree.text = @"";
        }
        
        CGFloat labelHeight = [self.cellLabelTwo sizeThatFits:CGSizeMake(kMainScreenWidth - 40 - 30, CGFLOAT_MAX)].height;
        CGFloat labelHeight2 = [self.cellLabelThree sizeThatFits:CGSizeMake(kMainScreenWidth - 40 - 30, CGFLOAT_MAX)].height;
        CGFloat height = 5 + 15 + labelHeight + 10 + labelHeight2 + 10 + 40 + 15 + 5;
        
        textInfoModel.cellHeight = height;
        tableViewHeight += height;
    }
    return tableViewHeight;
}

- (UILabel *)cellLabelOne {
    if (!_cellLabelOne) {
        _cellLabelOne = [[UILabel alloc] init];
        _cellLabelOne.font = [UIFont systemFontOfSize:15.0f weight:UIFontWeightMedium];
        _cellLabelOne.numberOfLines = 2;
    }
    return _cellLabelOne;
}

- (UILabel *)cellLabelTwo {
    if (!_cellLabelTwo) {
        _cellLabelTwo = [[UILabel alloc] init];
        _cellLabelTwo.font = [UIFont systemFontOfSize:14.0f];
        _cellLabelTwo.numberOfLines = 0;
    }
    return _cellLabelTwo;
}

- (UILabel *)cellLabelThree {
    if (!_cellLabelThree) {
        _cellLabelThree = [[UILabel alloc] init];
        _cellLabelThree.font = [UIFont systemFontOfSize:14.0f];
        _cellLabelThree.numberOfLines = 0;
    }
    return _cellLabelThree;
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
