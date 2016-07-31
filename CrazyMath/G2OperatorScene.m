//
//  G2OperatorScene.m
//  CrazyMath
//
//  Created by 周吴子煌 on 15/11/16.
//  Copyright © 2015年 Zhouwu Zihuang. All rights reserved.
//

#import "G2OperatorScene.h"
#import "LevelScene.h"
#import "G2PlusScene.h"
#import "G2SubtractScene.h"

@interface G2OperatorScene()
@property BOOL contentCreated;
@end

@implementation G2OperatorScene

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
    
    SKLabelNode * Label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    Label.text = @"Please select an operator ~";
    Label.fontSize = 15;
    Label.fontColor = [SKColor whiteColor];
    Label.position = CGPointMake(CGRectGetMidX(self.frame),1.75 * CGRectGetMidY(self.frame));
    
    SKSpriteNode * plus = [SKSpriteNode spriteNodeWithImageNamed:@"Plus"];
    plus.position = CGPointMake(0.55 * CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    plus.name = @"PLUS";
    
    SKSpriteNode * subtract = [SKSpriteNode spriteNodeWithImageNamed:@"Subtract"];
    subtract.position = CGPointMake(1.45 * CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    subtract.name = @"SUBTRACT";
    
    SKSpriteNode * back = [SKSpriteNode spriteNodeWithImageNamed:@"Back"];
    back.position = CGPointMake(CGRectGetMidX(self.frame), 0.35 * CGRectGetMidY(self.frame));
    back.name = @"BACK";
    
    
    
    [self addChild:Label];
    [self addChild:plus];
    [self addChild:subtract];
    [self addChild:back];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if ([node.name isEqualToString:@"PLUS"])
    {
        SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
        G2PlusScene * g2plusscene = [G2PlusScene sceneWithSize:self.view.bounds.size];
        g2plusscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:g2plusscene transition: reveal];
    }
    
    else if([node.name isEqualToString:@"SUBTRACT"])
    {
        SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
        G2SubtractScene * g2subtractscene = [G2SubtractScene sceneWithSize:self.view.bounds.size];
        g2subtractscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:g2subtractscene transition: reveal];
    }
    else if([node.name isEqualToString:@"BACK"]) {
        SKTransition *reveal = [SKTransition pushWithDirection:0.8  duration:0.8];
        LevelScene * levelscene = [LevelScene sceneWithSize:self.view.bounds.size];
        levelscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:levelscene transition: reveal];
    }
}
@end