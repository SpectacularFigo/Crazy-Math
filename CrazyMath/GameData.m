//
//  GameData.m
//  HopHero2
//
//  Created by BC on 12/24/14.
//  Copyright (c) 2014 BenCodes. All rights reserved.
//

#import "GameData.h"

@interface GameData ()
@property NSString *filePath;
@end

@implementation GameData

+ (id)data
{
    // Note: 'new' is short for 'alloc init'
    GameData *data = [GameData new];
    
    // Gets paths in NSDocumentDirectory where our data can be saved
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *fileName = @"archive.data";
    
    data.filePath = [path stringByAppendingString:fileName];
    
    return data;
}

- (void)save
{
    NSNumber *highScoreObject = [NSNumber numberWithInt:self.highScore];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:highScoreObject];
    [data writeToFile:self.filePath atomically:YES];
}

- (void)load
{
    NSData *data = [NSData dataWithContentsOfFile:self.filePath];
    NSNumber *highScoreObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.highScore = highScoreObject.intValue;
}

@end
