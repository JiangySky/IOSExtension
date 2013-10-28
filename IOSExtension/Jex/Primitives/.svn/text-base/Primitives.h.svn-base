//
//  DrawPrimitives.h
//  CrazyDice
//
//  Created by Jiangy on 11-4-26.
//  Copyright 2011 35VI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "Macros.h"

#pragma mark -

@interface Primitives : NSObject {
	BOOL				checkError;
	
	GLuint				textures[MAX_TEXTURE];
	CGSize				textureSize[MAX_TEXTURE];
	NSInteger			currTexture, nextTexture;
	
	NSMutableArray *	texturesArray;
}

@property BOOL			checkError;

+ (CGFloat)angleBetweenPoint:(CGPoint)startPoint andPoint:(CGPoint)endPoint;
+ (CGPoint)centerOfArcFrom:(CGPoint)startPoint to:(CGPoint)endPoint withRadius:(CGFloat)radius clockwise:(kDrawStyle)clockwise;
+ (UIImage *)glToImage;

#pragma mark -

- (void)cleanScreenInContext:(EAGLContext *)context;
- (void)cleanScreenInContext:(EAGLContext *)context withColor:(kColor4F)color;
- (void)cleanRect:(CGRect)rect inContext:(EAGLContext *)context withColor:(kColor4F)color;

- (void)checkGLError:(BOOL)visibleCheck;
- (CGSize)loadTextureWithImage:(UIImage *)uiImage orName:(NSString *)imageName;

#pragma mark -

- (void)drawPoint:(CGPoint)point inContext:(EAGLContext *)context withColor:(kColor4F)color;
- (void)drawPoint:(CGPoint)point inContext:(EAGLContext *)context withColor:(kColor4F)color width:(CGFloat)width;
- (void)drawPoints:(CGPoint *)points pointAmount:(NSInteger)count inContext:(EAGLContext *)context withColor:(kColor4F)color;
- (void)drawPoints:(CGPoint *)points pointAmount:(NSInteger)count 
		 inContext:(EAGLContext *)context 
		 withColor:(kColor4F)color width:(CGFloat)width;
- (void)drawPointsInContext:(EAGLContext *)context withColor:(kColor4F)color width:(CGFloat)width
					 points:(NSString *)s_point, ... NS_REQUIRES_NIL_TERMINATION;

#pragma mark -

- (void)drawLineFrom:(CGPoint)startPoint to:(CGPoint)endPoint inContext:(EAGLContext *)context withColor:(kColor4F)color;
- (void)drawLineFrom:(CGPoint)startPoint to:(CGPoint)endPoint 
		   inContext:(EAGLContext *)context 
		   withColor:(kColor4F)color width:(CGFloat)width;
- (void)drawLines:(CGPoint *)points pointAmount:(NSInteger)count inContext:(EAGLContext *)context withColor:(kColor4F)color;
- (void)drawLines:(CGPoint *)points pointAmount:(NSInteger)count 
		inContext:(EAGLContext *)context 
		withColor:(kColor4F)color width:(CGFloat)width;
- (void)drawLines:(CGPoint *)points pointAmount:(NSInteger)count 
		inContext:(EAGLContext *)context 
		withColor:(kColor4F)color width:(CGFloat)width 
		joinOrSeg:(kDrawStyle)isSeg;
- (void)drawLinesInContext:(EAGLContext *)context 
				 withColor:(kColor4F)color width:(CGFloat)width 
				 joinOrSeg:(kDrawStyle)isSeg
				   sPoints:(NSString *)s_point, ... NS_REQUIRES_NIL_TERMINATION;

#pragma mark -

- (void)drawRect:(CGRect)rect inContext:(EAGLContext *)context withColor:(kColor4F)color;
- (void)drawRect:(CGRect)rect 
	   inContext:(EAGLContext *)context 
	   withColor:(kColor4F)color width:(CGFloat)width;
