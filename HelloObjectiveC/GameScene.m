//
//  GameScene.m
//  HelloObjectiveC
//
//  Created by Stephen Brennan on 7/20/16.
//  Copyright (c) 2016 Stephen Brennan. All rights reserved.
//

#import "GameScene.h"



@implementation GameScene

-(SKSpriteNode *)loadAndScale:(NSString *)image inScale:(CGFloat)scale inAnchor:(CGFloat)anchor {
    SKSpriteNode * n = [ SKSpriteNode spriteNodeWithImageNamed:image];
    n.position = CGPointMake(self.frame.size.width/2, self.frame.size.height / 2);
    n.anchorPoint = CGPointMake(0.5, anchor);
    n.xScale = scale;
    n.yScale = scale;
    
    [self  addChild: n];
    
    return n;
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector: @selector(timerCallBack:) userInfo:nil repeats:true];
    
//    CGFloat scale = 0.2;
//    SKAction * rotate = [SKAction rotateByAngle: M_PI_2 duration:0];
    
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
    [self rotateTo:self.secondHand pct: pct];
    [self rotateTo:self.minuteHand pct: (minute + second / 60.0) / 60.0];
    [self rotateTo:self.hourHand pct: (hour + minute / 60.0 + second / 3600.0) / 12.0];
    
//    printf("hour: %ld, minute: %ld, second: %ld, pct: %f\n",(long)hour,(long)minute, (long)second,pct);
    
}
@end
