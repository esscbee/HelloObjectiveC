//
//  GameScene.m
//  HelloObjectiveC
//
//  Created by Stephen Brennan on 7/20/16.
//  Copyright (c) 2016 Stephen Brennan. All rights reserved.
//

#import "GameScene.h"

// *********************************** Constants ***********************
NSString *const NAME_TICK = @"TickMark";
NSString *const NAME_MINUTE = @"MinuteHand";
NSString *const NAME_HOUR = @"HourHand";
NSString *const NAME_SECOND = @"SecondHand";




// *********************************** UglyHands ***********************
@interface UglyHands : NSObject<Hands>
@property SKNode *hourHand;
@property SKNode *minuteHand;
@property SKNode *secondHand;

@property (weak) SKScene * scene;
@end

@implementation UglyHands
-(SKSpriteNode *)loadAndScale:(NSString *)image inScale:(CGFloat)scale inAnchor:(CGFloat)anchor {
    SKSpriteNode * n = [ SKSpriteNode spriteNodeWithImageNamed:image];
    n.position = CGPointMake(self.scene.frame.size.width/2, self.scene.frame.size.height / 2);
    n.anchorPoint = CGPointMake(0.5, anchor);
    n.xScale = scale;
    n.yScale = scale;
    
    [self.scene  addChild: n];
    
    return n;
}

-(id) initFromScene: (SKScene *)scene {
    if (self = [super init]) {
        self.scene = scene;
        self.hourHand = [self loadAndScale: @"HourHand" inScale:.1 inAnchor: 0.34];
        self.minuteHand = [self loadAndScale:@"MinuteHand" inScale:.15 inAnchor: 0.34];
        //    [self.minuteHand runAction:rotate];
        
        if (true) {
            self.secondHand = [self loadAndScale:@"SecondHand" inScale:.2 inAnchor: 0.275];
            //        self.secondHand.anchorPoint = CGPointMake(.5, .275);
            //        [self.secondHand runAction:rotate];
            //        [self.secondHand runAction:rotate];
        }
    }
    
    return self;
    
}
-(void) createFace {
    
}
-(void) setStatus:(NSString *)status {
    
}
@end

// *********************************** BlockHands *********************

@interface BlockHands : NSObject<Hands>
@property SKNode *hourHand;
@property SKNode *minuteHand;
@property SKNode *secondHand;
@property SKLabelNode *statusLabel;

@property CGFloat multiplier;

@property (weak) SKScene * scene;
@end

@implementation BlockHands
-(SKNode*) createBar: (CGFloat)height :(UIColor *)color :(NSString const*) name {
    
    CGSize size = CGSizeMake(2.0, height);
    SKSpriteNode * sk = [ SKSpriteNode spriteNodeWithColor:color size: size];
    CGSize fr = self.scene.frame.size;
    sk.position = CGPointMake(fr.width / 2.0, fr.height / 2.0);
    sk.anchorPoint = CGPointMake(0.25, 0.25);
    sk.name = name;
    sk.zPosition = 10;
    return sk;
}
-(SKNode*) createBarAndAnimate: (CGFloat)height :(UIColor *) color :(NSString const*) name  {
    SKNode *sk = [self createBar:height :color :name ];
    [self.scene addChild:sk ];
    [sk runAction:[ SKAction sequence:
                   @[
                     [SKAction fadeOutWithDuration:0],
                     [SKAction fadeInWithDuration:3]
                     ]]];
    
    return sk;
}
-(UIColor *) loadColor: (NSString *)key : (UIColor *) defColor {
    NSData * data =  [[ NSUserDefaults standardUserDefaults] dataForKey:key ];
    if (data) {
        UIColor * retColor = [ NSKeyedUnarchiver unarchiveObjectWithData:data ];
        if (retColor) {
            return retColor;
        }
    }
    return defColor;
}
-(id) initFromScene: (SKScene *)scene {
    if (self = [super init]) {
        self.scene = scene;
        CGSize size = self.scene.frame.size;
        CGFloat dim = size.width < size.height ? size.width : size.height;
        self.multiplier = dim / 50.0;
        
        UIColor *hourColor = [self loadColor:NAME_HOUR : [UIColor blackColor]];
        UIColor *minuteColor = [self loadColor:NAME_MINUTE : [UIColor whiteColor] ];
        UIColor *secondColor = [self loadColor:NAME_SECOND : [UIColor redColor] ];
        

        self.hourHand = [self createBarAndAnimate:20 * _multiplier : hourColor  :NAME_HOUR];
        self.minuteHand = [self createBarAndAnimate:30 * _multiplier : minuteColor  :NAME_MINUTE];
        self.secondHand = [self createBarAndAnimate:30 * _multiplier : secondColor :NAME_SECOND];
        
        // creat status
        self.statusLabel = [ SKLabelNode labelNodeWithText: nil ];
        CGPoint center = CGPointMake(size.width / 2, size.height - 30);
        self.statusLabel.position = center;
        [self.scene addChild:self.statusLabel ];
    }
    
    return self;
}

