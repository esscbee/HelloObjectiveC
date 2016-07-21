//
//  GameScene.h
//  HelloObjectiveC
//

//  Copyright (c) 2016 Stephen Brennan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene

@property NSTimer * timer;
@property SKNode *secondHand;
@property SKNode *minuteHand;
@property SKNode *hourHand;


@end
