//
//  SettingScene.m
//  CrazyMath
//
//  Created by 周吴子煌 on 15/11/14.
//  Copyright © 2015年 Zhouwu Zihuang. All rights reserved.
//

#import "IntroductionScene.h"
#import "MenuScene.h"
#import "LevelScene.h"

@interface IntroductionScene()
@property BOOL contentCreated;
@end

@implementation IntroductionScene

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
    self.backgroundColor = [SKColor colorWithRed:1 green:0.4 blue:0 alpha:1.0];
    self.scaleMode = SKSceneScaleModeAspectFill;
    
    SKLabelNode * Label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    Label.text = @"How to play";
    Label.fontSize = 30;
    Label.fontColor = [SKColor whiteColor];
    Label.position = CGPointMake(CGRectGetMidX(self.frame),1.75 * CGRectGetMidY(self.frame));
    
    
    SKSpriteNode * demo = [SKSpriteNode spriteNodeWithImageNamed:@"Demo"];
    demo.position = CGPointMake(CGRectGetMidX(self.frame), 1.1 * CGRectGetMidY(self.frame));
    demo.name = @"DEMO";
    
    SKSpriteNode * back = [SKSpriteNode spriteNodeWithImageNamed:@"Back"];
    back.position = CGPointMake(CGRectGetMidX(self.frame), 0.35 * CGRectGetMidY(self.frame));
    back.name = @"BACK";

    [self addChild:Label];
    [self addChild:demo];
    [self addChild:back];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if([node.name isEqualToString:@"BACK"]) {
        SKTransition *reveal = [SKTransition fadeWithDuration:0.7];
        MenuScene * menuscene = [MenuScene sceneWithSize:self.view.bounds.size];
        menuscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:menuscene transition: reveal];
    }
}
@end