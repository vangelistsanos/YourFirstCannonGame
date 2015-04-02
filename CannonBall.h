//
//  CannonBall.h
//  YourFirstCannonGame
//
//  Created by Vangelis Tsanos on 12/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"


//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32



@protocol CannonBallDelegate

@required

-(void) timeOutOfCannonBallHappened : (id) cb;

@end


@interface CannonBall : CCNode {
    CCSprite *sprCannonBall;
    b2Body *body;
    
    NSTimer *bombTimer;
    CCLayer *delegate;
}


@property (nonatomic,assign) CCLayer *delegate;



-(id)initWithWorld : (b2World*) p_World
        atLocation : (CGPoint) p_location
             angle : (float) p_angle
          velocity : (float) p_velocity
          spriteID : (int) p_spriteID;


-(b2Body *) getBody;

-(CCSprite *) getSprite;


+(float) calcRealSpeed : (float) p_velocity;

@end
