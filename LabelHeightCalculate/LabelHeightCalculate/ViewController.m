//
//  ViewController.m
//  LabelHeightCalculate
//
//  Created by admin on 16/12/2.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
//展示label
@property (weak, nonatomic) UILabel *DisplayLabel;
//实际大小
@property (weak, nonatomic) IBOutlet UILabel *realSizeLabel;
//计算大小
@property (weak, nonatomic) IBOutlet UILabel *calculateSizeLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *contentText = @"I'm the contenText.I'm the contenText.I'm the contenText.I'm the contenText.I'm the contenText.I'm the contenText.I'm the contenText.I'm the contenText.";
    
    UILabel *DisplayLabel = [[UILabel alloc] init];
    DisplayLabel.numberOfLines = 0;
    DisplayLabel.text = contentText;
    DisplayLabel.textColor = [UIColor orangeColor];
    DisplayLabel.font = [UIFont systemFontOfSize:17];
    DisplayLabel.frame = CGRectMake(20, 20, 200, 100);
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
}
@end
