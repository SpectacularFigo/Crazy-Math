//
//  WorldGenerator.m
//  HopHero2
//
//  Created by BC on 12/22/14.
//  Copyright (c) 2014 BenCodes. All rights reserved.
//

#import "WorldGenerator.h"

@interface WorldGenerator ()
@property double currentGroundX;
@property double currentObstacleX;
@property SKNode *world;
@end

@implementation WorldGenerator

static const uint32_t obstacleCategory = 0x1 << 1;
static const uint32_t groundCategory = 0x1 << 2;


// Factory method
+ (id)generatorWithWorld:(SKNode *)world
{
    WorldGenerator *generator = [WorldGenerator node];
    generator.currentGroundX = -400;
    generator.currentObstacleX = 250;
    generator.world = world;

    return generator;
}

- (void)populate
{
    for (int i = 0; i < 3; i++) {
        [self generate];
    }
}

- (void)generate
{
    SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
    ground.position = CGPointMake(self.currentGroundX, -self.scene.frame.size.height/2 + ground.frame.size.height/2);
    ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
    ground.physicsBody.categoryBitMask = groundCategory;
    ground.physicsBody.dynamic = NO;
    ground.name = @"ground";
    [self.world addChild:ground];
    
    self.currentGroundX += ground.frame.size.width;
    
    SKSpriteNode *obstacle = [SKSpriteNode spriteNodeWithColor:[self getRandomColor] size:CGSizeMake(40, 50)];
    obstacle.position = CGPointMake(self.currentObstacleX, ground.position.y + ground.frame.size.height/2 + obstacle.frame.size.height/2);
    obstacle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:obstacle.size];
    obstacle.physicsBody.dynamic = NO;
    obstacle.name = @"obstacle";
    obstacle.physicsBody.categoryBitMask = obstacleCategory;
    [self.world addChild:obstacle];
    
    self.currentObstacleX += 300;
}

- (UIColor *)getRandomColor
{
    UIColor *color;
    int rand = arc4random() % 6;
    switch (rand) {
        case 0:
            color = [UIColor redColor];
            break;
        case 1:
            color = [UIColor orangeColor];
            break;
        case 2:
            color = [UIColor blueColor];
            break;
        case 3:
            color = [UIColor purpleColor];
            break;
        case 4:
            color = [UIColor yellowColor];
            break;
        case 5:
            color = [UIColor brownColor];
            break;
        default:
            break;
    }
    return color;
}

@end
