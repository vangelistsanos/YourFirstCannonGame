//
//  MainGameLayer.mm
//  YourFirstCannonGame
//
//  Created by Vangelis Tsanos on 12/29/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import "MainGameLayer.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"






@interface MainGameLayer()
    -(void) initPhysics;
@end

@implementation MainGameLayer





#pragma mark main routines

/**
 * scene
 */
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainGameLayer *layer = [MainGameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
    
    
	// return the scene
	return scene;
}


/**
 * init
 */
-(id) init
{
	if( (self=[super init])) {
		
		self.isTouchEnabled = YES;          //touches on screen are enabled
		self.isAccelerometerEnabled = NO;   //accelerometer is disabled
        
		
		// init physics
		[self initPhysics];
		
		
		//set up background
        [self loadAndDisplayBackground:self];
        
        //set up cannon
        [self loadAndDisplayCannon:self];
        
        
        //setup level
        [self setupLevel];
        
        
        
        // This loads an image of the same name (but ending in png), and goes through the
        // plist to add definitions of each frame to the cache.
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cannon_strength_project_default.plist"];
        
        // Create a sprite sheet with the cannon strength images
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"cannon_strength_project_default.png"];
        [self addChild:spriteSheet];
        
        // Load up the frames of our animation
        NSMutableArray *strengthFrames = [NSMutableArray array];
        for(int i = 1; i <= 5; ++i) {
            [strengthFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"str_%d.png", i]]];
        }
        for (int i = 5; i>=1; i--) {
            [strengthFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"str_%d.png", i]]];
        }
        CCAnimation *fullStrengthAnim = [CCAnimation animationWithSpriteFrames:strengthFrames delay:0.1f];
        fullStrengthAnim.restoreOriginalFrame = NO;
        
        
        // Create a sprite for our strength bar
        
        sprCannonStrength = [CCSprite spriteWithSpriteFrameName:@"str_1.png"];
        fullStrengthAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:fullStrengthAnim]];
        
        [spriteSheet addChild:sprCannonStrength];
        
        [sprCannonStrength setPosition:CGPointMake(25,300)];
        [sprCannonStrength setRotation:90];
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"str_1.png"];
        [sprCannonStrength setDisplayFrame:frame];
        
        
		[self scheduleUpdate];
	}
	return self;
}


/**
 * Adds all the objects of the game...staticbrics,moving bricks,jointed objects etc.
 */
-(void) setupLevel
{
    //initialize cannon balls array
    cannonBalls = [[NSMutableArray alloc] init];
    enemies = [[NSMutableArray alloc] init];
    
    counterOfSprites = 0; // keeps current active sprites so it gives us a unique id whenever we want
    
    
    //set up fixed obstacles
    StaticBrick *sb1 = [[StaticBrick alloc] initWithWorld:world atLocation:CGPointMake(250, 230) spriteID:counterOfSprites  angle:0.0f];
    [self addChild:sb1];
    counterOfSprites++;
    MovingBrick *sb2 = [[MovingBrick alloc] initWithWorld:world atLocation:CGPointMake(300, 200) spriteID:counterOfSprites startMovement:-1];
    [self addChild:sb2];
    counterOfSprites++;
    StaticBrick *sb3 = [[StaticBrick alloc] initWithWorld:world atLocation:CGPointMake(350, 150) spriteID:counterOfSprites  angle:0.0f];
    [self addChild:sb3];
    counterOfSprites++;
    MovingBrick *sb4 = [[MovingBrick alloc] initWithWorld:world atLocation:CGPointMake(200, 100) spriteID:counterOfSprites startMovement:1];
    [self addChild:sb4];
    counterOfSprites++;
    StaticBrick *sb5 = [[StaticBrick alloc] initWithWorld:world atLocation:CGPointMake(450, 100) spriteID:counterOfSprites  angle:0.0f];
    [self addChild:sb5];
    counterOfSprites++;
    
    StaticBrick *sb55 = [[StaticBrick alloc] initWithWorld:world atLocation:CGPointMake(390, 100) spriteID:counterOfSprites  angle:90.0f];
    [self addChild:sb55];
    counterOfSprites++;
    
    StaticBrick *sb56 = [[StaticBrick alloc] initWithWorld:world atLocation:CGPointMake(450, 200) spriteID:counterOfSprites angle:45.0f];
    [self addChild:sb56];
    counterOfSprites++;
    
    
    //set up rock obstacles
    RoundGravityObject *sb6 = [[RoundGravityObject alloc] initWithWorld:world atLocation:CGPointMake(350,200) withImage:@"rock_128x128.png"spriteID:counterOfSprites];
    [self addChild:sb6];
    counterOfSprites++;
    
    
    
    
    
    
    
    //set up target object
    
    RectGravityObject *enemy = [[RectGravityObject alloc] initWithWorld:world atLocation:CGPointMake(240,300) withImage:@"monster.png"spriteID:counterOfSprites];
    [enemies addObject:enemy];
    [self addChild:enemy];
    counterOfSprites++;
    
    enemy = [[RectGravityObject alloc] initWithWorld:world atLocation:CGPointMake(450,150) withImage:@"monster.png"spriteID:counterOfSprites];
    [enemies addObject:enemy];
    [self addChild:enemy];
    counterOfSprites++;
    
    
    
    //************ This is an example of a joint between 2 objects
    StaticBrick *sb60 = [[StaticBrick alloc] initWithWorld:world atLocation:CGPointMake(150, 230) spriteID:counterOfSprites angle:0.0f];
    [self addChild:sb60];
    counterOfSprites++;
    
    
    RectGravityObject *sb61 = [[RectGravityObject alloc] initWithWorld:world atLocation:CGPointMake(150,200) withImage:@"wood_32x128.png"spriteID:counterOfSprites];
    [self addChild:sb61];
    counterOfSprites++;
    
    b2RevoluteJointDef revJointDef;
    revJointDef.Initialize([sb61 getBody], [sb60 getBody],
                           [sb61 getBody]->GetWorldPoint(b2Vec2(0/PTM_RATIO, 50/PTM_RATIO)));
    revJointDef.lowerAngle = CC_DEGREES_TO_RADIANS(-180);
    revJointDef.upperAngle = CC_DEGREES_TO_RADIANS(180);
    revJointDef.enableLimit = true;
    world->CreateJoint(&revJointDef);
    //**************
    
    
    enemiesToBeDeleted = [[NSMutableArray alloc] init];
}


