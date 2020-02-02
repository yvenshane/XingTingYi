//
//  VENPersonalMaterialDetailPageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2020/1/31.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENPersonalMaterialDetailPageViewController.h"
#import "VENMaterialDetailsPageModel.h"
#import "VENMaterialDetailsPageTableViewCellTwo.h"
#import "VENAudioPlayer.h"
#import "VENMaterialDetailsReadAloudPageViewController.h"
#import "VENMaterialDetailsTranslationPageViewController.h"
#import "VENMaterialDetailsPageHeaderView.h"
#import "VENMaterialDetailsPageMyDictationView.h"
#import "VENMaterialDetailsStartDictationPageViewController.h" // 继续听写
#import "VENMaterialDetailsMakeSubtitlesPageViewController.h" // 添加字幕
#import "VENMinePageMyNewWordBookViewController.h" // 添加生词
#import "VENMaterialPageAddPersonalMaterialViewController.h"

@interface VENPersonalMaterialDetailPageViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIView *navigationView; // 导航栏
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *myDictationView;
@property (weak, nonatomic) IBOutlet UIView *tableContentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myDictationViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableContentViewHeightLayoutConstraint;

@property (nonatomic, copy) NSDictionary *contentDict; // 总数据源
@property (nonatomic, strong) VENMaterialDetailsPageModel *infoModel;
@property (nonatomic, copy) NSArray *textInfoArr; // 朗读

@property (nonatomic, strong) UILabel *cellLabelTwo;
@property (nonatomic, strong) UILabel *cellLabelThree;

@property (nonatomic, copy) NSString *videoURL;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENPersonalMaterialDetailPageViewController

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
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.frame = CGRectZero;
    
    [self setupNavigationView];
    
    self.scrollView.delegate = self;
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    [self loadVideoMaterialDetailsPageData];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.videoURL = [userDefaults objectForKey:self.source_id];
}

