//
//  VENMyDictationDetailsRecordingPageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/31.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyDictationDetailsRecordingPageViewController.h"
#import "VENMyDictationDetailsRecordingPageTableViewCell.h"
#import "VENAudioRecorder.h"
#import "QiniuSDK.h"
#import "VENMaterialDetailsPageModel.h"

@interface VENMyDictationDetailsRecordingPageViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *beginLabel;
@property (weak, nonatomic) IBOutlet UIButton *beginButton;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIView *leftView2;
@property (weak, nonatomic) IBOutlet UIView *rightView2;
@property (weak, nonatomic) IBOutlet UIView *bottomContentView;

@property (nonatomic, strong) NSMutableArray *dataSourceMuArr;

@property (nonatomic, strong) VENAudioRecorder *audioRecorder;
@property (nonatomic, strong) NSMutableArray *audioRecorderMuArr;
@property (nonatomic, copy) NSDictionary *recorderInfoDict;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMyDictationDetailsRecordingPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.contentTextView.editable = NO;
    
    [self setupTableView];
//    [self setupRightButton];
    
    [self loadMyDictationDetailsRecordingPageData];
}

- (void)loadMyDictationDetailsRecordingPageData {
    
    NSString *url = @"";
    NSDictionary *parameters = @{};
    
    if (self.isPersonalMaterial) {
        url = @"userSource/dictationInfo";
        parameters = @{@"source_id" : self.source_id};
    } else {
        url = @"source/dictationInfo";
        parameters = @{@"source_id" : self.source_id,
                       @"source_period_id" : self.source_period_id};
    }
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:url parameters:parameters successBlock:^(id responseObject) {
        
        VENMaterialDetailsPageModel *dictationInfoModel = [VENMaterialDetailsPageModel yy_modelWithJSON:responseObject[@"content"][@"dictationInfo"]];
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[dictationInfoModel.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        self.contentTextView.attributedText = attributedString;
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.audioRecorderMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMyDictationDetailsRecordingPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *time = self.audioRecorderMuArr[indexPath.row][@"time"];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@\"", time];
    
    NSInteger duration = [time integerValue];
    CGFloat portion = (kMainScreenWidth - 40) / 60;
    CGFloat minTime = 70;
    
    if (duration * portion > minTime) {
        minTime = duration * portion;
    }
    
    cell.backgroundViewWidthLayoutConstraint.constant = minTime;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *path = self.audioRecorderMuArr[indexPath.row][@"path"];
    [self.audioRecorder playReadAloudWithPath:path];    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  50;
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

- (void)setupTableView {
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, CGRectGetHeight(self.bottomContentView.frame));
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"VENMyDictationDetailsRecordingPageTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.bottomContentView addSubview:self.tableView];
}

#pragma mark - 播放
- (IBAction)playButtonClick:(id)sender {
    [self.audioRecorder playReadAloudWithPath:self.recorderInfoDict[@"path"]];
}

#pragma mark - 重录
- (IBAction)remakeButtonClick:(id)sender {
    [self.audioRecorderMuArr removeAllObjects];
    [self.tableView reloadData];
    
    self.leftView2.hidden = YES;
    self.rightView2.hidden = YES;
}

#pragma mark - 完成
- (IBAction)finishButtonClick:(id)sender {
    [self.audioRecorderMuArr addObject:self.recorderInfoDict];
    
    [self.tableView reloadData];
    
    self.leftView2.hidden = NO;
    self.rightView2.hidden = NO;
    
    self.leftView.hidden = YES;
    self.rightView.hidden = YES;
    self.beginLabel.text = @"点击开始朗读";
}

#pragma mark - 合成录音
- (IBAction)synthesisButtonClick:(id)sender {
    [MBProgressHUD addLoading];
    
    NSMutableArray *audioList = [NSMutableArray array];
    
    for (NSDictionary *dict in self.audioRecorderMuArr) {
        [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypeGET urlString:@"qiniu/createToken" parameters:nil successBlock:^(id responseObject) {
            
            NSString *token = responseObject[@"content"][@"token"];
            NSString *path = dict[@"path"];
            NSData *data= [NSData dataWithContentsOfFile:path];
            NSString *keys = responseObject[@"content"][@"key"];
            
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            [upManager putData:data key:keys token:token complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                NSLog(@"info - %@", info);
                NSLog(@"resp - %@", resp);
                
                [audioList addObject:resp[@"key"]];
                
                if (audioList.count == self.audioRecorderMuArr.count) {
                    
                    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypeGET urlString:@"qiniu/createToken" parameters:nil successBlock:^(id responseObject) {
                        
                        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                        [parameters setValue:self.source_id forKey:@"source_id"];
                        [parameters setValue:self.source_period_id forKey:@"source_period_id"];
                        [parameters setValue:responseObject[@"content"][@"key"] forKey:@"path"];
                        
                        if (self.isPersonalMaterial) {
                            [parameters setValue:@"2" forKey:@"type"];
                        } else {
                            [parameters setValue:@"1" forKey:@"type"];
                        }
                        
                        for (NSInteger i = 0; i < audioList.count; i++) {
                            [parameters setValue:audioList[i] forKey:[NSString stringWithFormat:@"audioList[%ld]", i]];
                        }
                        
                        [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"user/reRead" parameters:parameters successBlock:^(id responseObject) {
                            
                            [MBProgressHUD removeLoading];
                            [self.navigationController popViewControllerAnimated:YES];
                            
                        } failureBlock:^(NSError *error) {
                            
                        }];
                        
                    } failureBlock:^(NSError *error) {
                        
                    }];
                }
                
            } option:[QNUploadOption defaultOptions]];
            
        } failureBlock:^(NSError *error) {
            
        }];
    }
}

#pragma mark - 录音
- (IBAction)beginButtonClick:(UIButton *)button {
    BOOL isReset = NO;
    
    if (button.selected) {
        button.selected = NO;
        self.leftView.hidden = NO;
        self.rightView.hidden = NO;
        self.beginLabel.text = @"点击重新朗读";
        isReset = YES;
        
        self.recorderInfoDict = [self.audioRecorder finishReadAloud];
    } else {
        button.selected = YES;
        if (isReset) {
            self.beginLabel.text = @"点击开始朗读";
        } else {
            self.leftView.hidden = YES;
            self.rightView.hidden = YES;
            self.leftView2.hidden = YES;
            self.rightView2.hidden = YES;

            self.beginLabel.text = @"点击完成朗读";
            [self.audioRecorder beginReadAloud]; // 开始录音
        }
    }
}

#pragma mark - 录音器
- (VENAudioRecorder *)audioRecorder {
    if (!_audioRecorder) {
        _audioRecorder = [VENAudioRecorder sharedAudioRecorder];
        
        // 录音超过60秒
        __weak typeof(self) weakSelf = self;
        _audioRecorder.recorderEndBlock = ^(NSDictionary *dict) {
            weakSelf.beginButton.selected = NO;
            weakSelf.leftView.hidden = NO;
            weakSelf.rightView.hidden = NO;
            weakSelf.beginLabel.text = @"点击重新朗读";
//            isReset = YES;
            weakSelf.recorderInfoDict = dict;
        };
    }
    return _audioRecorder;
}

- (void)setupRightButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)saveButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)audioRecorderMuArr {
    if (!_audioRecorderMuArr) {
        _audioRecorderMuArr = [NSMutableArray array];
    }
    return _audioRecorderMuArr;
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
