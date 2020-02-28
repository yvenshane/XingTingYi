//
//  VENMaterialDetailsPageMyDictationView.m
//  XingTingYi
//
//  Created by YVEN on 2019/11/25.
//  Copyright © 2019 Hefei Haiba Network Technology Co., Ltd. All rights reserved.
//

#import "VENMaterialDetailsPageMyDictationView.h"
#import <CoreText/CoreText.h>

@implementation VENMaterialDetailsPageMyDictationView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.contentVieww.layer.cornerRadius = 8.0f;
    self.contentVieww.layer.masksToBounds = YES;
    self.contentVieww.layer.borderWidth = 1.0f;
    self.contentVieww.layer.borderColor = UIColorFromRGB(0xE8E8E8).CGColor;
    
    self.contentLabel.numberOfLines = 3;
        
    [self.contentButton addTarget:self action:@selector(contentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *arr = [self getLinesArrayOfStringInLabel:self.contentLabel];
    if (arr.count > 3) {
        self.contentButton.hidden = NO;
    } else {
        self.contentButton.hidden = YES;
    }
}

- (void)contentButtonClick:(UIButton *)button {
    if (button.selected) {
        button.selected = NO;
        self.contentLabel.numberOfLines = 3;
    } else {
        button.selected = YES;
        self.contentLabel.numberOfLines = 0;
    }
    
    CGFloat height = [self.contentLabel sizeThatFits:CGSizeMake(kMainScreenWidth - 35 * 2, CGFLOAT_MAX)].height;
    
    if (self.myDictationViewBlock) {
        self.myDictationViewBlock(height);
    }
}

#pragma mark - 行数/每行内容
- (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label{
    NSString *text = [label text];
    UIFont *font = [label font];
    CGRect rect = [label frame];

    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge  CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [text substringWithRange:range];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
        //NSLog(@"''''''''''''''''''%@",lineString);
        [linesArray addObject:lineString];
    }

    CGPathRelease(path);
    CFRelease( frame );
    CFRelease(frameSetter);
    return (NSArray *)linesArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
