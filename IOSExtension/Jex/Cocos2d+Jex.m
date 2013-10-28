//
//  Cocos2d+Jex.m
//  CrazyDice
//
//  Created by Jiangy on 12-7-28.
//  Copyright (c) 2012年 35VI. All rights reserved.
//

#import "Cocos2d+Jex.h"
#import "CCScrollView.h"
#import "CCControlButton.h"
#import "CCScale9Sprite.h"
#import "Jex.h"

@implementation CCNode (Jex)

- (BOOL)isTouchInside:(UITouch *)touch {
    if (![self isVisibleInherit] || ![self acceptTouch] || [touch savedPhase:NO] == UITouchPhaseMoved) {
        return NO;
    }
    CGPoint touchLocation   = [touch locationInView:[touch view]];                      // Get the touch position
    touchLocation           = [CCDIRECTOR convertToGL:touchLocation];                   // Convert the position to GL space
    touchLocation           = [[self parent] convertToNodeSpace:touchLocation];         // Convert to the node space of this class
    
    return CGRectContainsPoint([self boundingBox], touchLocation);
}

- (BOOL)isTouchMoveInside:(UITouch *)touch {
    if (![self isVisibleInherit] || ![self acceptTouch]) {
        return NO;
    }
    CGPoint touchLocation   = [touch locationInView:[touch view]];                      // Get the touch position
    touchLocation           = [CCDIRECTOR convertToGL:touchLocation];                   // Convert the position to GL space
    touchLocation           = [[self parent] convertToNodeSpace:touchLocation];         // Convert to the node space of this class
    
    return CGRectContainsPoint([self boundingBox], touchLocation);
}

- (CGPoint)convertTouchToWorldSpace:(UITouch *)touch {
    CGPoint point = [touch locationInView: [touch view]];
	point = [[CCDirector sharedDirector] convertToGL: point];
	return [self convertToWorldSpace:point];
}

+ (CCNode *)nodeFromCCBFile:(NSString *)fileName {
    return [CCBReader nodeGraphFromFile:fileName];
}

+ (CCScene *)sceneFromCCBFile:(NSString *)fileName {
    return [CCBReader sceneWithNodeGraphFromFile:fileName];
}

+ (CCLayer *)layerFromCCBFile:(NSString *)fileName {
    return (CCLayer *)[CCBReader nodeGraphFromFile:fileName];
}

+ (CCSprite *)spriteFromCCBFile:(NSString *)fileName {
    return (CCSprite *)[CCBReader nodeGraphFromFile:fileName];
}

- (CCNode *)firstChild {
    return [children_ objectAtIndex:0];
}

- (CCNode *)lastChild {
    return [children_ lastObject];
}

- (CCNode *)getChildAtIndex:(NSInteger)index {
    CLAMP(index, 0, [children_ count] - 1);
    return [children_ objectAtIndex:index];
}

- (CCNode *)getChildByTag:(NSInteger)dstTag inherit:(BOOL)inherit {
    if (inherit) {
        for (CCNode * node in children_) {
            if (node.tag == dstTag) {
                return node;
            }
            if (![node isKindOfClass:[CCScale9Sprite class]] && ![node isKindOfClass:[CCControlButton class]] && [node containChild]) {
                CCNode * nodeInherit = [node getChildByTag:dstTag inherit:inherit];
                if (nodeInherit) {
                    return nodeInherit;
                }
            }
        }
        return nil;
        
    } else {
        return [self getChildByTag:dstTag];
    }
}

- (CCLayer *)topLayer {
    for (int i = [children_ count] - 1; i >= 0; i--) {
        id node = [children_ objectAtIndex:i];
        if ([node isKindOfClass:[CCLayer class]]
            && [(CCLayer *)node isTouchEnabled]
            && ![node isKindOfClass:[CCLayerColor class]]
            && ![node isKindOfClass:[CCControl class]]
            && ![node isKindOfClass:[CCScrollView class]]
            && ![node isKindOfClass:[CCScrollLayer class]]) {
            return [node topLayer];
        }
    }
    return (CCLayer *)self;
}

- (void)insertChild:(CCNode *)child atIndex:(NSInteger)index {
    if (VALUE_BETWEEN_CC(index, 0, [children_ count])) {
        if (index == [children_ count]) {
            [self addChild:child];
        } else {
            [children_ insertObject:child atIndex:index];
            [child setParent:self];
//            if(isRunning_) {
//                [child onEnter];
//                [child onEnterTransitionDidFinish];
//            }
        }
    }
}

