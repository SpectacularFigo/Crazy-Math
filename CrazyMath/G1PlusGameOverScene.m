//
//  G1PlusOverScene.m
//  CrazyMath
//
//  Created by 周吴子煌 on 15/11/18.
//  Copyright © 2015年 Zhouwu Zihuang. All rights reserved.
//

#import "G1PlusGameOverScene.h"
#import "G1OperatorScene.h"
#import "G1PlusScene.h"
#import "G1PlusFinishScene.h"


@interface G1PlusGameOverScene()
@property BOOL contentCreated;
@end


@implementation G1PlusGameOverScene


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
        
        
        extern int count1;
        count1 = 0;
        extern int SCORE1;
        SCORE1 = 0;
        extern int COUNT1;
        COUNT1 = 0;
    }
    
    else if([node.name isEqualToString:@"RETRY"]) {
        extern int count1;
        if (count1 == 10) {
            SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
            G1PlusFinishScene * g1plusfinishscene = [G1PlusFinishScene sceneWithSize:self.view.bounds.size];
            g1plusfinishscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g1plusfinishscene transition: reveal];
        }
        else
        {
            SKTransition *reveal = [SKTransition doorsCloseHorizontalWithDuration:0.5];
            G1PlusScene * g1plusscene = [G1PlusScene sceneWithSize:self.view.bounds.size];
            g1plusscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g1plusscene transition: reveal];
        }
    }

}

@end
