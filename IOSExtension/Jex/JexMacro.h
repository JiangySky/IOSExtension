//
//  JexMacro.h
//  CrazyDice
//
//  Created by Jiangy on 12-7-27.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#ifndef CrazyDice_JexMacro_h
#define CrazyDice_JexMacro_h

#define DECLARE_SINGLETON_FOR_CLASS(_className) \
+ (_className *)shared##Instance;

#define SYNTHESIZE_SINGLETON_FOR_CLASS(_className) \
static _className * shared##_className; \
+ (_className *)shared##Instance { \
@synchronized(self) { \
if (!shared##_className) { \
shared##_className = [[_className alloc] init]; \
} \
} \
return shared##_className; \
}

#define INSTANCE(_className)            [_className shared##Instance]

#define kUniqueIdentifierOpen           1

#define FLOAT_TOLERATE                  0.00001
#define FLOAT_EQUAL(x, y)               ((x) - (y) < FLOAT_TOLERATE && (x) - (y) > -FLOAT_TOLERATE)
#define FLOAT_NOT_EQUAL(x, y)           ((x) - (y) > FLOAT_TOLERATE || (x) - (y) < -FLOAT_TOLERATE)

#define ZONE_MALLOC(_structName)        (_structName *)NSZoneMalloc(NULL, sizeof(_structName))
#define RELEASE(_id)                    if (_id) { [_id release], _id = nil; }
#define FREE(_id)                       if (_id) { NSZoneFree(NULL, _id), _id = nil; }

#ifndef DEGREES_TO_RADIANS
#define DEGREES_TO_RADIANS(__ANGLE__)   ((__ANGLE__) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(__ANGLE__)   ((__ANGLE__) / M_PI * 180.0)
#endif

#ifndef SWAP
#define SWAP(_a, _b)									__typeof__(_a) temp; temp = _a; _a = _b; _b = temp
#define CLAMP(_value, _lower, _upper)					(_value = MIN(MAX(_lower, _value), _upper))
#endif

#ifndef VALUE_BETWEEN_OO
#define VALUE_BETWEEN_OO(_value, _lower, _upper)		(_value > _lower && _value < _upper)
#define VALUE_BETWEEN_OC(_value, _lower, _upper)		(_value > _lower && _value <= _upper)
#define VALUE_BETWEEN_CO(_value, _lower, _upper)		(_value >= _lower && _value < _upper)
#define VALUE_BETWEEN_CC(_value, _lower, _upper)		(_value >= _lower && _value <= _upper)
#endif

#endif
