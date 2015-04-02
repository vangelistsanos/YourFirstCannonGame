//
//  MovingBrick.h
//  YourFirstCannonGame
//
//  Created by Vangelis Tsanos on 1/1/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
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

@interface MovingBrick : CCNode {
    CCSprite *sprMovingBrick;
    b2Body *body;
    NSTimer *delayTimer;
    float movementDirection;
    
}


-(id)initWithWorld : (b2World*) p_World
        atLocation : (CGPoint) p_location
          spriteID : (int) p_spriteID
     startMovement : (int) p_startDirection;

-(b2Body *) getBody;

-(CCSprite *) getSprite;



@end
