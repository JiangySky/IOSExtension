//
//  UIView+Jex.m
//  CrazyDice
//
//  Created by Jiangy on 12-8-1.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import "UIView+Jex.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Jex)

- (void)setPosition:(CGPoint)position anchor:(NSInteger)anchor {
    CGPoint srcPos = self.frame.origin;
    CGSize srcSize = self.frame.size;
    CGAffineTransform t;
    switch (anchor) {
        case kJexAnchorLT:
            t = CGAffineTransformMakeTranslation(position.x - srcPos.x, position.y - srcPos.y);
            break;
        case kJexAnchorCT:
            t = CGAffineTransformMakeTranslation(position.x - srcPos.x - srcSize.width / 2, position.y - srcPos.y);
            break;
        case kJexAnchorRT:
            t = CGAffineTransformMakeTranslation(position.x - srcPos.x - srcSize.width, position.y - srcPos.y);
            break;
        case kJexAnchorLC:
            t = CGAffineTransformMakeTranslation(position.x - srcPos.x, position.y - srcPos.y - srcSize.height / 2);
            break;
        case kJexAnchorCC:
            t = CGAffineTransformMakeTranslation(position.x - srcPos.x - srcSize.width / 2, position.y - srcPos.y - srcSize.height / 2);
            break;
        case kJexAnchorRC:
            t = CGAffineTransformMakeTranslation(position.x - srcPos.x - srcSize.width, position.y - srcPos.y - srcSize.height / 2);
            break;
        case kJexAnchorLB:
            t = CGAffineTransformMakeTranslation(position.x - srcPos.x, position.y - srcPos.y - srcSize.height);
            break;
        case kJexAnchorCB:
            t = CGAffineTransformMakeTranslation(position.x - srcPos.x - srcSize.width / 2, position.y - srcPos.y - srcSize.height);
            break;
        case kJexAnchorRB:
            t = CGAffineTransformMakeTranslation(position.x - srcPos.x - srcSize.width, position.y - srcPos.y - srcSize.height);
            break;
        default:
            t = CGAffineTransformMakeTranslation(0, 0);
            break;
    }
    CGRect dstFrame = CGRectApplyAffineTransform(self.frame, t);
    [self setFrame:dstFrame];
}

- (void)saveToPhotosAlbum {
    UIGraphicsBeginImageContext(self.layer.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage * viewImg = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	UIImageWriteToSavedPhotosAlbum(viewImg, nil, nil, nil);
}

+ (KeyboardInfo)keyBoardInfo:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSValue * rectValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [rectValue CGRectValue];
    NSValue * durationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration;
    [durationValue getValue:&duration];
    return (KeyboardInfo){rect, duration};
}

- (void)moveTo:(CGPoint)dstPos animated:(BOOL)ani {
    if (ani) {
        
    } else {
        [self setPosition:dstPos anchor:kJexAnchorLT];
    }
}

@end
