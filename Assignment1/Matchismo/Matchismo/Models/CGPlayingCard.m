//
//  CGPlayingCard.m
//  Matchismo
//
//  Created by Jobert Sá on 4/7/14.
//  Copyright (c) 2014 http://codespark.co <*> codespark. All rights reserved.
//

#import "CGPlayingCard.h"

@implementation CGPlayingCard

- (NSString *)contents
{
    NSArray * rankStrings = [CGPlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    return @[@"♠️", @"♥️", @"♣️", @"♦️"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[CGPlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank { return [[self rankStrings] count] - 1; }

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [CGPlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
