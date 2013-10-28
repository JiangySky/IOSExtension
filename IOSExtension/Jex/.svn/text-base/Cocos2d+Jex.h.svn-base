//
//  Cocos2d+Jex.h
//  CrazyDice
//
//  Created by Jiangy on 12-7-28.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCScrollLayer.h"
#import "CCBReader.h"
#import "SimpleAudioEngine.h"
#import "CCScrollView.h"

#define COOLINT_TIME                        1
#define ANNOUNCEMENT_LOOP                   2
#define ANNOUNCEMENT_SPEED                  1
#define TAG_LABEL_FLYTIP                    9898
#define CCTEXTURECACHE                      [CCTextureCache sharedTextureCache]
#define CCDIRECTOR                          [CCDirector sharedDirector]
#define CCRUNNINGSCENE                      [CCDIRECTOR runningScene]
#define CCMAINLAYER                         [CCRUNNINGSCENE getChildAtIndex:0]
#define CCLAYER(_className, _tag)           (_className *)[CCMAINLAYER getChildByTag:_tag]
#define CCLAYERINHERIT(_className, _tag)    (_className *)[CCMAINLAYER getChildByTag:_tag inherit:YES]
#define CCBLAYER(_className, _tag)          (_className *)[[CCMAINLAYER getChildByTag:_tag] getChildAtIndex:0]
#define CCBLAYERINHERIT(_className, _tag)   (_className *)[[CCMAINLAYER getChildByTag:_tag inherit:YES] getChildAtIndex:0]
#define CCAUDIO                             [SimpleAudioEngine sharedEngine]

@protocol AnnouncementProtocol <NSObject>

- (NSInteger)nextAnnouncement;

@end

@interface CCNode (Jex)

- (BOOL)isTouchInside:(UITouch *)touch;
- (BOOL)isTouchMoveInside:(UITouch *)touch;
- (CGPoint)convertTouchToWorldSpace:(UITouch *)touch;
+ (CCNode *)nodeFromCCBFile:(NSString *)fileName;
+ (CCScene *)sceneFromCCBFile:(NSString *)fileName;
+ (CCLayer *)layerFromCCBFile:(NSString *)fileName;
+ (CCSprite *)spriteFromCCBFile:(NSString *)fileName;
- (CCNode *)firstChild;
- (CCNode *)lastChild;
- (CCNode *)getChildAtIndex:(NSInteger)index;
- (CCNode *)getChildByTag:(NSInteger)dstTag inherit:(BOOL)inherit;
- (CCLayer *)topLayer;
- (void)insertChild:(CCNode *)child atIndex:(NSInteger)index;
- (void)addChildWithMask:(CCNode *)node;
- (BOOL)containChild;
- (CGPoint)center;
- (void)setChildrenVisible:(BOOL)visible;
- (CGPoint)positionInParent:(CCNode *)node;
+ (CCAnimate *)animationWithName:(NSString *)aniName;
- (void)runAnimation:(NSString *)aniName inFile:(NSString *)file;
- (void)runAnimation:(NSString *)aniName;
- (void)runAnimation:(NSString *)aniName delay:(ccTime)time;
- (void)cooling;
- (void)coolForDelay:(ccTime)time;
- (BOOL)isInScrollView;
- (CCLayer *)parentLayer;

@end

@interface CCDirector (Jex)

- (void)loadingInNode:(CCNode *)node;
- (void)loadingInNode:(CCNode *)node shadow:(BOOL)shadow;
- (void)loadingInNode:(CCNode *)node withOffset:(CGPoint)offset;
- (void)loadingInNode:(CCNode *)node withOffset:(CGPoint)offset shadow:(BOOL)shadow;
- (void)loadingInPosition:(CGPoint)dstPos;
- (void)loadingInPosition:(CGPoint)dstPos shadow:(BOOL)shadow;
- (void)setLoadingHidden:(BOOL)hidden atPosition:(CGPoint)position withTip:(NSString *)tip shadow:(BOOL)shadow;
- (void)startDataInteraction;
- (void)stopDataInteraction;
- (void)reconnectLoading;
- (void)replaceScene:(CCScene *)scene withTransition:(NSInteger)trans;
- (void)removeUIView;
- (BOOL)focusOnUIView:(BOOL)resign;

@end

@interface CCScene (Jex)

- (void)displayAnnouncement:(NSString *)announcement withProtocol:(id <AnnouncementProtocol>)dstProtocol;
- (BOOL)isAnnouncementing;
- (void)stopAnnouncement;

@end

@interface CCLayer (Jex)

@end

@interface CCSprite (Jex)

- (void)resizeToTexture:(CCTexture2D *)texture;
- (void)setImage:(UIImage *)dstImage;
- (BOOL)isSwitchControll;
- (void)changeSwitchAnimation:(BOOL)animate;
- (BOOL)switchOn;
- (void)refreshForTexture:(NSString *)textureName;

@end

@interface CCTextureCache (Jex)

- (CCTexture2D *)replaceCGImage:(CGImageRef)imageref forKey:(NSString *)key;

@end

@interface CCLabelTTF (Jex)

+ (void)developingTipInParent:(CCNode *)pNode;
+ (void)flyTip:(NSString *)info inParent:(CCNode *)pNode;
+ (void)flyTip:(NSString *)info atPosition:(CGPoint)pos inParent:(CCNode *)pNode;
+ (void)flyTip:(NSString *)info inParent:(CCNode *)pNode withColor:(ccColor3B)dstColor;
+ (void)flyTip:(NSString *)info atPosition:(CGPoint)pos inParent:(CCNode *)pNode withColor:(ccColor3B)dstColor;
+ (void)flyTip:(NSString *)info inParent:(CCNode *)pNode delay:(ccTime)delay;
+ (void)flyTip:(NSString *)info atPosition:(CGPoint)pos inParent:(CCNode *)pNode delay:(ccTime)delay;
+ (void)flyTip:(NSString *)info inParent:(CCNode *)pNode withColor:(ccColor3B)dstColor delay:(ccTime)delay;
+ (void)flyTip:(NSString *)info atPosition:(CGPoint)pos inParent:(CCNode *)pNode withColor:(ccColor3B)dstColor delay:(ccTime)delay;
+ (void)flyTip:(NSString *)info inParent:(CCNode *)pNode withColor:(ccColor3B)dstColor size:(NSInteger)dstSize delay:(ccTime)delay;
+ (void)flyTip:(NSString *)info atPosition:(CGPoint)pos inParent:(CCNode *)pNode
     withColor:(ccColor3B)dstColor size:(NSInteger)dstSize delay:(ccTime)delay;
- (BOOL)isScrolling;
- (void)stopScroll;
- (void)autoScroll;
- (void)autoScrollWithDirect:(BOOL)isHorizontal andSpeed:(CGFloat)speed;
- (void)autoScrollWithDirect:(BOOL)isHorizontal andSpeed:(CGFloat)speed inRect:(CGRect)rect;

@end

@interface CCScrollView (Jex)

- (void)resizeContainer:(CGSize)dstSize withDirection:(CCScrollViewDirection)direction;

@end

@interface SimpleAudioEngine (Jex)

- (NSUInteger)playSound:(NSString *)name;
- (void)playMusic:(NSString *)name;
- (void)stopSound:(NSUInteger)soundId;
- (void)stopMusic;

@end

@interface CCAnimationCache (Jex)

- (void)addAnimationsWithAppFile:(NSString *)plist;

@end

@interface CCSpriteFrameCache (Jex)

- (void)addSpriteFramesWithAppFile:(NSString *)plist;

@end