- (void)addChildWithMask:(CCNode *)node {
    CGSize layerSize = [self contentSize];
#ifdef CCB_LAYER_GRAYMASK
    CCLayer * layer = [CCNode layerFromCCBFile:CCB_LAYER_GRAYMASK];
    [layer setContentSize:layerSize];
#else
    CCLayerColor * layer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 128) width:layerSize.width height:layerSize.height];
#endif
    [self addChild:layer z:0 tag:TAG_LAYER_GRAYMASK];
    [self setAcceptTouch:NO inherit:YES];
    [self addChild:node];
}

- (BOOL)containChild {
    return children_ && [children_ count] > 0;
}

- (CGPoint)center {
    return [Jex rectCenter:[self boundingBox]];
}

- (void)setChildrenVisible:(BOOL)visible {
    for (CCNode * node in children_) {
        [node setVisible:visible];
    }
}

- (CGPoint)positionInParent:(CCNode *)node {
    CGPoint pos = [self position];
    if (parent_ && ![parent_ isEqual:node] && ![self isEqual:node]) {
        CGPoint parentPos = [parent_ positionInParent:node];
        pos.x += parentPos.x;
        pos.y += parentPos.y;
        // NOTE: CCLayer && CCScrollView set anchor to {0,0}
        pos.x -= parent_.contentSize.width * parent_.anchorPoint.x;
        pos.y -= parent_.contentSize.height * parent_.anchorPoint.y;
    }
    return pos;
}

+ (CCAnimate *)animationWithName:(NSString *)aniName {
    static BOOL anmationLoaded = NO;
    if (!anmationLoaded) {
        [[CCAnimationCache sharedAnimationCache] addAnimationsWithFile:@"35Animations.plist"];
        anmationLoaded = YES;
    }
    CCAnimation * animation = [[CCAnimationCache sharedAnimationCache] animationByName:aniName];
    if (animation) {
        return [CCAnimate actionWithAnimation:animation];
    }
    return nil;
}

- (void)runAnimation:(NSString *)aniName inFile:(NSString *)file {
    CCAnimationCache * cache = [CCAnimationCache sharedAnimationCache];
    [cache addAnimationsWithFile:file];
    CCAnimation * animation = [cache animationByName:aniName];
    CCAnimate * action = [CCAnimate actionWithAnimation:animation];
    [self runAction:action];
}

- (void)runAnimation:(NSString *)aniName {
    [self runAction:[CCNode animationWithName:aniName]];
}

- (void)runAnimation:(NSString *)aniName delay:(ccTime)time {
    [self runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:time] two:[CCNode animationWithName:aniName]]];
}

- (void)cooling {
    [self coolForDelay:COOLINT_TIME];
}

- (void)coolForDelay:(ccTime)time {
    if ([self acceptTouch]) {
        [self setAcceptTouch:NO inherit:NO];
        CCDelayTime * doDelay = [CCDelayTime actionWithDuration:time];
        CCCallBlock * doNext = [CCCallBlock actionWithBlock:^{
            [self setAcceptTouch:YES inherit:NO];
        }];
        [self runAction:[CCSequence actionOne:doDelay two:doNext]];
    }
}

- (BOOL)isInScrollView {
    if (parent_) {
        if ([parent_ isKindOfClass:[CCScrollView class]]) {
            return YES;
        } else {
            return [parent_ isInScrollView];
        }
    }
    return NO;
}

- (CCLayer *)parentLayer {
    if (parent_) {
        if ([parent_ isKindOfClass:[CCLayer class]]) {
            return (CCLayer *)parent_;
        } else {
            return [parent_ parentLayer];
        }
    }
    return nil;
}

@end

#pragma mark -

@implementation CCDirector (Jex)

- (void)loadingInNode:(CCNode *)node {
    [self loadingInNode:node shadow:NO];
}

- (void)loadingInNode:(CCNode *)node shadow:(BOOL)shadow {
    CGPoint dstPos = ccp(self.winSize.width / 2, self.winSize.height / 2);
    if (node) {
        dstPos = [node center];
    }
    [self setLoadingHidden:NO atPosition:[self convertToUI:dstPos] withTip:nil shadow:shadow];
    [APP setTouchEnable:NO];
}

- (void)loadingInNode:(CCNode *)node withOffset:(CGPoint)offset {
    [self loadingInNode:node withOffset:offset shadow:NO];
}

- (void)loadingInNode:(CCNode *)node withOffset:(CGPoint)offset shadow:(BOOL)shadow {
    CGPoint dstPos = ccpAdd([node center], offset);
    [self setLoadingHidden:NO atPosition:[self convertToUI:dstPos] withTip:nil shadow:shadow];
    [APP setTouchEnable:NO];
}

