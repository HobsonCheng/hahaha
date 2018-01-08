//
//  NSString+DrawingAdapter.h
//  UIMaster
//
//  Created by bai on 16/6/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (DrawingAdapter)

// 适配函数
- (CGSize)sizeWithFontCompatible:(UIFont *)font;
- (CGSize)sizeWithFontCompatible:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)sizeWithFontCompatible:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)sizeWithFontCompatible:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (void)drawAtPointCompatible:(CGPoint)point withFont:(UIFont *)font;
- (void)drawInRectCompatible:(CGRect)rect withFont:(UIFont *)font;
- (void)drawInRectCompatible:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment;

@end

