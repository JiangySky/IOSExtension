//
//  UINavigationController+Jex.m
//  CrazyDice
//
//  Created by Jiangy on 12-8-2.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import "UINavigationController+Jex.h"
#import "UIDevice+Jex.h"

@interface UINavigationController (Private)

+ (UIImagePickerController *)pickerWithDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)dstDelegate;

@end

@implementation UINavigationController (Jex)

#pragma mark - == UIImagePickerController == -

+ (BOOL)cameraAvailable {
    return ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]
            || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]);
}

+ (BOOL)frontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

+ (BOOL)photoLibAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (UIImagePickerController *)pickerWithDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)dstDelegate {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = dstDelegate;
    picker.allowsEditing = YES;
    return picker;
}

+ (UIImagePickerController *)pickerFromCameraWithDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)dstDelegate {
    UIImagePickerController * picker = [UIImagePickerController pickerWithDelegate:dstDelegate];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.cameraDevice = [UIImagePickerController frontCameraAvailable] ? UIImagePickerControllerCameraDeviceFront : UIImagePickerControllerCameraDeviceRear;
    return [picker autorelease];
}

+ (UIImagePickerController *)pickerFromAlbumWithDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)dstDelegate {
    UIImagePickerController * picker = [UIImagePickerController pickerWithDelegate:dstDelegate];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.cameraDevice = [UIImagePickerController frontCameraAvailable] ? UIImagePickerControllerCameraDeviceFront : UIImagePickerControllerCameraDeviceRear;
    return [picker autorelease];
}

+ (UIImagePickerController *)pickerFromLibWithDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)dstDelegate {
    UIImagePickerController * picker = [UIImagePickerController pickerWithDelegate:dstDelegate];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    return [picker autorelease];
}

+ (void)pickerFromCameraInViewController:(UIViewController *)viewController 
                            withDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)dstDelegate {
    [viewController presentModalViewController:[UIImagePickerController pickerFromCameraWithDelegate:dstDelegate] animated:YES];
}

+ (void)pickerFromAlbumInViewController:(UIViewController *)viewController 
                           withDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)dstDelegate {
    if ([CURRENT_DEVICE isHD]) {
        UIImagePickerController * picker = [UIImagePickerController pickerWithDelegate:dstDelegate];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIPopoverController * popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        [popover presentPopoverFromRect:CGRectMake(0, 0, 300, 300)
                                 inView:viewController.view
               permittedArrowDirections:UIPopoverArrowDirectionAny
                               animated:YES];
    } else {
        [viewController presentModalViewController:[UIImagePickerController pickerFromAlbumWithDelegate:dstDelegate] animated:YES];
    }
}

+ (void)pickerFromLibInViewController:(UIViewController *)viewController
                         withDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)dstDelegate {
    if ([CURRENT_DEVICE isHD]) {
        UIImagePickerController * picker = [UIImagePickerController pickerWithDelegate:dstDelegate];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIPopoverController * popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        [popover presentPopoverFromRect:[[UIScreen mainScreen] bounds]
                                 inView:viewController.view
               permittedArrowDirections:UIPopoverArrowDirectionAny
                               animated:YES];
    } else {
        [viewController presentModalViewController:[UIImagePickerController pickerFromLibWithDelegate:dstDelegate] animated:YES];
    }
}

+ (void)saveViewToPhotosAlbum:(UIView *)view {
	UIGraphicsBeginImageContext(view.layer.bounds.size);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage * viewImg = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	UIImageWriteToSavedPhotosAlbum(viewImg, nil, nil, nil);
}
#ifdef PRIVATE_API_ENABLE
#pragma mark - == ABPeoplePickerNavigationController == -

+ (ABPeoplePickerNavigationController *)addressBookWithDelegate:(id <ABPeoplePickerNavigationControllerDelegate>)dstDelegate {
    ABPeoplePickerNavigationController * picker = [ABPeoplePickerNavigationController new];
	[picker setPeoplePickerDelegate:dstDelegate];
    return [picker autorelease];
}

+ (void)addressBookInViewController:(UIViewController *)viewController
                       withDelegate:(id <ABPeoplePickerNavigationControllerDelegate>)dstDelegate {
    [viewController presentModalViewController:[UINavigationController addressBookWithDelegate:dstDelegate] animated:YES];
}

#pragma mark - == MFMailComposeViewController == -

+ (void)mailTo:(NSString *)mail withTitle:(NSString *)title content:(NSString *)content inViewController:(UIViewController *)viewController
      delegate:(id <MFMailComposeViewControllerDelegate>)mailDelegate {
    MFMailComposeViewController * mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = mailDelegate;
    [mc setSubject:title];
    [mc setToRecipients:[NSArray arrayWithObjects:mail, nil]];
    [mc setMessageBody:content isHTML:NO];
    [viewController presentModalViewController:mc animated:YES];
    [mc release];
}
#endif
@end
