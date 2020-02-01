//
//  VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController.m
//  XingTingYi
//
//  Created by YVEN on 2019/12/11.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController.h"
#import "VENMaterialDetailsTranslationPageSearchWordAddNewWordsTableHeaderView.h"
#import "VENChooseCategoryView.h"
#import "QiniuSDK.h"
#import "VENMaterialDetailsAddNewWordsEditNewWordsModel.h"

@interface VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController ()
@property (nonatomic, strong) VENMaterialDetailsTranslationPageSearchWordAddNewWordsTableHeaderView *headerView;
@property (nonatomic, copy) NSString *sort_id;
@property (nonatomic, copy) NSString *sort_name;

@property (nonatomic, copy) NSString *path;

@property (nonatomic, strong) VENMaterialDetailsAddNewWordsEditNewWordsModel *wordsInfoModel;
@property (nonatomic, copy) NSString *pronunciation_words;
@property (nonatomic, copy) NSString *sentences;
@property (nonatomic, copy) NSString *associate;

@end

static NSString *const cellIdentifier = @"cellIdentifier";
@implementation VENMaterialDetailsTranslationPageSearchWordAddNewWordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTableView];
    
    if (self.isEdit) {
        self.navigationItem.title = @"编辑生词";
        [self loadEditNewWordsData];
    } else {
        self.navigationItem.title = @"添加生词";
    }
}

//userSource/subUserWords

