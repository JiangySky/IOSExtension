//
//  UIView+Jex.h
//  CrazyDice
//
//  Created by Jiangy on 12-8-1.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GET_KEYBOARD_INFO(_height, _duration) \

enum _JexAnchor {
    kJexAnchorLT,
    kJexAnchorCT,
    kJexAnchorRT,
    kJexAnchorLC,
    kJexAnchorCC,
    kJexAnchorRC,
    kJexAnchorLB,
    kJexAnchorCB,
    kJexAnchorRB
};

typedef struct _JexKeyboardInfo {
    CGRect      rect;
    CGFloat     duration;
} KeyboardInfo;

@interface UIView (Jex)

- (void)setPosition:(CGPoint)position anchor:(NSInteger)anchor;
- (void)saveToPhotosAlbum;
+ (KeyboardInfo)keyBoardInfo:(NSNotification *)notification;
- (void)moveTo:(CGPoint)dstPos animated:(BOOL)ani;

@end
