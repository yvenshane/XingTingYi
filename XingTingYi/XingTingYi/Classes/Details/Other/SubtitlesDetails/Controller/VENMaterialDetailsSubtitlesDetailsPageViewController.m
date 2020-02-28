//
//  VENMaterialDetailsSubtitlesDetailsPageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2020/2/3.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsSubtitlesDetailsPageViewController.h"
#import "VENAudioPlayerView.h"
#import "VENAudioPlayer.h"
#import "VENMaterialDetailsSubtitlesDetailsPageTableViewCell.h"
#import "VENMaterialDetailsSubtitlesDetailsPageModel.h"
#import "VENMaterialDetailsSubtitlesPopupView.h"

@interface VENMaterialDetailsSubtitlesDetailsPageViewController ()
@property (weak, nonatomic) IBOutlet UIView *topAudioPlayerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topAudioPlayerViewHeightLayoutConstraint;

@property (nonatomic, strong) VENAudioPlayerView *audioPlayerView;
@property (nonatomic, strong) NSMutableArray *dataSourceMuArr;
@property (nonatomic, strong) NSMutableArray *dataSourceMuArrTwo;

@property (nonatomic, strong) VENMaterialDetailsSubtitlesPopupView *popupView;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMaterialDetailsSubtitlesDetailsPageViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.audioPlayerView.audioPlayer stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"字幕详情";
    
    // 顶部播放器试图
    self.topAudioPlayerView.backgroundColor = [UIColor whiteColor];
    self.topAudioPlayerView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.03].CGColor;
    self.topAudioPlayerView.layer.shadowOffset = CGSizeMake(0,4);
    self.topAudioPlayerView.layer.shadowOpacity = 1;
    self.topAudioPlayerView.layer.shadowRadius = 8;
    [self.topAudioPlayerView addSubview:self.audioPlayerView];

    CGFloat height = (kMainScreenWidth - 40) / (335.0 / 120.0) + 15 + 20;
    self.topAudioPlayerViewHeightLayoutConstraint.constant = height;
    
    
    self.tableView.frame = CGRectMake(0, height, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - (kTabBarHeight - 49) - height);
    self.tableView.scrollEnabled = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"VENMaterialDetailsSubtitlesDetailsPageTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.tableView];
    
    self.audioPlayerView.audioURL = self.audioURL;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.audioPlayerView.frame = CGRectMake(20, 15, kMainScreenWidth - 40, (kMainScreenWidth - 40) / (335.0 / 120.0) - 14);
}

- (void)setSubtitlesList:(NSArray *)subtitlesList {
    _subtitlesList = subtitlesList;
    
    if (![VENEmptyClass isEmptyArray:subtitlesList]) {
        self.audioPlayerView.subtitlesButton.hidden = NO;
        self.audioPlayerView.subtitlesButtonWidthLayoutConstraint.constant = 20.0f;
        self.audioPlayerView.subtitlesButtonRightLayoutConstraint.constant = 15.0f;
        [self.audioPlayerView.subtitlesButton addTarget:self action:@selector(subtitlesButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        for (NSDictionary *dict in subtitlesList) {
            [self.dataSourceMuArrTwo addObject:[VENMaterialDetailsSubtitlesDetailsPageModel yy_modelWithDictionary:dict]];
        }
    }
}

- (void)subtitlesButtonClick:(UIButton *)button {
    if (button.selected) {
        button.selected = NO;
        self.popupView.hidden = YES;
        
    } else {
        button.selected = YES;
        
        self.popupView.hidden = NO;
    }
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

- (void)setSubtitles:(NSString *)subtitles {
    _subtitles = subtitles;
    
    NSString *lrc = [NSString stringWithContentsOfURL:[NSURL URLWithString:subtitles] encoding:NSUTF8StringEncoding error:nil];
           
    NSArray *lrcArr = [lrc componentsSeparatedByString:@"\n"];
     
//    NSString *pattern = @"\\[\\d{1,2}\\:\\d{1,2}\\]]";
    NSString *pattern = @"\\[\\d{1,2}\\:\\d{1,2}\\.\\d{1,2}\\]";
    [lrcArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
        
        if ([regularExpression numberOfMatchesInString:obj options:0 range:NSMakeRange(0, ((NSString *)obj).length)]) {
            
            NSRange minRange = [obj rangeOfString:pattern options:NSRegularExpressionSearch range:NSMakeRange(0, ((NSString *)obj).length)];
            
            NSString *time = [NSString stringWithFormat:@"%@]", [[obj substringToIndex:minRange.length] substringToIndex:6]];
            NSString *content = [obj substringFromIndex:minRange.length];
            
            [self.dataSourceMuArr addObject:[VENMaterialDetailsSubtitlesDetailsPageModel yy_modelWithDictionary:@{@"time" : time,
                                                                                                                  @"content" : content,
                                                                                                                  @"status" : @"0"}]];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMaterialDetailsSubtitlesDetailsPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENMaterialDetailsSubtitlesDetailsPageModel *model = self.dataSourceMuArr[indexPath.row];
    
    cell.titleLabel.text = model.content;
    cell.titleLabel.textColor = [model.status isEqualToString:@"1"] ? UIColorFromRGB(0x222222) : UIColorFromRGB(0x999999);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = (kMainScreenWidth - 40) / (335.0 / 120.0) + 15 + 20;
    
    return (kMainScreenHeight - height) / 2 - 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = (kMainScreenWidth - 40) / (335.0 / 120.0) + 15 + 20;
    
    return (kMainScreenHeight - height) / 2;
}

#pragma mark - 音频播放器
- (VENAudioPlayerView *)audioPlayerView {
    if (!_audioPlayerView) {
        _audioPlayerView = [[[NSBundle mainBundle] loadNibNamed:@"VENAudioPlayerView" owner:nil options:nil] firstObject];
        
        __weak typeof(self) weakSelf = self;
        _audioPlayerView.playProgressBlock = ^(float time) {
            
            NSString *timeStr = [NSString stringWithFormat:@"[%@]", [weakSelf convertTime:time]];
            
            for (NSInteger i = 0; i < weakSelf.dataSourceMuArr.count; i++) {
                VENMaterialDetailsSubtitlesDetailsPageModel *model = weakSelf.dataSourceMuArr[i];
                if ([model.time isEqualToString:timeStr]) {
                    model.status = @"1";
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                } else {
                    model.status = @"0";
                }
            }
            
            for (NSInteger i = 0; i < weakSelf.dataSourceMuArrTwo.count; i++) {
                VENMaterialDetailsSubtitlesDetailsPageModel *model = weakSelf.dataSourceMuArrTwo[i];
                if ([[NSString stringWithFormat:@"[%@]", model.time] isEqualToString:timeStr]) {
                    weakSelf.popupView.contentLabel.text = model.content;
                }
            }
        };
    }
    return _audioPlayerView;
}

- (NSString *)convertTime:(CGFloat)second {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (second / 3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    
    return [formatter stringFromDate:date];
}

- (NSMutableArray *)dataSourceMuArrTwo {
    if (!_dataSourceMuArrTwo) {
        _dataSourceMuArrTwo = [NSMutableArray array];
    }
    return _dataSourceMuArrTwo;
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

@end