- (void)loadingInPosition:(CGPoint)dstPos {
    [self loadingInPosition:dstPos shadow:NO];
}

- (void)loadingInPosition:(CGPoint)dstPos shadow:(BOOL)shadow {
    [self setLoadingHidden:NO atPosition:dstPos withTip:nil shadow:shadow];
    [APP setTouchEnable:NO];
}

- (void)setLoadingHidden:(BOOL)hidden atPosition:(CGPoint)position withTip:(NSString *)tip shadow:(BOOL)shadow {
    static UIActivityIndicatorView * loading;
    static UILabel * lable;
    static UIButton * rectButton;
    if (!loading) {
        loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [loading setHidesWhenStopped:YES];
        lable = [[UILabel alloc] initWithFrame:CGRectMake(loading.frame.origin.x - 20, 40, loading.frame.size.width + 40, 20)];
        [lable setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        [lable setTextColor:[UIColor whiteColor]];
        [lable setTextAlignment:UITextAlignmentCenter];
        [lable setHidden:YES];
//        rectButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [rectButton setFrame:CGRectMake(loading.frame.origin.x - 10, loading.frame.origin.y - 10,
//                                        loading.frame.size.width + 20, loading.frame.size.height + 20)];
        rectButton = [[UIButton alloc] initWithFrame:CGRectMake(loading.frame.origin.x - 10, loading.frame.origin.y - 10,
                                                                loading.frame.size.width + 20, loading.frame.size.height + 20)];
        [rectButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        [rectButton setEnabled:NO];
        [rectButton setHidden:YES];
        [loading addSubview:rectButton];
        [loading addSubview:lable];
        [self.view addSubview:loading];
    }
//    [rectButton setHidden:hidden];
    if (hidden) {
        [lable setHidden:hidden];
        [loading stopAnimating];
    } else {
        [loading setPosition:position anchor:kJexAnchorCC];
        if (!NSStringIsEmpty(tip)) {
            [lable setText:tip];
            [lable setHidden:hidden];
        }
        [loading startAnimating];
    }
}

- (void)startDataInteraction {
    [self setLoadingHidden:NO atPosition:ccp([self winSize].width / 2, [self winSize].height / 2) withTip:nil shadow:YES];
    [APP setTouchEnable:NO];
}

- (void)stopDataInteraction {
    [self setLoadingHidden:YES atPosition:CGPointZero withTip:nil shadow:NO];
    [APP setTouchEnable:YES];
}

- (void)reconnectLoading {
    [self setLoadingHidden:NO atPosition:ccp([self winSize].width / 2, [self winSize].height / 2)
                   withTip:NSLocalizedString(@"正在同步", @"") shadow:NO];
    [APP setTouchEnable:NO];
}

- (void)replaceScene:(CCScene *)scene withTransition:(NSInteger)trans {
    [CCRUNNINGSCENE stopAnnouncement];
    switch (abs(trans) % 10) {
        case 0:
            [CCDIRECTOR replaceScene:scene];
            break;
        case 1:
            [CCDIRECTOR replaceScene:[CCTransitionRotoZoom transitionWithDuration:0.3 scene:scene]];
            break;
        case 2:
            if (trans > 0) {
                [CCDIRECTOR replaceScene:[CCTransitionProgressRadialCW transitionWithDuration:0.3 scene:scene]];
            } else {
                [CCDIRECTOR replaceScene:[CCTransitionProgressRadialCCW transitionWithDuration:0.3 scene:scene]];
            }
            break;
        case 3:
            if (trans > 0) {
                [CCDIRECTOR replaceScene:[CCTransitionFadeBL transitionWithDuration:0.3 scene:scene]];
            } else {
                [CCDIRECTOR replaceScene:[CCTransitionFadeTR transitionWithDuration:0.3 scene:scene]];
            }
            break;
        case 4:
            [CCDIRECTOR replaceScene:[CCTransitionCrossFade transitionWithDuration:0.3 scene:scene]];
            break;
        case 5:
            [CCDIRECTOR replaceScene:[CCTransitionPageTurn transitionWithDuration:0.3 scene:scene]];
            break;
        case 6:
            [CCDIRECTOR replaceScene:[CCTransitionTurnOffTiles transitionWithDuration:0.3 scene:scene]];
            break;
        case 7:
            [CCDIRECTOR replaceScene:[CCTransitionSplitCols transitionWithDuration:0.3 scene:scene]];
            break;
        case 8:
            if (trans > 0) {
                [CCDIRECTOR replaceScene:[CCTransitionSlideInB transitionWithDuration:0.3 scene:scene]];
            } else {
                [CCDIRECTOR replaceScene:[CCTransitionSlideInT transitionWithDuration:0.3 scene:scene]];
            }
            break;
        case 9:
            if (trans > 0) {
                [CCDIRECTOR replaceScene:[CCTransitionProgressInOut transitionWithDuration:0.3 scene:scene]];
            } else {
                [CCDIRECTOR replaceScene:[CCTransitionProgressOutIn transitionWithDuration:0.3 scene:scene]];
            }
            break;
        default:
            break;
    }
    [CCDIRECTOR stopDataInteraction];
}

- (void)removeUIView {
    NSArray * arrayView = [CCDIRECTOR.view subviews];
    for (int i = [arrayView count] - 1; i >= 0; i--) {
        if ([[arrayView objectAtIndex:i] isKindOfClass:[UITextField class]]
            || [[arrayView objectAtIndex:i] isKindOfClass:[UITextView class]]) {
            [[arrayView objectAtIndex:i] resignFirstResponder];
            [[arrayView objectAtIndex:i] removeFromSuperview];
        }
    }
}

- (BOOL)focusOnUIView:(BOOL)resign {
    if ([APP isIgnoringInteractionEvents] && NETWORK_ENABLE) {
        return YES;
    }
    NSArray * arrayView = [CCDIRECTOR.view subviews];
    for (id view in arrayView) {
        if (([view isKindOfClass:[UITextField class]] || [view isKindOfClass:[UITextView class]])
            && [view isFirstResponder]) {
            if (resign) {
                [view resignFirstResponder];
            }
            return YES;
        }
    }
    return NO;
}

@end

#pragma mark -

@implementation CCScene (Jex)

static id <AnnouncementProtocol> AnnouncementProtocol;
static CCLayerColor * AnnouncementLayer = nil;
static CCLabelTTF * AnnouncementLabel = nil;

- (void)displayAnnouncement:(NSString *)announcement withProtocol:(id <AnnouncementProtocol>)dstProtocol {
    if (!AnnouncementProtocol) {
        AnnouncementProtocol = dstProtocol;
    }
    if (!AnnouncementLayer) {
        CGSize size = CGSizeMake([CCDIRECTOR winSize].width, ([CURRENT_DEVICE isHD] ? 64 : 32));
        AnnouncementLayer = [[CCLayerColor alloc] initWithColor:ccc4(0, 0, 0, 160) width:size.width height:size.height];
        [AnnouncementLayer setAnchorPoint:CGPointZero];
        AnnouncementLabel = [[CCLabelTTF alloc] initWithString:@"Announcement" dimensions:size hAlignment:kCCTextAlignmentLeft
                                                      fontName:@"Helvetica" fontSize:([CURRENT_DEVICE isHD] ? 28 : 14)];
        [AnnouncementLabel setAnchorPoint:ccp(0, 0.5)];
        [AnnouncementLabel setScrollAlways:YES];
        [AnnouncementLabel setPosition:ccp(0, size.height * AnnouncementLabel.anchorPoint.y)];
        [AnnouncementLayer addChild:AnnouncementLabel];
    }
    if ([self isAnnouncementing]) {
        [AnnouncementLabel stopScroll];
    }
    [AnnouncementLabel setString:announcement];
    [AnnouncementLabel setScrollLoop:ANNOUNCEMENT_LOOP];
    CGRect sRect = CGRectMake(0, [CCDIRECTOR winSize].height - AnnouncementLayer.contentSize.height,
                              [CCDIRECTOR winSize].width, AnnouncementLayer.contentSize.height);
    [AnnouncementLabel autoScrollWithDirect:YES andSpeed:ANNOUNCEMENT_SPEED inRect:sRect];
    [AnnouncementLabel setPosition:ccp(AnnouncementLayer.contentSize.width, AnnouncementLabel.position.y)];
    if (!AnnouncementLayer.parent) {
        if (![AnnouncementLayer containChild]) {
            [AnnouncementLayer addChild:AnnouncementLabel];
        }
        [self schedule:@selector(updateAnnouncement:) interval:0.5];
        [AnnouncementLayer setPosition:ccp(0, [CCDIRECTOR winSize].height)];
        [AnnouncementLayer runAction:[CCMoveBy actionWithDuration:0.3 position:ccp(0, -AnnouncementLayer.contentSize.height)]];
        [CCMAINLAYER addChild:AnnouncementLayer];
    }
}

- (void)updateAnnouncement:(ccTime)time {
    if (AnnouncementLabel.scrollLoop == 0 && [AnnouncementProtocol nextAnnouncement] < 0) {
        [self unschedule:@selector(updateAnnouncement:)];
        [AnnouncementLabel unscheduleUpdate];
        CCMoveBy * doAction = [CCMoveBy actionWithDuration:0.3 position:ccp(0, AnnouncementLayer.contentSize.height)];
        CCCallBlock * doNext = [CCCallBlock actionWithBlock:^{
            [AnnouncementLayer removeFromParentAndCleanup:NO];
        }];
        [AnnouncementLayer runAction:[CCSequence actionOne:doAction two:doNext]];
    }
}

- (BOOL)isAnnouncementing {
    return AnnouncementLabel && AnnouncementLabel.scrollLoop > 0;
}

- (void)stopAnnouncement {
    if ([self isAnnouncementing]) {
        [self unschedule:@selector(updateAnnouncement:)];
        [AnnouncementLabel stopScroll];
        [AnnouncementLayer removeAllChildrenWithCleanup:NO];
        [AnnouncementLayer setParent:nil];
    }
}

@end

#pragma mark -

@implementation CCLayer (Jex)

@end

#pragma mark -

@implementation CCSprite (Jex)

- (void)resizeToTexture:(CCTexture2D *)texture {
    CGRect rect = {CGPointZero, texture.contentSize};
    [self setDisplayFrame:[CCSpriteFrame frameWithTexture:texture rect:rect]];
}

- (void)setImage:(UIImage *)dstImage {
    [self setTexture:[[[CCTexture2D alloc] initWithCGImage:dstImage.CGImage resolutionType:kCCResolutionUnknown] autorelease]];
}

- (BOOL)isSwitchControll {
    if (children_ && [children_ count] == 1) {
        CCNode * node = [self getChildAtIndex:0];
        return [node boundingBox].size.width < [self boundingBox].size.width;
    }
    return NO;
}

- (void)changeSwitchAnimation:(BOOL)animate {
    CCNode * node = [self getChildAtIndex:0];
    CGPoint pos = [node position];
    CGFloat distance = [node boundingBox].size.width;
    if (FLOAT_EQUAL(pos.x, 0) || FLOAT_EQUAL(pos.x, distance)) {
        if (FLOAT_EQUAL(pos.x, distance)) {
            distance *= -1;
        }
        pos.x += distance;
        [node runAction:[CCMoveTo actionWithDuration:(animate ? 0.2 : 0) position:pos]];
    }
}

- (BOOL)switchOn {
    CCNode * node = [self getChildAtIndex:0];
    return !CGPointEqualToPoint(node.position, CGPointZero);
}

- (void)refreshForTexture {
    NSString * path = [INSTANCE(Update) updateResourceFullPath:userObject_];
    if ([NSFileManager fileExit:path isDirectory:NO]) {
        [self setTexture:[CCTEXTURECACHE addImage:path]];
        [self setUserObject:nil];
        [self removeChildByTag:TAG_ICON_GRAYMASK cleanup:NO];
        [self unschedule:@selector(refreshForTexture)];
    }
}

- (void)refreshForTexture:(NSString *)textureName {
    NSString * path = [INSTANCE(Update) updateResourceFullPath:textureName];
    if ([NSFileManager fileExit:path isDirectory:NO]) {
        [self setTexture:[CCTEXTURECACHE addImage:path]];
    } else {
        [self setUserObject:[textureName retain]];
        CCSprite * loading = (CCSprite *)[self getChildByTag:TAG_ICON_GRAYMASK];
        CCRotateBy * doRotate = [CCRotateBy actionWithDuration:2 angle:360];
        if (loading) {
            [loading stopAllActions];
            [loading runAction:[CCRepeatForever actionWithAction:doRotate]];
        } else {
            loading = [CCSprite spriteWithTexture:[CCTEXTURECACHE textureForKey:PIC_LOADING]];
            [loading setPosition:ccp(self.contentSize.width / 2, self.contentSize.height / 2)];
            [self addChild:loading z:0 tag:TAG_ICON_GRAYMASK];
            [loading runAction:[CCRepeatForever actionWithAction:doRotate]];
        }
        [self schedule:@selector(refreshForTexture) interval:1];
    }
}

@end

#pragma mark -

@implementation CCTextureCache (Jex)

- (CCTexture2D *)replaceCGImage:(CGImageRef)imageref forKey:(NSString *)key {
    NSAssert(imageref != nil, @"TextureCache: image MUST not be nill");
    
	__block CCTexture2D * tex = nil;
    
#ifdef __CC_PLATFORM_IOS
	tex = [[CCTexture2D alloc] initWithCGImage:imageref resolutionType:kCCResolutionUnknown];
#elif __CC_PLATFORM_MAC
	tex = [[CCTexture2D alloc] initWithCGImage:imageref];
#endif
    
	if (tex && key) {
		dispatch_sync(_dictQueue, ^{
			[textures_ setObject: tex forKey:key];
		});
	} else {
		CCLOG(@"cocos2d: Couldn't add CGImage in CCTextureCache");
	}
    
	return [tex autorelease];
}

@end

#pragma mark -

@implementation CCLabelTTF (Jex)

+ (void)developingTipInParent:(CCNode *)pNode {
    CGSize size = [pNode contentSize];
    CGFloat fontSize = 12;
    if ([pNode isKindOfClass:[CCMAINLAYER class]] || CGSizeEqualToSize(pNode.contentSize, [CCDIRECTOR winSize])) {
        fontSize = 18;
    }
    [CCLabelTTF flyTip:NSLocalizedString(@"暂未开通，敬请期待！", @"")
            atPosition:ccp(size.width / 2, size.height / 2) inParent:pNode withColor:ccRED size:fontSize delay:0];
}

+ (void)flyTip:(NSString *)info inParent:(CCNode *)pNode {
    CGSize size = [pNode contentSize];
    CGFloat fontSize = 12;
    if ([pNode isKindOfClass:[CCMAINLAYER class]] || CGSizeEqualToSize(pNode.contentSize, [CCDIRECTOR winSize])) {
        fontSize = 18;
    }
    [CCLabelTTF flyTip:info atPosition:ccp(size.width / 2, size.height / 2) inParent:pNode withColor:ccRED size:fontSize delay:0];
}

+ (void)flyTip:(NSString *)info inParent:(CCNode *)pNode delay:(ccTime)delay {
    CGSize size = [pNode contentSize];
    CGFloat fontSize = 12;
    if ([pNode isKindOfClass:[CCMAINLAYER class]] || CGSizeEqualToSize(pNode.contentSize, [CCDIRECTOR winSize])) {
        fontSize = 18;
    }
    [CCLabelTTF flyTip:info atPosition:ccp(size.width / 2, size.height / 2) inParent:pNode withColor:ccRED size:fontSize delay:delay];
}

+ (void)flyTip:(NSString *)info atPosition:(CGPoint)pos inParent:(CCNode *)pNode {
    CGFloat fontSize = 12;
    if ([pNode isKindOfClass:[CCMAINLAYER class]] || CGSizeEqualToSize(pNode.contentSize, [CCDIRECTOR winSize])) {
        fontSize = 18;
    }
    [CCLabelTTF flyTip:info atPosition:pos inParent:pNode withColor:ccRED size:fontSize delay:0];
}

+ (void)flyTip:(NSString *)info atPosition:(CGPoint)pos inParent:(CCNode *)pNode delay:(ccTime)delay {
    CGFloat fontSize = 12;
    if ([pNode isKindOfClass:[CCMAINLAYER class]] || CGSizeEqualToSize(pNode.contentSize, [CCDIRECTOR winSize])) {
        fontSize = 18;
    }
    [CCLabelTTF flyTip:info atPosition:pos inParent:pNode withColor:ccRED size:fontSize delay:delay];
}

+ (void)flyTip:(NSString *)info inParent:(CCNode *)pNode withColor:(ccColor3B)dstColor {
    CGSize size = [pNode contentSize];
    CGFloat fontSize = 12;
    if ([pNode isKindOfClass:[CCMAINLAYER class]] || CGSizeEqualToSize(pNode.contentSize, [CCDIRECTOR winSize])) {
        fontSize = 18;
    }
    [CCLabelTTF flyTip:info atPosition:ccp(size.width / 2, size.height / 2) inParent:pNode withColor:dstColor size:fontSize delay:0];
}

+ (void)flyTip:(NSString *)info inParent:(CCNode *)pNode withColor:(ccColor3B)dstColor delay:(ccTime)delay {
    CGSize size = [pNode contentSize];
    CGFloat fontSize = 12;
    if ([pNode isKindOfClass:[CCMAINLAYER class]] || CGSizeEqualToSize(pNode.contentSize, [CCDIRECTOR winSize])) {
        fontSize = 18;
    }
    [CCLabelTTF flyTip:info atPosition:ccp(size.width / 2, size.height / 2) inParent:pNode withColor:dstColor size:fontSize delay:delay];
}

+ (void)flyTip:(NSString *)info inParent:(CCNode *)pNode withColor:(ccColor3B)dstColor size:(NSInteger)dstSize delay:(ccTime)delay {
    CGSize size = [pNode contentSize];
    [CCLabelTTF flyTip:info atPosition:ccp(size.width / 2, size.height / 2) inParent:pNode withColor:dstColor size:dstSize delay:delay];
}

+ (void)flyTip:(NSString *)info atPosition:(CGPoint)pos inParent:(CCNode *)pNode withColor:(ccColor3B)dstColor {
    CGFloat fontSize = 12;
    if ([pNode isKindOfClass:[CCMAINLAYER class]] || CGSizeEqualToSize(pNode.contentSize, [CCDIRECTOR winSize])) {
        fontSize = 18;
    }
    [CCLabelTTF flyTip:info atPosition:pos inParent:pNode withColor:dstColor size:fontSize delay:0];
}

+ (void)flyTip:(NSString *)info atPosition:(CGPoint)pos inParent:(CCNode *)pNode withColor:(ccColor3B)dstColor delay:(ccTime)delay {
    CGFloat fontSize = 12;
    if ([pNode isKindOfClass:[CCMAINLAYER class]] || CGSizeEqualToSize(pNode.contentSize, [CCDIRECTOR winSize])) {
        fontSize = 18;
    }
    [CCLabelTTF flyTip:info atPosition:pos inParent:pNode withColor:dstColor size:fontSize delay:delay];
}

+ (void)flyTip:(NSString *)info atPosition:(CGPoint)pos inParent:(CCNode *)pNode
     withColor:(ccColor3B)dstColor size:(NSInteger)dstSize delay:(ccTime)delay {
    CGFloat deviceAdd = [CURRENT_DEVICE isHD] ? 2 : 1;
    BOOL needAdd = NO;
    CCLabelTTF * tipLabel = (CCLabelTTF *)[pNode getChildByTag:TAG_LABEL_FLYTIP];
    if (!tipLabel || ![tipLabel isKindOfClass:[CCLabelTTF class]]) {
        tipLabel = [CCLabelTTF labelWithString:info fontName:@"Helvetica-Bold" fontSize:dstSize * deviceAdd];
        needAdd = YES;
    } else {
        [tipLabel setString:info];
    }
    [tipLabel setColor:dstColor];
    if (![pNode isInScrollView]) {
        CGSize size = [tipLabel contentSize];
        CGPoint parentPos = [pNode positionInParent:CCMAINLAYER];
        if (parentPos.x > 0 && parentPos.y > 0) {
            if (parentPos.x + pos.x - [pNode contentSize].width / 2 - size.width * tipLabel.anchorPoint.x < 0) {
                pos.x = size.width * tipLabel.anchorPoint.x + parentPos.x - [pNode contentSize].width / 2;
            } else if (size.width * tipLabel.anchorPoint.x + parentPos.x + pos.x - [pNode contentSize].width / 2 > [CCDIRECTOR winSize].width) {
                pos.x = [CCDIRECTOR winSize].width - size.width * tipLabel.anchorPoint.x -  parentPos.x + [pNode contentSize].width / 2;
            }
        }
    }
    [tipLabel setPosition:pos];
    [tipLabel setBorder:YES];
    CCMoveBy * doAction = [CCMoveBy actionWithDuration:1.3 position:ccp(0, (dstSize < 20 ? 35 : 50) * deviceAdd)];
    CCSequence * doFadeOut = [CCSequence actionOne:[CCDelayTime actionWithDuration:1] two:[CCFadeOut actionWithDuration:0.3]];
    CCCallFunc * doNext = [CCCallFunc actionWithTarget:tipLabel selector:@selector(removeFromParentAndCleanup:)];
    if (needAdd) {
        [pNode addChild:tipLabel z:0 tag:TAG_LABEL_FLYTIP];
    }
    if (delay > 0) {
        [tipLabel setVisible:NO];
        [tipLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:delay], [CCShow action],
                             [CCSpawn actionOne:doAction two:doFadeOut], doNext, nil]];
    } else {
        [tipLabel runAction:[CCSequence actionOne:[CCSpawn actionOne:doAction two:doFadeOut] two:doNext]];
    }
}

