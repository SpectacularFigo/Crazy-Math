//
//  LevelScene.m
//  CrazyMath
//
//  Created by 周吴子煌 on 15/11/14.
//  Copyright © 2015年 Zhouwu Zihuang. All rights reserved.
//

#import "LevelScene.h"
#import "MenuScene.h"
#import "G1OperatorScene.h"
#import "G2OperatorScene.h"
#import "G3OperatorScene.h"

@interface LevelScene()
@property BOOL contentCreated;
@end

@implementation LevelScene

- (void) didMoveToView:(SKView *)view
{
    if(!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor colorWithRed:0.7 green:0.4 blue:1.0 alpha:1.0];
    self.scaleMode = SKSceneScaleModeAspectFill;
    
    
    
    //Create functional buttons
    SKSpriteNode * grade1 = [SKSpriteNode spriteNodeWithImageNamed:@"Grade1"];
    grade1.position = CGPointMake(1.25 * CGRectGetMidX(self.frame), 1.6 * CGRectGetMidY(self.frame));
    grade1.name = @"GRADE1";
    
    SKSpriteNode * grade2 = [SKSpriteNode spriteNodeWithImageNamed:@"Grade2"];
    grade2.position = CGPointMake(0.65 * CGRectGetMidX(self.frame), 1.2 * CGRectGetMidY(self.frame));
    grade2.name = @"GRADE2";
    
    SKSpriteNode * grade3 = [SKSpriteNode spriteNodeWithImageNamed:@"Grade3"];
    grade3.position = CGPointMake(CGRectGetMidX(self.frame), 0.8 * CGRectGetMidY(self.frame));
    grade3.name = @"GRADE3";
    
    SKSpriteNode * back = [SKSpriteNode spriteNodeWithImageNamed:@"Back"];
    back.position = CGPointMake(CGRectGetMidX(self.frame), 0.35 * CGRectGetMidY(self.frame));
    back.name = @"BACK";
    
    
    //Create a decoration
    SKSpriteNode * snowman = [SKSpriteNode spriteNodeWithImageNamed:@"Snowman"];
    snowman.position = CGPointMake(1.8 * CGRectGetMidX(self.frame), 0.18 * CGRectGetMidY(self.frame));
    
    SKSpriteNode * bell = [SKSpriteNode spriteNodeWithImageNamed:@"Bell"];
    bell.position = CGPointMake(0.18 * CGRectGetMidX(self.frame), 1.8 * CGRectGetMidY(self.frame));
    
    [self addChild:grade1];
    [self addChild:grade2];
    [self addChild:grade3];

    [self addChild:snowman];
    [self addChild:bell];
    [self addChild:back];
    
}


//Touch voids
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if([node.name isEqualToString:@"GRADE1"]) {
        SKTransition *reveal = [SKTransition pushWithDirection:0.8  duration:0.8];
        G1OperatorScene * g1operatorscene = [G1OperatorScene sceneWithSize:self.view.bounds.size];
        g1operatorscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:g1operatorscene transition: reveal];
    }
    
    else if ([node.name isEqualToString:@"GRADE2"]) {
        SKTransition *reveal = [SKTransition pushWithDirection:0.8  duration:0.8];
        G2OperatorScene * g2operatorscene = [G2OperatorScene sceneWithSize:self.view.bounds.size];
        g2operatorscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:g2operatorscene transition: reveal];
    }
    
    else if ([node.name isEqualToString:@"GRADE3"]) {
        SKTransition *reveal = [SKTransition pushWithDirection:0.8  duration:0.8];
        G3OperatorScene * g3operatorscene = [G3OperatorScene sceneWithSize:self.view.bounds.size];
        g3operatorscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:g3operatorscene transition: reveal];
    }
    else if([node.name isEqualToString:@"BACK"]) {
        SKTransition *reveal = [SKTransition fadeWithDuration:0.7];
        MenuScene * menuscene = [MenuScene sceneWithSize:self.view.bounds.size];
        menuscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:menuscene transition: reveal];
    }
    
}



@end

