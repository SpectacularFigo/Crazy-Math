//
//  G1SubtractGameOverScene.m
//  CrazyMath
//
//  Created by 周吴子煌 on 15/11/19.
//  Copyright © 2015年 Zhouwu Zihuang. All rights reserved.
//

#import "G1SubtractGameOverScene.h"
#import "G1OperatorScene.h"
#import "G1SubtractScene.h"
#import "G1SubtractFinishScene.h"


@interface G1SubtractGameOverScene()
@property BOOL contentCreated;
@end


@implementation G1SubtractGameOverScene


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
    self.backgroundColor = [SKColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0];
    self.scaleMode = SKSceneScaleModeAspectFill;
    
    SKLabelNode * label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    label.text = @"Wrong answer ~";
    label.fontSize = 35;
    label.fontColor = [SKColor whiteColor];
    label.position = CGPointMake(CGRectGetMidX(self.frame), 1.3 * CGRectGetMidY(self.frame));
    
    SKSpriteNode * retry = [SKSpriteNode spriteNodeWithImageNamed:@"Retry"];
    retry.position = CGPointMake(0.5 *CGRectGetMidX(self.frame), 0.35 * CGRectGetMidY(self.frame));
    retry.name = @"RETRY";
    
    SKSpriteNode * back = [SKSpriteNode spriteNodeWithImageNamed:@"Back"];
    back.position = CGPointMake(1.5 * CGRectGetMidX(self.frame), 0.35 * CGRectGetMidY(self.frame));
    back.name = @"BACK";
    
    [self addChild:label];
    [self addChild:retry];
    [self addChild:back];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"BACK"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.8];
        G1OperatorScene * g1operatorscene = [G1OperatorScene sceneWithSize:self.view.bounds.size];
        g1operatorscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:g1operatorscene transition: reveal];
        
        
        extern int count2;
        count2 = 0;
        extern int SCORE2;
        SCORE2 = 0;
        extern int COUNT2;
        COUNT2 = 0;
    }
    
    else if([node.name isEqualToString:@"RETRY"]) {
        extern int count2;
        if (count2 == 10) {
            SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
            G1SubtractFinishScene * g1subtractfinishscene = [G1SubtractFinishScene sceneWithSize:self.view.bounds.size];
            g1subtractfinishscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g1subtractfinishscene transition: reveal];
        }
        else
        {
            SKTransition *reveal = [SKTransition doorsCloseHorizontalWithDuration:0.5];
            G1SubtractScene * g1subtractscene = [G1SubtractScene sceneWithSize:self.view.bounds.size];
            g1subtractscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g1subtractscene transition: reveal];
        }
    }
    
}

@end

