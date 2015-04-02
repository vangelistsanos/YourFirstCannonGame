//
//  CannonBallStack.h
//  YourFirstCannonGame
//
//  Created by Vangelis Tsanos on 12/31/12.
//
//

#import <Foundation/Foundation.h>
#import "CannonBall_DTO.h"

@interface CannonBallStack : NSObject {
    NSMutableArray *objectsOnStack;
    NSMutableArray *objectsToRemove;
    NSTimer *tmr;
}


-(id) init;
-(void) addCannonBallToStack : (CannonBall_DTO *) cbdto;
-(void) clearCannonBallStack;
-(NSMutableArray *) getAllObjectsThatMustBeRemoved;

@end
