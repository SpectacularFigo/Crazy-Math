//
//  G1SubtractScene.m
//  CrazyMath
//
//  Created by 周吴子煌 on 15/11/14.
//  Copyright © 2015年 Zhouwu Zihuang. All rights reserved.
//

#import "G1SubtractScene.h"
#import "G1SubtractLoseScene.h"
#import "G1SubtractFinishScene.h"
#import "G1SubtractWinScene.h"
#import "G1OperatorScene.h"
#import "G1SubtractGameOverScene.h"

int a2 = 0;
int b2 = 0;
int c2 = 0;
int count2 = 0;
int SCORE2 = 0;
int COUNT2 = 0;


@interface G1SubtractScene () <SKPhysicsContactDelegate>
@property (nonatomic) SKSpriteNode * player;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) int numbersDestroyed;
@property (strong, nonatomic) SKLabelNode * resultLabel;
@property (nonatomic) NSInteger result;
@property (nonatomic) NSInteger totalSpawns;
@property (nonatomic) BOOL gameOver;
@end

static int r;

static const uint32_t equalCategory = 0x1 << 0;
static const uint32_t numberCategory = 0x1 << 1;
static inline CGPoint rwAdd(CGPoint a, CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}
static inline CGPoint rwSub(CGPoint a, CGPoint b)
{
    return CGPointMake(a.x - b.x, a.y - b.y);
}
static inline CGPoint rwMult(CGPoint a, float b)
{
    return CGPointMake(a.x * b, a.y * b);
}
static inline float rwLength(CGPoint a)
{
    return sqrtf(a.x * a.x + a.y * a.y);
}
static inline CGPoint rwNormalize(CGPoint a)
{
    float length = rwLength(a);
    return CGPointMake(a.x / length, a.y / length);
}



@implementation G1SubtractScene

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size])
    {
        count2 += 1;
        
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        self.backgroundColor = [SKColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
        
        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"Player"];
        self.player.position = CGPointMake(self.frame.size.width/2, self.player.size.height/2);
        
        SKSpriteNode * back = [SKSpriteNode spriteNodeWithImageNamed:@"Sled"];
        back.position = CGPointMake(0.9 * self.frame.size.width, back.size.height/2);
        back.name = @"SLED";
        
        SKLabelNode * label1 = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
        label1.text = @"No:";
        label1.fontSize = 20;
        label1.fontColor = [SKColor blackColor];
        label1.position = CGPointMake(0.65 * self.frame.size.width, 10);
        
        COUNT2 += 1;
        SKLabelNode * label2 = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
        NSString * stringint = [NSString stringWithFormat:@"%d",COUNT2];
        label2.text = stringint;
        label2.fontSize = 20;
        label2.fontColor = [SKColor blackColor];
        label2.position = CGPointMake(0.72 * self.frame.size.width, 10);
        
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
        self.resultLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        self.resultLabel.text = @"0";
        self.resultLabel.fontSize = 25;
        self.resultLabel.fontColor = [SKColor whiteColor];
        self.resultLabel.position = CGPointMake(120,10);
        
        
        
        
        [self addChild:self.player];
        [self addChild:back];
        [self addChild:label1];
        [self addChild:label2];
        [self addEquation];
        [self addChild:self.resultLabel];
        
    }
    return self;
}


- (void)addEquation
{
    SKLabelNode * label1 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    SKLabelNode * label2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    SKLabelNode * label3 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    SKLabelNode * label4 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    a2 = (arc4random()%10)+1;
    b2 = (arc4random()%10)+1;
    c2 = a2 + b2;
    
    NSString * stringint1 = [NSString stringWithFormat:@"%d",c2];
    NSString * stringint2 = [NSString stringWithFormat:@"%d",a2];
    
    label1.text = stringint1;
    label1.fontSize = 25;
    label1.fontColor = [SKColor whiteColor];
    label1.position = CGPointMake(20,10);
    
    label2.text = @"-";
    label2.fontSize = 25;
    label2.fontColor = [SKColor whiteColor];
    label2.position = CGPointMake(45,10);
    
    
    label3.text = stringint2;
    label3.fontSize = 25;
    label3.fontColor = [SKColor whiteColor];
    label3.position = CGPointMake(70,10);
    
    label4.text = @"=";
    label4.fontSize = 25;
    label4.fontColor = [SKColor whiteColor];
    label4.position = CGPointMake(95,10);
    
    [self addChild:label1];
    [self addChild:label2];
    [self addChild:label3];
    [self addChild:label4];
}


