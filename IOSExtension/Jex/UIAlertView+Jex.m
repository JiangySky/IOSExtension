//
//  UIAlertView+Jex.m
//  CrazyDice
//
//  Created by Jiangy on 12-7-31.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import "UIAlertView+Jex.h"

@implementation UIAlertView (Jex)

/*!
 @function
 @abstract   Alert view with params all
 @param      params : NSArray : [delegate, title, message, cancelButton, otherButton(option)]
 @return     UIAlertView : alertView(unnecessary)
 */
+ (UIAlertView *)alertViewWithParams:(NSArray *)params {
    id <UIAlertViewDelegate> delegate = (id)[params objectAtIndex:0];
	NSString * title = (NSString *)[params objectAtIndex:1];
	NSString * message = (NSString *)[params objectAtIndex:2];
	NSString * cancelBtnTip = (NSString *)[params objectAtIndex:3];
	
	UIAlertView * alert = [UIAlertView alloc];
	if ([params count] > 4) {
		NSString * otherBtnTip = (NSString *)[params objectAtIndex:4];
		[alert initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelBtnTip otherButtonTitles:otherBtnTip, nil];
	} else {
		[alert initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelBtnTip otherButtonTitles:nil];
	}
    
    return [alert autorelease];
}

+ (void)displayAlertViewWithParams:(NSArray *)params {
    id <UIAlertViewDelegate> delegate = (id)[params objectAtIndex:0];
	NSString * title = (NSString *)[params objectAtIndex:1];
	NSString * message = (NSString *)[params objectAtIndex:2];
	NSString * cancelBtnTip = (NSString *)[params objectAtIndex:3];
	
	UIAlertView * alert = [UIAlertView alloc];
	if ([params count] > 4) {
		NSString * otherBtnTip = (NSString *)[params objectAtIndex:4];
		[alert initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelBtnTip otherButtonTitles:otherBtnTip, nil];
	} else {
		[alert initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelBtnTip otherButtonTitles:nil];
	}
    [alert show];
    [alert release];
}

@end
