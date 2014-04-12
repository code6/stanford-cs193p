//
//  CGCardMatchingGame.m
//  Matchismo
//
//  Created by Jobert Sá on 4/9/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CGCardMatchingGame.h"

@interface CGCardMatchingGame()

@property (nonatomic, readwrite) NSInteger pointsForLastMove;
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray * cards; // of CGCard

@end

@implementation CGCardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(CGDeck *)deck
{
    self = [super init];
    if (self) {
        for (NSUInteger i = 0; i < count; i++) {
            CGCard * card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    return self;
}

- (CGCard *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 1;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    self.pointsForLastMove = 0;
    CGCard * card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            // match against other chosen cards
            NSMutableArray * chosenCards = [[NSMutableArray alloc] init];
            for (CGCard * otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [chosenCards addObject:otherCard];
                    if ([chosenCards count] == (self.matchMode - 1)) break;
                }
            }
            if ([chosenCards count] == (self.matchMode - 1)) {
                int matchScore = [card match:chosenCards];
                card.matched = matchScore;
                for (CGCard * chosenCard in chosenCards) {
                    chosenCard.matched = matchScore;
                    chosenCard.chosen = matchScore;
                }
                self.pointsForLastMove = matchScore ? (matchScore * MATCH_BONUS) : (self.matchMode * -MISMATCH_PENALTY);
                self.score += self.pointsForLastMove;
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

- (void)setMatchMode:(NSUInteger)matchMode
{
    if (matchMode == 2 || matchMode == 3) {
        _matchMode = matchMode;
    }
}

@end
