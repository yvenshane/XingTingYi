//
//  VENMyReadingDetailsViewController.m
//  XingTingYi
//
//  Created by YVEN on 2020/1/28.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyReadingDetailsViewController.h"
#import "VENMaterialDetailsPageModel.h"
#import "VENAudioPlayerView.h"
#import "VENMaterialDetailPageViewController.h"
#import "VENMyReadingDetailsTableViewCell.h"
#import "VENAudioPlayer.h"
#import "VENMaterialDetailsStartDictationPageViewController.h"
#import "VENMaterialDetailsMakeSubtitlesPageViewController.h"

@interface VENMyReadingDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIView *audioContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *audioContentViewHeightLayoutConstraint;
@property (nonatomic, strong) VENAudioPlayerView *audioPlayerView;

@property (weak, nonatomic) IBOutlet UIView *middleToolsBarContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleToolsBarContentViewHeightLayoutConstarint;

@property (weak, nonatomic) IBOutlet UIView *bottomContentView;
@property (weak, nonatomic) IBOutlet UIView *bottomToolsBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomContentViewHeightLayoutConstarint;

@property (nonatomic, copy) NSArray *textInfoArr;
@property (nonatomic, copy) NSArray *avInfoArr;
@property (nonatomic, strong) VENMaterialDetailsPageModel *infoModel;

@property (nonatomic, strong) UILabel *cellLabelTwo;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMyReadingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"朗读详情";
    
    self.pictureImageView.layer.cornerRadius = 4.0f;
    self.pictureImageView.layer.masksToBounds = YES;
    
    [self setupBottomToolBar];
    [self loadMyReadingDetailsPageData];
}

- (void)loadMyReadingDetailsPageData {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"source/sourceInfo" parameters:@{@"id" : self.source_id} successBlock:^(id responseObject) {
        
        self.avInfoArr = [NSArray yy_modelArrayWithClass:[VENMaterialDetailsPageModel class] json:responseObject[@"content"][@"avInfo"]];
        self.textInfoArr = [NSArray yy_modelArrayWithClass:[VENMaterialDetailsPageModel class] json:responseObject[@"content"][@"textInfo"]];
        
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
    
    // 播放器
    self.audioContentView.hidden = YES;
    self.audioContentViewHeightLayoutConstraint.constant = 0.0f;
    // middleToolsBar
    self.middleToolsBarContentView.hidden = YES;
    self.middleToolsBarContentViewHeightLayoutConstarint.constant = 0.0f;
    
    if (![VENEmptyClass isEmptyArray:self.avInfoArr]) {
        VENMaterialDetailsPageModel *avInfoModel = self.avInfoArr[0];
        
        if (![VENEmptyClass isEmptyString:avInfoModel.path]) {
            self.audioContentView.hidden = NO;

            self.audioPlayerView.audioURL = avInfoModel.path;
            // audio
            self.audioContentView.layer.cornerRadius = 8.0f;
            self.audioContentView.layer.masksToBounds = YES;

            CGFloat audioHeight = (kMainScreenWidth - 40) / (335.0 / 120.0);
            self.audioContentViewHeightLayoutConstraint.constant = audioHeight;

            self.audioPlayerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.audioContentView.frame), CGRectGetHeight(self.audioContentView.frame));
            
            // middleToolsBar
            self.middleToolsBarContentView.hidden = NO;
            self.middleToolsBarContentViewHeightLayoutConstarint.constant = 80.0f;
            
            
        }
    }
    
    if (self.textInfoArr.count > 0) {
        CGFloat height = [self getTextInfoHeight];
        self.bottomContentViewHeightLayoutConstarint.constant = height;
        
        // tableView
        [self setupTableView];
        
        self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, height);
    } else {
        self.bottomContentViewHeightLayoutConstarint.constant = 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.textInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMyReadingDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENMaterialDetailsPageModel *textInfoModel = self.textInfoArr[indexPath.row];
    
    cell.titleLabel.text = textInfoModel.content;
    
    // 播放
    cell.playButtonClickBlock = ^() {
        [[VENAudioPlayer sharedAudioPlayer] playWithURL:[NSURL URLWithString:textInfoModel.read]];
        [[VENAudioPlayer sharedAudioPlayer] play];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMaterialDetailsPageModel *textInfoModel = self.textInfoArr[indexPath.row];
    
    if (!textInfoModel.cellHeight) {
        return CGFLOAT_MIN;
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
    self.tableView.frame = CGRectZero;
    self.tableView.autoresizingMask = UIViewAutoresizingNone;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"VENMyReadingDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.bottomContentView addSubview:self.tableView];
}

#pragma mark - TableView Height
- (CGFloat)getTextInfoHeight {
    CGFloat tableViewHeight = 0;
    for (VENMaterialDetailsPageModel *textInfoModel in self.textInfoArr) {
        
        self.cellLabelTwo.text = textInfoModel.content;
        
        CGFloat labelHeight = [self.cellLabelTwo sizeThatFits:CGSizeMake(kMainScreenWidth - 40 - 30, CGFLOAT_MAX)].height;
        
        CGFloat height = 5 + 15 + labelHeight + 10 + 40 + 15 + 5;
        
        textInfoModel.cellHeight = height;
        tableViewHeight += height;
    }
    return tableViewHeight;
}

#pragma mark - 下载音频
- (IBAction)downloadButtonClick:(id)sender {
    [MBProgressHUD showText:@"下载音频"];
}

#pragma mark - 开始听写
- (IBAction)dictationButtonClick:(id)sender {
    VENMaterialDetailsPageModel *model = self.avInfoArr[0];
    
    VENMaterialDetailsStartDictationPageViewController *vc = [[VENMaterialDetailsStartDictationPageViewController alloc] init];
    vc.source_id = self.infoModel.id;
    vc.source_period_id = model.id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 制作字幕
- (IBAction)subtitleButtonClick:(id)sender {
    VENMaterialDetailsPageModel *model = self.avInfoArr[0];
    
    VENMaterialDetailsMakeSubtitlesPageViewController *vc = [[VENMaterialDetailsMakeSubtitlesPageViewController alloc] init];
    vc.source_period_id = model.id;
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
    
    [leftButton setTitle:@"删除朗读" forState:UIControlStateNormal];
    [rightButton setTitle:@"重新朗读" forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)leftButtonClick {
    NSDictionary *parameters = @{@"source_id" : self.source_id,
                                 @"sourceType" : @"1",
                                 @"doType" : @"2"};
    
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

- (UILabel *)cellLabelTwo {
    if (!_cellLabelTwo) {
        _cellLabelTwo = [[UILabel alloc] init];
        _cellLabelTwo.font = [UIFont systemFontOfSize:14.0f];
        _cellLabelTwo.numberOfLines = 0;
    }
    return _cellLabelTwo;
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