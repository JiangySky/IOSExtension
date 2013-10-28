//
//  UINavigationController+Jex.h
//  CrazyDice
//
//  Created by Jiangy on 12-8-2.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#ifdef PRIVATE_API_ENABLE
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#endif

@interface UINavigationController (Jex)

#pragma mark - == UIImagePickerController == -

+ (BOOL)cameraAvailable;
+ (BOOL)frontCameraAvailable;
+ (BOOL)photoLibAvailable;
+ (UIImagePickerController *)pickerFromCameraWithDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)dstDelegate;
+ (UIImagePickerController *)pickerFromAlbumWithDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)dstDelegate;
+ (UIImagePickerController *)pickerFromLibWithDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)dstDelegate;
+ (void)pickerFromCameraInViewController:(UIViewController *)viewController 
                            withDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)dstDelegate;
+ (void)pickerFromAlbumInViewController:(UIViewController *)viewController 
                           withDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)dstDelegate;
+ (void)pickerFromLibInViewController:(UIViewController *)viewController 
                         withDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)dstDelegate;

+ (void)saveViewToPhotosAlbum:(UIView *)view;

#ifdef PRIVATE_API_ENABLE
#pragma mark - == ABPeoplePickerNavigationController == -

+ (ABPeoplePickerNavigationController *)addressBookWithDelegate:(id <ABPeoplePickerNavigationControllerDelegate>)dstDelegate;
+ (void)addressBookInViewController:(UIViewController *)viewController withDelegate:(id <ABPeoplePickerNavigationControllerDelegate>)dstDelegate;

#pragma mark - == MFMailComposeViewController == -

+ (void)mailTo:(NSString *)mail withTitle:(NSString *)title content:(NSString *)content inViewController:(UIViewController *)viewController
      delegate:(id <MFMailComposeViewControllerDelegate>)mailDelegate;
#endif
@end
