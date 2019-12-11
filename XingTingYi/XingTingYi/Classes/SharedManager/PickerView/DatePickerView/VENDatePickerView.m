//
//  VENDatePickerView.m
//  CosmeticsStory
//
//  Created by YVEN on 2019/5/12.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENDatePickerView.h"

@interface VENDatePickerView ()
@property (nonatomic, strong) UIButton *backgroundButton;
@property (nonatomic, strong) UIView *datePickerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) CALayer *lineLayer;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, copy) NSDateFormatter *dateFormatter;
@property (nonatomic, copy) NSString *dateString;

@end

static const CGFloat kMargin = 10;
static const CGFloat kToolBarHeight = 48;
static const CGFloat kDatePickerHeight = 216;
@implementation VENDatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIButton *backgroundButton = [[UIButton alloc] init];
        backgroundButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [backgroundButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backgroundButton];
        
        UIView *datePickerView = [[UIView alloc] init];
        datePickerView.backgroundColor = [UIColor whiteColor];
        [backgroundButton addSubview:datePickerView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = UIColorFromRGB(0x333333);
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [datePickerView addSubview:titleLabel];
        
        UIButton *cancelButton = [[UIButton alloc] init];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [datePickerView addSubview:cancelButton];
        
        UIButton *confirmButton = [[UIButton alloc] init];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [datePickerView addSubview:confirmButton];
        
        CALayer *lineLayer = [[CALayer alloc] init];
        lineLayer.backgroundColor = UIColorFromRGB(0xE8E8E8).CGColor;
        [datePickerView.layer addSublayer:lineLayer];
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker setMaximumDate:[NSDate date]];
        [datePicker addTarget:self action:@selector(dateValueChanged:) forControlEvents:UIControlEventValueChanged];
        [datePickerView addSubview:datePicker];
        
        _datePickerView = datePickerView;
        _backgroundButton = backgroundButton;
        _titleLabel = titleLabel;
        _cancelButton = cancelButton;
        _confirmButton = confirmButton;
        _lineLayer = lineLayer;
        _datePicker = datePicker;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundButton.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    self.datePickerView.frame = CGRectMake(0, kMainScreenHeight - kDatePickerHeight - kToolBarHeight - (kTabBarHeight - 49), kMainScreenWidth, kDatePickerHeight + kToolBarHeight + (kTabBarHeight - 49));
    
    self.titleLabel.text = self.title;
    self.titleLabel.frame = CGRectMake(kMargin + kToolBarHeight + kMargin, 0, kMainScreenWidth - (kMargin + kToolBarHeight + kMargin) * 2, kToolBarHeight);
    self.cancelButton.frame = CGRectMake(kMargin, 0, kToolBarHeight, kToolBarHeight);
    self.confirmButton.frame = CGRectMake(kMainScreenWidth - kToolBarHeight - kMargin, 0, kToolBarHeight, kToolBarHeight);
    self.lineLayer.frame = CGRectMake(0, kToolBarHeight - 1, kMainScreenWidth, 1);
    
    [self.datePicker setDate:[VENEmptyClass isEmptyString:self.date] ? [NSDate date] : [self.dateFormatter dateFromString:self.date] animated:YES];
    self.datePicker.frame = CGRectMake(0, kToolBarHeight, kMainScreenWidth, kDatePickerHeight);
}

#pragma mark - ToolBarButtonClick
- (void)cancelButtonClick {
    [self removeFromSuperview];
}

- (void)confirmButtonClick {
    if ([VENEmptyClass isEmptyString:self.dateString]) {
        self.dateString = [VENEmptyClass isEmptyString:self.date] ? [self.dateFormatter stringFromDate:[NSDate date]] : self.date;
    }
    
    if (self.datePickerViewBlock) {
        self.datePickerViewBlock(self.dateString);
    }
    
    [self removeFromSuperview];
}

#pragma mark - dateValueChanged
- (void)dateValueChanged:(UIDatePicker *)datePicker {
    self.dateString = [self.dateFormatter stringFromDate:datePicker.date];
}

#pragma mark - dateFormatter
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