- (BOOL)isScrolling {
    return CGRectIsNull(scrollRect) || CGRectIsEmpty(scrollRect);
}

- (void)stopScroll {
    [self setScrollLoop:-1];
    [self setDimensions:dimensionsBeforeScroll];
    [self setPosition:positionBeforeScroll];
    [self setScrollRect:CGRectNull];
}

- (void)autoScroll {
    [self autoScrollWithDirect:YES andSpeed:0.5 inRect:CGRectZero];
}

- (void)autoScrollWithDirect:(BOOL)isHorizontal andSpeed:(CGFloat)speed {
    [self autoScrollWithDirect:isHorizontal andSpeed:speed inRect:CGRectZero];
}

- (void)autoScrollWithDirect:(BOOL)isHorizontal andSpeed:(CGFloat)speed inRect:(CGRect)rect {
    [self setScrollHorizontal:isHorizontal];
    [self setScrollSpeed:speed];
    [self setScrollRect:rect];
}

@end

@implementation CCScrollView (Jex)

- (void)resizeContainer:(CGSize)dstSize withDirection:(CCScrollViewDirection)direction {
    switch (direction) {
        case CCScrollViewDirectionVertical:
            if (dstSize.height < self.contentSize.height) {
                [self setDirection:CCScrollViewDirectionNone];
                [self.container setContentSize:self.contentSize];
                for (CCNode * node in self.container.children) {
                    [node setPosition:ccpAdd(node.position, ccp(0, self.contentSize.height - dstSize.height))];
                }
            } else {
                [self setDirection:direction];
                [self.container setContentSize:dstSize];
            }
            [self.container setPosition:ccp(0, self.contentSize.height - self.container.contentSize.height)];
            [self setViewSize:self.viewSize];
            break;
        
        case CCScrollViewDirectionHorizontal:
            if (dstSize.width < self.contentSize.width) {
                [self setDirection:CCScrollViewDirectionNone];
            } else {
                [self setDirection:direction];
            }
            [self.container setContentSize:dstSize];
            [self.container setPosition:CGPointZero];
            [self setViewSize:self.viewSize];
            break;
            
        default:
            break;
    }
}

