//
//  G3DivideGameOverScene.m
//  CrazyMath
//
//  Created by 周吴子煌 on 15/11/19.
//  Copyright © 2015年 Zhouwu Zihuang. All rights reserved.
//

#import "G3DivideGameOverScene.h"
#import "G3OperatorScene.h"
#import "G3DivideScene.h"
#import "G3DivideFinishScene.h"


@interface G3DivideGameOverScene()
@property BOOL contentCreated;
@end


@implementation G3DivideGameOverScene


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
        
        
        extern int count8;
        count8 = 0;
        extern int SCORE8;
        SCORE8 = 0;
        extern int COUNT8;
        COUNT8 = 0;
    }
    
    else if([node.name isEqualToString:@"RETRY"]) {
        extern int count8;
        if (count8 == 10) {
            SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
            G3DivideFinishScene * g3dividefinishscene = [G3DivideFinishScene sceneWithSize:self.view.bounds.size];
            g3dividefinishscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g3dividefinishscene transition: reveal];
        }
        else
        {
            SKTransition *reveal = [SKTransition doorsCloseHorizontalWithDuration:0.5];
            G3DivideScene * g3dividescene = [G3DivideScene sceneWithSize:self.view.bounds.size];
            g3dividescene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g3dividescene transition: reveal];
        }
    }
    
}

@end
