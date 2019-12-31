//
//  VENMinePageMyNewWordBookDetailsPageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/27.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMinePageMyNewWordBookDetailsPageViewController.h"
#import "VENMaterialDetailsAddNewWordsEditNewWordsModel.h"
#import "VENAudioPlayer.h"
#import "VENChooseCategoryView.h"
#import "VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController.h"
#import "VENMinePageMyNewWordBookModel.h"

@interface VENMinePageMyNewWordBookDetailsPageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *discriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *pronunciationView;
@property (weak, nonatomic) IBOutlet UILabel *pronunciationLabel;
@property (weak, nonatomic) IBOutlet UIButton *pronunciationButton;
@property (weak, nonatomic) IBOutlet UIView *paraphraseView;
@property (weak, nonatomic) IBOutlet UILabel *paraphraseLabel;
@property (weak, nonatomic) IBOutlet UIView *sentenceView;
@property (weak, nonatomic) IBOutlet UILabel *sentenceLabel;
@property (weak, nonatomic) IBOutlet UIView *associationView;
@property (weak, nonatomic) IBOutlet UILabel *associationLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;

@property (nonatomic, strong) VENMaterialDetailsAddNewWordsEditNewWordsModel *wordsInfoModel;

@end

@implementation VENMinePageMyNewWordBookDetailsPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.isSearch) {
        self.navigationItem.title = @"生词详情";
    } else {
        self.navigationItem.title = @"我的生词本";
        [self setupRightButton];
        [self setupBottomBar];
    }
    
    self.pronunciationView.backgroundColor = [UIColor whiteColor];
    self.pronunciationView.layer.cornerRadius = 8.0f;
    self.pronunciationView.layer.shadowColor = UIColorFromRGB(0x000000).CGColor;
    self.pronunciationView.layer.shadowOpacity = 0.1;
    self.pronunciationView.layer.shadowRadius = 2.5;
    self.pronunciationView.layer.shadowOffset = CGSizeMake(0,0);
    
    self.paraphraseView.backgroundColor = [UIColor whiteColor];
    self.paraphraseView.layer.cornerRadius = 8.0f;
    self.paraphraseView.layer.shadowColor = UIColorFromRGB(0x000000).CGColor;
    self.paraphraseView.layer.shadowOpacity = 0.1;
    self.paraphraseView.layer.shadowRadius = 2.5;
    self.paraphraseView.layer.shadowOffset = CGSizeMake(0,0);
    
    self.sentenceView.backgroundColor = [UIColor whiteColor];
    self.sentenceView.layer.cornerRadius = 8.0f;
    self.sentenceView.layer.shadowColor = UIColorFromRGB(0x000000).CGColor;
    self.sentenceView.layer.shadowOpacity = 0.1;
    self.sentenceView.layer.shadowRadius = 2.5;
    self.sentenceView.layer.shadowOffset = CGSizeMake(0,0);
    
    self.associationView.backgroundColor = [UIColor whiteColor];
    self.associationView.layer.cornerRadius = 8.0f;
    self.associationView.layer.shadowColor = UIColorFromRGB(0x000000).CGColor;
    self.associationView.layer.shadowOpacity = 0.1;
    self.associationView.layer.shadowRadius = 2.5;
    self.associationView.layer.shadowOffset = CGSizeMake(0,0);
    
    [self loadNewWordBookDetailsPageDataWithWordsID:self.words_id];
}