/**
 * dealloc
 */
-(void) dealloc
{
    
    
    [self releaseBackground:self];
    [self releaseCannon:self];
    
    
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	
	[super dealloc];
}	




/**
 * initPhysics
 */
-(void) initPhysics
{
 
    //windowSize = [[CCDirector sharedDirector] winSize];
    windowSize = CGSizeMake(480, 320); //iphone4 resolution -- it also supports retina
    
   

    
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
	
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);		
	
	
	// Define the ground body.
	//b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;		
	
	// bottom
	
	groundBox.Set(b2Vec2(0,0), b2Vec2(windowSize.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0,windowSize.height/PTM_RATIO), b2Vec2(windowSize.width/PTM_RATIO,windowSize.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(0,windowSize.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(windowSize.width/PTM_RATIO,windowSize.height/PTM_RATIO), b2Vec2(windowSize.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
}




/**
 * draw
 */
-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommended to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();	
	
	kmGLPopMatrix();
}




/**
 * update
 */

-(void) update: (ccTime) dt
{
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation.
    // we should always have these values fixed
	world->Step(dt, velocityIterations, positionIterations);
    
    for (RectGravityObject *rgo in enemiesToBeDeleted) {
        [enemies removeObject:rgo];
        [self doTargetExplosion:[rgo getSprite].position];
        [[rgo getSprite] removeFromParentAndCleanup:YES];
        //remove body
        world->DestroyBody([rgo getBody]);
        rgo = nil;
    }

    [enemiesToBeDeleted removeAllObjects];
    
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}
	}
}



















#pragma mark Cannon Ball delegate

/**
 * time out of cannon ball
 */
-(void) timeOutOfCannonBallHappened : (CannonBall *) cb
{
    
    
    //check all enemies and if within range destroy them
    for (RectGravityObject *rgo in enemies)
    {
        if ([self findDistanceBetween2Points:[cb getSprite].position :[rgo getSprite].position]<50) {
            [enemiesToBeDeleted addObject:rgo];
        }
    }
    
    
    //do some explosion effect
    [self doParticleExplosion:[cb getSprite].position];
    
    //remove sprite of cannon
    [[cb getSprite] removeFromParentAndCleanup:YES];
 
    //remove body of cannon
    world->DestroyBody([cb getBody]);
    cb = nil;
    
}




















#pragma mark Touch Events

/**
 * ccTouchesBegan
 */

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
        
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
        fStartPoint = location;
        
        CCLOG(@"start-->%f %f",location.x,location.y);
        
	}
    
}




/**
 * ccTouchesMoved
 */
-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
        fEndPoint = location;
        
        fAngleOfPoints = atan2f(fEndPoint.y-fStartPoint.y,fEndPoint.x-fStartPoint.x) * 180 / M_PI;
        
        [sprCannon setRotation:90-fAngleOfPoints];
		CCLOG(@"start point pos  %f %f      end point pos %f %f   angle of points %f",fStartPoint.x,fStartPoint.y,fEndPoint.x,fEndPoint.y,fAngleOfPoints);
        CCLOG(@"strength of cannon %f", [self findDistanceBetween2Points:fStartPoint:fEndPoint]);
        
       
        
	}
    
    CCSpriteFrame *frame;
    int iStr = (int)[CannonBall calcRealSpeed:[self findDistanceBetween2Points:fStartPoint:fEndPoint]];
    switch (iStr) {
        case 5:
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"str_1.png"];
        break;
        case 10:
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"str_1.png"];
        break;
        case 15 :
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"str_2.png"];

        break;
        case 20 :
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"str_3.png"];

        break;
        case 25 :
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"str_4.png"];

        break;
        case 30 :
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"str_5.png"];

        break;
    }
    
    
    [sprCannonStrength setDisplayFrame:frame];
    
        
    
}