- (void)fillRect:(CGRect)rect inContext:(EAGLContext *)context withColor:(kColor4F)color gradient:(const GLfloat *)glColors;
- (void)drawRects:(CGRect *)rects rectAmount:(NSInteger)count inContext:(EAGLContext *)context withColor:(kColor4F)color;
- (void)drawRects:(CGRect *)rects rectAmount:(NSInteger)count  
		inContext:(EAGLContext *)context 
		withColor:(kColor4F)color width:(CGFloat)width;
- (void)fillRects:(CGRect *)rects rectAmount:(NSInteger)count 
		inContext:(EAGLContext *)context 
		withColor:(kColor4F)color gradient:(const GLfloat *)glColors;
- (void)drawRectsInContext:(EAGLContext *)context 
				 withColor:(kColor4F)color width:(CGFloat)width 
					sRects:(NSString *)s_rect, ... NS_REQUIRES_NIL_TERMINATION;
- (void)fillRectsInContext:(EAGLContext *)context 
				 withColor:(kColor4F)color gradient:(const GLfloat *)glColors
					sRects:(NSString *)s_rect, ... NS_REQUIRES_NIL_TERMINATION;
- (void)fillHollowRect:(CGRect)rect inContext:(EAGLContext *)context withColor:(kColor4F)color gradient:(const GLfloat *)glColors;

#pragma mark -

- (void)drawEllipse:(CGRect)rect inContext:(EAGLContext *)context withColor:(kColor4F)color;
- (void)drawEllipse:(CGRect)rect 
		  inContext:(EAGLContext *)context 
		  withColor:(kColor4F)color width:(CGFloat)width;
- (void)fillEllipse:(CGRect)rect inContext:(EAGLContext *)context withColor:(kColor4F)color gradient:(const GLfloat *)glColors;
- (void)drawEllipses:(CGRect *)rects rectAmount:(NSInteger)count inContext:(EAGLContext *)context withColor:(kColor4F)color;
- (void)drawEllipses:(CGRect *)rects rectAmount:(NSInteger)count  
		   inContext:(EAGLContext *)context 
		   withColor:(kColor4F)color width:(CGFloat)width;
- (void)fillEllipses:(CGRect *)rects rectAmount:(NSInteger)count 
		   inContext:(EAGLContext *)context 
		   withColor:(kColor4F)color gradient:(const GLfloat *)glColors;
- (void)drawEllipsesInContext:(EAGLContext *)context 
					withColor:(kColor4F)color width:(CGFloat)width 
					   sRects:(NSString *)s_rect, ... NS_REQUIRES_NIL_TERMINATION;
- (void)fillEllipsesInContext:(EAGLContext *)context 
					withColor:(kColor4F)color gradient:(const GLfloat *)glColors
					   sRects:(NSString *)s_rect, ... NS_REQUIRES_NIL_TERMINATION;
- (void)fillHollowFanAt:(CGPoint)center radius:(CGFloat)radius 
                   from:(CGFloat)startAngle to:(CGFloat)endAngle clockwise:(kDrawStyle)clockwise 
              inContext:(EAGLContext *)context 
              withColor:(kColor4F)color gradient:(const GLfloat *)glColors;

#pragma mark -

- (void)drawArcAt:(CGPoint)center radius:(CGFloat)radius 
			 from:(CGFloat)startAngle to:(CGFloat)endAngle clockwise:(kDrawStyle)clockwise 
		inContext:(EAGLContext *)context withColor:(kColor4F)color;
- (void)drawArcAt:(CGPoint)center radius:(CGFloat)radius 
			 from:(CGFloat)startAngle to:(CGFloat)endAngle clockwise:(kDrawStyle)clockwise
		inContext:(EAGLContext *)context 
		withColor:(kColor4F)color width:(CGFloat)width;
- (void)fillArcAt:(CGPoint)center radius:(CGFloat)radius 
			 from:(CGFloat)startAngle to:(CGFloat)endAngle clockwise:(kDrawStyle)clockwise
		inContext:(EAGLContext *)context 
		withColor:(kColor4F)color gradient:(const GLfloat *)glColors;
