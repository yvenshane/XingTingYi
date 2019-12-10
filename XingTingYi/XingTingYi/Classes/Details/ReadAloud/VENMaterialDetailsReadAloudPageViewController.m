//
//  VENMaterialDetailsReadAloudPageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/9.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsReadAloudPageViewController.h"
#import "VENMaterialDetailsPageModel.h"
#import <AVFoundation/AVFoundation.h>

@interface VENMaterialDetailsReadAloudPageViewController ()
@property (nonatomic, strong) UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginLabel;
@property (weak, nonatomic) IBOutlet UIButton *beginButton;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic, strong) VENMaterialDetailsPageModel *infoModel;

@property (nonatomic, strong) AVAudioRecorder *audioRecorder; // 录音器
@property (nonatomic, strong) AVAudioPlayer *player; // 播放器
@property (nonatomic, strong) NSURL *recordFileUrl; // 文件地址

@end

@implementation VENMaterialDetailsReadAloudPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupTableView];
    [self loadMaterialDetailsReadAloudPageData];
    
    [self.beginButton addTarget:self action:@selector(beginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton addTarget:self action:@selector(playReadAloud) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)rightButtonClick {
    
}

- (void)beginButtonClick:(UIButton *)button {
    
    BOOL isReset = NO;
    
    if (button.selected) {
        button.selected = NO;
        self.leftView.hidden = NO;
        self.rightView.hidden = NO;
        self.beginLabel.text = @"点击重新朗读";
        isReset = YES;
        [self finishReadAloud]; // 完成录音
    } else {
        button.selected = YES;
        if (isReset) {
            self.beginLabel.text = @"点击开始朗读";
        } else {
            self.leftView.hidden = YES;
            self.rightView.hidden = YES;
            self.beginLabel.text = @"点击完成朗读";
            [self beginReadAloud]; // 开始录音
        }
    }
}

- (void)loadMaterialDetailsReadAloudPageData {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"source/readInfo" parameters:@{@"source_period_id" : self.source_period_id} successBlock:^(id responseObject) {
        
        self.infoModel = [VENMaterialDetailsPageModel yy_modelWithJSON:responseObject[@"content"][@"info"]];
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:self.contentLabel];
    
    self.contentLabel.text = self.infoModel.content;
    CGFloat height = [self.contentLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 30 * 2, CGFLOAT_MAX)].height;
    self.contentLabel.frame = CGRectMake(30, 16, kMainScreenWidth - 30 * 2, height);
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    self.contentLabel.text = self.infoModel.content;
    CGFloat height = [self.contentLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 30 * 2, CGFLOAT_MAX)].height;
    
    return height + 16 + 16;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)setupTableView {
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - 210 - (kTabBarHeight - 49));
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = nil;
    [self.view addSubview:self.tableView];
}

#pragma mark - 开始录音
- (void)beginReadAloud {
    if (self.audioRecorder) {
        // 删除录音
        [self.audioRecorder deleteRecording];
    }
    //准备录音
    [self.audioRecorder prepareToRecord];
    //开始录音
    [self.audioRecorder record];
    // 几秒后开始录音
    // [self.audioRecorder recordAtTime:self.audioRecorder.deviceCurrentTime + 5];
    // 录音录多久
    [self.audioRecorder recordForDuration:60];
}

#pragma mark - 完成录音
- (void)finishReadAloud {
//    if (self.audioRecorder.currentTime > 2) {
//        [self.audioRecorder stop];
//    } else {
//        NSLog(@"录音时间不超过2秒，删除");
//        [self.audioRecorder stop];
//        [self.audioRecorder deleteRecording];
//    }
    
    [self.audioRecorder stop];
}

#pragma mark - 播放录音
- (void)playReadAloud {
    if ([self.player isPlaying]) return;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordFileUrl error:nil];
    
    [self.player play];
}

#pragma mark - 录音器
- (AVAudioRecorder *)audioRecorder {
    if (!_audioRecorder) {
        // 确定录音存放的位置
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"ra%@.caf", [self getCurrentTimestamp]]];
        self.recordFileUrl = [NSURL URLWithString:path];
        
        // 录音参数
        NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
        // 设置编码格式
        [recordSettings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        // 采样率
        [recordSettings setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
        // 通道数
        [recordSettings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        // 音频质量,采样质量
        [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];

        // 创建录音对象
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:recordSettings error:nil];
    }
    return _audioRecorder;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = UIColorFromRGB(0x222222);
        _contentLabel.font = [UIFont systemFontOfSize:18.0f weight:UIFontWeightMedium];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

// 获取当前时间戳
- (NSString *)getCurrentTimestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0]; // 获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970]*1000;// *1000 是精确到毫秒(13位),不乘就是精确到秒(10位)
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
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