- (void)loadNewWordBookDetailsPageDataWithWordsID:(NSString *)wordsID {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"source/wordsInfo" parameters:@{@"words_id" : wordsID} successBlock:^(id responseObject) {
        
        self.wordsInfoModel = [VENMaterialDetailsAddNewWordsEditNewWordsModel yy_modelWithJSON:responseObject[@"content"][@"wordsInfo"]];
        
        self.titleLabel.text = self.wordsInfoModel.name;
        self.discriptionLabel.text = [NSString stringWithFormat:@"本条生词由 %@ 制作", self.wordsInfoModel.nickname];
        self.pronunciationLabel.text = self.wordsInfoModel.pronunciation_words;
        self.paraphraseLabel.text = self.wordsInfoModel.paraphrase;
        self.sentenceLabel.text = self.wordsInfoModel.sentences;
        self.associationLabel.text = self.wordsInfoModel.associate;
        
        if (self.isSearch) {
            [self setupBottomBar];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - 播放读音
- (IBAction)pronunciationButtonClick:(id)sender {
    [[VENAudioPlayer sharedAudioPlayer] playWithURL:[NSURL URLWithString:self.wordsInfoModel.path]];
    [[VENAudioPlayer sharedAudioPlayer] play];
}

#pragma mark - bottomBar
- (void)setupBottomBar {
    if (self.isSearch) {
        UIButton *addNewWordsBookButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 48)];
        
        if ([self.wordsInfoModel.is_exist isEqualToString:@"1"]) {
            addNewWordsBookButton.backgroundColor = UIColorFromRGB(0xFFDE02);
            [addNewWordsBookButton setTitle:@"添加到生词本" forState:UIControlStateNormal];
            [addNewWordsBookButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        } else {
            addNewWordsBookButton.backgroundColor = UIColorFromRGB(0xE8E8E8);
            [addNewWordsBookButton setTitle:@"已添加生词" forState:UIControlStateNormal];
            [addNewWordsBookButton setTitleColor:UIColorFromRGB(0xB2B2B2) forState:UIControlStateNormal];
        }
        
        addNewWordsBookButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [addNewWordsBookButton addTarget:self action:@selector(addNewWordsBookButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBarView addSubview:addNewWordsBookButton];
        
    } else {
        UIButton *previousButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth / 2, 48)];
        [previousButton setTitle:@"上一个生词" forState:UIControlStateNormal];
        [previousButton setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
        previousButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [previousButton addTarget:self action:@selector(previousButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBarView addSubview:previousButton];
        
        UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth / 2, 0, kMainScreenWidth / 2, 48)];
        [nextButton setTitle:@"下一个生词" forState:UIControlStateNormal];
        [nextButton setTitleColor:UIColorFromRGB(0x1A1A1A) forState:UIControlStateNormal];
        nextButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBarView addSubview:nextButton];
    }
}

- (void)addNewWordsBookButtonClick:(UIButton *)button {
    if ([self.wordsInfoModel.is_exist isEqualToString:@"1"]) {
        VENChooseCategoryView *chooseCategoryView = [[VENChooseCategoryView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        __weak typeof(self) weakSelf = self;
        chooseCategoryView.chooseCategoryViewBlock = ^(NSDictionary *dict) {
            
            NSDictionary *parameters = @{@"words_id" : weakSelf.wordsInfoModel.id,
                                         @"sort_id" : dict[@"sort_id"]};
            
            [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"user/addOtherWords" parameters:parameters successBlock:^(id responseObject) {
                
                button.backgroundColor = UIColorFromRGB(0xE8E8E8);
                [button setTitle:@"已添加生词" forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromRGB(0xB2B2B2) forState:UIControlStateNormal];
                
                if (self.myNewWordBookDetailsPageBlock) {
                    self.myNewWordBookDetailsPageBlock();
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyNewWordsPage" object:nil];
                
            } failureBlock:^(NSError *error) {
                
            }];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:chooseCategoryView];
    }
}

#pragma mark - 上一个
- (void)previousButtonClick {
    if (self.indexPathRow - 1 > -1) {
        VENMinePageMyNewWordBookModel *model = self.dataSourceArr[self.indexPathRow - 1] ;
        [self loadNewWordBookDetailsPageDataWithWordsID:model.id];
        self.indexPathRow--;
    }
}

#pragma mark - 下一个
- (void)nextButtonClick {
    if (self.indexPathRow + 1 < self.dataSourceArr.count) {
        VENMinePageMyNewWordBookModel *model = self.dataSourceArr[self.indexPathRow + 1] ;
        [self loadNewWordBookDetailsPageDataWithWordsID:model.id];
        self.indexPathRow++;
    }
}

#pragma mark - 我的生词本 编辑
- (void)setupRightButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [button addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
}

- (void)editButtonClick {
    VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController *vc = [[VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController alloc] init];
    vc.isEdit = YES;
    vc.words_id = self.wordsInfoModel.id;
    vc.source_id = self.wordsInfoModel.sort_id;
    [self.navigationController pushViewController:vc animated:YES];
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
