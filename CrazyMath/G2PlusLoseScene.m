//
//  G2PlusLoseScene.m
//  CrazyMath
//
//  Created by 周吴子煌 on 15/11/16.
//  Copyright © 2015年 Zhouwu Zihuang. All rights reserved.
//

#import "G2PlusLoseScene.h"
#import "G2PlusScene.h"
#import "LevelScene.h"

@interface G2PlusLoseScene()
@property BOOL contentCreated;

@end

@implementation G2PlusLoseScene

-(id)initWithSize:(CGSize)size won:(BOOL)won {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        NSString * message;
        if (won)
        {
            message = @"You Won";
        } else {
            message = @"You Lose";
        }
        
    }
    return self;
}


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
    label1.text = @"+0";
    label1.fontSize = 40;
    label1.fontColor = [SKColor yellowColor];
    label1.position = CGPointMake(CGRectGetMidX(self.frame),1.8 * CGRectGetMidY(self.frame));
    
    SKLabelNode * label2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    label2.text = @"You missed it~";
    label2.fontSize = 35;
    label2.fontColor = [SKColor purpleColor];
    label2.position = CGPointMake(CGRectGetMidX(self.frame),1.3 * CGRectGetMidY(self.frame));
    
    SKSpriteNode * dessert = [SKSpriteNode spriteNodeWithImageNamed:@"Dessert"];
    dessert.position = CGPointMake(CGRectGetMidX(self.frame), 0.9 * CGRectGetMidY(self.frame));
    
    SKSpriteNode * retry = [SKSpriteNode spriteNodeWithImageNamed:@"Retry"];
    retry.position = CGPointMake(0.5 * CGRectGetMidX(self.frame),0.35 * CGRectGetMidY(self.frame));
    retry.name = @"RETRY";
    
    SKSpriteNode * back = [SKSpriteNode spriteNodeWithImageNamed:@"Back"];
    back.position = CGPointMake(1.5 * CGRectGetMidX(self.frame),0.35 * CGRectGetMidY(self.frame));
    back.name = @"BACK";
    
    [self addChild:label1];
    [self addChild:label2];
    [self addChild:dessert];
    [self addChild:retry];
    [self addChild:back];
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode * node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"RETRY"]) {
        SKTransition *reveal = [SKTransition doorsCloseVerticalWithDuration:0.5];
        G2PlusScene * g2plusscene = [G2PlusScene sceneWithSize:self.view.bounds.size];
        g2plusscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:g2plusscene transition: reveal];
    }
    else if ([node.name isEqualToString:@"BACK"]) {
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
    
}


@end
