//
//  UIViewController+Jex.m
//  CrazyDice
//
//  Created by Jiangy on 12-8-2.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import "UIViewController+Jex.h"

@implementation UIViewController (Jex)

#pragma mark - == ABNewPersonViewController == -

+ (ABNewPersonViewController *)addressBookCreaterWithDelegate:(id <ABNewPersonViewControllerDelegate>)dstDelegate {
    ABNewPersonViewController * creater = [ABNewPersonViewController new];
	creater.newPersonViewDelegate = dstDelegate;
    return [creater autorelease];
}

+ (void)addressBookCreaterInViewController:(UIViewController *)viewController withDelegate:(id <ABNewPersonViewControllerDelegate>)dstDelegate {
    [viewController presentModalViewController:[UIViewController addressBookCreaterWithDelegate:dstDelegate] animated:YES];
}

@end
