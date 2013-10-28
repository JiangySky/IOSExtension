//
//  UISwitch+Jex.m
//  CrazyDice
//
//  Created by Jiangy on 12-7-28.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import "UISwitch+Jex.h"
#define TagOffet_UISwitch        1000

@implementation UISwitch (Jex)

- (UILabel *)labelLeft {
    return (UILabel *)[self viewWithTag:(TagOffet_UISwitch + 1)];
}

- (UILabel *)labelRight {
    return (UILabel *)[self viewWithTag:(TagOffet_UISwitch + 2)];    
}

- (void)locate:(UIView *)aView withCount:(int *)count {
    for (UIView * subView in [aView subviews]) {
        if ([subView isKindOfClass:[UILabel class]]) {
            *count += 1;
            [subView setTag:(TagOffet_UISwitch + (*count))];
        } else {
            [self locate:subView withCount:count];
        }
    }
}

+ (UISwitch *)switchWithFrame:(CGRect)frame andLeftText:(NSString *)leftText rightText:(NSString *)rightText {
    UISwitch * jexSwitch = [[UISwitch alloc] initWithFrame:frame];
    int labelCount = 0;
    [jexSwitch locate:jexSwitch withCount:&labelCount];
    if (labelCount == 2) {
        [[jexSwitch labelLeft] setText:leftText];
        [[jexSwitch labelRight] setText:rightText];
    }
    return [jexSwitch autorelease];
}

@end
