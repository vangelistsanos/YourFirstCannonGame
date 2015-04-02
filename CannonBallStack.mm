//
//  CannonBallStack.m
//  YourFirstCannonGame
//
//  Created by Vangelis Tsanos on 12/31/12.
//
//

#import "CannonBallStack.h"

@implementation CannonBallStack



-(id) init
{
    self = [super init];
    if (self) {
        objectsOnStack = [[NSMutableArray alloc] init];
        objectsToRemove = [[NSMutableArray alloc] init];
        tmr = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(tmrUpdate) userInfo:nil repeats:YES];
    }
    return self;
}

-(void) addCannonBallToStack : (CannonBall_DTO *) cbdto
{
    [objectsOnStack addObject:cbdto];
}




-(void) clearCannonBallStack
{
    [objectsOnStack removeAllObjects];
    [objectsToRemove removeAllObjects];
 }




-(void) removeZeroCountDownCannonBallsFromStack
{
    
    
    for (CannonBall_DTO *cdto in objectsOnStack) {
        if (cdto.countDownValue==0) {
            [objectsToRemove addObject:cdto];
        }
    }
    
    
    [objectsOnStack removeObjectsInArray:objectsToRemove];
    
}




-(NSMutableArray *) getAllObjectsThatMustBeRemoved
{
    return objectsToRemove;
}





-(void) tmrUpdate
{
    for (CannonBall_DTO *cdto in objectsOnStack) {
        if (cdto.countDownValue!=0) cdto.countDownValue--;
    }
}




-(void) dealloc
{
    
    [self clearCannonBallStack];
    [tmr invalidate];
    tmr = nil;
    [super dealloc];
    
}

@end
