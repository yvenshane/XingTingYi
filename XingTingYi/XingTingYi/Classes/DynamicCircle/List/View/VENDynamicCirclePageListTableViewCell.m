//
//  VENDynamicCirclePageListTableViewCell.m
//  XingTingYi
//
//  Created by YVEN on 2019/8/30.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENDynamicCirclePageListTableViewCell.h"
#import "VENDynamicCirclePageListModel.h"

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
    self.contentLabel.text = model.title;
    self.commentLabel.text = [NSString stringWithFormat:@"评论(%@)", model.count];
    
    // 图片
    for (UIView *subview in self.pictureView.subviews) {
        [subview removeFromSuperview];
    }
    
    if (model.images.count > 0) {
        if (model.images.count == 1) {
            CGFloat maxWidth = kMainScreenWidth - 66 - 20;
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, maxWidth, maxWidth)];
            [button sd_setImageWithURL:[NSURL URLWithString:model.images[0]] forState:UIControlStateNormal];
            button.imageView.contentMode = UIViewContentModeScaleAspectFill;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
            button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
            [self.pictureView addSubview:button];
            
            self.pictureHeightLayoutConstraint.constant = maxWidth;
            
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
                [button sd_setImageWithURL:[NSURL URLWithString:model.images[i]] forState:UIControlStateNormal];
                button.imageView.contentMode = UIViewContentModeScaleAspectFill;
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
                button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
                [self.pictureView addSubview:button];
                
                self.pictureHeightLayoutConstraint.constant = y + maxWidth + 5;
            }
        }
    } else {
        self.pictureHeightLayoutConstraint.constant = 0;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
