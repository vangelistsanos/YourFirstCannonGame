//
//  StaticBrick.h
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



@interface StaticBrick : CCNode {
        CCSprite *sprStaticBrick;
        b2Body *body;
        
    }
    
    
-(id)initWithWorld : (b2World*) p_World
        atLocation : (CGPoint) p_location
          spriteID : (int) p_spriteID
             angle : (float) p_angle;
    
    
    -(b2Body *) getBody;
    
    -(CCSprite *) getSprite;


@end
