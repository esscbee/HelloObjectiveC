//
//  GameScene.m
//  HelloObjectiveC
//
//  Created by Stephen Brennan on 7/20/16.
//  Copyright (c) 2016 Stephen Brennan. All rights reserved.
//

#import "GameScene.h"


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
@end

// *********************************** BlockHands *********************

@interface BlockHands : NSObject<Hands>
@property SKNode *hourHand;
@property SKNode *minuteHand;
@property SKNode *secondHand;

@property (weak) SKScene * scene;
@end

@implementation BlockHands
-(SKNode*) createBar: (CGFloat)height :(UIColor *) color {
    
    CGSize size = CGSizeMake(2.0, height);
    SKSpriteNode * sk = [ SKSpriteNode spriteNodeWithColor:color size: size];
    CGSize fr = self.scene.frame.size;
    sk.position = CGPointMake(fr.width / 2.0, fr.height / 2.0);
    sk.anchorPoint = CGPointMake(0.25, 0.25);
    [self.scene addChild:sk ];
    
    return sk;
}
-(id) initFromScene: (SKScene *)scene {
    if (self = [super init]) {
        self.scene = scene;
        self.hourHand = [self createBar:150 : [UIColor blackColor]];
        self.minuteHand = [self createBar:250 : [UIColor blackColor]];
        self.secondHand = [self createBar:250 : [UIColor redColor]];
        
    }
    
    return self;
}



@end



// *********************************** GameScene ***********************
@implementation GameScene
-(void) load {
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
//    self.hands = [[UglyHands alloc] initFromScene:self];
    self.hands = [[BlockHands alloc] initFromScene:self];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector: @selector(timerCallBack:) userInfo:nil repeats:true];
    
//    CGFloat scale = 0.2;
//    SKAction * rotate = [SKAction rotateByAngle: M_PI_2 duration:0];
    

}

-(void) rotateTo: (SKSpriteNode *) n pct:(double) pct {
    CGFloat pis = pct * M_PI * -2;
    CGFloat duration = (pis == 0 || pis == 1) ? 0 : 0.1;
    SKAction * rotate = [ SKAction rotateToAngle:pis duration: duration];
    [ n runAction:rotate];
    
}

-(void) timerCallBack: (NSTimer *) theTimer {
    
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
    
//    printf("hour: %ld, minute: %ld, second: %ld, pct: %f\n",(long)hour,(long)minute, (long)second,pct);
    
}
@end
