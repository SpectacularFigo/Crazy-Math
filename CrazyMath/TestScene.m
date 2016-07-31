//
//  TestScene.m
//  CrazyMath
//
//  Created by 周吴子煌 on 15/11/14.
//  Copyright © 2015年 Zhouwu Zihuang. All rights reserved.
//

#import "TestScene.h"
#import "MenuScene.h"


@interface TestScene()
@property BOOL contentCreated;
@end

@implementation TestScene

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
    self.backgroundColor = [SKColor blueColor];
    self.scaleMode = SKSceneScaleModeAspectFill;
    
    
    SKSpriteNode * back = [SKSpriteNode spriteNodeWithImageNamed:@"Back"];
    back.position = CGPointMake(CGRectGetMidX(self.frame), 0.35 * CGRectGetMidY(self.frame));
    back.name = @"BACK";
    
    SKLabelNode * label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    label.text = @"Coming soon...";
    label.fontSize = 20;
    label.fontColor = [SKColor whiteColor];
    label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));

    [self addChild:back];
    [self addChild:label];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"BACK"]) {
        SKTransition *reveal = [SKTransition fadeWithDuration:0.7];
        MenuScene * menuscene = [MenuScene sceneWithSize:self.view.bounds.size];
        menuscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:menuscene transition: reveal];
    }
}

@end
