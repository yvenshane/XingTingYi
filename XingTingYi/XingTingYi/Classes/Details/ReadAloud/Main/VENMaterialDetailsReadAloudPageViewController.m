//
//  VENMaterialDetailsReadAloudPageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/9.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsReadAloudPageViewController.h"
#import "VENMaterialDetailsPageModel.h"
#import "VENAudioRecorder.h"
#import "QiniuSDK.h"

@interface VENMaterialDetailsReadAloudPageViewController ()
@property (nonatomic, strong) UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginLabel;
@property (weak, nonatomic) IBOutlet UIButton *beginButton;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic, strong) VENMaterialDetailsPageModel *infoModel;

@property (nonatomic, strong) VENAudioRecorder *audioRecorder;
@property (nonatomic, copy) NSString *path;

@end

@implementation VENMaterialDetailsReadAloudPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupTableView];
    [self loadMaterialDetailsReadAloudPageData];
    
    [self.beginButton addTarget:self action:@selector(beginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - 播放
- (void)leftButtonClick {
    [self.audioRecorder playReadAloudWithPath:self.path];
}

#pragma mark - 完成
- (void)rightButtonClick {
    [MBProgressHUD addLoading];
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypeGET urlString:@"qiniu/createToken" parameters:nil successBlock:^(id responseObject) {
        
        NSString *token = responseObject[@"content"][@"token"];
        NSString *path = self.path;
        NSData *data= [NSData dataWithContentsOfFile:path];
        NSString *keys = responseObject[@"content"][@"key"];
        
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        [upManager putData:data key:keys token:token complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            NSLog(@"info - %@", info);
            NSLog(@"resp - %@", resp);

            NSDictionary *parameters = @{@"source_period_id" : self.source_period_id,
                                         @"path" : resp[@"key"]};

            [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"source/read" parameters:parameters successBlock:^(id responseObject) {
                
                [MBProgressHUD removeLoading];
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshDetailPage" object:nil userInfo:nil];

            } failureBlock:^(NSError *error) {

            }];

        } option:[QNUploadOption defaultOptions]];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 录音/完成
- (void)beginButtonClick:(UIButton *)button {
    
    BOOL isReset = NO;
    
    if (button.selected) {
        button.selected = NO;
        self.leftView.hidden = NO;
        self.rightView.hidden = NO;
        self.beginLabel.text = @"点击重新朗读";
        isReset = YES;
        self.path = [self.audioRecorder finishReadAloud][@"path"]; // 完成录音
    } else {
        button.selected = YES;
        if (isReset) {
            self.beginLabel.text = @"点击开始朗读";
        } else {
            self.leftView.hidden = YES;
            self.rightView.hidden = YES;
            self.beginLabel.text = @"点击完成朗读";
            [self.audioRecorder beginReadAloud]; // 开始录音
        }
    }
}

#pragma mark - 录音器
- (VENAudioRecorder *)audioRecorder {
    if (!_audioRecorder) {
        _audioRecorder = [VENAudioRecorder sharedAudioRecorder];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
