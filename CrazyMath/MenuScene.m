//
//  GameScene.m
//  CrazyMath
//
//  Created by 周吴子煌 on 15/11/14.
//  Copyright (c) 2015年 Zhouwu Zihuang. All rights reserved.
//

#import "MenuScene.h"
#import "LevelScene.h"
#import "TestScene.h"
#import "IntroductionScene.h"


@interface MenuScene()
@property BOOL contentCreated;
@end
@implementation MenuScene


-(void)didMoveToView:(SKView *)view
{
    if(!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}


- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFill;
    
    SKSpriteNode * logo = [SKSpriteNode spriteNodeWithImageNamed:@"Logo"];
    logo.position = CGPointMake(CGRectGetMidX(self.frame), 1.7 * CGRectGetMidY(self.frame));
    logo.name = @"LOGO";
    
    SKSpriteNode * tree = [SKSpriteNode spriteNodeWithImageNamed:@"ChristmasTree"];
    tree.position = CGPointMake(CGRectGetMidX(self.frame),1.2 * CGRectGetMidY(self.frame));
    tree.name = @"CHRISTMASTREE";
    
    
    
    SKLabelNode * start = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    start.text = @"Let's play";
    start.name = @"START";
    start.fontSize = 20;
    start.fontColor = [SKColor redColor];
    start.position = CGPointMake(CGRectGetMidX(self.frame),0.75 * CGRectGetMidY(self.frame));
    
    SKLabelNode * test = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    test.text = @"Test";
    test.name = @"TEST";
    test.fontSize = 20;
    test.fontColor = [SKColor greenColor];
    test.position = CGPointMake(CGRectGetMidX(self.frame),0.6 * CGRectGetMidY(self.frame));
    
    SKLabelNode * intro = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    intro.text = @"How to play";
    intro.name = @"INTRO";
    intro.fontSize = 20;
    intro.fontColor = [SKColor yellowColor];
    intro.position = CGPointMake(CGRectGetMidX(self.frame),0.45 * CGRectGetMidY(self.frame));
    
    SKLabelNode * label1 = [SKLabelNode labelNodeWithFontNamed:@""];
    label1.text = @"Copyright © 2015 Team 15. All rights reserved";
    label1.fontSize = 10;
    label1.fontColor = [SKColor whiteColor];
    label1.position = CGPointMake(CGRectGetMidX(self.frame), 0.1 * CGRectGetMidY(self.frame));
    
    SKLabelNode * label2 = [SKLabelNode labelNodeWithFontNamed:@""];
    label2.text = @"Design for Ann";
    label2.fontSize = 10;
    label2.fontColor = [SKColor whiteColor];
    label2.position = CGPointMake(CGRectGetMidX(self.frame),0.05 * CGRectGetMidY(self.frame));

    
    [self addChild:logo];
    [self addChild:tree];
    [self addChild:start];
    [self addChild:test];
    [self addChild:intro];
    [self addChild:label1];
    [self addChild:label2];

    
}


//Touch void.
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    
    if ([node.name isEqualToString:@"START"])
    {
        SKTransition *reveal = [SKTransition doorwayWithDuration:0.7];
        
        LevelScene * levelscene = [LevelScene sceneWithSize:self.view.bounds.size];
        levelscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:levelscene transition: reveal];
    }
    
    else if ([node.name isEqualToString:@"TEST"]) {
        SKTransition *reveal = [SKTransition doorwayWithDuration:0.7];
        
        TestScene * testscene = [TestScene sceneWithSize:self.view.bounds.size];
        testscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:testscene transition: reveal];
    }
    
    else if ([node.name isEqualToString:@"INTRO"]) {
        SKTransition *reveal = [SKTransition doorwayWithDuration:0.7];
        IntroductionScene * introductionscene = [IntroductionScene sceneWithSize:self.view.bounds.size];
        introductionscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:introductionscene transition: reveal];
    }
}


-(void)update:(CFTimeInterval)currentTime
{
}

@end