//add target
- (void)addTarget
{
    r = arc4random()%3;
    if(r == 0)
    {
        SKSpriteNode * target4 = [SKSpriteNode spriteNodeWithImageNamed:@"Target4"];
        int minX = target4.size.width / 2;
        int maxX = self.frame.size.width - target4.size.width / 2;
        int rangeX = maxX - minX;
        int actualX = (arc4random() % rangeX) + minX;
        target4.position = CGPointMake(actualX, self.frame.size.height + target4.size.height/2);
        target4.name = @"target4";
        [self addChild:target4];
        
        target4.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:target4.size];
        target4.physicsBody.dynamic = YES;
        target4.physicsBody.categoryBitMask = numberCategory;
        target4.physicsBody.contactTestBitMask = equalCategory;
        target4.physicsBody.collisionBitMask = 0;
        
        int minDuration = 8.0;
        int maxDuration = 14.0;
        int rangeDuration = maxDuration - minDuration;
        int actualDuration = (arc4random() % rangeDuration) + minDuration;
        
        SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX,-target4.size.height/2) duration:actualDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        SKAction * loseAction = [SKAction runBlock:^{
            if(count2 < 10)
            {
                SKTransition *reveal = [SKTransition doorsOpenVerticalWithDuration:0.5];
                SKScene * g1subtractlosescene = [[G1SubtractLoseScene alloc] initWithSize:self.size won:NO];
                [self.view presentScene:g1subtractlosescene transition: reveal];
            }
            else
            {
                SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
                G1SubtractFinishScene * g1subtractfinishscene = [G1SubtractFinishScene sceneWithSize:self.view.bounds.size];
                g1subtractfinishscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g1subtractfinishscene transition: reveal];
            }}];
        [target4 runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
    }
    if(r == 1)
    {
        SKSpriteNode * target5 = [SKSpriteNode spriteNodeWithImageNamed:@"Target5"];
        
        int minX = target5.size.width / 2;
        int maxX = self.frame.size.width - target5.size.width / 2;
        int rangeX = maxX - minX;
        int actualX = (arc4random() % rangeX) + minX;
        
        target5.position = CGPointMake(actualX, self.frame.size.height + target5.size.height/2);
        target5.name = @"target5";
        [self addChild:target5];
        
        target5.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:target5.size];
        target5.physicsBody.dynamic = YES;
        target5.physicsBody.categoryBitMask = numberCategory;
        target5.physicsBody.contactTestBitMask = equalCategory;
        target5.physicsBody.collisionBitMask = 0;
        
        int minDuration = 8.0;
        int maxDuration = 14.0;
        int rangeDuration = maxDuration - minDuration;
        int actualDuration = (arc4random() % rangeDuration) + minDuration;
        
        SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX,-target5.size.height/2) duration:actualDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        
        SKAction * loseAction = [SKAction runBlock:^{
            if(count2 < 10)
            {
                SKTransition *reveal = [SKTransition doorsOpenVerticalWithDuration:0.5];
                SKScene * g1subtractlosescene = [[G1SubtractLoseScene alloc] initWithSize:self.size won:NO];
                [self.view presentScene:g1subtractlosescene transition: reveal];
            }
            else
            {
                SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
                G1SubtractFinishScene * g1subtractfinishscene = [G1SubtractFinishScene sceneWithSize:self.view.bounds.size];
                g1subtractfinishscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g1subtractfinishscene transition: reveal];
            }}];
        [target5 runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
    }
    if(r == 2)
    {
        SKSpriteNode * target6 = [SKSpriteNode spriteNodeWithImageNamed:@"Target6"];
        
        int minX = target6.size.width / 2;
        int maxX = self.frame.size.width - target6.size.width / 2;
        int rangeX = maxX - minX;
        int actualX = (arc4random() % rangeX) + minX;
        
        target6.position = CGPointMake(actualX, self.frame.size.height + target6.size.height/2);
        target6.name = @"target6";
        [self addChild:target6];
        
        target6.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:target6.size];
        target6.physicsBody.dynamic = YES;
        target6.physicsBody.categoryBitMask = numberCategory;
        target6.physicsBody.contactTestBitMask = equalCategory;
        target6.physicsBody.collisionBitMask = 0;
        
        int minDuration = 8.0;
        int maxDuration = 14.0;
        int rangeDuration = maxDuration - minDuration;
        int actualDuration = (arc4random() % rangeDuration) + minDuration;
        
        SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX,-target6.size.height/2) duration:actualDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        
        SKAction * loseAction = [SKAction runBlock:^{
            if(count2 < 10)
            {
                SKTransition *reveal = [SKTransition doorsOpenVerticalWithDuration:0.5];
                SKScene * g1subtractlosescene = [[G1SubtractLoseScene alloc] initWithSize:self.size won:NO];
                [self.view presentScene:g1subtractlosescene transition: reveal];
            }
            else
            {
                SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
                G1SubtractFinishScene * g1subtractfinishscene = [G1SubtractFinishScene sceneWithSize:self.view.bounds.size];
                g1subtractfinishscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g1subtractfinishscene transition: reveal];
            }}];
        [target6 runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
    }
}



- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
{
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 0.8)
    {
        self.lastSpawnTimeInterval = 0;
        [self addTarget];
    }
}


