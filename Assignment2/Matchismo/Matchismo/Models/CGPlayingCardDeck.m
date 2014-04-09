//
//  CGPlayingCardDeck.m
//  Matchismo
//
//  Created by Jobert Sá on 4/7/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CGPlayingCardDeck.h"
#import "CGPlayingCard.h"

@implementation CGPlayingCardDeck

- (instancetype)init
{
    if ((self = [super init])) {
        for (NSString * suit in [CGPlayingCard validSuits]) {
            for (NSUInteger rank = 1; rank <= [CGPlayingCard maxRank]; rank++) {
                CGPlayingCard * card = [[CGPlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                [self addCard:card];
            }
        }
    }
    
    return self;
}

@end
