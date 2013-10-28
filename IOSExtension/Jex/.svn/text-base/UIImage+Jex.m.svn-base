//
//  UIImage+Jex.m
//  CrazyDice
//
//  Created by Jiangy on 12-7-31.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import "UIImage+Jex.h"
#import "JexMacro.h"
#import "UIApplication+Jex.h"
#import "ASIHTTPRequest.h"

@interface UIImage (Private)

- (UIImage *)roundToSize:(CGSize)dstSize corner:(CGFloat)corner;
- (UIImage *)scaleToSize:(CGSize)dstSize;

@end

@implementation UIImage (Jex)

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight) {
    float fw,fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2); // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1); // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

- (UIImage *)roundToSize:(CGSize)dstSize corner:(CGFloat)corner {
    int w = dstSize.width;
    int h = dstSize.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, corner, corner);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), self.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
}

- (UIImage *)scaleToSize:(CGSize)dstSize {
    if (CGSizeEqualToSize(self.size, dstSize)) {
        return self;
    }
	UIGraphicsBeginImageContext(dstSize);
    [self drawInRect:CGRectMake(0, 0, dstSize.width, dstSize.height)];
    UIImage * dstImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return dstImage;
}

+ (UIImage *)imageWithString:(NSString *)text font:(UIFont *)font {
    CGSize size  = [text sizeWithFont:font];     
	UIGraphicsBeginImageContext(size);  
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();       
	[text drawAtPoint:CGPointMake(0, 0) withFont:font];      
	UIImage * dstImage = UIGraphicsGetImageFromCurrentImageContext();          
	UIGraphicsEndImageContext(); 
	CGContextRelease(ctx);
	
	return dstImage;
}

- (UIImage *)resizeImage:(CGSize)dstSize withCorner:(CGFloat)corner {
    if (FLOAT_EQUAL(corner, 0)) {
        return [self scaleToSize:dstSize];
    } else {
        return [self roundToSize:dstSize corner:corner];
    }
}

- (UIImage *)scaleImage:(CGPoint)dstScale {
    return [self scaleToSize:CGSizeMake(self.size.width * dstScale.x, self.size.height * dstScale.y)];
}

- (UIImage *)scaleX:(CGFloat)dstScale {
    return [self scaleImage:CGPointMake(dstScale, 1)];
}

- (UIImage *)scaleY:(CGFloat)dstScale {
    return [self scaleImage:CGPointMake(1, dstScale)];
}

- (UIImage *)clipImage:(CGRect)dstRect {
    CGImageRef imageRef = self.CGImage;
	CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, dstRect);
	return [UIImage imageWithCGImage:imagePartRef];
}

- (BOOL)savePNGToDocumentWithName:(NSString *)name {
    return [self savePNGToPath:[APP resourceInDocument:name]];
}

- (BOOL)savePNGToTemporaryWithName:(NSString *)name {
    return [self savePNGToPath:[APP resourceInTemporary:name]];
}

- (BOOL)savePNGToPath:(NSString *)fileFullPath {
    return [UIImagePNGRepresentation(self) writeToFile:fileFullPath atomically:YES];
}

- (void)saveImgToPhotosAlbum {
	UIImageWriteToSavedPhotosAlbum(self, nil, nil, nil);
}

- (NSString *)getString {
    if (self) {
        NSData * dataObj = UIImagePNGRepresentation(self);
        return [ASIHTTPRequest base64forData:dataObj];
    } else {
        return @"";
    }
}

- (NSData *)JSONDataRepresentation {
    return UIImagePNGRepresentation(self);
}

@end
