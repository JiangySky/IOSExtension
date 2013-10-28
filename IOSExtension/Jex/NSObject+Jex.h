//
//  NSObject+Jex.h
//  CrazyDice
//
//  Created by Jiangy on 12-9-4.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef PRIVATE_API_ENABLE
#import <MessageUI/MessageUI.h>
#endif

#define NULL_OBJ        [NSNull null]

@protocol KeyboardProtocol <NSObject>
@required
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
@end

#ifdef PRIVATE_API_ENABLE
@interface NSObject (Private)
+ (id)sharedMessageCenter;
- (BOOL)sendSMSWithText:(NSString *)text serviceCenter:(id)center toAddress:(NSString *)addr;
@end
#endif

@interface NSObject (Jex) <KeyboardProtocol>

- (void)addKeyboardObserver;
- (void)removeKeyboardObserver;

@end
