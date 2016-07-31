//
//  Hero.m
//  HopHero2
//
//  Created by BC on 12/22/14.
//  Copyright (c) 2014 BenCodes. All rights reserved.
//

#import "Hero.h"

@interface Hero ()

@property BOOL isJumping;

@end

@implementation Hero

static const uint32_t heroCategory = 0x1 << 0;
static const uint32_t obstacleCategory = 0x1 << 1;
static const uint32_t groundCategory = 0x1 << 2;


+ (id)hero
{
    Hero *hero = [Hero spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(40, 40)];
    
    SKSpriteNode *lefteye = [SKSpriteNode spriteNodeWithColor:
                             [UIColor whiteColor] size:CGSizeMake(5, 5)];
    lefteye.position = CGPointMake(-6, 8);
    [hero addChild:lefteye];
    
    SKSpriteNode *righteye = [SKSpriteNode spriteNodeWithColor:
                             [UIColor whiteColor] size:CGSizeMake(5, 5)];
    righteye.position = CGPointMake(11, 8);
    [hero addChild:righteye];
    
    
    hero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hero.size];
    hero.physicsBody.categoryBitMask = heroCategory;
    hero.physicsBody.contactTestBitMask = obstacleCategory | groundCategory;
    hero.name = @"hero";
    return hero;
}

- (void)jump
{
    if (!self.isJumping) {
        [self.physicsBody applyImpulse:CGVectorMake(0, 40)];
        [self runAction:[SKAction playSoundFileNamed:@"onJump.wav" waitForCompletion:NO]];
        self.isJumping = YES;
    }

}

- (void)land
{
    self.isJumping = NO;
}

- (void)start
{
    SKAction *incrementRight = [SKAction moveByX:1 y:0 duration:0.004];
    SKAction *moveRight = [SKAction repeatActionForever:incrementRight];
    [self runAction:moveRight];
}

- (void)stop
{
    [self removeAllActions];
}

//- (void)walkRight
//{
//    SKAction *incrementRight = [SKAction moveByX:10 y:0 duration:0];
//    [self runAction:incrementRight];
//}
@end