-(void)createFace {
    for(int i = 0; i < 60 ; i ++) {
        int mul = (0 == i%5) ? 27 : 29;
        SKNode *skOuter = [ self createBar: 30 * _multiplier : [UIColor colorWithRed:0 green:.7 blue:0 alpha:.8 ] :NAME_TICK];
        skOuter.zPosition = -10;
        skOuter.alpha = 1;
        [ self.scene addChild:skOuter ];
        SKNode *skInner =[ self createBar: mul * _multiplier : [self.scene backgroundColor ] : @"no_name"];
        skInner.zPosition = 1;
//        skInner.alpha = .5;
        [ self.scene addChild:skInner ];
        CGFloat angle = i / 60.0 * M_PI * 2;
        SKAction *rotate = [ SKAction rotateToAngle:angle duration:0];
        [ skOuter runAction:rotate];
        [ skInner runAction:rotate];
    }
}
-(void) setStatus:(NSString *)status {
    self.statusLabel.text = status;
}


@end



// *********************************** GameScene ***********************
@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
//    self.hands = [[UglyHands alloc] initFromScene:self];
    self.hands = [[BlockHands alloc] initFromScene:self];
    [self.hands createFace];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector: @selector(timerCallBack:) userInfo:nil repeats:true];
    [self updateHands ] ;
    
//    CGFloat scale = 0.2;
//    SKAction * rotate = [SKAction rotateByAngle: M_PI_2 duration:0];
    

}

-(void) rotateTo: (SKNode *) n pct:(double) pct {
    CGFloat pis = pct * M_PI * -2;
    CGFloat duration = (pis == 0 || pis == 1) ? 0 : 0.1;
    SKAction * rotate = [ SKAction rotateToAngle:pis duration: duration];
    [ n runAction:rotate];
    
}
-(void)updateHands {
    NSDate *date  = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    
    if (hour >= 12) {
        hour -= 12;
    }
    
    double pct = second / 60.0;
    [self rotateTo:self.hands.secondHand pct: pct];
    [self rotateTo:self.hands.minuteHand pct: (minute + second / 60.0) / 60.0];
    [self rotateTo:self.hands.hourHand pct: (hour + minute / 60.0 + second / 3600.0) / 12.0];
}
-(void) timerCallBack: (NSTimer *) theTimer {
    [ self updateHands ];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    for(UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self ];
        SKNode *node = [self nodeAtPoint:location];
        if(node != nil) {
            NSString * name = node.name;
            
            break;
        }
        
    }
}

-(void)setColor:(NSString *)name :(UIColor *)theColor {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:theColor];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:name ];
    
    for(SKNode *n in self.children) {
        if(n.name == name) {
            ((SKSpriteNode *)n).color = theColor;
        }
    }
}


@end
