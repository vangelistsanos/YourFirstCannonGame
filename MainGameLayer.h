//
//  MainGameLayer.h
//  YourFirstCannonGame
//
//  Created by Vangelis Tsanos on 12/29/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "CannonBall.h"
#import "StaticBrick.h"
#import "MovingBrick.h"
#import "RoundGravityObject.h"
#import "RectGravityObject.h"
//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// MainGameLayer
@interface MainGameLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate, CannonBallDelegate>
{
	CCTexture2D *spriteTexture_;	// weak ref
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref
    
    
    CCSprite *sprBackground;
    CCSprite *sprCannon;
    CCSprite *sprCannonStrength;
    CGPoint fStartPoint,fEndPoint;
    float fAngleOfPoints;
    int counterOfSprites;
    NSMutableArray *cannonBalls;
    NSMutableArray *enemies;
    NSMutableArray *enemiesToBeDeleted;

    b2BodyDef groundBodyDef;
    CCAction *fullStrengthAction;
    BOOL activeActionForSprCannonStrength;
    
    CGSize windowSize;
    
}

// returns a CCScene that contains the MainGameLayer as the only child
+(CCScene *) scene;

@end