@end

@implementation SimpleAudioEngine (Jex)

- (NSUInteger)playSound:(NSString *)name {
    return  [self playEffect:[APP appResourcePath:name]];
}

- (void)playMusic:(NSString *)name {
    [self playBackgroundMusic:[APP appResourcePath:name] loop:YES];
}

- (void)stopSound:(NSUInteger)soundId {
    [self stopEffect:soundId];
}

- (void)stopMusic {
    [self stopBackgroundMusic];
}

@end

@implementation CCAnimationCache (Jex)

- (void)addAnimationsWithAppFile:(NSString *)plist {
    NSAssert(plist, @"Invalid texture file name");
    
    NSString * path = [APP appResourcePath:plist];
	NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
	NSAssert1(dict, @"CCAnimationCache: File could not be found: %@", plist);
    
    NSDictionary * animations = [dict objectForKey:@"animations"];
    if (animations == nil) {
		CCLOG(@"cocos2d: CCAnimationCache: No animations were found in provided dictionary.");
		return;
	}
	
	NSUInteger version = 1;
	NSDictionary * properties = [dict objectForKey:@"properties"];
	if (properties) {
		version = [[properties objectForKey:@"format"] intValue];
	}
	NSArray * spritesheets = [properties objectForKey:@"spritesheets"];
	for (NSString * name in spritesheets) {
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithAppFile:name];
    }
	switch (version) {
		case 1:
			[self parseVersion1:animations];
			break;
		case 2:
			[self parseVersion2:animations];
			break;
		default:
			NSAssert(NO, @"Invalid animation format");
	}
}

