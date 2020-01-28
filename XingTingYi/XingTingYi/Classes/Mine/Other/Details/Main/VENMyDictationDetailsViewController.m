//
//  VENMyDictationDetailsViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/31.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyDictationDetailsViewController.h"
#import "VENMyDictationDetailsRecordingPageViewController.h"
#import "VENMyDictationDetailsTranslationPageViewController.h"
#import "VENMaterialDetailsPageModel.h"
#import "VENAudioPlayerView.h"
#import "VENMaterialDetailPageViewController.h"
#import "VENMaterialDetailsPageTableViewCellTwo.h"
#import "VENAudioPlayer.h"
#import "VENMyDictationDetailsLabelPageViewController.h"
#import "VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController.h"

@interface VENMyDictationDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
// 标签工具栏
@property (weak, nonatomic) IBOutlet UIView *labelContentView;
@property (weak, nonatomic) IBOutlet UIView *labelView;
// 音频播放器
@property (weak, nonatomic) IBOutlet UIView *audioContentView;
// 中间工具栏 播放/录音/翻译/添加生词
@property (weak, nonatomic) IBOutlet UIView *middleToolsBarContentView;
@property (weak, nonatomic) IBOutlet UIView *middleToolsBar;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *recordingButton;
@property (weak, nonatomic) IBOutlet UIButton *translationButton;
@property (weak, nonatomic) IBOutlet UIButton *addNewWordsBookButton;

@property (weak, nonatomic) IBOutlet UIView *middleToolsBarContentView2;
@property (weak, nonatomic) IBOutlet UIButton *addNewWordsBookButton2;

// 底部视图
@property (weak, nonatomic) IBOutlet UIView *bottomContentView;
// 底部工具栏 删除听写/重新听写
@property (weak, nonatomic) IBOutlet UIView *bottomToolsBar;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelContentViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *audioContentViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleToolsBarContentViewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleToolsBarContentViewHeightLayoutConstraint2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomContentViewHeightLayoutConstarint;

@property (nonatomic, strong) VENAudioPlayerView *audioPlayerView;
@property (nonatomic, strong) UILabel *cellLabelTwo;
@property (nonatomic, strong) UILabel *cellLabelThree;

@property (nonatomic, copy) NSArray *avInfoOriginalArr;
@property (nonatomic, strong) NSMutableArray *avInfoNewMuArr;
@property (nonatomic, strong) VENMaterialDetailsPageModel *infoModel;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMyDictationDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"听写详情";
    
    self.pictureImageView.layer.cornerRadius = 4.0f;
    self.pictureImageView.layer.masksToBounds = YES;
    
    self.addNewWordsBookButton.layer.cornerRadius = 20.0f;
    self.addNewWordsBookButton.layer.masksToBounds = YES;
    
    [self setupBottomToolBar];
    [self loadMyDictationDetailsPageData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMyOtherDetailPage:) name:@"RefreshMyOtherDetailPage" object:nil];
}

- (void)refreshMyOtherDetailPage:(NSNotification *)noti {
    
    for (UIView *subviews in self.bottomContentView.subviews) {
        [subviews removeFromSuperview];
    }

    [self loadMyDictationDetailsPageData];
    [self.tableView reloadData];
}

