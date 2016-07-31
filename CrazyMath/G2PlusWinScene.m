//
//  G2PlusWinScene.m
//  CrazyMath
//
//  Created by 周吴子煌 on 15/11/16.
//  Copyright © 2015年 Zhouwu Zihuang. All rights reserved.
//

#import "G2PlusWinScene.h"
#import "LevelScene.h"
#import "G2PlusFinishScene.h"
#import "G2PlusScene.h"


@interface G2PlusWinScene()
@property BOOL contentCreated;
@end


@implementation G2PlusWinScene


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
    self.backgroundColor = [SKColor colorWithRed:0.2 green:0.4 blue:0.6 alpha:1.0];
    self.scaleMode = SKSceneScaleModeAspectFill;
    
    SKLabelNode * label1 = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
    label1.text = @"+10";
    label1.fontSize = 40;
    label1.fontColor = [SKColor yellowColor];
    label1.position = CGPointMake(CGRectGetMidX(self.frame),1.8 * CGRectGetMidY(self.frame));
    
    SKLabelNode * label2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    label2.text = @"Good job!";
    label2.fontSize = 35;
    label2.fontColor = [SKColor redColor];
    label2.position = CGPointMake(CGRectGetMidX(self.frame),1.3 * CGRectGetMidY(self.frame));
    
    SKSpriteNode * gift = [SKSpriteNode spriteNodeWithImageNamed:@"Gift"];
    gift.position = CGPointMake(CGRectGetMidX(self.frame), 0.7 * CGRectGetMidY(self.frame));
    
    
    SKSpriteNode * next = [SKSpriteNode spriteNodeWithImageNamed:@"Next"];
    next.position = CGPointMake(0.5 *CGRectGetMidX(self.frame), 0.35 * CGRectGetMidY(self.frame));
    next.name = @"NEXT";
    
    SKSpriteNode * back = [SKSpriteNode spriteNodeWithImageNamed:@"Back"];
    back.position = CGPointMake(1.5 * CGRectGetMidX(self.frame), 0.35 * CGRectGetMidY(self.frame));
    back.name = @"BACK";
    
    [self addChild:label2];
    [self addChild:label1];
    [self addChild:gift];
    [self addChild:next];
    [self addChild:back];
    [self addEquation];
}



- (void)addEquation
{
    extern int a3;
    extern int b3;
    extern int c3;
    
    SKLabelNode * label1 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    SKLabelNode * label2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    SKLabelNode * label3 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    SKLabelNode * label4 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    SKLabelNode * label5 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    
    NSString * stringInt1 = [NSString stringWithFormat:@"%d",a3];
    NSString * stringInt2 = [NSString stringWithFormat:@"%d",b3];
    NSString * stringInt3 = [NSString stringWithFormat:@"%d",c3];
    
    label1.text = stringInt1;
    label1.fontSize = 35;
    label1.fontColor = [SKColor whiteColor];
    label1.position = CGPointMake(0.6 *CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    
    label2.text = @"+";
    label2.fontSize = 35;
    label2.fontColor = [SKColor whiteColor];
    label2.position = CGPointMake(0.8 *CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    
    
    label3.text = stringInt2;
    label3.fontSize = 35;
    label3.fontColor = [SKColor whiteColor];
    label3.position = CGPointMake(1.0 *CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    
    label4.text = @"=";
    label4.fontSize = 35;
    label4.fontColor = [SKColor whiteColor];
    label4.position = CGPointMake(1.2 *CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    
    label5.text = stringInt3;
    label5.fontSize = 35;
    label5.fontColor = [SKColor whiteColor];
    label5.position = CGPointMake(1.4 *CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    
    [self addChild:label1];
    [self addChild:label2];
    [self addChild:label3];
    [self addChild:label4];
    [self addChild:label5];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"BACK"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.8];
        LevelScene * levelscene = [LevelScene sceneWithSize:self.view.bounds.size];
        levelscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:levelscene transition: reveal];
        
        extern int count3;
        count3 = 0;
        extern int SCORE3;
        SCORE3 = 0;
        extern int COUNT3;
        COUNT3 = 0;
    }
    
    else if([node.name isEqualToString:@"NEXT"]) {
        extern int count3;
        if (count3 == 10) {
            SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
            G2PlusFinishScene * g2plusfinishscene = [G2PlusFinishScene sceneWithSize:self.view.bounds.size];
            g2plusfinishscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g2plusfinishscene transition: reveal];
        }
        else
        {
            SKTransition *reveal = [SKTransition doorsCloseHorizontalWithDuration:0.5];
            G2PlusScene * g2plusscene = [G2PlusScene sceneWithSize:self.view.bounds.size];
            g2plusscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g2plusscene transition: reveal];
        }
    }
    
    
}

@end