/**
 * ccTouchesEnded
 */
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		location = [[CCDirector sharedDirector] convertToGL: location];
        
        float sprCannonRotation = sprCannon.rotation;
        CCLOG(@"%f",sprCannonRotation);
        fEndPoint = location;
        CCLOG(@"strength of cannon final %f", [self findDistanceBetween2Points:fStartPoint:fEndPoint]);
        
        
        //create new cannonball
        CannonBall *cb = [[CannonBall alloc] initWithWorld:world atLocation:sprCannon.position angle:fAngleOfPoints velocity:[self findDistanceBetween2Points:fStartPoint:fEndPoint] spriteID:counterOfSprites];
       
        cb.delegate = self;
        [self addChild:cb];
        counterOfSprites++;
        [cannonBalls addObject:cb];
        [[SimpleAudioEngine sharedEngine] playEffect:@"cannonball.mp3"];
        

        
    }
    
    
CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"str_1.png"];
[sprCannonStrength setDisplayFrame:frame];

}



















#pragma mark distance calculation

/**
 * findDistanceBetween2Points
 */
-(float) findDistanceBetween2Points:(CGPoint ) pointA : (CGPoint) pointB {
    //Euclidean distance
    float dist = sqrtf(powf((pointA.x - pointB.x),2)+powf((pointA.y-pointB.y),2));
    CCLOG(@"MAX DISTANCE CALCULATED %f",dist);
    return dist;
}



















 
#pragma mark Particle Explosions

/**
 * doParticleExplosion
 */
-(void) doParticleExplosion : (CGPoint) location{
    CCParticleExplosion *myEmitter;
    
    myEmitter = [[CCParticleExplosion alloc] initWithTotalParticles:30];
    
    //fire.png is my particle image
    myEmitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"fire.png"]; //32x32
    myEmitter.position = location;
    myEmitter.life =0.8;
    myEmitter.duration = 0.4;
    myEmitter.scale = 0.2;
    myEmitter.speed = 150;
    
    //For not showing color
    myEmitter.blendAdditive = NO;
    
    myEmitter.autoRemoveOnFinish = YES;
    [self addChild:myEmitter];
    [[SimpleAudioEngine sharedEngine] playEffect:@"explode.mp3"];
}




/**
 * doTargetExplosion
 */
-(void) doTargetExplosion : (CGPoint) location {
    CCParticleExplosion *myEmitter;
    
    myEmitter = [[CCParticleExplosion alloc] initWithTotalParticles:30];
    
    //blood.png is my particle image
    myEmitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"blood.png"]; //32x32
    myEmitter.position = location;
    myEmitter.life =0.8;
    myEmitter.duration = 0.4;
    myEmitter.scale = 0.2;
    myEmitter.speed = 200;
    
    //For not showing color
    myEmitter.blendAdditive = NO;
    myEmitter.rotation = 2.0;
    myEmitter.autoRemoveOnFinish = YES;
    [self addChild:myEmitter];
    [[SimpleAudioEngine sharedEngine] playEffect:@"splatter.mp3"];
}























#pragma mark load and release of background and cannon

/**
 * loadAndDisplayCannon
 */
-(void) loadAndDisplayCannon : (CCLayer *) c2d_layer
{
    sprCannon = [CCSprite spriteWithFile:@"cannon_140x140.png"];
    [sprCannon setPosition:ccp(100.0f,50.0f)];
    [c2d_layer addChild:sprCannon];
}



/**
 * releaseCannon
 */
-(void) releaseCannon : (CCLayer *) c2d_layer
{
    [sprCannon removeFromParentAndCleanup:YES];
    sprCannon = NULL;
}



/**
 * loadAndDisplayBackground
 */
-(void) loadAndDisplayBackground : (CCLayer *) c2d_layer
{
    sprBackground = [CCSprite spriteWithFile:@"old-paper-texture_960x640.jpg"];
    [sprBackground setPosition:ccp(240.0f,160.0f)];
    [c2d_layer addChild:sprBackground];
    
}



/**
 * releaseBackground
 */
-(void) releaseBackground : (CCLayer *) c2d_layer
{
    [sprBackground removeFromParentAndCleanup:YES];
    sprBackground = NULL;
}


















#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}




-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

@end
