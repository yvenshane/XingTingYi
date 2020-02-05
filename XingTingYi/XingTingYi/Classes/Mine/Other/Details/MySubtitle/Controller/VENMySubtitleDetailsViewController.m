//
//  VENMySubtitleDetailsViewController.m
//  XingTingYi
//
//  Created by YVEN on 2020/1/29.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMySubtitleDetailsViewController.h"
#import "VENMaterialDetailsPageModel.h"
#import "VENMaterialDetailPageViewController.h"
#import "VENMySubtitleDetailsTableViewCell.h"
#import "VENMaterialDetailsMakeSubtitlesPageViewController.h"
#import "VENPersonalMaterialDetailPageViewController.h"

@interface VENMySubtitleDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomContentView;
@property (weak, nonatomic) IBOutlet UIView *bottomToolsBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomContentViewHeightLayoutConstarint;

@property (nonatomic, strong) NSMutableArray *subtitleMuArr;
@property (nonatomic, strong) VENMaterialDetailsPageModel *infoModel;

@property (nonatomic, strong) UILabel *cellLabelTwo;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMySubtitleDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"字幕详情";
    
    self.pictureImageView.layer.cornerRadius = 4.0f;
    self.pictureImageView.layer.masksToBounds = YES;
    
    [self setupBottomToolBar];
    [self loadMySubtitleDetailsPageData];
}

- (void)loadMySubtitleDetailsPageData {
    
    NSString *url = @"";
    NSDictionary *parameters = @{};
    
    if (self.isPersonalMaterial) {
        url = @"userSource/userSourceInfo";
        parameters = @{@"source_id" : self.source_id};
    } else {
        if (self.isExcellentCourse) {
            url = @"goodCourse/myGoodCourseInfo";
            parameters = @{@"source_id" : self.source_id};
        } else {
            url = @"source/sourceInfo";
            parameters = @{@"id" : self.source_id};
        }
    }
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:url parameters:parameters successBlock:^(id responseObject) {
        
        NSArray *avInfoArr = [NSArray yy_modelArrayWithClass:[VENMaterialDetailsPageModel class] json:responseObject[@"content"][@"avInfo"]];
        
        [self.subtitleMuArr removeAllObjects];
        for (VENMaterialDetailsPageModel *model in avInfoArr) {
            if (![VENEmptyClass isEmptyArray:model.subtitlesList]) {
                [self.subtitleMuArr addObject:model];
            }
        }
        
        [self setupContentWithDict:responseObject[@"content"]];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)setupContentWithDict:(NSDictionary *)dict {
    if (self.isPersonalMaterial) {
        self.infoModel = [VENMaterialDetailsPageModel yy_modelWithJSON:dict[@"sourceInfo"]];
    } else {
        self.infoModel = [VENMaterialDetailsPageModel yy_modelWithJSON:dict[@"info"]];
    }
    
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
    
    if (self.subtitleMuArr.count > 0) {
        CGFloat height = [self getSubtitleHeight];
        self.bottomContentViewHeightLayoutConstarint.constant = height;
        
        // tableView
        [self setupTableView];
        
        self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, height);
    } else {
        if (self.isPersonalMaterial) {
            NSString *content = self.infoModel.content;
            
            // content
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            
            UILabel *contenLabel = [[UILabel alloc] init];
            contenLabel.textColor = UIColorFromRGB(0x222222);
            contenLabel.font = [UIFont systemFontOfSize:14.0f];
            contenLabel.attributedText = attributedString;
            contenLabel.numberOfLines = 0;
            
            CGFloat height = [contenLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 40, CGFLOAT_MAX)].height;
            contenLabel.frame = CGRectMake(20, 0, kMainScreenWidth - 40, height);
            
            [self.bottomContentView addSubview:contenLabel];
            
            self.bottomContentViewHeightLayoutConstarint.constant = height;
        } else {
            self.bottomContentViewHeightLayoutConstarint.constant = 0;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subtitleMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMySubtitleDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENMaterialDetailsPageModel *subtitleModel = self.subtitleMuArr[indexPath.row];
    
    if (indexPath.row < 10) {
        cell.numberLabel.text = [NSString stringWithFormat:@"0%ld", (long)indexPath.row + 1];
    } else {
        cell.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
    }
    cell.titleLabel.text = subtitleModel.subtitlesList[0][@"content"];
    
    cell.checkButtonClickBlock = ^{
        VENMaterialDetailsMakeSubtitlesPageViewController *vc = [[VENMaterialDetailsMakeSubtitlesPageViewController alloc] init];
        vc.source_period_id = subtitleModel.id;
        vc.isExcellentCourse = self.isExcellentCourse;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    VENMaterialDetailsPageModel *subtitleModel = self.subtitleMuArr[indexPath.row];
    
    if (!subtitleModel.cellHeight) {
        return CGFLOAT_MIN;
    } else {
        return subtitleModel.cellHeight;
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
    [self.tableView registerNib:[UINib nibWithNibName:@"VENMySubtitleDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.bottomContentView addSubview:self.tableView];
}

#pragma mark - TableView Height
- (CGFloat)getSubtitleHeight {
    CGFloat tableViewHeight = 0;
    for (VENMaterialDetailsPageModel *subtitleModel in self.subtitleMuArr) {
        
        self.cellLabelTwo.text = subtitleModel.subtitlesList[0][@"content"];
        
        CGFloat labelHeight = [self.cellLabelTwo sizeThatFits:CGSizeMake(kMainScreenWidth - 75 - 35 - 40, CGFLOAT_MAX)].height;
        CGFloat height = 5 + 25 + 20 + labelHeight + 1 + 44 + 5;
        
        subtitleModel.cellHeight = height;
        tableViewHeight += height;
    }
    return tableViewHeight;
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
    
    [leftButton setTitle:@"删除字幕" forState:UIControlStateNormal];
    [rightButton setTitle:@"重新制作字幕" forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)leftButtonClick {
    NSString *sourceType = @"";
    
    if (self.isPersonalMaterial) {
        sourceType = @"2";
    } else {
        if (self.isExcellentCourse) {
            sourceType = @"3";
        } else {
            sourceType = @"1";
        }
    }
    NSDictionary *parameters = @{@"source_id" : self.source_id,
                                 @"sourceType" : sourceType,
                                 @"doType" : @"4"};
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"user/delDosource" parameters:parameters successBlock:^(id responseObject) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        if (self.deleteBlock) {
            self.deleteBlock();
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)rightButtonClick {
    if (self.isPersonalMaterial) {
        VENPersonalMaterialDetailPageViewController *vc = [[VENPersonalMaterialDetailPageViewController alloc] init];
        vc.source_id = self.source_id;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        VENMaterialDetailPageViewController *vc = [[VENMaterialDetailPageViewController alloc] init];
        vc.id = self.source_id;
        vc.isExcellentCourse = self.isExcellentCourse;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSMutableArray *)subtitleMuArr {
    if (!_subtitleMuArr) {
        _subtitleMuArr = [NSMutableArray array];
    }
    return _subtitleMuArr;
}

- (UILabel *)cellLabelTwo {
    if (!_cellLabelTwo) {
        _cellLabelTwo = [[UILabel alloc] init];
        _cellLabelTwo.font = [UIFont systemFontOfSize:16.0f];
        _cellLabelTwo.numberOfLines = 2;
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
