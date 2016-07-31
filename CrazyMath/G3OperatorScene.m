//
//  G3OperatorScene.m
//  CrazyMath
//
//  Created by 周吴子煌 on 15/11/18.
//  Copyright © 2015年 Zhouwu Zihuang. All rights reserved.
//

#import "G3OperatorScene.h"
#import "LevelScene.h"
#import "G3PlusScene.h"
#import "G3SubtractScene.h"
#import "G3MultiplyScene.h"
#import "G3DivideScene.h"

@interface G3OperatorScene()
@property BOOL contentCreated;
@end

@implementation G3OperatorScene

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
    plus.position = CGPointMake(0.55 * CGRectGetMidX(self.frame), 1.35 * CGRectGetMidY(self.frame));
    plus.name = @"PLUS";
    
    SKSpriteNode * subtract = [SKSpriteNode spriteNodeWithImageNamed:@"Subtract"];
    subtract.position = CGPointMake(1.45 * CGRectGetMidX(self.frame), 1.35 * CGRectGetMidY(self.frame));
    subtract.name = @"SUBTRACT";
    
    
    SKSpriteNode * multiply = [SKSpriteNode spriteNodeWithImageNamed:@"Multiply"];
    multiply.position = CGPointMake(0.55 * CGRectGetMidX(self.frame), 0.95 * CGRectGetMidY(self.frame));
    multiply.name = @"MULTIPLY";
    
    SKSpriteNode * divide = [SKSpriteNode spriteNodeWithImageNamed:@"Divide"];
    divide.position = CGPointMake(1.45 * CGRectGetMidX(self.frame), 0.95 * CGRectGetMidY(self.frame));
    divide.name = @"DIVIDE";
    
    
    
    SKSpriteNode * back = [SKSpriteNode spriteNodeWithImageNamed:@"Back"];
    back.position = CGPointMake(CGRectGetMidX(self.frame), 0.35 * CGRectGetMidY(self.frame));
    back.name = @"BACK";
    
    
    
    [self addChild:Label];
    [self addChild:plus];
    [self addChild:subtract];
    [self addChild:multiply];
    [self addChild:divide];
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
        G3PlusScene * g3plusscene = [G3PlusScene sceneWithSize:self.view.bounds.size];
        g3plusscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:g3plusscene transition: reveal];
    }
    else if([node.name isEqualToString:@"SUBTRACT"])
    {
        SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
        G3SubtractScene * g3subtractscene = [G3SubtractScene sceneWithSize:self.view.bounds.size];
        g3subtractscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:g3subtractscene transition: reveal];
    }
    else if([node.name isEqualToString:@"MULTIPLY"])
    {
        SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
        G3MultiplyScene * g3multiplyscene = [G3MultiplyScene sceneWithSize:self.view.bounds.size];
        g3multiplyscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:g3multiplyscene transition: reveal];
    }
    else if([node.name isEqualToString:@"DIVIDE"])
    {
        SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
        G3DivideScene * g3dividescene = [G3DivideScene sceneWithSize:self.view.bounds.size];
        g3dividescene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:g3dividescene transition: reveal];
    }
    else if([node.name isEqualToString:@"BACK"]) {
        SKTransition *reveal = [SKTransition pushWithDirection:0.8  duration:0.8];
        LevelScene * levelscene = [LevelScene sceneWithSize:self.view.bounds.size];
        levelscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:levelscene transition: reveal];
    }
}
@end