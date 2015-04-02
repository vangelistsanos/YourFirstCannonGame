//
//  StaticBrick.m
//  YourFirstCannonGame
//
//  Created by Vangelis Tsanos on 12/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "StaticBrick.h"


@implementation StaticBrick

-(id)initWithWorld : (b2World*) p_World
        atLocation : (CGPoint) p_location
          spriteID : (int) p_spriteID
             angle : (float) p_angle
{
    
    
    
    
    self = [super init];
    if (self) {
        
        
        //sprite creation
        sprStaticBrick= [CCSprite spriteWithFile:@"brick_64x32.png"];
        sprStaticBrick.position = ccp( p_location.x, p_location.y);
        sprStaticBrick.tag = p_spriteID;
        
        [self addChild:sprStaticBrick];
        
        // Define the dynamic body.
        //Set up a 1m squared box in the physics world
        b2BodyDef bodyDef;
        bodyDef.type = b2_staticBody;    // no gravity
        
        
        bodyDef.position.Set(p_location.x/PTM_RATIO, p_location.y/PTM_RATIO);
        bodyDef.userData = sprStaticBrick;
        body = p_World->CreateBody(&bodyDef);
        
        b2PolygonShape dynamicPolygon;
        //dynamicCircle.m_radius = 9.0f/PTM_RATIO;
        
        dynamicPolygon.SetAsBox(sprStaticBrick.contentSize.width/PTM_RATIO/2,
                                sprStaticBrick.contentSize.height/PTM_RATIO/2);
        

        
        // Define the dynamic body fixture.
        b2FixtureDef fixtureDef;
        fixtureDef.shape = &dynamicPolygon;

        
        body->CreateFixture(&fixtureDef);
     
        /* set angle of object */
        float angle =p_angle; //or whatever you angle is
        b2Vec2 pos = body->GetPosition();
        body->SetTransform(pos, angle);
                
    }
    
    
    
    return self;
    
    
}



-(b2Body *) getBody {
    return body;
}


-(CCSprite *) getSprite {
    return sprStaticBrick;
}

@end
