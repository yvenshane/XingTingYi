//
//  VENDynamicCirclePageListTableViewCell.m
//  XingTingYi
//
//  Created by YVEN on 2019/8/30.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENDynamicCirclePageListTableViewCell.h"
#import "VENDynamicCirclePageListModel.h"
#import "JJPhotoManeger.h"

@interface VENDynamicCirclePageListTableViewCell ()
@property (nonatomic, strong) NSMutableArray<JJDataModel *> *dataModelMuArr;

@end

@implementation VENDynamicCirclePageListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    ViewRadius(self.avatarImageView, 18.0f);
}

- (void)setModel:(VENDynamicCirclePageListModel*)model {
    _model = model;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    //    cell.bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.nameLabel.text = model.nickname;
    self.timeLabel.text = model.time;
    if ([VENEmptyClass isEmptyString:model.time]) {
        self.timeLabel.text = model.created_at;
    }
    self.contentLabel.text = model.title;
    self.commentLabel.text = [NSString stringWithFormat:@"评论(%@)", model.count];
    if ([VENEmptyClass isEmptyString:model.count]) {
        self.commentLabel.text = [NSString stringWithFormat:@"评论(%@)", model.num];
    }
    
    // 图片
    for (UIView *subview in self.pictureView.subviews) {
        [subview removeFromSuperview];
    }
    
    [self.dataModelMuArr removeAllObjects];
    
    if (model.images.count > 0) {
        if (model.images.count == 1) {
            CGFloat maxWidth = kMainScreenWidth - 66 - 20;
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, maxWidth, maxWidth)];
            button.tag = 0;
            [button sd_setImageWithURL:[NSURL URLWithString:model.images[0]] forState:UIControlStateNormal];
            button.imageView.contentMode = UIViewContentModeScaleAspectFill;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
            button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.pictureView addSubview:button];
            
            self.pictureHeightLayoutConstraint.constant = maxWidth;
            
            JJDataModel *dataModel = [JJDataModel alloc];
            dataModel.containerView = button;
//            dataModel.holdImg = [UIImage imageNamed:@""];
            dataModel.imgUrl = model.images[0];
            [self.dataModelMuArr addObject:dataModel];
            
            // 方法2 适配图片高宽
//            __weak typeof(self) weakSelf = self;
//            [imageView sd_setImageWithURL:[NSURL URLWithString:model.images[0]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//
//                CGFloat imageWidth = imageView.image.size.width;
//                CGFloat imageHeight = imageView.image.size.height;
//
//                NSLog(@"宽：%f, 高：%f", imageWidth, imageHeight);
//
//                CGFloat maxWidth = kMainScreenWidth - 66 - 20;
//
//                if (imageWidth > maxWidth) {
//                    imageHeight = imageHeight * maxWidth / imageWidth;
//                    imageWidth = maxWidth;
//                }
//
//                imageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
//                [weakSelf.pictureView addSubview:imageView];
//
//
//                weakSelf.pictureHeightLayoutConstraint.constant = imageHeight;
//            }];
        } else {
            
            CGFloat maxWidth = 0;
            CGFloat y = 0;
            
            if (model.images.count > 2) {
                maxWidth = (kMainScreenWidth - 66 - 15) / 3 - 5;
            } else {
                maxWidth = (kMainScreenWidth - 66 - 15) / 2 - 5;
            }
            
            for (NSInteger i = 0; i < model.images.count; i++) {
                
                NSLog(@"%ld", i % 3);
                
                if (i % 3 == 0) {
                    if (i != 0) {
                        y += maxWidth + 5;
                    }
                }
                
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i % 3 * maxWidth + i % 3 * 5, y, maxWidth, maxWidth)];
                button.tag = i;
                [button sd_setImageWithURL:[NSURL URLWithString:model.images[i]] forState:UIControlStateNormal];
                button.imageView.contentMode = UIViewContentModeScaleAspectFill;
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
                button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.pictureView addSubview:button];
                
                self.pictureHeightLayoutConstraint.constant = y + maxWidth + 5;
                
                JJDataModel *dataModel = [JJDataModel alloc];
                dataModel.containerView = button;
//                dataModel.holdImg = [UIImage imageNamed:@""];
                dataModel.imgUrl = model.images[i];
                [self.dataModelMuArr addObject:dataModel];
            }
        }
    } else {
        self.pictureHeightLayoutConstraint.constant = 0;
    }
}

- (void)buttonClick:(UIButton *)button { 
    JJPhotoManeger *maneger = [[JJPhotoManeger alloc]init];
    maneger.exitComplate = ^(NSInteger lastSelectIndex) {
        NSLog(@"%zd",lastSelectIndex);
    };
    
    [maneger showPhotoViewerModels:self.dataModelMuArr selectView:button];
}

- (IBAction)moreButtonClick:(id)sender {
    if (self.moreButtonClickBlock) {
        self.moreButtonClickBlock();
    }
}

- (NSMutableArray<JJDataModel *> *)dataModelMuArr {
    if (!_dataModelMuArr) {
        _dataModelMuArr = [NSMutableArray array];
    }
    return _dataModelMuArr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
