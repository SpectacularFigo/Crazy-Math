//
//  G1PlusScene.m
//  CrazyMath
//
//  Created by 周吴子煌 on 15/11/14.
//  Copyright © 2015年 Zhouwu Zihuang. All rights reserved.
//

#import "G1PlusScene.h"
#import "G1PlusLoseScene.h"
#import "G1PlusFinishScene.h"
#import "G1PlusWinScene.h"
#import "G1OperatorScene.h"


#import "G1PlusGameOverScene.h"

int a1 = 0;
int b1 = 0;
int c1 = 0;
int count1 = 0;
int SCORE1 = 0;
int COUNT1 = 0;


@interface G1PlusScene () <SKPhysicsContactDelegate>
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



@implementation G1PlusScene

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size])
    {
        count1 += 1;
        
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
        
        COUNT1 += 1;
        SKLabelNode * label2 = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
        NSString * stringint = [NSString stringWithFormat:@"%d",COUNT1];
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
    
    a1 = (arc4random()%10)+1;
    b1 = (arc4random()%10)+1;
    c1 = a1 + b1;
    
    NSString * stringint1 = [NSString stringWithFormat:@"%d",a1];
    NSString * stringint2 = [NSString stringWithFormat:@"%d",b1];
    
    label1.text = stringint1;
    label1.fontSize = 25;
    label1.fontColor = [SKColor whiteColor];
    label1.position = CGPointMake(20,10);
    
    label2.text = @"+";
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
        SKSpriteNode * target1 = [SKSpriteNode spriteNodeWithImageNamed:@"Target1"];
        int minX = target1.size.width / 2;
        int maxX = self.frame.size.width - target1.size.width / 2;
        int rangeX = maxX - minX;
        int actualX = (arc4random() % rangeX) + minX;
        target1.position = CGPointMake(actualX, self.frame.size.height + target1.size.height/2);
        target1.name = @"target1";
        [self addChild:target1];
        
        target1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:target1.size];
        target1.physicsBody.dynamic = YES;
        target1.physicsBody.categoryBitMask = numberCategory;
        target1.physicsBody.contactTestBitMask = equalCategory;
        target1.physicsBody.collisionBitMask = 0;
        
        int minDuration = 8.0;
        int maxDuration = 14.0;
        int rangeDuration = maxDuration - minDuration;
        int actualDuration = (arc4random() % rangeDuration) + minDuration;
        
        SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX,-target1.size.height/2) duration:actualDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        SKAction * loseAction = [SKAction runBlock:^{
            if(count1 < 10)
            {
                SKTransition *reveal = [SKTransition doorsOpenVerticalWithDuration:0.5];
                SKScene * g1pluslosescene = [[G1PlusLoseScene alloc] initWithSize:self.size won:NO];
                [self.view presentScene:g1pluslosescene transition: reveal];
            }
            else
            {
                SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
                G1PlusFinishScene * g1plusfinishscene = [G1PlusFinishScene sceneWithSize:self.view.bounds.size];
                g1plusfinishscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g1plusfinishscene transition: reveal];
            }}];
        [target1 runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
    }
    if(r == 1)
    {
        SKSpriteNode * target2 = [SKSpriteNode spriteNodeWithImageNamed:@"Target2"];
        
        int minX = target2.size.width / 2;
        int maxX = self.frame.size.width - target2.size.width / 2;
        int rangeX = maxX - minX;
        int actualX = (arc4random() % rangeX) + minX;
        
        target2.position = CGPointMake(actualX, self.frame.size.height + target2.size.height/2);
        target2.name = @"target2";
        [self addChild:target2];
        
        target2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:target2.size];
        target2.physicsBody.dynamic = YES;
        target2.physicsBody.categoryBitMask = numberCategory;
        target2.physicsBody.contactTestBitMask = equalCategory;
        target2.physicsBody.collisionBitMask = 0;
        
        int minDuration = 8.0;
        int maxDuration = 14.0;
        int rangeDuration = maxDuration - minDuration;
        int actualDuration = (arc4random() % rangeDuration) + minDuration;
        
        SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX,-target2.size.height/2) duration:actualDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        
        SKAction * loseAction = [SKAction runBlock:^{
            if(count1 < 10)
            {
                SKTransition *reveal = [SKTransition doorsOpenVerticalWithDuration:0.5];
                SKScene * g1pluslosescene = [[G1PlusLoseScene alloc] initWithSize:self.size won:NO];
                [self.view presentScene:g1pluslosescene transition: reveal];
            }
            else
            {
                SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
                G1PlusFinishScene * g1plusfinishscene = [G1PlusFinishScene sceneWithSize:self.view.bounds.size];
                g1plusfinishscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g1plusfinishscene transition: reveal];
            }}];
        [target2 runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
    }
    if(r == 2)
    {
        SKSpriteNode * target3 = [SKSpriteNode spriteNodeWithImageNamed:@"Target3"];
        
        int minX = target3.size.width / 2;
        int maxX = self.frame.size.width - target3.size.width / 2;
        int rangeX = maxX - minX;
        int actualX = (arc4random() % rangeX) + minX;
        
        target3.position = CGPointMake(actualX, self.frame.size.height + target3.size.height/2);
        target3.name = @"target3";
        [self addChild:target3];
        
        target3.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:target3.size];
        target3.physicsBody.dynamic = YES;
        target3.physicsBody.categoryBitMask = numberCategory;
        target3.physicsBody.contactTestBitMask = equalCategory;
        target3.physicsBody.collisionBitMask = 0;
        
        int minDuration = 8.0;
        int maxDuration = 14.0;
        int rangeDuration = maxDuration - minDuration;
        int actualDuration = (arc4random() % rangeDuration) + minDuration;
        
        SKAction * actionMove = [SKAction moveTo:CGPointMake(actualX,-target3.size.height/2) duration:actualDuration];
        SKAction * actionMoveDone = [SKAction removeFromParent];
        
        SKAction * loseAction = [SKAction runBlock:^{
            if(count1 < 10)
            {
                SKTransition *reveal = [SKTransition doorsOpenVerticalWithDuration:0.5];
                SKScene * g1pluslosescene = [[G1PlusLoseScene alloc] initWithSize:self.size won:NO];
                [self.view presentScene:g1pluslosescene transition: reveal];
            }
            else
            {
                SKTransition *reveal = [SKTransition crossFadeWithDuration:0.5];
                G1PlusFinishScene * g1plusfinishscene = [G1PlusFinishScene sceneWithSize:self.view.bounds.size];
                g1plusfinishscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g1plusfinishscene transition: reveal];
            }}];
        [target3 runAction:[SKAction sequence:@[actionMove, loseAction, actionMoveDone]]];
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
        
        extern int count1;
        count1 = 0;
        extern int SCORE1;
        SCORE1 = 0;
        extern int COUNT1;
        COUNT1 = 0;
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
    if([target.name  isEqual:@"target1"])
    {
        [snowball removeFromParent];
        [target removeFromParent];
        
        self.numbersDestroyed +=1;
        self.result += 1;
        
        if (self.numbersDestroyed == c1)
        {
            if(count1 <= 10)
            {
                [self.resultLabel setText:[NSString stringWithFormat:@"%ld",(long)self.result]];
                
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                G1PlusWinScene * g1pluswinscene = [G1PlusWinScene sceneWithSize:self.view.bounds.size];
                g1pluswinscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g1pluswinscene transition: reveal];
                
                SCORE1 += 10;
            }
        }
        
        else if(self.numbersDestroyed > c1)
        {
            SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
            G1PlusGameOverScene * g1plusgameoverscene = [G1PlusGameOverScene sceneWithSize:self.view.bounds.size];
            g1plusgameoverscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g1plusgameoverscene transition: reveal];
        }
    }
    
    
    else if([target.name  isEqual:@"target2"])
    {
        [snowball removeFromParent];
        [target removeFromParent];
        
        self.numbersDestroyed +=2;
        self.result += 2;
        
        if (self.numbersDestroyed == c1)
        {
            if(count1 <= 10)
            {
                [self.resultLabel setText:[NSString stringWithFormat:@"%ld",(long)self.result]];
                
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                G1PlusWinScene * g1pluswinscene = [G1PlusWinScene sceneWithSize:self.view.bounds.size];
                g1pluswinscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g1pluswinscene transition: reveal];
                
                SCORE1 += 10;
            }
        }
        
        else if(self.numbersDestroyed > c1)
        {
            SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
            G1PlusGameOverScene * g1plusgameoverscene = [G1PlusGameOverScene sceneWithSize:self.view.bounds.size];
            g1plusgameoverscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g1plusgameoverscene transition: reveal];
        }
    }
    
    
    
    else if([target.name  isEqual:@"target3"])
    {
        [snowball removeFromParent];
        [target removeFromParent];
        
        self.numbersDestroyed +=3;
        self.result += 3;
        
        if (self.numbersDestroyed == c1)
        {
            if(count1 <= 10)
            {
                [self.resultLabel setText:[NSString stringWithFormat:@"%ld",(long)self.result]];
                
                SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
                G1PlusWinScene * g1pluswinscene = [G1PlusWinScene sceneWithSize:self.view.bounds.size];
                g1pluswinscene.scaleMode = SKSceneScaleModeAspectFill;
                [self.view presentScene:g1pluswinscene transition: reveal];
                
                SCORE1 += 10;
            }
        }
        
        else if(self.numbersDestroyed > c1)
        {
            SKTransition *reveal = [SKTransition doorsOpenHorizontalWithDuration:0.5];
            G1PlusGameOverScene * g1plusgameoverscene = [G1PlusGameOverScene sceneWithSize:self.view.bounds.size];
            g1plusgameoverscene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:g1plusgameoverscene transition: reveal];
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
