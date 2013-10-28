//
//  Macros.h
//  CrazyDice
//
//  Created by Jiangy on 11-4-26.
//  Copyright 2011 35VI. All rights reserved.
//

#import "Jex.h"

typedef float GLfloat;
typedef struct ColorRGBA {
	GLfloat			r;
	GLfloat			g;
	GLfloat			b;
	GLfloat			a;
} kColor4F;

static inline kColor4F color4F (const GLfloat r, const GLfloat g, const GLfloat b, const GLfloat a) {
	kColor4F color = {r, g, b, a};
	return color;
}

static inline BOOL color4FEqual(kColor4F ca, kColor4F cb)
{
	return ca.r == cb.r && ca.g == cb.g && ca.b == cb.b && ca.a == cb.a;
}

static const kColor4F nilColor4F = {0, 0, 0, 0};
static const kColor4F kColor4FTeach = {0, 0, 0, 0.2};
static const kColor4F kColor4FCD = {0, 0, 0, 0.5};
static const kColor4F kColor4FDarken = {0, 0, 0, 0.4};
static const kColor4F kColor4FLight = {1, 1, 1, 0.4};
static const kColor4F kColor4FProtect = {0.79, 0.80, 0.75, 0.7};

static const kColor4F kColor4FBlack = {0, 0, 0, 1};
static const kColor4F kColor4FWhite = {1, 1, 1, 1};
static const kColor4F kColor4FRed = {1, 0, 0, 1};
static const kColor4F kColor4FYellow = {1, 1, 0, 1};
static const kColor4F kColor4FGreen = {0, 1, 0, 1};
static const kColor4F kColor4FMagenta = {1, 0, 1, 1};
static const kColor4F kColor4FCray = {0, 1, 1, 1};
static const kColor4F kColor4FBlue = {0, 0, 1, 1};

typedef enum DRAW_STYLE {
	kAlignmentLeftTop,
	kAlignmentLeftVcenter,
	kAlignmentLeftBottom,
	kAlignmentHcenterTop,
	kAlignmentHcenterVcenter,
	kAlignmentHcenterBottom,
	kAlignmentRightTop,
	kAlignmentRightVcenter,
	kAlignmentRightBottom,
	
	kLineSolid = NO,
	kLineDotted = YES,
	kLineSegments = YES,
	kLineJoin = NO,
	
	kArcClockwise = 0,
	kArcCounterClockwise = 1,
	
	kFlipNone = UIImageOrientationUp,
	kFlipX = UIImageOrientationUpMirrored,
	kFlipY = UIImageOrientationRightMirrored,
	kFlipXY = UIImageOrientationDown,
	
	kFillByScale = 0,
	kFillByTiled = 1,
	
	kGradientLinear = YES,
	kGradientRadial = NO,
	
}kDrawStyle;

typedef struct BezierPoints {
	CGPoint sp;			// start point
	CGPoint ep;			// end point
	CGPoint cp1;		// controll point 1
	CGPoint cp2;		// controll point 2
}kBezier;

#define isNilColor4F(_color)					color4FEqual(_color, nilColor4F)

#ifndef SWAP
#define SWAP(_a, _b)							__typeof__(_a) temp; temp = _a; _a = _b; _b = temp
#define CLAMP(_value, _lower, _upper)			(_value = MIN(MAX(_lower, _value), _upper))
#endif
#ifndef VALUE_BETWEEN_OO
#define VALUE_BETWEEN_OO(_value, _lower, _upper)		(_value > _lower && _value < _upper)
#define VALUE_BETWEEN_OC(_value, _lower, _upper)		(_value > _lower && _value <= _upper)
#define VALUE_BETWEEN_CO(_value, _lower, _upper)		(_value >= _lower && _value < _upper)
#define VALUE_BETWEEN_CC(_value, _lower, _upper)		(_value >= _lower && _value <= _upper)
#endif

#define DEFAULT_LINE_WIDTH				1
#define DEFAULT_LINE_CAP				kCGLineCapButt
#define DEFAULT_LINE_JOIN				kCGLineJoinMiter
#define DEFAULT_ALIGNMENT				kAlignmentLeftTop
#define DEFAULT_FONT					@"Helvetica"
#define DEFAULT_FONT_SIZE				20

#define ARRAY_LENGTH(_array)			sizeof(_array) / sizeof(_array[0])

#define textLength(_text)				strlen(_text)

#define sPoint(_point)					NSStringFromCGPoint(_point)
#define pString(_string)				CGPointFromString(_string)
#define sRect(_rect)					NSStringFromCGRect(_rect)
#define rString(_string)				CGRectFromString(_string)


#define DISTANCE_BETWEEN_POINT(_startPoint, _endPoint)								\
			sqrtf(powf(_startPoint.x - _endPoint.x, 2) + powf(_startPoint.y - _endPoint.y, 2))

#define LOG_INFO(_info, _method)													\
			NSString * METHOD_INFO = @" %@ ";										\
			NSLog([_info stringByAppendingString:METHOD_INFO], _method)


#define DEFAULT_DEPTH		0
#define MAX_TEXTURE			20

#define GL_EXCEPTION(_context)														\
			if (!_context) {														\
				LOG_INFO(@"EAGLContext is nil", self);								\
				return;																\
			}

#define SET_GL_WITH_COLOR(_color)													\
			const CGFloat * components = CGColorGetComponents(_color.CGColor);		\
			CGFloat alpha = CGColorGetAlpha(_color.CGColor);						\
			glColor4f(components[0], components[1], components[2], alpha)

#define SET_GL_WITH_COLOR_WIDTH(_color, _width)										\
			SET_GL_WITH_COLOR(_color);												\
			glLineWidth(DEFAULT_LINE_WIDTH)

#define GL_DRAW_ARRAY(_context, _color, _glColors, _width, _vertices, _first, _count, _mode)				\
			if (_count <= 0) {														\
				return;																\
			}																		\
			GL_EXCEPTION(_context);													\
			glPushMatrix();															\
			{																		\
				if (!isNilColor4F(_color)) {										\
					glColor4f(_color.r, _color.g, _color.b, _color.a);				\
				} else {															\
					glColorPointer(4, GL_FLOAT, 0, _glColors);						\
					glEnableClientState(GL_COLOR_ARRAY);							\
				}																	\
				glVertexPointer(3, GL_FLOAT, 0, _vertices);							\
				glDisable(GL_TEXTURE_2D);											\
				glEnableClientState(GL_VERTEX_ARRAY);								\
				glPointSize(_width);												\
				glLineWidth(_width);												\
				glDrawArrays(_mode, _first, _count);								\
				glDisableClientState(GL_COLOR_ARRAY);								\
				glEnable(GL_TEXTURE_2D);											\
			}																		\
			glPopMatrix();															\
			if (checkError) {														\
				[self checkGLError:NO];												\
			}


