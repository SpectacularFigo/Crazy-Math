//
//  G1PlusFinishScene.m
//  CrazyMath
//
//  Created by 周吴子煌 on 15/11/14.
//  Copyright © 2015年 Zhouwu Zihuang. All rights reserved.
//

int bonus = 0;


#import "G1PlusFinishScene.h"
#import "G1OperatorScene.h"
#import "GameScene.h"

@interface G1PlusFinishScene()
@property BOOL contentCreated;
@end




@implementation G1PlusFinishScene


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
    self.backgroundColor = [SKColor colorWithRed:0.6 green:0.4 blue:0.2 alpha:1.0];
    self.scaleMode = SKSceneScaleModeAspectFill;
    
    extern int SCORE1;
    
    if (SCORE1 == 100) {
        bonus += 1;
    }
    
    SKLabelNode * label1 = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
    NSString * stringInt = [NSString stringWithFormat:@"%d",SCORE1];
    
    label1.text = stringInt;
    label1.fontSize = 40;
    label1.fontColor = [SKColor yellowColor];
    label1.position = CGPointMake(1.3 * CGRectGetMidX(self.frame),1.45 * CGRectGetMidY(self.frame));
    
    SKLabelNode * label2 = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
    label2.text = @"SCORE:";
    label2.fontSize = 25;
    label2.fontColor = [SKColor yellowColor];
    label2.position = CGPointMake(0.6 * CGRectGetMidX(self.frame),1.45 * CGRectGetMidY(self.frame));
    
    
    SKLabelNode * label3 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    label3.text = @"Completed!";
    label3.fontSize = 35;
    label3.fontColor = [SKColor blueColor];
    label3.position = CGPointMake(CGRectGetMidX(self.frame),1.7 * CGRectGetMidY(self.frame));
    
    SKSpriteNode * deer = [SKSpriteNode spriteNodeWithImageNamed:@"Deer"];
    deer.position = CGPointMake(CGRectGetMidX(self.frame), 0.9 * CGRectGetMidY(self.frame));
    deer.name = @"DEER";
    
    SKSpriteNode * back = [SKSpriteNode spriteNodeWithImageNamed:@"Back"];
    back.position = CGPointMake(CGRectGetMidX(self.frame), 0.35 * CGRectGetMidY(self.frame));
    back.name = @"BACK";

    [self addChild:deer];
    [self addChild:back];
    [self addChild:label1];
    [self addChild:label2];
    [self addChild:label3];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    extern int SCORE1;
    SCORE1 = 0;
    extern int count1;
    count1 = 0;
    extern int COUNT1;
    COUNT1 = 0;
    
    if ([node.name isEqualToString:@"BACK"])
    {
        extern int bonus;
        if (bonus == 1)
        {
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.8];
            GameScene * cookiegamescene = [GameScene sceneWithSize:self.view.bounds.size];
            cookiegamescene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:cookiegamescene transition: reveal];
        }
        else
        {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.8];
        G1OperatorScene * g1operatorscene = [G1OperatorScene sceneWithSize:self.view.bounds.size];
        g1operatorscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:g1operatorscene transition: reveal];
        }
    }
}

@end