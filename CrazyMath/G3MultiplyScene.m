//
//  G3MultiplyScene.m
//  CrazyMath
//
//  Created by 周吴子煌 on 15/11/18.
//  Copyright © 2015年 Zhouwu Zihuang. All rights reserved.
//

#import "G3MultiplyScene.h"
#import "G3MultiplyLoseScene.h"
#import "G3MultiplyFinishScene.h"
#import "G3MultiplyWinScene.h"
#import "G3OperatorScene.h"
#import "G3MultiplyGameOverScene.h"

int a7 = 0;
int b7 = 0;
int c7 = 0;
int count7 = 0;
int SCORE7 = 0;
int COUNT7 = 0;


@interface G3MultiplyScene () <SKPhysicsContactDelegate>
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



@implementation G3MultiplyScene

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size])
    {
        count7 += 1;
        
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
        
        COUNT7 += 1;
        SKLabelNode * label2 = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
        NSString * stringint = [NSString stringWithFormat:@"%d",COUNT7];
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
    
    a7 = (arc4random()%10)+1;
    b7 = (arc4random()%10)+1;
    c7 = a7 * b7;
    
    NSString * stringint1 = [NSString stringWithFormat:@"%d",a7];
    NSString * stringint2 = [NSString stringWithFormat:@"%d",b7];
    
    label1.text = stringint1;
    label1.fontSize = 25;
    label1.fontColor = [SKColor whiteColor];
    label1.position = CGPointMake(20,10);
    
    label2.text = @"×";
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
        SKSpriteNode * target7 = [SKSpriteNode spriteNodeWithImageNamed:@"Target7"];
        int minX = target7.size.width / 2;
        int maxX = self.frame.size.width - target7.size.width / 2;
        int rangeX = maxX - minX;
        int actualX = (arc4random() % rangeX) + minX;
        target7.position = CGPointMake(actualX, self.frame.size.height + target7.size.height/2);
        target7.name = @"target7";
        [self addChild:target7];
        
        target7.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:target7.size];
        target7.physicsBody.dynamic = YES;
        target7.physicsBody.categoryBitMask = numberCategory;
        target7.physicsBody.contactTestBitMask = equalCategory;
        target7.physicsBody.collisionBitMask = 0;
        
        int minDuration = 5.0;
        int maxDuration = 8.0;
        int rangeDuration = maxDuration - minDuration;
        int actualDuration = (arc4random() % rangeDuration) + minDuration;
        
        SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX,-target7.size.height/2) duration:actualDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        SKAction * loseAction = [SKAction runBlock:^{
            if(count7 < 10)
            {
                SKTransition *reveal = [SKTransition doorsOpenVerticalWithDuration:0.5];
                SKScene * g3multiplylosescene = [[G3MultiplyLoseScene alloc] initWithSize:self.size won:NO];
                [self.view presentScene:g3multiplylosescene transition: reveal];
            }
            else
            {
                SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
                G3MultiplyFinishScene * g3multiplyfinishscene = [G3MultiplyFinishScene sceneWithSize:self.view.bounds.size];
                g3multiplyfinishscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g3multiplyfinishscene transition: reveal];
            }}];
        [target7 runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
    }
    if(r == 1)
    {
        SKSpriteNode * target8 = [SKSpriteNode spriteNodeWithImageNamed:@"Target8"];
        
        int minX = target8.size.width / 2;
        int maxX = self.frame.size.width - target8.size.width / 2;
        int rangeX = maxX - minX;
        int actualX = (arc4random() % rangeX) + minX;
        
        target8.position = CGPointMake(actualX, self.frame.size.height + target8.size.height/2);
        target8.name = @"target8";
        [self addChild:target8];
        
        target8.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:target8.size];
        target8.physicsBody.dynamic = YES;
        target8.physicsBody.categoryBitMask = numberCategory;
        target8.physicsBody.contactTestBitMask = equalCategory;
        target8.physicsBody.collisionBitMask = 0;
        
        int minDuration = 5.0;
        int maxDuration = 8.0;
        int rangeDuration = maxDuration - minDuration;
        int actualDuration = (arc4random() % rangeDuration) + minDuration;
        
        SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX,-target8.size.height/2) duration:actualDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        
        SKAction * loseAction = [SKAction runBlock:^{
            if(count7 < 10)
            {
                SKTransition *reveal = [SKTransition doorsOpenVerticalWithDuration:0.5];
                SKScene * g3multiplylosescene = [[G3MultiplyLoseScene alloc] initWithSize:self.size won:NO];
                [self.view presentScene:g3multiplylosescene transition: reveal];
            }
            else
            {
                SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
                G3MultiplyFinishScene * g3multiplyfinishscene = [G3MultiplyFinishScene sceneWithSize:self.view.bounds.size];
                g3multiplyfinishscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g3multiplyfinishscene transition: reveal];
            }}];
        [target8 runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
    }
    if(r == 2)
    {
        SKSpriteNode * target9 = [SKSpriteNode spriteNodeWithImageNamed:@"Target9"];
        
        int minX = target9.size.width / 2;
        int maxX = self.frame.size.width - target9.size.width / 2;
        int rangeX = maxX - minX;
        int actualX = (arc4random() % rangeX) + minX;
        
        target9.position = CGPointMake(actualX, self.frame.size.height + target9.size.height/2);
        target9.name = @"target9";
        [self addChild:target9];
        
        target9.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:target9.size];
        target9.physicsBody.dynamic = YES;
        target9.physicsBody.categoryBitMask = numberCategory;
        target9.physicsBody.contactTestBitMask = equalCategory;
        target9.physicsBody.collisionBitMask = 0;
        
        int minDuration = 5.0;
        int maxDuration = 8.0;
        int rangeDuration = maxDuration - minDuration;
        int actualDuration = (arc4random() % rangeDuration) + minDuration;
        
        SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX,-target9.size.height/2) duration:actualDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        
        SKAction * loseAction = [SKAction runBlock:^{
            if(count7 < 10)
            {
                SKTransition *reveal = [SKTransition doorsOpenVerticalWithDuration:0.5];
                SKScene * g3multiplylosescene = [[G3MultiplyLoseScene alloc] initWithSize:self.size won:NO];
                [self.view presentScene:g3multiplylosescene transition: reveal];
            }
            else
            {
                SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
                G3MultiplyFinishScene * g3multiplyfinishscene = [G3MultiplyFinishScene sceneWithSize:self.view.bounds.size];
                g3multiplyfinishscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g3multiplyfinishscene transition: reveal];
            }}];
        [target9 runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
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
        
        extern int count7;
        count7 = 0;
        extern int SCORE7;
        SCORE7 = 0;
        extern int COUNT7;
        COUNT7 = 0;
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
    if([target.name  isEqual:@"target7"])
    {
        [snowball removeFromParent];
        [target removeFromParent];
        
        self.numbersDestroyed +=1;
        self.result += 1;
        
        if (self.numbersDestroyed == c7)
        {
            if(count7 <= 10)
            {
                [self.resultLabel setText:[NSString stringWithFormat:@"%ld",(long)self.result]];
                
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                G3MultiplyWinScene * g3multiplywinscene = [G3MultiplyWinScene sceneWithSize:self.view.bounds.size];
                g3multiplywinscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g3multiplywinscene transition: reveal];
                
                SCORE7 += 10;
            }
        }
        
        else if(self.numbersDestroyed > c7)
        {
            SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
            G3MultiplyGameOverScene * g3multiplygameoverscene = [G3MultiplyGameOverScene sceneWithSize:self.view.bounds.size];
            g3multiplygameoverscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g3multiplygameoverscene transition: reveal];
        }
    }
    
    
    else if([target.name  isEqual:@"target8"])
    {
        [snowball removeFromParent];
        [target removeFromParent];
        
        self.numbersDestroyed +=2;
        self.result += 2;
        
        if (self.numbersDestroyed == c7)
        {
            if(count7 <= 10)
            {
                [self.resultLabel setText:[NSString stringWithFormat:@"%ld",(long)self.result]];
                
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                G3MultiplyWinScene * g3multiplywinscene = [G3MultiplyWinScene sceneWithSize:self.view.bounds.size];
                g3multiplywinscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g3multiplywinscene transition: reveal];
                
                SCORE7 += 10;
            }
        }
        
        else if(self.numbersDestroyed > c7)
        {
            SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
            G3MultiplyGameOverScene * g3multiplygameoverscene = [G3MultiplyGameOverScene sceneWithSize:self.view.bounds.size];
            g3multiplygameoverscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g3multiplygameoverscene transition: reveal];
        }
    }
    
    
    
    else if([target.name  isEqual:@"target9"])
    {
        [snowball removeFromParent];
        [target removeFromParent];
        
        self.numbersDestroyed +=3;
        self.result += 3;
        
        if (self.numbersDestroyed == c7)
        {
            if(count7 <= 10)
            {
                [self.resultLabel setText:[NSString stringWithFormat:@"%ld",(long)self.result]];
                
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                G3MultiplyWinScene * g3multiplywinscene = [G3MultiplyWinScene sceneWithSize:self.view.bounds.size];
                g3multiplywinscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g3multiplywinscene transition: reveal];
                
                SCORE7 += 10;
            }
        }
        
        else if(self.numbersDestroyed > c7)
        {
            SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
            G3MultiplyGameOverScene * g3multiplygameoverscene = [G3MultiplyGameOverScene sceneWithSize:self.view.bounds.size];
            g3multiplygameoverscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g3multiplygameoverscene transition: reveal];
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