- (void)loadEditNewWordsData {
    NSString *url = @"";
    NSDictionary *parameters = @{};
    
    if (self.isPersonalMaterial) {
        url = @"userSource/userWordsInfo";
        parameters = @{@"words_id" : self.words_id,
                       @"source_id" : self.source_id};
    } else {
        url = @"source/wordsInfo";
        parameters = @{@"words_id" : self.words_id};
    }
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:url parameters:parameters successBlock:^(id responseObject) {
        
        self.wordsInfoModel = [VENMaterialDetailsAddNewWordsEditNewWordsModel yy_modelWithJSON:responseObject[@"content"][@"wordsInfo"]];
        
        NSArray *wordsCategoryArr = responseObject[@"content"][@"wordsCategory"];
        
        for (NSDictionary *dict in wordsCategoryArr) {
            for (NSDictionary *dict2 in dict[@"son"]) {
                if ([self.wordsInfoModel.sort_id isEqualToString:dict2[@"id"]]) {
                    self.sort_id = dict2[@"id"];
                    self.sort_name = dict2[@"name"];
                }
            }
        }
        
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VENMaterialDetailsTranslationPageSearchWordAddNewWordsTableHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"VENMaterialDetailsTranslationPageSearchWordAddNewWordsTableHeaderView" owner:nil options:nil].lastObject;
    headerView.isEdit = self.isEdit;
    headerView.path = self.wordsInfoModel.path;
    
    headerView.addNewWordsBlock = ^(NSString *str) {
        self.path = str;
    };
    
    // 生词
    headerView.nnewWordsTextField.text = [VENEmptyClass isEmptyString:self.keyword] ? self.wordsInfoModel.name : self.keyword;
    [headerView.nnewWordsTextField addTarget:self action:@selector(nnewWordsTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    // 分类
    headerView.categoryLabel.text = [VENEmptyClass isEmptyString:self.sort_name] ? @"请选择" : self.sort_name;
    headerView.categoryLabel.textColor = [headerView.categoryLabel.text isEqualToString:@"请选择"] ? UIColorFromRGB(0xB2B2B2) : UIColorFromRGB(0x222222);
    [headerView.categoryButton addTarget:self action:@selector(categoryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 释义
    headerView.translateTextField.text = [VENEmptyClass isEmptyString:self.translation] ? self.wordsInfoModel.paraphrase : self.translation;
    [headerView.translateTextField addTarget:self action:@selector(translateTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    // 读音
    headerView.pronunciationTextField.text = self.wordsInfoModel.pronunciation_words;
    
    // 例句
    headerView.textViewOne.text = self.wordsInfoModel.sentences;
    headerView.placeholderLabelOne.hidden = [VENEmptyClass isEmptyString:self.wordsInfoModel.sentences] ? NO : YES;
    
    // 联想
    headerView.textViewTwo.text = self.wordsInfoModel.associate;
    headerView.placeholderLabelTwo.hidden = [VENEmptyClass isEmptyString:self.wordsInfoModel.associate] ? NO : YES;
    
    _headerView = headerView;
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 487;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    
    if (self.isEdit) {
        
        CGFloat width = (kMainScreenWidth - 20 * 2 - 15) / 2;
        
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 25, width, 48)];
        deleteButton.backgroundColor = [UIColor whiteColor];
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [deleteButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        deleteButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        deleteButton.layer.cornerRadius = 24.0f;
        deleteButton.layer.masksToBounds = YES;
        deleteButton.layer.borderWidth = 1.0f;
        deleteButton.layer.borderColor = UIColorFromRGB(0x222222).CGColor;
        [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:deleteButton];
        
        UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(20 + 15 + width, 25, width, 48)];
        saveButton.backgroundColor = UIColorFromRGB(0xFFDE02);
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [saveButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        saveButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        saveButton.layer.cornerRadius = 24.0f;
        saveButton.layer.masksToBounds = YES;
        [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:saveButton];
    } else {
        UIButton *commitButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 25, kMainScreenWidth - 40, 48)];
        commitButton.backgroundColor = UIColorFromRGB(0xFFDE02);
        [commitButton setTitle:@"提交" forState:UIControlStateNormal];
        [commitButton setTitleColor:UIColorFromRGB(0x222222) forState:UIControlStateNormal];
        commitButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        commitButton.layer.cornerRadius = 24.0f;
        commitButton.layer.masksToBounds = YES;
        [commitButton addTarget:self action:@selector(commitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:commitButton];
    }
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 25 + 48;
}

- (void)nnewWordsTextFieldEditingChanged:(UITextField *)textField {
    self.keyword = textField.text;
}

- (void)translateTextFieldEditingChanged:(UITextField *)textField {
    self.translation = textField.text;
}

#pragma mark - 选择分类
- (void)categoryButtonClick {
    [self.headerView.nnewWordsTextField resignFirstResponder];
    [self.headerView.translateTextField resignFirstResponder];
    
    VENChooseCategoryView *chooseCategoryView = [[VENChooseCategoryView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight)];
//    chooseCategoryView.sort_id = self.sort_id;
    __weak typeof(self) weakSelf = self;
    chooseCategoryView.chooseCategoryViewBlock = ^(NSDictionary *dict) {
        weakSelf.sort_id = dict[@"sort_id"];
        weakSelf.sort_name = dict[@"sort_name"];
        
        [weakSelf.tableView reloadData];
    };
    [self.view addSubview:chooseCategoryView];
}

#pragma mark - 删除/保存/提交
- (void)deleteButtonClick {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"user/delWords" parameters:@{@"words_id" : self.words_id} successBlock:^(id responseObject) {
        
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyNewWordsPage" object:nil];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)saveButtonClick {
    if (![VENEmptyClass isEmptyString:self.path]) { // 重新录音
        [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypeGET urlString:@"qiniu/createToken" parameters:nil successBlock:^(id responseObject) {
            
            NSString *token = responseObject[@"content"][@"token"];
            NSString *path = self.path;
            NSData *data= [NSData dataWithContentsOfFile:path];
            NSString *keys = responseObject[@"content"][@"key"];
            
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            [upManager putData:data key:keys token:token complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                NSLog(@"info - %@", info);
                NSLog(@"resp - %@", resp);
                
                NSDictionary *parameters = @{@"source_id" : self.source_id,
                                             @"words_id" : self.words_id,
                                             @"name" : self.headerView.nnewWordsTextField.text,
                                             @"sort_id" : self.sort_id,
                                             @"paraphrase" : self.headerView.translateTextField.text,
                                             @"pronunciation" : resp[@"key"],
                                             @"pronunciation_words" : self.headerView.pronunciationTextField.text,
                                             @"sentences" : self.headerView.textViewOne.text,
                                             @"associate" : self.headerView.textViewTwo.text};
                
                [MBProgressHUD addLoading];
                
                NSString *url = @"";
                if (self.isPersonalMaterial) {
                    url = @"userSource/subUserWords";
                } else {
                    url = @"source/subWords";
                }
                
                [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:url parameters:parameters successBlock:^(id responseObject) {
                    
                    [MBProgressHUD removeLoading];
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyNewWordsPage" object:nil];
                    
                } failureBlock:^(NSError *error) {
                    
                }];
                
            } option:[QNUploadOption defaultOptions]];
            
        } failureBlock:^(NSError *error) {
            
        }];
    } else { // 没有修改录音
        NSDictionary *parameters = @{@"source_id" : self.source_id,
                                     @"words_id" : self.words_id,
                                     @"name" : self.headerView.nnewWordsTextField.text,
                                     @"sort_id" : self.sort_id,
                                     @"paraphrase" : self.headerView.translateTextField.text,
                                     @"pronunciation" : self.wordsInfoModel.pronunciation,
                                     @"pronunciation_words" : self.headerView.pronunciationTextField.text,
                                     @"sentences" : self.headerView.textViewOne.text,
                                     @"associate" : self.headerView.textViewTwo.text};
        
        [MBProgressHUD addLoading];
        
        NSString *url = @"";
        if (self.isPersonalMaterial) {
            url = @"userSource/subUserWords";
        } else {
            url = @"source/subWords";
        }
        
        [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:url parameters:parameters successBlock:^(id responseObject) {
            
            [MBProgressHUD removeLoading];
            [self.navigationController popViewControllerAnimated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyNewWordsPage" object:nil];
            
        } failureBlock:^(NSError *error) {
            
        }];
    }
}

- (void)commitButtonClick {

    if ([VENEmptyClass isEmptyString:self.path]) {
        return;
    }
    
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypeGET urlString:@"qiniu/createToken" parameters:nil successBlock:^(id responseObject) {
        
        NSString *token = responseObject[@"content"][@"token"];
        NSString *path = self.path;
        NSData *data= [NSData dataWithContentsOfFile:path];
        NSString *keys = responseObject[@"content"][@"key"];
        
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        [upManager putData:data key:keys token:token complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            NSLog(@"info - %@", info);
            NSLog(@"resp - %@", resp);
            
            NSDictionary *parameters = @{};
            NSString *url = @"";
            
            if ([self.origin isEqualToString:@"PersonalCenter"]) {
                parameters = @{@"source_id" : @"0",
                               @"words_id" : @"0",
                               @"name" : self.keyword,
                               @"sort_id" : self.sort_id,
                               @"paraphrase" : self.translation,
                               @"pronunciation" : resp[@"key"],
                               @"pronunciation_words" : self.headerView.pronunciationTextField.text,
                               @"sentences" : self.headerView.textViewOne.text,
                               @"associate" : self.headerView.textViewTwo.text,
                               @"type" : @"0"};
                url = @"user/reSubWords";
            } else {
                parameters = @{@"source_id" : self.source_id,
                               @"words_id" : @"0",
                               @"name" : self.keyword,
                               @"sort_id" : self.sort_id,
                               @"paraphrase" : self.translation,
                               @"pronunciation" : resp[@"key"],
                               @"pronunciation_words" : self.headerView.pronunciationTextField.text,
                               @"sentences" : self.headerView.textViewOne.text,
                               @"associate" : self.headerView.textViewTwo.text};
                
                if (self.isPersonalMaterial) {
                    url = @"userSource/subUserWords";
                } else {
                    url = @"source/subWords";
                }
            }
            
            [MBProgressHUD addLoading];
            
            [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:url parameters:parameters successBlock:^(id responseObject) {
                
                [MBProgressHUD removeLoading];
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMyNewWordsPage" object:nil];
                
            } failureBlock:^(NSError *error) {
                
            }];
            
        } option:[QNUploadOption defaultOptions]];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)setupTableView {
    self.tableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - kStatusBarAndNavigationBarHeight - (kTabBarHeight - 49));
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = nil;
    [self.view addSubview:self.tableView];
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
