//
//  UITextField+Jex.m
//  CrazyDice
//
//  Created by Jiangy on 12-7-28.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import "UITextField+Jex.h"
#import "UIDevice+Jex.h"

@implementation UITextField (Jex)

+ (UITextField *)textFieldWithFrame:(CGRect)frame {
    frame.size.width -= 5;
    frame.size.height -= ([CURRENT_DEVICE isHD] ? 20 : 6);
    frame = CGRectOffset(frame, 5, ([CURRENT_DEVICE isHD] ? 10 : 3));
    UITextField * jexTextField = [[UITextField alloc] initWithFrame:frame];
    [jexTextField setPropDefault];
    return jexTextField;
}

+ (UITextField *)passwordFieldWithFrame:(CGRect)frame {
    frame.size.width -= 5;
    frame.size.height -= ([CURRENT_DEVICE isHD] ? 20 : 6);
    frame = CGRectOffset(frame, 5, ([CURRENT_DEVICE isHD] ? 10 : 3));
    UITextField * jexTextField = [[UITextField alloc] initWithFrame:frame];
    [jexTextField setPropDefault];
    [jexTextField setSecureTextEntry:YES];
    return jexTextField;
}

+ (UITextField *)textFieldWithFrame:(CGRect)frame leftViewWidth:(CGFloat)width title:(NSString *)title content:(NSString *)text showClear:(BOOL)clear {
    frame.size.width -= 5;
    frame.size.height -= ([CURRENT_DEVICE isHD] ? 20 : 6);
    frame = CGRectOffset(frame, 5, ([CURRENT_DEVICE isHD] ? 10 : 3));
    UITextField * jexTextField = [[UITextField alloc] initWithFrame:frame];
    [jexTextField setPropDefault];
    if (title) {
        CGRect rect = CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
        [jexTextField addLeftview:rect withTitle:title];
    }
    [jexTextField setPlaceholder:text];
    if (clear) {
        [jexTextField showClear];
    }
    return jexTextField;
}

+ (UITextField *)passwordFieldWithFrame:(CGRect)frame leftViewWidth:(CGFloat)width title:(NSString *)title showClear:(BOOL)clear {
    frame.size.width -= 5;
    frame.size.height -= ([CURRENT_DEVICE isHD] ? 20 : 6);
    frame = CGRectOffset(frame, 5, ([CURRENT_DEVICE isHD] ? 10 : 3));
    UITextField * jexTextField = [[UITextField alloc] initWithFrame:frame];
    [jexTextField setPropDefault];
    if (title) {        
        CGRect rect = CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
        [jexTextField addLeftview:rect withTitle:title];
    }
    if (clear) {
        [jexTextField showClear];
    }
    [jexTextField setSecureTextEntry:YES];
    return jexTextField;
}

- (void)setPropDefault {
    [self setKeyboardAppearance:UIKeyboardAppearanceAlert];
    if ([[UIDevice osMajorVer] intValue] >= 5) {
        [self setSpellCheckingType:UITextSpellCheckingTypeNo];
    }
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self setClearsContextBeforeDrawing:NO];
    [self setBorderStyle:UITextBorderStyleNone];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setFont:[UIFont fontWithName:@"Helvetica" size:([CURRENT_DEVICE isHD] ? 28 : 14)]];
}

- (void)setWithBgColor:(UIColor *)bgColor textColor:(UIColor *)textColor isPassword:(BOOL)psw {
    [self setKeyboardAppearance:UIKeyboardAppearanceAlert];
    if ([[UIDevice osMajorVer] intValue] >= 5) {
        [self setSpellCheckingType:UITextSpellCheckingTypeNo];
    }
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self setClearsContextBeforeDrawing:NO];
    [self setBackgroundColor:(bgColor ? bgColor : [UIColor clearColor])];
    [self setTextColor:(textColor ? textColor : [UIColor blackColor])];
    [self setSecureTextEntry:psw];
}

- (void)showClear {
	[self setClearButtonMode:UITextFieldViewModeAlways];
}

- (UILabel *)addLeftview:(CGRect)leftViewRect withTitle:(NSString *)title {
	UILabel * label = [[UILabel alloc] initWithFrame:leftViewRect];
	[label setFont:[UIFont fontWithName:@"Helvetica" size:([CURRENT_DEVICE isHD] ? 28 : 14)]];
    label.text = title;
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor grayColor];
	self.leftViewMode = UITextFieldViewModeAlways;
	self.leftView = label;
	
	[label release];
	return label;
}

- (void)addLeftview:(UILabel *)label {
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor grayColor];
	
	self.leftViewMode = UITextFieldViewModeAlways;
	self.leftView = label;
}


@end
