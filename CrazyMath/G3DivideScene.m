//
//  G3DivideScene.m
//  CrazyMath
//
//  Created by 周吴子煌 on 15/11/18.
//  Copyright © 2015年 Zhouwu Zihuang. All rights reserved.
//

#import "G3DivideScene.h"
#import "G3DivideLoseScene.h"
#import "G3DivideFinishScene.h"
#import "G3DivideWinScene.h"
#import "G3OperatorScene.h"
#import "G3DivideGameOverScene.h"

int a8 = 0;
int b8 = 0;
int c8 = 0;
int count8 = 0;
int SCORE8 = 0;
int COUNT8 = 0;


@interface G3DivideScene () <SKPhysicsContactDelegate>
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



@implementation G3DivideScene

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size])
    {
        count8 += 1;
        
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
        
        COUNT8 += 1;
        SKLabelNode * label2 = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
        NSString * stringint = [NSString stringWithFormat:@"%d",COUNT8];
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
    
    a8 = (arc4random()%10)+1;
    b8 = (arc4random()%10)+1;
    c8 = a8 * b8;
    
    NSString * stringint1 = [NSString stringWithFormat:@"%d",c8];
    NSString * stringint2 = [NSString stringWithFormat:@"%d",a8];
    
    label1.text = stringint1;
    label1.fontSize = 25;
    label1.fontColor = [SKColor whiteColor];
    label1.position = CGPointMake(20,10);
    
    label2.text = @"÷";
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
        SKSpriteNode * target10 = [SKSpriteNode spriteNodeWithImageNamed:@"Target10"];
        int minX = target10.size.width / 2;
        int maxX = self.frame.size.width - target10.size.width / 2;
        int rangeX = maxX - minX;
        int actualX = (arc4random() % rangeX) + minX;
        target10.position = CGPointMake(actualX, self.frame.size.height + target10.size.height/2);
        target10.name = @"target10";
        [self addChild:target10];
        
        target10.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:target10.size];
        target10.physicsBody.dynamic = YES;
        target10.physicsBody.categoryBitMask = numberCategory;
        target10.physicsBody.contactTestBitMask = equalCategory;
        target10.physicsBody.collisionBitMask = 0;
        
        int minDuration = 5.0;
        int maxDuration = 8.0;
        int rangeDuration = maxDuration - minDuration;
        int actualDuration = (arc4random() % rangeDuration) + minDuration;
        
        SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX,-target10.size.height/2) duration:actualDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        SKAction * loseAction = [SKAction runBlock:^{
            if(count8 < 10)
            {
                SKTransition *reveal = [SKTransition doorsOpenVerticalWithDuration:0.5];
                SKScene * g3dividelosescene = [[G3DivideLoseScene alloc] initWithSize:self.size won:NO];
                [self.view presentScene:g3dividelosescene transition: reveal];
            }
            else
            {
                SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
                G3DivideFinishScene * g3dividefinishscene = [G3DivideFinishScene sceneWithSize:self.view.bounds.size];
                g3dividefinishscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g3dividefinishscene transition: reveal];
            }}];
        [target10 runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
    }
    if(r == 1)
    {
        SKSpriteNode * target11 = [SKSpriteNode spriteNodeWithImageNamed:@"Target11"];
        
        int minX = target11.size.width / 2;
        int maxX = self.frame.size.width - target11.size.width / 2;
        int rangeX = maxX - minX;
        int actualX = (arc4random() % rangeX) + minX;
        
        target11.position = CGPointMake(actualX, self.frame.size.height + target11.size.height/2);
        target11.name = @"target11";
        [self addChild:target11];
        
        target11.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:target11.size];
        target11.physicsBody.dynamic = YES;
        target11.physicsBody.categoryBitMask = numberCategory;
        target11.physicsBody.contactTestBitMask = equalCategory;
        target11.physicsBody.collisionBitMask = 0;
        
        int minDuration = 5.0;
        int maxDuration = 8.0;
        int rangeDuration = maxDuration - minDuration;
        int actualDuration = (arc4random() % rangeDuration) + minDuration;
        
        SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX,-target11.size.height/2) duration:actualDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        
        SKAction * loseAction = [SKAction runBlock:^{
            if(count8 < 10)
            {
                SKTransition *reveal = [SKTransition doorsOpenVerticalWithDuration:0.5];
                SKScene * g3dividelosescene = [[G3DivideLoseScene alloc] initWithSize:self.size won:NO];
                [self.view presentScene:g3dividelosescene transition: reveal];
            }
            else
            {
                SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
                G3DivideFinishScene * g3dividefinishscene = [G3DivideFinishScene sceneWithSize:self.view.bounds.size];
                g3dividefinishscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g3dividefinishscene transition: reveal];
            }}];
        [target11 runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
    }
    if(r == 2)
    {
        SKSpriteNode * target12 = [SKSpriteNode spriteNodeWithImageNamed:@"Target12"];
        
        int minX = target12.size.width / 2;
        int maxX = self.frame.size.width - target12.size.width / 2;
        int rangeX = maxX - minX;
        int actualX = (arc4random() % rangeX) + minX;
        
        target12.position = CGPointMake(actualX, self.frame.size.height + target12.size.height/2);
        target12.name = @"target12";
        [self addChild:target12];
        
        target12.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:target12.size];
        target12.physicsBody.dynamic = YES;
        target12.physicsBody.categoryBitMask = numberCategory;
        target12.physicsBody.contactTestBitMask = equalCategory;
        target12.physicsBody.collisionBitMask = 0;
        
        int minDuration = 5.0;
        int maxDuration = 8.0;
        int rangeDuration = maxDuration - minDuration;
        int actualDuration = (arc4random() % rangeDuration) + minDuration;
        
        SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX,-target12.size.height/2) duration:actualDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        
        SKAction * loseAction = [SKAction runBlock:^{
            if(count8 < 10)
            {
                SKTransition *reveal = [SKTransition doorsOpenVerticalWithDuration:0.5];
                SKScene * g3dividelosescene = [[G3DivideLoseScene alloc] initWithSize:self.size won:NO];
                [self.view presentScene:g3dividelosescene transition: reveal];
            }
            else
            {
                SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
                G3DivideFinishScene * g3dividefinishscene = [G3DivideFinishScene sceneWithSize:self.view.bounds.size];
                g3dividefinishscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g3dividefinishscene transition: reveal];
            }}];
        [target12 runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
    }
}



- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast
{
    self.lastSpawnTimeInterval += timeSinceLast;
    if (self.lastSpawnTimeInterval > 0.3)
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
        G3OperatorScene * g3operatorscene = [G3OperatorScene sceneWithSize:self.view.bounds.size];
        g3operatorscene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:g3operatorscene transition: reveal];
        
        extern int count8;
        count8 = 0;
        extern int SCORE8;
        SCORE8 = 0;
        extern int COUNT8;
        COUNT8 = 0;
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
    if([target.name  isEqual:@"target10"])
    {
        [snowball removeFromParent];
        [target removeFromParent];
        
        self.numbersDestroyed +=1;
        self.result += 1;
        
        if (self.numbersDestroyed == b8)
        {
            if(count8 <= 10)
            {
                [self.resultLabel setText:[NSString stringWithFormat:@"%ld",(long)self.result]];
                
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                G3DivideWinScene * g3dividewinscene = [G3DivideWinScene sceneWithSize:self.view.bounds.size];
                g3dividewinscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g3dividewinscene transition: reveal];
                
                SCORE8 += 10;
            }
        }
        
        else if(self.numbersDestroyed > b8)
        {
            SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
            G3DivideGameOverScene * g3dividegameoverscene = [G3DivideGameOverScene sceneWithSize:self.view.bounds.size];
            g3dividegameoverscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g3dividegameoverscene transition: reveal];
        }
    }
    
    
    else if([target.name  isEqual:@"target11"])
    {
        [snowball removeFromParent];
        [target removeFromParent];
        
        self.numbersDestroyed +=2;
        self.result += 2;
        
        if (self.numbersDestroyed == b8)
        {
            if(count8 <= 10)
            {
                [self.resultLabel setText:[NSString stringWithFormat:@"%ld",(long)self.result]];
                
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                G3DivideWinScene * g3dividewinscene = [G3DivideWinScene sceneWithSize:self.view.bounds.size];
                g3dividewinscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g3dividewinscene transition: reveal];
                
                SCORE8 += 10;
            }
        }
        
        else if(self.numbersDestroyed > b8)
        {
            SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
            G3DivideGameOverScene * g3dividegameoverscene = [G3DivideGameOverScene sceneWithSize:self.view.bounds.size];
            g3dividegameoverscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g3dividegameoverscene transition: reveal];
        }
    }
    
    
    
    else if([target.name  isEqual:@"target12"])
    {
        [snowball removeFromParent];
        [target removeFromParent];
        
        self.numbersDestroyed +=3;
        self.result += 3;
        
        if (self.numbersDestroyed == b8)
        {
            if(count8 <= 10)
            {
                [self.resultLabel setText:[NSString stringWithFormat:@"%ld",(long)self.result]];
                
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                G3DivideWinScene * g3dividewinscene = [G3DivideWinScene sceneWithSize:self.view.bounds.size];
                g3dividewinscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g3dividewinscene transition: reveal];
                
                SCORE8 += 10;
            }
        }
        
        else if(self.numbersDestroyed > b8)
        {
            SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
            G3DivideGameOverScene * g3dividegameoverscene = [G3DivideGameOverScene sceneWithSize:self.view.bounds.size];
            g3dividegameoverscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g3dividegameoverscene transition: reveal];
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

