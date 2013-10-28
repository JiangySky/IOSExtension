//
//  UITextField+Jex.h
//  CrazyDice
//
//  Created by Jiangy on 12-7-28.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITextField (Jex)

+ (UITextField *)textFieldWithFrame:(CGRect)rect;
+ (UITextField *)passwordFieldWithFrame:(CGRect)rect;
+ (UITextField *)textFieldWithFrame:(CGRect)frame leftViewWidth:(CGFloat)width title:(NSString *)title content:(NSString *)text showClear:(BOOL)clear;
+ (UITextField *)passwordFieldWithFrame:(CGRect)frame leftViewWidth:(CGFloat)width title:(NSString *)title showClear:(BOOL)clear;
- (void)setPropDefault;
- (void)setWithBgColor:(UIColor *)bgColor textColor:(UIColor *)textColor isPassword:(BOOL)psw;
- (void)showClear;
- (UILabel *)addLeftview:(CGRect)leftViewRect withTitle:(NSString *)title;
- (void)addLeftview:(UILabel *)label;

@end
