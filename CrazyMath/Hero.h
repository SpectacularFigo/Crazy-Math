//
//  Hero.h
//  HopHero2
//
//  Created by BC on 12/22/14.
//  Copyright (c) 2014 BenCodes. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Hero : SKSpriteNode

+ (id)hero;
- (void)jump;
- (void)land;
- (void)start;
- (void)stop;
//- (void)walkRight;

@end
