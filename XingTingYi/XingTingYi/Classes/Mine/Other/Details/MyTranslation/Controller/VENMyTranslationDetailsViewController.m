//
//  VENMyTranslationDetailsViewController.m
//  XingTingYi
//
//  Created by YVEN on 2020/1/29.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMyTranslationDetailsViewController.h"
#import "VENMaterialDetailsPageModel.h"
#import "VENMyTranslationDetailsTableViewCell.h"
#import "VENMaterialDetailPageViewController.h"
#import "VENPersonalMaterialDetailPageViewController.h"

@interface VENMyTranslationDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomContentView;
@property (weak, nonatomic) IBOutlet UIView *bottomToolsBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomContentViewHeightLayoutConstarint;

@property (nonatomic, copy) NSArray *textInfoArr;
@property (nonatomic, strong) VENMaterialDetailsPageModel *infoModel;

@property (nonatomic, strong) UILabel *cellLabelTwo;
@property (nonatomic, strong) UILabel *cellLabelThree;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMyTranslationDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"翻译详情";
    
    self.pictureImageView.layer.cornerRadius = 4.0f;
    self.pictureImageView.layer.masksToBounds = YES;
    
    [self setupBottomToolBar];
    [self loadMyTranslationDetailsPageData];
}

- (void)loadMyTranslationDetailsPageData {
    
    NSString *url = @"";
    NSDictionary *parameters = @{};
    
    if (self.isPersonalMaterial) {
        url = @"userSource/userSourceInfo";
        parameters = @{@"source_id" : self.source_id};
    } else {
        url = @"source/sourceInfo";
        parameters = @{@"id" : self.source_id};
    }
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:url parameters:parameters successBlock:^(id responseObject) {
        
        if (self.isPersonalMaterial) {
            self.textInfoArr = [NSArray yy_modelArrayWithClass:[VENMaterialDetailsPageModel class] json:responseObject[@"content"][@"sourceText"]];
        } else {
            self.textInfoArr = [NSArray yy_modelArrayWithClass:[VENMaterialDetailsPageModel class] json:responseObject[@"content"][@"textInfo"]];
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
    VENMyTranslationDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    VENMaterialDetailsPageModel *textInfoModel = self.textInfoArr[indexPath.row];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[textInfoModel.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    cell.titleLabel.attributedText = attributedString;
    
    NSString *contentStr = @"";
    NSString *grammar = @"";
    NSString *words = @"";
    
    if (self.isPersonalMaterial) {
        contentStr = textInfoModel.info[@"content"];
        grammar = textInfoModel.info[@"grammar"];
        words = textInfoModel.info[@"words"];
    } else {
        contentStr = textInfoModel.translation[@"content"];
        grammar = textInfoModel.translation[@"grammar"];
        words = textInfoModel.translation[@"words"];
    }
    
    if (![VENEmptyClass isEmptyString:contentStr] && ![VENEmptyClass isEmptyString:grammar] && ![VENEmptyClass isEmptyString:words]) {
        cell.contentLabel.text = [NSString stringWithFormat:@"翻译：%@\n语法：%@\n单词：%@", contentStr, grammar, words];
    } else {
        cell.contentLabel.text = @"";
    }
    
    cell.goodView.hidden = self.isPersonalMaterial ? YES : NO;
    
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
    [self.tableView registerNib:[UINib nibWithNibName:@"VENMyTranslationDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.bottomContentView addSubview:self.tableView];
}

#pragma mark - TableView Height
- (CGFloat)getTextInfoHeight {
    CGFloat tableViewHeight = 0;
    for (VENMaterialDetailsPageModel *textInfoModel in self.textInfoArr) {
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[textInfoModel.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        self.cellLabelTwo.attributedText = attributedString;
        
        NSString *contentStr = @"";
        NSString *grammar = @"";
        NSString *words = @"";
        
        if (self.isPersonalMaterial) {
            contentStr = textInfoModel.info[@"content"];
            grammar = textInfoModel.info[@"grammar"];
            words = textInfoModel.info[@"words"];
        } else {
            contentStr = textInfoModel.translation[@"content"];
            grammar = textInfoModel.translation[@"grammar"];
            words = textInfoModel.translation[@"words"];
        }
        
        if (![VENEmptyClass isEmptyString:contentStr] && ![VENEmptyClass isEmptyString:grammar] && ![VENEmptyClass isEmptyString:words]) {
            self.cellLabelThree.text = [NSString stringWithFormat:@"翻译：%@\n语法：%@\n单词：%@", contentStr, grammar, words];
        } else {
            self.cellLabelThree.text = @"";
        }
        
        CGFloat labelHeight = [self.cellLabelTwo sizeThatFits:CGSizeMake(kMainScreenWidth - 40 - 30, CGFLOAT_MAX)].height;
        CGFloat labelHeight2 = [self.cellLabelThree sizeThatFits:CGSizeMake(kMainScreenWidth - 40 - 30, CGFLOAT_MAX)].height;
        
        CGFloat height = 0;
        if (self.isPersonalMaterial) {
            height = 5 + 15 + labelHeight + 10 + labelHeight2 + 15;
        } else {
            height = 5 + 15 + labelHeight + 10 + labelHeight2 + 25 + 15;
        }
        
        textInfoModel.cellHeight = height;
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
    
    [leftButton setTitle:@"删除翻译" forState:UIControlStateNormal];
    [rightButton setTitle:@"重新翻译" forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)leftButtonClick {
    NSDictionary *parameters = @{@"source_id" : self.source_id,
                                 @"sourceType" : self.isPersonalMaterial ? @"2" : @"1",
                                 @"doType" : @"3"};
    
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
        [self.navigationController pushViewController:vc animated:YES];
    }
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
