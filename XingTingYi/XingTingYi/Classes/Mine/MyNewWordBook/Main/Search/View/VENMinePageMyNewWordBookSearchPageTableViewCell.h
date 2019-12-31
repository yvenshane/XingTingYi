//
//  VENMinePageMyNewWordBookSearchPageTableViewCell.h
//  XingTingYi
//
//  Created by YVEN on 2019/12/30.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VENMinePageMyNewWordBookSearchPageModel;

NS_ASSUME_NONNULL_BEGIN

typedef void (^addNewWordBookBlock)(NSString *);
@interface VENMinePageMyNewWordBookSearchPageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pronunciationLabel;
@property (weak, nonatomic) IBOutlet UILabel *paraphraseLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *addNewWordBookButton;

@property (nonatomic, strong) VENMinePageMyNewWordBookSearchPageModel *model;
@property (nonatomic, copy) addNewWordBookBlock addNewWordBookBlock;

@end

NS_ASSUME_NONNULL_END
