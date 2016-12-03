//
//  ViewController.m
//  LabelHeightCalculate
//
//  Created by admin on 16/12/2.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>

@interface ViewController ()
//展示label
@property (weak, nonatomic) UILabel *DisplayLabel;
//实际大小
@property (weak, nonatomic) IBOutlet UILabel *realSizeLabel;
//计算大小
@property (weak, nonatomic) IBOutlet UILabel *calculateSizeLabel;
//分割内容显示
@property (weak, nonatomic) IBOutlet UILabel *linesContentLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *contentText = @"南美足联同意国民竞技队请求，沙佩科恩斯队将获南美杯冠军。南美足联同意国民竞技队请求，沙佩科恩斯队将获南美杯冠军。南美足联同意国民竞技队请求，沙佩科恩斯队将获南美杯冠军。";
    
    UILabel *DisplayLabel = [[UILabel alloc] init];
    DisplayLabel.numberOfLines = 0;
    DisplayLabel.text = contentText;
    DisplayLabel.textColor = [UIColor orangeColor];
    DisplayLabel.font = [UIFont systemFontOfSize:17];
    DisplayLabel.frame = CGRectMake(20, 70, 200, 200);
    [DisplayLabel sizeToFit];
    DisplayLabel.backgroundColor = [UIColor greenColor];
    [self.view addSubview:DisplayLabel];
    
    _DisplayLabel = DisplayLabel;
    
    //至少设置一个font属性
    UIFont *fnt = self.DisplayLabel.font;
    NSDictionary *dict = @{NSFontAttributeName: fnt};
    
    //在为达到高度的情况下只有label的宽度有约束作用，高度最多为1000
    CGSize defineSize = CGSizeMake(_DisplayLabel.bounds.size.width, 1000);
    
    /*options
     NSStringDrawingTruncatesLastVisibleLine
     如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号
     
     NSStringDrawingUsesLineFragmentOrigin
     ✅启用自动换行
     
     NSStringDrawingUsesFontLeading
     ✅计算行高时使用行距
     
     NSStringDrawingUsesDeviceMetrics
     计算布局时使用图元字形（而不是印刷字体）
     */
    CGRect rect = [contentText boundingRectWithSize:defineSize
                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:dict
                                            context:nil];
    
    NSString *calculateSize = NSStringFromCGSize(rect.size);
    _calculateSizeLabel.text = [NSString stringWithFormat:@"计算的大小为:%@", calculateSize];
    NSString *realSize = NSStringFromCGSize(_DisplayLabel.bounds.size);
    _realSizeLabel.text = [NSString stringWithFormat:@"实际的大小为:%@", realSize];
    
    //分割
    NSArray *arr = [self getLinesArrayOfStringInLabel:_DisplayLabel];
    NSMutableString *lineContent = [NSMutableString string];
    
    for (int i = 0; i < arr.count; i++) {
        [lineContent appendFormat:@"第%zd行为：%@\n", i, arr[i]];
    }
    _linesContentLabel.text = lineContent.copy;

}

#pragma mark - Tool

//计算当前行数，每行的内容
- (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label{
    NSString *text = [label text];
    UIFont *font = [label font];
    //目的为了取到label的宽度
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
        [linesArray addObject:lineString];
    }
    CFRelease(frameSetter);
    CFRelease(frame);
    CFRelease(path);
    return (NSArray *)linesArray;
}

@end
