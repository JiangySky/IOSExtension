//
//  NSObject+Jex.m
//  CrazyDice
//
//  Created by Jiangy on 12-9-4.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import "NSObject+Jex.h"

@implementation NSObject (Jex)

- (void)addKeyboardObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeKeyboardObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    // NOTE: overwrite
}
- (void)keyboardWillHide:(NSNotification *)notification {
    // NOTE: overwrite
}

@end