@end

@implementation CCSpriteFrameCache (Jex)

- (void)addSpriteFramesWithAppFile:(NSString *)plist {
	NSAssert(plist, @"plist filename should not be nil");
	
	if (![loadedFilenames_ member:plist]) {
        NSString * path = [APP appResourcePath:plist];
		NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:path];
        
		NSString * texturePath = nil;
		NSDictionary * metadataDict = [dict objectForKey:@"metadata"];
		if (metadataDict) {
			// try to read  texture file name from meta data
			texturePath = [metadataDict objectForKey:@"textureFileName"];
        }
		if (texturePath) {
			// build texture path relative to plist file
			NSString * textureBase = [plist stringByDeletingLastPathComponent];
			texturePath = [textureBase stringByAppendingPathComponent:texturePath];
		} else {
			// build texture path by replacing file extension
			texturePath = [plist stringByDeletingPathExtension];
			texturePath = [texturePath stringByAppendingPathExtension:@"png"];
            
			CCLOG(@"cocos2d: CCSpriteFrameCache: Trying to use file '%@' as texture", texturePath);
		}
        
		[self addSpriteFramesWithDictionary:dict textureFilename:texturePath];
		
		[loadedFilenames_ addObject:plist];
        
	} else {
		CCLOGINFO(@"cocos2d: CCSpriteFrameCache: file already loaded: %@", plist);
    }
}

@end

