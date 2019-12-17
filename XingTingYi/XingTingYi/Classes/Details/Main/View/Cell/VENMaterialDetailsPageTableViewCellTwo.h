//
//  VENMaterialDetailsPageTableViewCellTwo.h
//  XingTingYi
//
//  Created by YVEN on 2019/12/9.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^buttonOneBlock)(UIButton *);
typedef void (^buttonTwoBlock)(void);
typedef void (^buttonThreeBlock)(void);
@interface VENMaterialDetailsPageTableViewCellTwo : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backgroundVieww;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;

@property (nonatomic, copy) buttonOneBlock buttonOneBlock;
@property (nonatomic, copy) buttonTwoBlock buttonTwoBlock;
@property (nonatomic, copy) buttonThreeBlock buttonThreeBlock;

@end

NS_ASSUME_NONNULL_END