- (void)drawArcFrom:(CGPoint)startPoint to:(CGPoint)endPoint radius:(CGFloat)radius clockwise:(kDrawStyle)clockwise 
		  inContext:(EAGLContext *)context 
		  withColor:(kColor4F)color;
- (void)drawArcFrom:(CGPoint)startPoint to:(CGPoint)endPoint radius:(CGFloat)radius clockwise:(kDrawStyle)clockwise 
		  inContext:(EAGLContext *)context 
		  withColor:(kColor4F)color width:(CGFloat)width;
- (void)fillArcFrom:(CGPoint)startPoint to:(CGPoint)endPoint radius:(CGFloat)radius clockwise:(kDrawStyle)clockwise 
		  inContext:(EAGLContext *)context 
		  withColor:(kColor4F)color gradient:(const GLfloat *)glColors;

#pragma mark -

- (void)drawBezierCurve:(kBezier)bPoints inContext:(EAGLContext *)context withColor:(kColor4F)color;
- (void)drawBezierCurve:(kBezier)bPoints 
			  inContext:(EAGLContext *)context 
			  withColor:(kColor4F)color width:(CGFloat)width;

#pragma mark -

- (void)drawRoundRect:(CGRect)rect radius:(CGFloat)radius inContext:(EAGLContext *)context withColor:(kColor4F)color;
- (void)drawRoundRect:(CGRect)rect radius:(CGFloat)radius 
			inContext:(EAGLContext *)context 
			withColor:(kColor4F)color width:(CGFloat)width;
- (void)fillRoundRect:(CGRect)rect radius:(CGFloat)radius 
			inContext:(EAGLContext *)context 
			withColor:(kColor4F)color gradient:(const GLfloat *)glColors;

#pragma mark -

- (void)drawPolygonByPoints:(CGPoint *)points pointAmount:(NSInteger)count 
				  inContext:(EAGLContext *)context 
				  withColor:(kColor4F)color;
- (void)drawPolygonByPoints:(CGPoint *)points pointAmount:(NSInteger)count  
				  inContext:(EAGLContext *)context 
				  withColor:(kColor4F)color width:(CGFloat)width;
- (void)fillPolygonByPoints:(CGPoint *)points pointAmount:(NSInteger)count  
				  inContext:(EAGLContext *)context 
				  withColor:(kColor4F)color gradient:(const GLfloat *)glColors;

- (void)drawRegularPolygon:(NSInteger)sideAmount at:(CGPoint)center radius:(CGFloat)radius angle:(CGFloat)angle 
				 inContext:(EAGLContext *)context 
				 withColor:(kColor4F)color;
- (void)drawRegularPolygon:(NSInteger)sideAmount at:(CGPoint)center radius:(CGFloat)radius angle:(CGFloat)angle 
				 inContext:(EAGLContext *)context 
				 withColor:(kColor4F)color width:(CGFloat)width;
- (void)fillRegularPolygon:(NSInteger)sideAmount at:(CGPoint)center radius:(CGFloat)radius angle:(CGFloat)angle 
				 inContext:(EAGLContext *)context 
				 withColor:(kColor4F)color gradient:(const GLfloat *)glColors;

#pragma mark -

- (void)drawStar:(NSInteger)pointAmount at:(CGPoint)center radius:(CGFloat)radius angle:(CGFloat)angle 
	   inContext:(EAGLContext *)context 
	   withColor:(kColor4F)color;
- (void)drawStar:(NSInteger)pointAmount at:(CGPoint)center radius:(CGFloat)radius angle:(CGFloat)angle 
	   inContext:(EAGLContext *)context 
	   withColor:(kColor4F)color width:(CGFloat)width;
- (void)fillStar:(NSInteger)pointAmount at:(CGPoint)center radius:(CGFloat)radius angle:(CGFloat)angle 
	   inContext:(EAGLContext *)context 
	   withColor:(kColor4F)color gradient:(const GLfloat *)glColors;

#pragma mark -

- (void)drawFanAt:(CGPoint)center radius:(CGFloat)radius 
			 from:(CGFloat)startAngle to:(CGFloat)endAngle clockwise:(kDrawStyle)clockwise 
		inContext:(EAGLContext *)context withColor:(kColor4F)color;
