//
//  IntroLayer.h
//  YourFirstCannonGame
//
//  Created by Vangelis Tsanos on 12/29/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"


@interface IntroLayer : CCLayer
{
}

// returns a CCScene that contains the MainGameLayer as the only child
+(CCScene *) scene;

@end
