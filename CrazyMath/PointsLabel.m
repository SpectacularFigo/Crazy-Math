//
//  PointsLabel.m
//  HopHero2
//
//  Created by BC on 12/23/14.
//  Copyright (c) 2014 BenCodes. All rights reserved.
//

#import "PointsLabel.h"

@implementation PointsLabel

+ (id)pointsLabelWithFontNamed:(NSString *)fontName
{
    PointsLabel *pointsLabel = [PointsLabel labelNodeWithFontNamed:fontName];
    pointsLabel.text = @"0";
    pointsLabel.number = 0;
    return pointsLabel;
}

- (void)increment
{
    self.number++;
    self.text = [NSString stringWithFormat:@"%i", self.number];
    
}

- (void)setPoints:(int)points
{
    self.number = points;
    self.text = [NSString stringWithFormat:@"%i", self.number];
}

- (void)reset
{
    self.number = 0;
    self.text = @"0";
}
@end
