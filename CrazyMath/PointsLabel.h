//
//  PointsLabel.h
//  HopHero2
//
//  Created by BC on 12/23/14.
//  Copyright (c) 2014 BenCodes. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PointsLabel : SKLabelNode

@property int number;


+ (id)pointsLabelWithFontNamed:(NSString *)fontName;
- (void)increment;
- (void)setPoints:(int)points;
- (void)reset;



@end
