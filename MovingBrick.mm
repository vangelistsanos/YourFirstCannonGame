//
//  MovingBrick.m
//  YourFirstCannonGame
//
//  Created by Vangelis Tsanos on 1/1/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MovingBrick.h"


@implementation MovingBrick

-(id)initWithWorld : (b2World*) p_World
        atLocation : (CGPoint) p_location
          spriteID : (int) p_spriteID
     startMovement : (int) p_startDirection;
{
    
    
    
    
    self = [super init];
    if (self) {
        
        
        //sprite creation
        sprMovingBrick= [CCSprite spriteWithFile:@"brick_64x32.png"];
        sprMovingBrick.position = ccp( p_location.x, p_location.y);
        sprMovingBrick.tag = p_spriteID;
        
        [self addChild:sprMovingBrick];
        
        // Define the dynamic body.
        //Set up a 1m squared box in the physics world
        b2BodyDef bodyDef;
        bodyDef.type = b2_kinematicBody;    // no gravity
        
        
        bodyDef.position.Set(p_location.x/PTM_RATIO, p_location.y/PTM_RATIO);
        bodyDef.userData = sprMovingBrick;
        body = p_World->CreateBody(&bodyDef);
        
        b2PolygonShape dynamicPolygon;

        
        dynamicPolygon.SetAsBox(sprMovingBrick.contentSize.width/PTM_RATIO/2,
                                sprMovingBrick.contentSize.height/PTM_RATIO/2);
        
        
        
        // Define the dynamic body fixture.
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicPolygon;
        body->CreateFixture(&fixtureDef);
        
        delayTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(changeDirectionTimer) userInfo:nil repeats:YES];
        
        if (p_startDirection>0) movementDirection = 1; else movementDirection = -1;
        b2Vec2 vel = b2Vec2(movementDirection,0);
        body->SetLinearVelocity(vel);
        
        
    }
    
    
    
    return self;
    
    
}



-(void) changeDirectionTimer
{
    if (movementDirection==1) movementDirection=-1; else movementDirection=1;
    b2Vec2 vel = b2Vec2(movementDirection,0);
    body->SetLinearVelocity(vel);
}



-(b2Body *) getBody
{
    return body;
}




-(CCSprite *) getSprite
{
    return sprMovingBrick;
}

@end
