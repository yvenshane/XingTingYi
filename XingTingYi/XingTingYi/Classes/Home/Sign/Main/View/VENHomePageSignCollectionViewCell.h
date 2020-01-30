//
//  VENHomePageSignCollectionViewCell.h
//  XingTingYi
//
//  Created by YVEN on 2020/1/29.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^numberButtonClickBlock)(void);
@interface VENHomePageSignCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *numberButton;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;

@property (nonatomic, copy) numberButtonClickBlock numberButtonClickBlock;

@end

NS_ASSUME_NONNULL_END
