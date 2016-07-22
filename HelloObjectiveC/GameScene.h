//
//  GameScene.h
//  HelloObjectiveC
//

//  Copyright (c) 2016 Stephen Brennan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@protocol Hands
@property SKNode *hourHand;
@property SKNode *minuteHand;
@property SKNode *secondHand;
@end



@interface GameScene : SKScene

@property NSTimer * timer;
@property id <Hands> hands;

-(void) load ;

//@property SKNode *secondHand;
//@property SKNode *minuteHand;
//@property SKNode *hourHand;


@end
