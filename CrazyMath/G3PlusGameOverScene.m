//
//  G3PlusGameOverScene.m
//  CrazyMath
//
//  Created by 周吴子煌 on 15/11/19.
//  Copyright © 2015年 Zhouwu Zihuang. All rights reserved.
//

#import "G3PlusGameOverScene.h"
#import "G3OperatorScene.h"
#import "G3PlusScene.h"
#import "G3PlusFinishScene.h"


@interface G3PlusGameOverScene()
@property BOOL contentCreated;
@end


@implementation G3PlusGameOverScene


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
        
        
        extern int count5;
        count5 = 0;
        extern int SCORE5;
        SCORE5 = 0;
        extern int COUNT5;
        COUNT5 = 0;
    }
    
    else if([node.name isEqualToString:@"RETRY"]) {
        extern int count5;
        if (count5 == 10) {
            SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
            G3PlusFinishScene * g3plusfinishscene = [G3PlusFinishScene sceneWithSize:self.view.bounds.size];
            g3plusfinishscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g3plusfinishscene transition: reveal];
        }
        else
        {
            SKTransition *reveal = [SKTransition doorsCloseHorizontalWithDuration:0.5];
            G3PlusScene * g3plusscene = [G3PlusScene sceneWithSize:self.view.bounds.size];
            g3plusscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g3plusscene transition: reveal];
        }
    }
    
}

@end

