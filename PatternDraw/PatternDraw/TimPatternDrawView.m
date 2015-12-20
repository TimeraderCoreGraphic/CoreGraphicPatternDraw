//
//  TimPatternDrawView.m
//  PatternDraw
//
//  Created by 李佳 on 15/12/20.
//  Copyright © 2015年 LiJia. All rights reserved.
//

#import "TimPatternDrawView.h"
#import <CoreGraphics/CGPattern.h>
#import <CoreText/CTFont.h>
#import <CoreGraphics/CGFont.h>

static const CGFloat cellWidth = 16.0; //单元格宽
static const CGFloat cellHeight = 16.0; //单元格高
static const CGFloat arcMargin = 2.0;

static const CGFloat xStep = 20.0;
static const CGFloat yStep = 20.0;


/*
 步骤
 写一个绘制着色模式单元格的回调函数
 设置着色模式的颜色空间
 设置着色模式的骨架(Anatomy)
 指定着色模式作为填充或描边模式
 使用着色模式绘制
 */


//info: 一个指向模式相关数据的指针。这个参数是可选的，可以传递NULL。传递给回调的数据与后面创建模式的数据是一样的。
//context: 绘制模式单元格的图形上下文

static NSString* text = @"Hello Timereader 佳";


void TimDrawColoredPattern (void *info, CGContextRef ctx)
{
    //画个圆。
    CGContextSaveGState(ctx);
    CGContextAddArc(ctx, cellHeight / 2, cellHeight / 2, (cellWidth - arcMargin) / 2, 0, 2 * M_PI, 1);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokePath(ctx);
    
    NSString* showText = @"X";
    NSString* fontName = @"Times New Roman";
    
    CTFontRef fontZero = CTFontCreateUIFontForLanguage(kCTFontUIFontUser, 10, NULL);
    CTFontRef ctFont = CTFontCreateCopyWithFamily(fontZero, 12.0, NULL, (CFStringRef)fontName);
    
    unichar* chars = (unichar*)malloc(sizeof(unichar) * showText.length);
    CGGlyph* glyphs = (CGGlyph*)malloc(sizeof(CGGlyph) * showText.length);
    
    CFStringGetCharacters((CFStringRef)showText, CFRangeMake(0, showText.length), chars);
    CTFontGetGlyphsForCharacters(ctFont, chars, glyphs, showText.length);
    
    CGPoint* points = (CGPoint*)malloc(sizeof(CGPoint) * showText.length);
    for (int i = 0; i < showText.length; ++i)
    {
        points[i] = CGPointMake(4 + 6 * i, 4);
    }
    
    CGFontRef cgFont = CGFontCreateWithFontName((CFStringRef)fontName);
    CGContextSetFont(ctx, cgFont);
    CGContextSetFontSize(ctx, 12);
    
    CGContextShowGlyphsAtPositions(ctx, glyphs, points, showText.length);
    free(chars);
    free(glyphs);
    free(points);

    CGContextAddRect(ctx, CGRectMake(0, 0, cellWidth, cellHeight));
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextStrokePath(ctx);
    
    CGContextRestoreGState(ctx);
}



@implementation TimPatternDrawView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef patternSpace;
    
    // 创建模式颜色空间，并传递NULL作为参数
    patternSpace = CGColorSpaceCreatePattern (NULL);
    // 在模式颜色空间中设置填充颜色
    CGContextSetFillColorSpace (context, patternSpace);
    CGColorSpaceRelease (patternSpace);
    //生成模式
    CGPatternCallbacks callBacks = {0,TimDrawColoredPattern, NULL};
    /*
     三种模式
     1. 没有失真(no distortion): 以细微调整模式单元格之间的间距为代价，但通常不超过一个设备像素。
     2. 最小的失真的恒定间距：设定单元格之间的间距，以细微调整单元大小为代价，但通常不超过一个设备像素。
     3. 恒定间距：设定单元格之间间距，以调整单元格大小为代价，以求尽快的平铺
     */
    
    CGPatternRef pattern = CGPatternCreate(NULL, CGRectMake(0, 0, cellWidth, cellHeight), CGAffineTransformIdentity, xStep, yStep, kCGPatternTilingNoDistortion, true, &callBacks);
    //设置透明度
    CGFloat alpha = 1;
    CGRect drawRect = CGRectMake(0, 60, self.frame.size.width, self.frame.size.height - 70);
    CGContextSetFillPattern (context, pattern, &alpha);
    //开始渲染pattern
    CGContextFillRect(context, drawRect);
    CGPatternRelease(pattern);
}

@end
