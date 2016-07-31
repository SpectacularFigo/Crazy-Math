//
//  G2SubtractScene.m
//  CrazyMath
//
//  Created by 周吴子煌 on 15/11/16.
//  Copyright © 2015年 Zhouwu Zihuang. All rights reserved.
//

#import "G2SubtractScene.h"
#import "G2SubtractLoseScene.h"
#import "G2SubtractFinishScene.h"
#import "G2SubtractWinScene.h"
#import "G2OperatorScene.h"
#import "G2SubtractGameOverScene.h"

int a4 = 0;
int b4 = 0;
int c4 = 0;
int count4 = 0;
int SCORE4 = 0;
int COUNT4 = 0;


@interface G2SubtractScene () <SKPhysicsContactDelegate>
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



@implementation G2SubtractScene

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size])
    {
        count4 += 1;
        
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
        
        COUNT4 += 1;
        SKLabelNode * label2 = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
        NSString * stringint = [NSString stringWithFormat:@"%d",COUNT4];
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
    
    a4 = (arc4random()%20)+1;
    b4 = (arc4random()%20)+1;
    c4 = a4 + b4;
    
    NSString * stringint1 = [NSString stringWithFormat:@"%d",c4];
    NSString * stringint2 = [NSString stringWithFormat:@"%d",a4];
    
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
        
        int minDuration = 6.0;
        int maxDuration = 12.0;
        int rangeDuration = maxDuration - minDuration;
        int actualDuration = (arc4random() % rangeDuration) + minDuration;
        
        SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX,-target4.size.height/2) duration:actualDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        SKAction * loseAction = [SKAction runBlock:^{
            if(count4 < 10)
            {
                SKTransition *reveal = [SKTransition doorsOpenVerticalWithDuration:0.5];
                SKScene * g2subtractlosescene = [[G2SubtractLoseScene alloc] initWithSize:self.size won:NO];
                [self.view presentScene:g2subtractlosescene transition: reveal];
            }
            else
            {
                SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
                G2SubtractFinishScene * g2subtractfinishscene = [G2SubtractFinishScene sceneWithSize:self.view.bounds.size];
                g2subtractfinishscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g2subtractfinishscene transition: reveal];
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
        
        int minDuration = 6.0;
        int maxDuration = 12.0;
        int rangeDuration = maxDuration - minDuration;
        int actualDuration = (arc4random() % rangeDuration) + minDuration;
        
        SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX,-target5.size.height/2) duration:actualDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        
        SKAction * loseAction = [SKAction runBlock:^{
            if(count4 < 10)
            {
                SKTransition *reveal = [SKTransition doorsOpenVerticalWithDuration:0.5];
                SKScene * g2subtractlosescene = [[G2SubtractLoseScene alloc] initWithSize:self.size won:NO];
                [self.view presentScene:g2subtractlosescene transition: reveal];
            }
            else
            {
                SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
                G2SubtractFinishScene * g2subtractfinishscene = [G2SubtractFinishScene sceneWithSize:self.view.bounds.size];
                g2subtractfinishscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g2subtractfinishscene transition: reveal];
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
        
        int minDuration = 6.0;
        int maxDuration = 12.0;
        int rangeDuration = maxDuration - minDuration;
        int actualDuration = (arc4random() % rangeDuration) + minDuration;
        
        SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX,-target6.size.height/2) duration:actualDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        
        SKAction * loseAction = [SKAction runBlock:^{
            if(count4 < 10)
            {
                SKTransition *reveal = [SKTransition doorsOpenVerticalWithDuration:0.5];
                SKScene * g2subtractlosescene = [[G2SubtractLoseScene alloc] initWithSize:self.size won:NO];
                [self.view presentScene:g2subtractlosescene transition: reveal];
            }
            else
            {
                SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
                G2SubtractFinishScene * g2subtractfinishscene = [G2SubtractFinishScene sceneWithSize:self.view.bounds.size];
                g2subtractfinishscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g2subtractfinishscene transition: reveal];
            }}];
        [target6 runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
    }
}



- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
{
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 0.6)
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
        G2OperatorScene * g2operatorscene = [G2OperatorScene sceneWithSize:self.view.bounds.size];
        g2operatorscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:g2operatorscene transition: reveal];
        
        extern int count4;
        count4 = 0;
        extern int SCORE4;
        SCORE4 = 0;
        extern int COUNT4;
        COUNT4 = 0;
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
        
        if (self.numbersDestroyed == b4)
        {
            if(count4 <= 10)
            {
                [self.resultLabel setText:[NSString stringWithFormat:@"%ld",(long)self.result]];
                
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                G2SubtractWinScene * g2subtractwinscene = [G2SubtractWinScene sceneWithSize:self.view.bounds.size];
                g2subtractwinscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g2subtractwinscene transition: reveal];
                
                SCORE4 += 10;
            }
        }
        
        else if(self.numbersDestroyed > b4)
        {
            SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
            G2SubtractGameOverScene * g2subtractgameoverscene = [G2SubtractGameOverScene sceneWithSize:self.view.bounds.size];
            g2subtractgameoverscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g2subtractgameoverscene transition: reveal];
        }
    }
    
    
    else if([target.name  isEqual:@"target5"])
    {
        [snowball removeFromParent];
        [target removeFromParent];
        
        self.numbersDestroyed +=2;
        self.result += 2;
        
        if (self.numbersDestroyed == b4)
        {
            if(count4 <= 10)
            {
                [self.resultLabel setText:[NSString stringWithFormat:@"%ld",(long)self.result]];
                
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                G2SubtractWinScene * g2subtractwinscene = [G2SubtractWinScene sceneWithSize:self.view.bounds.size];
                g2subtractwinscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g2subtractwinscene transition: reveal];
                
                SCORE4 += 10;
            }
        }
        
        else if(self.numbersDestroyed > b4)
        {
            SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
            G2SubtractGameOverScene * g2subtractgameoverscene = [G2SubtractGameOverScene sceneWithSize:self.view.bounds.size];
            g2subtractgameoverscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g2subtractgameoverscene transition: reveal];
        }
    }
    
    
    
    else if([target.name  isEqual:@"target6"])
    {
        [snowball removeFromParent];
        [target removeFromParent];
        
        self.numbersDestroyed +=3;
        self.result += 3;
        
        if (self.numbersDestroyed == b4)
        {
            if(count4 <= 10)
            {
                [self.resultLabel setText:[NSString stringWithFormat:@"%ld",(long)self.result]];
                
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                G2SubtractWinScene * g2subtractwinscene = [G2SubtractWinScene sceneWithSize:self.view.bounds.size];
                g2subtractwinscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g2subtractwinscene transition: reveal];
                
                SCORE4 += 10;
            }
        }
        
        else if(self.numbersDestroyed > b4)
        {
            SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
            G2SubtractGameOverScene * g2subtractgameoverscene = [G2SubtractGameOverScene sceneWithSize:self.view.bounds.size];
            g2subtractgameoverscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g2subtractgameoverscene transition: reveal];
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
