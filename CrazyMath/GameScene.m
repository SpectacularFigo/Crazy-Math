//
//  GameScene.m
//  HopHero2
//
//  Created by BC on 12/22/14.
//  Copyright (c) 2014 BenCodes. All rights reserved.
//

#import "GameScene.h"
#import "Hero.h"
#import "WorldGenerator.h"
#import "PointsLabel.h"
#import "GameData.h"

@interface GameScene ()
@property BOOL isStarted;
@property BOOL isGameOver;
@end

@implementation GameScene
{
    Hero *hero;
    SKNode *world;
    WorldGenerator *generator;
}

static NSString *GAME_FONT = @"AmericanTypewriter-Bold";

- (void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.anchorPoint = CGPointMake(0.5, 0.5);
    
    self.backgroundColor = [SKColor colorWithRed:0.54 green:0.7853 blue:1.0 alpha:1.0];
    
    // Note (below): Don't have to initialize physicsWorld like with
    // physicsBody b/c it is already initialized upon Scene creation
    self.physicsWorld.contactDelegate = self;
    
    world = [SKNode node];
    [self addChild:world];
    
    generator = [WorldGenerator generatorWithWorld:world];
    [self addChild:generator];
    [generator populate];
    
    hero = [Hero hero];
    [world addChild:hero];
    
    [self loadScoreLabels];
    
    SKLabelNode *tapToBeginLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    tapToBeginLabel.name = @"tapToBeginLabel";
    tapToBeginLabel.text = @"tap to begin";
    tapToBeginLabel.fontSize = 20.0;
    [self addChild:tapToBeginLabel];
    [self animateWithPulse:tapToBeginLabel];
    
    [self loadClouds];
}

- (void)loadScoreLabels
{
    PointsLabel *pointsLabel = [PointsLabel pointsLabelWithFontNamed:GAME_FONT];
    pointsLabel.position = CGPointMake(-self.frame.size.width/2 + 30, 140);
    pointsLabel.name = @"pointsLabel";
    [self addChild:pointsLabel];
    
    GameData *data = [GameData data];
    [data load];
    
    PointsLabel *highScoreLabel = [PointsLabel pointsLabelWithFontNamed:GAME_FONT];
    highScoreLabel.position = CGPointMake(self.frame.size.width/2 - 30, 140);
    highScoreLabel.name = @"highScoreLabel";
    [highScoreLabel setPoints:data.highScore];
    [self addChild:highScoreLabel];
    
    PointsLabel *bestLabel = [PointsLabel pointsLabelWithFontNamed:GAME_FONT];
    bestLabel.position = CGPointMake(-75, 0);
    bestLabel.name = @"bestLabel";
    bestLabel.text = @"Best:";
    [highScoreLabel addChild:bestLabel];
}

- (void)loadClouds
{
    SKShapeNode *cloud1 = [SKShapeNode node];
    cloud1.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 65, 100, 40)].CGPath;
    cloud1.fillColor = [UIColor whiteColor];
    cloud1.strokeColor = [UIColor blackColor];
    [world addChild:cloud1];
    
    SKShapeNode *cloud2 = [SKShapeNode node];
    cloud2.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-250, 45, 100, 40)].CGPath;
    cloud2.fillColor = [UIColor whiteColor];
    cloud2.strokeColor = [UIColor blackColor];
    [world addChild:cloud2];
}

- (void)start
{
    self.isStarted = YES;
    [[self childNodeWithName:@"tapToBeginLabel"] removeFromParent];
    [hero start];
}

- (void)clear
{
    GameScene *scene = [[GameScene alloc] initWithSize:self.frame.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene];
}

- (void)gameOver
{
    self.isGameOver = YES;
    [self runAction:[SKAction playSoundFileNamed:@"onGameOver.mp3" waitForCompletion:NO]];
    [hero stop];

    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    gameOverLabel.text = @"Game Over ... Daht, daht, dahhh :(";
    gameOverLabel.position = CGPointMake(0, 50);
    [self addChild:gameOverLabel];
    
    SKLabelNode *tapToReset = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    tapToReset.name = @"tapToReset";
    tapToReset.text = @"tap to reset";
    tapToReset.fontSize = 20.0;
    [self addChild:tapToReset];
    [self animateWithPulse:tapToReset];
    
    [self updateHighScore];
}

-(void)updateHighScore
{
    PointsLabel *pointsLabel = (PointsLabel *)[self childNodeWithName:@"pointsLabel"];
    PointsLabel *highScoreLabel = (PointsLabel *)[self childNodeWithName:@"highScoreLabel"];
    
    if (pointsLabel.number > highScoreLabel.number) {
        [highScoreLabel setPoints:pointsLabel.number];
        
        GameData *data = [GameData data];
        data.highScore  = pointsLabel.number;
        [data save];
    }

}
-(void)didSimulatePhysics
{
    [self centerOnNode:hero];
    [self handlePoints];
    [self handleGeneration];
    [self handleCleanup];
}

-(void)centerOnNode:(SKNode *)node
{
    CGPoint positionInScene = [self convertPoint:node.position fromNode:node.parent];
    world.position = CGPointMake(world.position.x - positionInScene.x,
                                 world.position.y);
}

-(void)handlePoints
{
    [world enumerateChildNodesWithName:@"obstacle" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x < hero.position.x) {
            // Get pointsLabel created in didMoveToView (above)
            PointsLabel *pointsLabel = (PointsLabel *)[self childNodeWithName:@"pointsLabel"];
            [pointsLabel increment];
        }
    }];
}

// Calls generate method of the WorldGenerator class every time hero jumps over an obstacle
-(void)handleGeneration
{
    [world enumerateChildNodesWithName:@"obstacle" usingBlock:^(SKNode *node, BOOL *stop) {
        if(node.position.x < hero.position.x) {
            node.name = @"obstacle_cancelled";
             [generator generate];
         }
    }];
}

-(void)handleCleanup
{
    [world enumerateChildNodesWithName:@"ground" usingBlock:^(SKNode *node, BOOL *stop) {
        if(node.position.x < hero.position.x - self.frame.size.width/2 - node.frame.size.width/2) {
            [node removeFromParent];
        }
    }];
    
    [world enumerateChildNodesWithName:@"obstacle_cancelled " usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.x < hero.position.x - self.frame.size.width/2 - node.frame.size.width/2) {
            [node removeFromParent];
        }
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    // If game is not started, start the hero moving with first touch
    if (!self.isStarted)
        [self start];
    // But, if game is over, call the clear method
    else if (self.isGameOver)
        [self clear];
    else
        [hero jump];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    if ([contact.bodyA.node.name isEqualToString: @"ground"] || [contact.bodyB.node.name isEqualToString: @"ground"]) {
        [hero land];
    } else {
        [self gameOver];
    }
}

/* ANIMATION METHODS ETC... */

-(void)animateWithPulse:(SKNode *)node
{
    SKAction *disappear = [SKAction fadeAlphaTo:0.0 duration:0.6];
    SKAction *appear = [SKAction fadeAlphaTo:1.0 duration:0.6];
    SKAction *pulse = [SKAction sequence:@[disappear, appear]];
    [node runAction:[SKAction repeatActionForever:pulse]];
}

@end
