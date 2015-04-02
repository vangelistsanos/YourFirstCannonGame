//
//  CannonBall_DTO.h
//  YourFirstCannonGame
//
//  Created by Vangelis Tsanos on 12/31/12.
//
//

#import <Foundation/Foundation.h>
#import "CannonBall.h"

@interface CannonBall_DTO : NSObject

@property (nonatomic,strong) CannonBall *cannonBallObject;
@property (nonatomic,assign) NSInteger *countDownValue;

@end
