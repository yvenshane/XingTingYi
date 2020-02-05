//
//  VENExcellentCourseDetailsPageViewController.m
//  XingTingYi
//
//  Created by YVEN on 2020/2/5.
//  Copyright © 2020 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENExcellentCourseDetailsPageViewController.h"
#import "VENExcellentCourseDetailsPageModel.h"

@interface VENExcellentCourseDetailsPageViewController ()

@end

@implementation VENExcellentCourseDetailsPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"课程详情";
    
    self.pictureImageViewHeightLayoutConstraint.constant = kMainScreenWidth / (375.0 / 250.0);
    
    [self loadExcellentCourseDetailsPageData];
}

- (void)loadExcellentCourseDetailsPageData {
    [[VENNetworkingManager shareManager] requestWithType:HttpRequestTypePOST urlString:@"goodCourse/goodCourseInfo" parameters:@{@"id" : self.id} successBlock:^(id responseObject) {
        
        VENExcellentCourseDetailsPageModel *model = [VENExcellentCourseDetailsPageModel yy_modelWithJSON:responseObject[@"content"][@"goodCourseInfo"]];
        
        [self.pictureImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
        self.titleLabel.text = model.title;
        self.otherLabel.text = [NSString stringWithFormat:@"%@    已有%@人购买", model.created_at, model.buynum];
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.price];
        self.contentLabel.text = model.descriptionn;
        
    } failureBlock:^(NSError *error) {
        
    }];
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