- (void)loadMyDictationDetailsPageData {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"source/sourceInfo" parameters:@{@"id" : self.source_id} successBlock:^(id responseObject) {
        
        self.avInfoOriginalArr = [NSArray yy_modelArrayWithClass:[VENMaterialDetailsPageModel class] json:responseObject[@"content"][@"avInfo"]];
        
        [self.avInfoNewMuArr removeAllObjects];
        for (VENMaterialDetailsPageModel *model in self.avInfoOriginalArr) {
            if (![VENEmptyClass isEmptyString:model.dictationInfo[@"content"]]) {
                [self.avInfoNewMuArr addObject:model];
            }
        }
        
        if (self.avInfoOriginalArr.count > 1) {
            // tableView
            [self setupTableView];
            
            CGFloat height = [self getAvInfoHeight];
            self.bottomContentViewHeightLayoutConstarint.constant = height;
            self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, height);
        } else {
            self.bottomContentViewHeightLayoutConstarint.constant = 0;
        }
        
        [self setupContentWithDict:responseObject[@"content"]];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)setupContentWithDict:(NSDictionary *)dict {
    
    self.infoModel = [VENMaterialDetailsPageModel yy_modelWithJSON:dict[@"info"]];
    
    self.pictureImageView.contentMode = UIViewContentModeScaleToFill;
    [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:self.infoModel.image]];
    self.titleLabel.text = self.infoModel.title;
    self.dateLabel.text = self.infoModel.created_at;
    
    if ([self.infoModel.type isEqualToString:@"1"]) {
        self.tagImageView.image = [UIImage imageNamed:@"icon_tag_audio"];
    } else if ([self.infoModel.type isEqualToString:@"2"]) {
        self.tagImageView.image = [UIImage imageNamed:@"icon_tag_video"];
    } else if ([self.infoModel.type isEqualToString:@"3"]) {
        self.tagImageView.image = [UIImage imageNamed:@"icon_tag_text"];
    }  else if ([self.infoModel.type isEqualToString:@"4"]) {
        self.tagImageView.image = [UIImage imageNamed:@"icon_tag_audio_text"];
    }  else if ([self.infoModel.type isEqualToString:@"5"]) {
        self.tagImageView.image = [UIImage imageNamed:@"icon_tag_video_text"];
    }
    
    // 标签
    self.labelContentView.hidden = YES;
    self.labelContentViewHeightLayoutConstraint.constant = 0.0f;
    
    if (![VENEmptyClass isEmptyArray:self.infoModel.dictation_tag]) {
        self.labelContentView.hidden = NO;
        self.labelContentViewHeightLayoutConstraint.constant = 40.0f;
        
        CGFloat x = 0.0f;
        
        for (NSInteger i = 0; i < self.infoModel.dictation_tag.count; i++) {
            UIButton *button = [[UIButton alloc] init];
            button.tag = i;
            [button setTitle:self.infoModel.dictation_tag[i][@"name"] forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
            
            button.layer.cornerRadius = 15.0f;
            button.layer.masksToBounds = YES;
            button.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
            button.layer.borderWidth = 0.5f;
            
            [button addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            CGFloat width = [button.titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 15.0f)].width + 24;
            
            if (x + width + 10 > kMainScreenWidth - 62 - 20) {
                return;
            }
            
            button.frame = CGRectMake(x, 0, width, 30);
            
            [self.labelView addSubview:button];
            
            x += width + 10;
        }
    }
    
    VENMaterialDetailsPageModel *avInfoModel = self.avInfoOriginalArr[0];
    
    // 播放器
    self.audioContentView.hidden = YES;
    self.audioContentViewHeightLayoutConstraint.constant = 0.0f;
    
    if (![VENEmptyClass isEmptyString:avInfoModel.path]) {
        self.audioContentView.hidden = NO;
        
        self.audioPlayerView.audioURL = avInfoModel.path;
        // audio
        self.audioContentView.layer.cornerRadius = 8.0f;
        self.audioContentView.layer.masksToBounds = YES;
        
        CGFloat audioHeight = (kMainScreenWidth - 40) / (335.0 / 120.0);
        self.audioContentViewHeightLayoutConstraint.constant = audioHeight + 30;
        
        self.audioPlayerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.audioContentView.frame), CGRectGetHeight(self.audioContentView.frame) - 30);
    }
    
    // middleToolsBar
    if (self.avInfoOriginalArr.count > 1) {
        self.middleToolsBarContentView.hidden = YES;
        self.middleToolsBarContentViewHeightLayoutConstraint.constant = 0.0f;
        self.middleToolsBarContentView2.hidden = NO;
        self.middleToolsBarContentViewHeightLayoutConstraint2.constant = 60.0f;
    } else {
        self.middleToolsBarContentView.hidden = NO;
        self.middleToolsBarContentViewHeightLayoutConstraint.constant = 70.0f;
        self.middleToolsBarContentView2.hidden = YES;
        self.middleToolsBarContentViewHeightLayoutConstraint2.constant = 0.0f;
        
        // content
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[avInfoModel.dictationInfo[@"content"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        UILabel *contenLabel = [[UILabel alloc] init];
        contenLabel.textColor = UIColorFromRGB(0x222222);
        contenLabel.font = [UIFont systemFontOfSize:14.0f];
        contenLabel.attributedText = attributedString;
        contenLabel.numberOfLines = 0;
        
        CGFloat height = [contenLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 40, CGFLOAT_MAX)].height;
        contenLabel.frame = CGRectMake(20, 0, kMainScreenWidth - 40, height);
        
        [self.bottomContentView addSubview:contenLabel];
        
        self.bottomContentViewHeightLayoutConstarint.constant = height;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.avInfoNewMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMaterialDetailsPageTableViewCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENMaterialDetailsPageModel *avInfoModel = self.avInfoNewMuArr[indexPath.row];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[avInfoModel.dictationInfo[@"content"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    cell.titleLabel.attributedText = attributedString;
    
    NSString *contentStr = avInfoModel.dictationInfo[@"translation"][@"content"];
    NSString *grammar = avInfoModel.dictationInfo[@"translation"][@"grammar"];
    NSString *words = avInfoModel.dictationInfo[@"translation"][@"words"];
    
    if (![VENEmptyClass isEmptyString:contentStr] && ![VENEmptyClass isEmptyString:grammar] && ![VENEmptyClass isEmptyString:words]) {
        cell.contentLabel.text = [NSString stringWithFormat:@"翻译：%@\n语法：%@\n单词：%@", contentStr, grammar, words];
    } else {
        cell.contentLabel.text = @"";
    }
    
    if (![VENEmptyClass isEmptyString:avInfoModel.path]) {
        cell.buttonOne.selected = YES;
    }
    
    // 播放
    cell.buttonOneBlock = ^(UIButton *button) {
        if (button.selected) {
            [[VENAudioPlayer sharedAudioPlayer] playWithURL:[NSURL URLWithString:avInfoModel.path]];
            [[VENAudioPlayer sharedAudioPlayer] play];
        }
    };
    
    // 录音
    cell.buttonTwoBlock = ^{
        VENMyDictationDetailsRecordingPageViewController *vc = [[VENMyDictationDetailsRecordingPageViewController alloc] init];
        vc.source_id = avInfoModel.dictationInfo[@"source_id"];
        vc.source_period_id = avInfoModel.dictationInfo[@"source_period_id"];
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    //翻译
    cell.buttonThreeBlock = ^{
        VENMyDictationDetailsTranslationPageViewController *vc = [[VENMyDictationDetailsTranslationPageViewController alloc] init];
        vc.source_id = avInfoModel.dictationInfo[@"source_id"];
        vc.source_period_id = avInfoModel.dictationInfo[@"source_period_id"];
        vc.type = @"1"; // 平台素材
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMaterialDetailsPageModel *avInfoModel = self.avInfoNewMuArr[indexPath.row];
    
    if (!avInfoModel.cellHeight) {
        return [self getAvInfoHeight];
    } else {
        return avInfoModel.cellHeight;
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
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"VENMaterialDetailsPageTableViewCellTwo" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.bottomContentView addSubview:self.tableView];
}

#pragma mark - TableView Height
- (CGFloat)getAvInfoHeight {
    CGFloat tableViewHeight = 0;
    for (VENMaterialDetailsPageModel *avInfoModel in self.avInfoNewMuArr) {
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[avInfoModel.dictationInfo[@"content"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        self.cellLabelTwo.attributedText = attributedString;
        
        NSString *contentStr = avInfoModel.dictationInfo[@"translation"][@"content"];
        NSString *grammar = avInfoModel.dictationInfo[@"translation"][@"grammar"];
        NSString *words = avInfoModel.dictationInfo[@"translation"][@"words"];
        
        if (![VENEmptyClass isEmptyString:contentStr] && ![VENEmptyClass isEmptyString:grammar] && ![VENEmptyClass isEmptyString:words]) {
            self.cellLabelThree.text = [NSString stringWithFormat:@"翻译：%@\n语法：%@\n单词：%@", contentStr, grammar, words];
        } else {
            self.cellLabelThree.text = @"";
        }
        
        CGFloat labelHeight = [self.cellLabelTwo sizeThatFits:CGSizeMake(kMainScreenWidth - 40 - 30, CGFLOAT_MAX)].height;
        CGFloat labelHeight2 = [self.cellLabelThree sizeThatFits:CGSizeMake(kMainScreenWidth - 40 - 30, CGFLOAT_MAX)].height;
        CGFloat height = 5 + 15 + labelHeight + 10 + labelHeight2 + 10 + 40 + 15 + 5;
        
        avInfoModel.cellHeight = height;
        tableViewHeight += height;
    }
    return tableViewHeight;
}

#pragma mark - middleToolsBar
// 播放
- (IBAction)playButtonClick:(id)sender {
    [MBProgressHUD showText:@"播放"];
}

// 录音
- (IBAction)recordingButtonClick:(id)sender {
    VENMaterialDetailsPageModel *model = self.avInfoOriginalArr[0];
    
    VENMyDictationDetailsRecordingPageViewController *vc = [[VENMyDictationDetailsRecordingPageViewController alloc] init];
    vc.source_id = model.dictationInfo[@"source_id"];
    vc.source_period_id = model.dictationInfo[@"source_period_id"];
    [self.navigationController pushViewController:vc animated:YES];
}

// 翻译
- (IBAction)translationButtonClick:(id)sender {
    VENMaterialDetailsPageModel *model = self.avInfoOriginalArr[0];
    
    VENMyDictationDetailsTranslationPageViewController *vc = [[VENMyDictationDetailsTranslationPageViewController alloc] init];
    vc.source_id = model.dictationInfo[@"source_id"];
    vc.source_period_id = model.dictationInfo[@"source_period_id"];
    vc.type = @"1"; // 平台素材
    [self.navigationController pushViewController:vc animated:YES];
}

// 添加生词
- (IBAction)addNewWordsBookButtonClick:(id)sender {
    VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController *vc = [[VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController alloc] init];
    vc.source_id = self.source_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 标签点击
- (void)tagButtonClick:(UIButton *)button {
    VENMyDictationDetailsLabelPageViewController *vc = [[VENMyDictationDetailsLabelPageViewController alloc] init];
    vc.navigationItem.title = self.infoModel.dictation_tag[button.tag][@"name"];
    vc.dictation_tag = self.infoModel.dictation_tag[button.tag][@"id"];
    vc.type = @"1"; // 平台素材
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - bottomToolBar
- (void)setupBottomToolBar {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xF1F1F1);
    [self.bottomToolsBar addSubview:lineView];
    
    CGFloat width = (kMainScreenWidth - 40 - 15) / 2;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, width, 40)];
    leftButton.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [leftButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    leftButton.layer.cornerRadius = 20.0f;
    leftButton.layer.masksToBounds = YES;
    [self.bottomToolsBar addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(20 + width + 15, 10, (kMainScreenWidth - 40 - 15) / 2, 40)];
    rightButton.backgroundColor = UIColorFromRGB(0xFFDE02);
    [rightButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    rightButton.layer.cornerRadius = 20.0f;
    rightButton.layer.masksToBounds = YES;
    [self.bottomToolsBar addSubview:rightButton];
    
    [leftButton setTitle:@"删除听写" forState:UIControlStateNormal];
    [rightButton setTitle:@"重新听写" forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)leftButtonClick {
    NSDictionary *parameters = @{@"source_id" : self.source_id,
                                 @"sourceType" : @"1",  
                                 @"doType" : @"1"};
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"user/delDosource" parameters:parameters successBlock:^(id responseObject) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        if (self.deleteBlock) {
            self.deleteBlock();
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)rightButtonClick {
    VENMaterialDetailPageViewController *vc = [[VENMaterialDetailPageViewController alloc] init];
    vc.id = self.source_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 音频播放器
- (VENAudioPlayerView *)audioPlayerView {
    if (!_audioPlayerView) {
        _audioPlayerView = [[[NSBundle mainBundle] loadNibNamed:@"VENAudioPlayerView" owner:nil options:nil] firstObject];
        [self.audioContentView addSubview:_audioPlayerView];
    }
    return _audioPlayerView;
}

- (NSMutableArray *)avInfoNewMuArr {
    if (!_avInfoNewMuArr) {
        _avInfoNewMuArr = [NSMutableArray array];
    }
    return _avInfoNewMuArr;
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
