//
//  WorldGenerator.h
//  HopHero2
//
//  Created by BC on 12/22/14.
//  Copyright (c) 2014 BenCodes. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface WorldGenerator : SKNode

+ (id)generatorWithWorld:(SKNode *)world;
- (void)populate;
- (void)generate;

@end
