//
//  GameData.h
//  HopHero2
//
//  Created by BC on 12/24/14.
//  Copyright (c) 2014 BenCodes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject

@property int highScore;

+ (id)data;
- (void)save;
- (void)load;

@end
