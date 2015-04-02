//
//  CannonBall.m
//  YourFirstCannonGame
//
//  Created by Vangelis Tsanos on 12/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CannonBall.h"


@implementation CannonBall


@synthesize delegate;


-(id)initWithWorld : (b2World*) p_World
        atLocation : (CGPoint) p_location
             angle : (float) p_angle
          velocity : (float) p_velocity
          spriteID : (int) p_spriteID
{
    
    

        
        self = [super init];
        if (self) {
            
            
            //sprite creation
            sprCannonBall= [CCSprite spriteWithFile:@"cannonball_40x40.png"];
            sprCannonBall.position = ccp( p_location.x, p_location.y);
            sprCannonBall.tag = p_spriteID;
            
            [self addChild:sprCannonBall];
            
            // Define the dynamic body.
            //Set up a 1m squared box in the physics world
            b2BodyDef bodyDef;
            bodyDef.type = b2_dynamicBody;
            
            
            bodyDef.position.Set(p_location.x/PTM_RATIO, p_location.y/PTM_RATIO);
            bodyDef.userData = sprCannonBall;
            body = p_World->CreateBody(&bodyDef);
            
            
            // Define another box shape for our dynamic body.
            b2CircleShape dynamicCircle;
            dynamicCircle.m_radius = 9.0f/PTM_RATIO;
            
            
            // Define the dynamic body fixture.
            b2FixtureDef fixtureDef;
            fixtureDef.shape = &dynamicCircle;
            fixtureDef.density = 1.0f;  //weight
            fixtureDef.friction = 0.8f;   //friction
            fixtureDef.restitution = 0.4f;  //bouncing
            //fixtureDef.isSensor = true;  //we set to true when we want to know that a collision happened
            
            body->CreateFixture(&fixtureDef);
            b2Vec2 ballVel;
            
            //float speed = fmodf(p_velocity, 50);
            
            
            float speed = [CannonBall calcRealSpeed:p_velocity];
                        
            
            
            CCLOG(@"REAL SPEED = %f",speed);
            float angle = p_angle*M_PI/180.0f;
            b2Vec2 calcVel = speed*b2Vec2(cos(angle),sin(angle));

            body->SetLinearVelocity(calcVel);
            
            
            bombTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(cannonBallTimeOut) userInfo:nil repeats:NO];
 
        }
        
        
        
        return self;
    

}


+(float) calcRealSpeed : (float) p_velocity {
    float speed;
    if (p_velocity <= 10) speed = 5;
    if ((p_velocity > 10) && (p_velocity<=50)) speed = 10;
    if ((p_velocity > 50) && (p_velocity<=100)) speed = 15;
    if ((p_velocity > 100) && (p_velocity<=150)) speed = 20;
    if ((p_velocity > 150) && (p_velocity<=200)) speed = 25;
    if (p_velocity >200) speed = 30;
    
    return speed;
}



-(void) cannonBallTimeOut
{
    [bombTimer invalidate];
    bombTimer = nil;

    [self.delegate timeOutOfCannonBallHappened : self];
    
}




-(b2Body *) getBody
{
    return body;
}


-(CCSprite *) getSprite
{
    return sprCannonBall;
}



@end
