//
//  UITouch+Jex.m
//  CrazyDice
//
//  Created by Jiangy on 12-8-8.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import "UITouch+Jex.h"

@implementation UITouch (Jex)

- (UITouchPhase)savedPhase:(BOOL)udpate {
    static UITouchPhase savedPhase = UITouchPhaseBegan;
    if (udpate && savedPhase != [self phase]) {
        savedPhase = [self phase];
    }
    return savedPhase;
}

@end