- (void)drawFanAt:(CGPoint)center radius:(CGFloat)radius 
			 from:(CGFloat)startAngle to:(CGFloat)endAngle clockwise:(kDrawStyle)clockwise
		inContext:(EAGLContext *)context 
		withColor:(kColor4F)color width:(CGFloat)width;
- (void)fillFanAt:(CGPoint)center radius:(CGFloat)radius 
			 from:(CGFloat)startAngle to:(CGFloat)endAngle clockwise:(kDrawStyle)clockwise
		inContext:(EAGLContext *)context 
		withColor:(kColor4F)color gradient:(const GLfloat *)glColors;

#pragma mark -

- (void)drawImage:(UIImage *)image at:(CGPoint)position inContext:(EAGLContext *)context;
- (void)drawImage:(UIImage *)image at:(CGPoint)position inContext:(EAGLContext *)context withTrans:(CGFloat)alpha;
- (void)drawImage:(UIImage *)image at:(CGPoint)position alignment:(kDrawStyle)alignment
		inContext:(EAGLContext *)context;
- (void)drawImage:(UIImage *)image at:(CGPoint)position alignment:(kDrawStyle)alignment
		inContext:(EAGLContext *)context  withTrans:(CGFloat)alpha;
- (void)drawImage:(UIImage *)image at:(CGPoint)position alignment:(kDrawStyle)alignment 
		inContext:(EAGLContext *)context 
		withTrans:(CGFloat)alpha flip:(kDrawStyle)flip rotate:(CGFloat)angle scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY;
- (void)drawImageNamed:(NSString *)name at:(CGPoint)position inContext:(EAGLContext *)context;
- (void)drawImageNamed:(NSString *)name at:(CGPoint)position 
			 inContext:(EAGLContext *)context 
			 withTrans:(CGFloat)alpha;
- (void)drawImageNamed:(NSString *)name at:(CGPoint)position alignment:(kDrawStyle)alignment
			 inContext:(EAGLContext *)context;
- (void)drawImageNamed:(NSString *)name at:(CGPoint)position alignment:(kDrawStyle)alignment 
			 inContext:(EAGLContext *)context 
			 withTrans:(CGFloat)alpha;
- (void)drawImageNamed:(NSString *)name at:(CGPoint)position alignment:(kDrawStyle)alignment 
			 inContext:(EAGLContext *)context
			 withTrans:(CGFloat)alpha flip:(kDrawStyle)flip rotate:(CGFloat)angle scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY;

- (void)fillImage:(UIImage *)image inRect:(CGRect)rect inContext:(EAGLContext *)context;
- (void)fillImage:(UIImage *)image inRect:(CGRect)rect inContext:(EAGLContext *)context withTrans:(CGFloat)alpha;
- (void)fillImage:(UIImage *)image inRect:(CGRect)rect 
		inContext:(EAGLContext *)context 
		withTrans:(CGFloat)alpha flip:(kDrawStyle)flip rotate:(CGFloat)angle;
- (void)fillImageNamed:(NSString *)name inRect:(CGRect)rect inContext:(EAGLContext *)context;
- (void)fillImageNamed:(NSString *)name inRect:(CGRect)rect
			 inContext:(EAGLContext *)context 
			 withTrans:(CGFloat)alpha;
- (void)fillImageNamed:(NSString *)name inRect:(CGRect)rect
			 inContext:(EAGLContext *)context
			 withTrans:(CGFloat)alpha flip:(kDrawStyle)flip rotate:(CGFloat)angle;

- (void)drawTexture:(GLuint)texture inRect:(CGRect)rect 
		  inContext:(EAGLContext *)context 
		  withTrans:(CGFloat)alpha flip:(kDrawStyle)flip rotate:(CGFloat)angle;
- (void)drawTexture:(GLuint)texture at:(CGPoint)center 
	   inContextext:(EAGLContext *)context 
			   from:(CGFloat)startAngle to:(CGFloat)endAngle;

@end