- (void)update:(NSTimeInterval)currentTime
{
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1)
    {
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    [self.resultLabel setText:[NSString stringWithFormat:@"%ld",(long)self.result]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"SLED"]) {
        SKTransition *reveal = [SKTransition doorsCloseHorizontalWithDuration:0.5];
        G1OperatorScene * g1operatorscene = [G1OperatorScene sceneWithSize:self.view.bounds.size];
        g1operatorscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:g1operatorscene transition: reveal];
        
        extern int count2;
        count2 = 0;
        extern int SCORE2;
        SCORE2 = 0;
        extern int COUNT2;
        COUNT2 = 0;
    }
    
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //shooting sound
    //[self runAction:[SKAction playSoundFileNamed:@"shoot.caf" waitForCompletion:NO]];
    
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    SKSpriteNode * snowball = [SKSpriteNode spriteNodeWithImageNamed:@"Snowball"];
    snowball.position = CGPointMake(self.frame.size.width/2, self.player.size.height);
    
    snowball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:snowball.size.width/2];
    snowball.physicsBody.dynamic = YES;
    snowball.physicsBody.categoryBitMask = equalCategory;
    snowball.physicsBody.contactTestBitMask = numberCategory;
    snowball.physicsBody.collisionBitMask = 0;
    snowball.physicsBody.usesPreciseCollisionDetection = YES;
    
    CGPoint offset = rwSub(location, snowball.position);
    
    if (offset.y <= 0) return;
    [self addChild:snowball];
    CGPoint direction = rwNormalize(offset);
    CGPoint shootAmount = rwMult(direction, 1000);
    CGPoint realDest = rwAdd(shootAmount, snowball.position);
    
    float velocity = 200.0/1.0;
    float realMoveDuration = self.size.width / velocity;
    SKAction * actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [snowball runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    
    
}




- (void)equal:(SKSpriteNode *)snowball didCollideWithNumber:(SKSpriteNode *)target
{
    NSLog(@"Hit");
    if([target.name  isEqual:@"target4"])
    {
        [snowball removeFromParent];
        [target removeFromParent];
        
        self.numbersDestroyed +=1;
        self.result += 1;
        
        if (self.numbersDestroyed == b2)
        {
            if(count2 <= 10)
            {
                [self.resultLabel setText:[NSString stringWithFormat:@"%ld",(long)self.result]];
                
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                G1SubtractWinScene * g1subtractwinscene = [G1SubtractWinScene sceneWithSize:self.view.bounds.size];
                g1subtractwinscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g1subtractwinscene transition: reveal];
                
                SCORE2 += 10;
            }
        }
        
        else if(self.numbersDestroyed > b2)
        {
            SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
            G1SubtractGameOverScene * g1subtractgameoverscene = [G1SubtractGameOverScene sceneWithSize:self.view.bounds.size];
            g1subtractgameoverscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g1subtractgameoverscene transition: reveal];
        }
    }
    
    
    else if([target.name  isEqual:@"target5"])
    {
        [snowball removeFromParent];
        [target removeFromParent];
        
        self.numbersDestroyed +=2;
        self.result += 2;
        
        if (self.numbersDestroyed == b2)
        {
            if(count2 <= 10)
            {
                [self.resultLabel setText:[NSString stringWithFormat:@"%ld",(long)self.result]];
                
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                G1SubtractWinScene * g1subtractwinscene = [G1SubtractWinScene sceneWithSize:self.view.bounds.size];
                g1subtractwinscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g1subtractwinscene transition: reveal];
                
                SCORE2 += 10;
            }
        }
        
        else if(self.numbersDestroyed > b2)
        {
            SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
            G1SubtractGameOverScene * g1subtractgameoverscene = [G1SubtractGameOverScene sceneWithSize:self.view.bounds.size];
            g1subtractgameoverscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g1subtractgameoverscene transition: reveal];
        }
    }
    
    
    
    else if([target.name  isEqual:@"target6"])
    {
        [snowball removeFromParent];
        [target removeFromParent];
        
        self.numbersDestroyed +=3;
        self.result += 3;
        
        if (self.numbersDestroyed == b2)
        {
            if(count2 <= 10)
            {
                [self.resultLabel setText:[NSString stringWithFormat:@"%ld",(long)self.result]];
                
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                G1SubtractWinScene * g1subtractwinscene = [G1SubtractWinScene sceneWithSize:self.view.bounds.size];
                g1subtractwinscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g1subtractwinscene transition: reveal];
                
                SCORE2 += 10;
            }
        }
        
        else if(self.numbersDestroyed > b2)
        {
            SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
            G1SubtractGameOverScene * g1subtractgameoverscene = [G1SubtractGameOverScene sceneWithSize:self.view.bounds.size];
            g1subtractgameoverscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g1subtractgameoverscene transition: reveal];
        }
    }
    
    
    
}



- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & equalCategory) != 0 &&
        (secondBody.categoryBitMask & numberCategory) != 0)
    {
        [self equal:(SKSpriteNode *) firstBody.node didCollideWithNumber:(SKSpriteNode *) secondBody.node];
    }
}

@end
