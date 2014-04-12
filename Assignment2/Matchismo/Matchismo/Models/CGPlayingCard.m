//
//  CGPlayingCard.m
//  Matchismo
//
//  Created by Jobert Sá on 4/7/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CGPlayingCard.h"

@implementation CGPlayingCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    if ([otherCards count] == 1) {
        CGPlayingCard * otherCard = [otherCards firstObject];
        if (otherCard.rank == self.rank) {
            score = 4;
        } else if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1;
        }
    } else {
        CGPlayingCard * firstOfOtherCards = [otherCards firstObject];
        NSMutableArray * mutableOtherCards = [NSMutableArray arrayWithArray:otherCards];
        [mutableOtherCards removeObject:firstOfOtherCards];
        // Result is the sum of the matches between all chosen cards
        return [self match:@[firstOfOtherCards]] + [self match:mutableOtherCards] + [firstOfOtherCards match:mutableOtherCards];
    }
    return score;
}

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
