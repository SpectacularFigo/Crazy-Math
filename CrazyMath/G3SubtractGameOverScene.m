//
//  G3SubtractGameOverScene.m
//  CrazyMath
//
//  Created by 周吴子煌 on 15/11/19.
//  Copyright © 2015年 Zhouwu Zihuang. All rights reserved.
//

#import "G3SubtractGameOverScene.h"
#import "G3OperatorScene.h"
#import "G3SubtractScene.h"
#import "G3SubtractFinishScene.h"


@interface G3SubtractGameOverScene()
@property BOOL contentCreated;
@end


@implementation G3SubtractGameOverScene


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
        G3OperatorScene * g3operatorscene = [G3OperatorScene sceneWithSize:self.view.bounds.size];
        g3operatorscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:g3operatorscene transition: reveal];
        
        
        extern int count6;
        count6 = 0;
        extern int SCORE6;
        SCORE6 = 0;
        extern int COUNT6;
        COUNT6 = 0;
    }
    
    else if([node.name isEqualToString:@"RETRY"]) {
        extern int count6;
        if (count6 == 10) {
            SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
            G3SubtractFinishScene * g3subtractfinishscene = [G3SubtractFinishScene sceneWithSize:self.view.bounds.size];
            g3subtractfinishscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g3subtractfinishscene transition: reveal];
        }
        else
        {
            SKTransition *reveal = [SKTransition doorsCloseHorizontalWithDuration:0.5];
            G3SubtractScene * g3subtractscene = [G3SubtractScene sceneWithSize:self.view.bounds.size];
            g3subtractscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g3subtractscene transition: reveal];
        }
    }
    
}

@end
