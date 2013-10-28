//
//  UIImage+Jex.h
//  CrazyDice
//
//  Created by Jiangy on 12-7-31.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONRepresentation.h"

@interface UIImage (Jex) <JSONRepresentation>

+ (UIImage *)imageWithString:(NSString *)text font:(UIFont *)font;
- (UIImage *)resizeImage:(CGSize)dstSize withCorner:(CGFloat)corner;
- (UIImage *)scaleImage:(CGPoint)dstScale;
- (UIImage *)scaleX:(CGFloat)dstScale;
- (UIImage *)scaleY:(CGFloat)dstScale;
- (UIImage *)clipImage:(CGRect)dstRect;
- (BOOL)savePNGToDocumentWithName:(NSString *)name;
- (BOOL)savePNGToTemporaryWithName:(NSString *)name;
- (BOOL)savePNGToPath:(NSString *)fileFullPath;
- (void)saveImgToPhotosAlbum;
- (NSString *)getString;

@end
