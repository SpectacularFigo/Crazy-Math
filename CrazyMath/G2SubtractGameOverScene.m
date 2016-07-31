//
//  G2SubtractGameOverScene.m
//  CrazyMath
//
//  Created by 周吴子煌 on 15/11/19.
//  Copyright © 2015年 Zhouwu Zihuang. All rights reserved.
//

#import "G2SubtractGameOverScene.h"
#import "G2OperatorScene.h"
#import "G2SubtractScene.h"
#import "G2SubtractFinishScene.h"


@interface G2SubtractGameOverScene()
@property BOOL contentCreated;
@end


@implementation G2SubtractGameOverScene


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
        G2OperatorScene * g2operatorscene = [G2OperatorScene sceneWithSize:self.view.bounds.size];
        g2operatorscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:g2operatorscene transition: reveal];
        
        
        extern int count4;
        count4 = 0;
        extern int SCORE4;
        SCORE4 = 0;
        extern int COUNT4;
        COUNT4 = 0;
    }
    
    else if([node.name isEqualToString:@"RETRY"]) {
        extern int count4;
        if (count4 == 10) {
            SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
            G2SubtractFinishScene * g2subtractfinishscene = [G2SubtractFinishScene sceneWithSize:self.view.bounds.size];
            g2subtractfinishscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g2subtractfinishscene transition: reveal];
        }
        else
        {
            SKTransition *reveal = [SKTransition doorsCloseHorizontalWithDuration:0.5];
            G2SubtractScene * g2subtractscene = [G2SubtractScene sceneWithSize:self.view.bounds.size];
            g2subtractscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g2subtractscene transition: reveal];
        }
    }
    
}

@end