- (void)loadVideoMaterialDetailsPageData {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"userSource/userSourceInfo" parameters:@{@"source_id" : self.source_id} successBlock:^(id responseObject) {
        
        self.contentDict = responseObject[@"content"];
        
        self.infoModel = [VENMaterialDetailsPageModel yy_modelWithJSON:responseObject[@"content"][@"sourceInfo"]];
        self.textInfoArr = [NSArray yy_modelArrayWithClass:[VENMaterialDetailsPageModel class] json:responseObject[@"content"][@"sourceText"]];
        
        // tableView height
        if (self.textInfoArr.count > 0) {
            CGFloat height = [self getTextInfoHeight];
            self.tableContentViewHeightLayoutConstraint.constant = height + 60;
            self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, height + 60);
        } else {
            self.tableContentViewHeightLayoutConstraint.constant = 30;
            self.tableView.frame = CGRectZero;
        }
        
        // bottomView
        [self setupBottomToolBar];
        // headerView
        [self setupHeaderView];
        // myDictationView
        [self setupMyDictationView];
        // tableView
        [self setupTableView];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.textInfoArr.count > 0) {
        return self.textInfoArr.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMaterialDetailsPageTableViewCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENMaterialDetailsPageModel *textInfoModel = self.textInfoArr[indexPath.row];
    
    cell.titleLabel.text = textInfoModel.content;
    
    NSString *contentStr = textInfoModel.info[@"content"];
    NSString *grammar = textInfoModel.info[@"grammar"];
    NSString *words = textInfoModel.info[@"words"];
    
    if (![VENEmptyClass isEmptyString:contentStr] && ![VENEmptyClass isEmptyString:grammar] && ![VENEmptyClass isEmptyString:words]) {
        cell.contentLabel.text = [NSString stringWithFormat:@"翻译：%@\n语法：%@\n单词：%@", contentStr, grammar, words];
    } else {
        cell.contentLabel.text = @"";
    }
    
    if (![VENEmptyClass isEmptyString:textInfoModel.readInfo[@"path"]]) {
        cell.buttonOne.selected = YES;
    }
    
    cell.buttonOneBlock = ^(UIButton *button) {
        if (button.selected) {
            [[VENAudioPlayer sharedAudioPlayer] playWithURL:[NSURL URLWithString:textInfoModel.readInfo[@"path"]]];
            [[VENAudioPlayer sharedAudioPlayer] play];
        }
    };
    
    cell.buttonTwoBlock = ^{
        VENMaterialDetailsReadAloudPageViewController *vc = [[VENMaterialDetailsReadAloudPageViewController alloc] init];
        vc.isPersonalMaterial = YES;
        vc.source_period_id = textInfoModel.id;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    cell.buttonThreeBlock = ^{
        VENMaterialDetailsTranslationPageViewController *vc = [[VENMaterialDetailsTranslationPageViewController alloc] init];
        vc.isPersonalMaterial = YES;
        vc.source_period_id = textInfoModel.id;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMaterialDetailsPageModel *textInfoModel = self.textInfoArr[indexPath.row];

    if (!textInfoModel.cellHeight) {
        return [self getTextInfoHeight] + 60;
    } else {
        return textInfoModel.cellHeight;
    }
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

#pragma mark - tableView
- (void)setupTableView {
    self.tableView.autoresizingMask = UIViewAutoresizingNone;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"VENMaterialDetailsPageTableViewCellTwo" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableContentView addSubview:self.tableView];
}

#pragma mark - TableView Height
- (CGFloat)getTextInfoHeight {
    CGFloat tableViewHeight = 0;
    for (VENMaterialDetailsPageModel *textInfoModel in self.textInfoArr) {
        self.cellLabelTwo.text = textInfoModel.content;
        
        NSString *contentStr = textInfoModel.info[@"content"];
        NSString *grammar = textInfoModel.info[@"grammar"];
        NSString *words = textInfoModel.info[@"words"];
        
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

#pragma mark - headerView
- (void)setupHeaderView {
    VENMaterialDetailsPageHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"VENMaterialDetailsPageHeaderView" owner:nil options:nil].lastObject;
    headerView.isPersonalMaterial = YES;
    headerView.videoURL = self.videoURL;
    self.headerViewHeightLayoutConstraint.constant = [headerView getHeightFromData:self.contentDict];
    [self.headerView addSubview:headerView];
}

#pragma mark - MyDictationView
- (void)setupMyDictationView {
    self.myDictationViewHeightLayoutConstraint.constant = 0.0f;
    
    if (![VENEmptyClass isEmptyString:self.infoModel.content]) {
        VENMaterialDetailsPageMyDictationView *myDictationView = [[NSBundle mainBundle] loadNibNamed:@"VENMaterialDetailsPageMyDictationView" owner:nil options:nil].lastObject;
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[self.infoModel.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
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
        
        BOOL isContinue = ![VENEmptyClass isEmptyArray:self.infoModel.dictation_tag_info];
        [leftButton setTitle:isContinue ? @"继续听写" : @"开始听写" forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(startDictation) forControlEvents:UIControlEventTouchUpInside];
        
        BOOL isModify = ![VENEmptyClass isEmptyArray:self.infoModel.subtitlesList];
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
    if ([VENEmptyClass isEmptyString:self.videoURL]) {
        
        BOOL isContinue = ![VENEmptyClass isEmptyArray:self.infoModel.dictation_tag_info];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@需要重新添加素材", isContinue ? @"继续听写" : @"开始听写"] message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *appropriateAction = [UIAlertAction actionWithTitle:@"去添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self pushToAddMaterialPage];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        [alert addAction:appropriateAction];

        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        VENMaterialDetailsStartDictationPageViewController *vc = [[VENMaterialDetailsStartDictationPageViewController alloc] init];
        vc.isPersonalMaterial = YES;
        vc.source_id = self.infoModel.id;
        vc.source_period_id = [VENEmptyClass isEmptyArray:self.infoModel.dictation_tag_info] ? @"0" : self.infoModel.dictation_tag_info[0][@"id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 制作字幕
- (void)makeSubtitles {
    if ([VENEmptyClass isEmptyString:self.videoURL]) {
        
        BOOL isModify = ![VENEmptyClass isEmptyArray:self.infoModel.subtitlesList];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@需要重新添加素材", isModify ? @"修改字幕" : @"制作字幕"] message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *appropriateAction = [UIAlertAction actionWithTitle:@"去添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self pushToAddMaterialPage];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        [alert addAction:appropriateAction];

        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        VENMaterialDetailsMakeSubtitlesPageViewController *vc = [[VENMaterialDetailsMakeSubtitlesPageViewController alloc] init];
        vc.isPersonalMaterial = YES;
        vc.source_period_id = [VENEmptyClass isEmptyArray:self.infoModel.dictation_tag_info] ? @"0" : self.infoModel.dictation_tag_info[0][@"id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)pushToAddMaterialPage {
    VENMaterialPageAddPersonalMaterialViewController *vc = [[VENMaterialPageAddPersonalMaterialViewController alloc] init];
    vc.name = self.infoModel.title;
    vc.picture = self.infoModel.image;
    vc.type = self.infoModel.type;
    vc.user_source_id = self.source_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 添加生词
- (void)addNewWords {
    VENMaterialDetailsPageModel *model = self.textInfoArr[0];
    
    VENMinePageMyNewWordBookViewController *vc = [[VENMinePageMyNewWordBookViewController alloc] init];
    vc.isPersonalMaterial = YES;
    vc.source_id = model.info[@"source_id"];
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

#pragma mark - 导航栏
- (void)setupNavigationView {
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kStatusBarAndNavigationBarHeight)];
    [self.view addSubview:navigationView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(22, kStatusBarHeight, 44, 44)];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
        
    _navigationView = navigationView;
}

#pragma mark - 返回
- (void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
    [[VENAudioPlayer sharedAudioPlayer] stop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.navigationView.backgroundColor = [UIColor colorWithRed:255.0f / 255.0f green:255.0f / 255.0f blue:255.0f / 255.0f alpha:scrollView.contentOffset.y / kStatusBarAndNavigationBarHeight];
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
