//
//  CGCardMatchingGame.m
//  Matchismo
//
//  Created by Jobert Sá on 4/9/14.
//  Copyright (c) 2014 http://codespark.co <*> codespark. All rights reserved.
//

#import "CGCardMatchingGame.h"

@interface CGCardMatchingGame()

@property (nonatomic, readwrite) NSInteger pointsForCurrentMove;
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
    self.pointsForCurrentMove = 0;
    CGCard * card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            // Take all the chosen cards which are not matched into an array
            NSMutableArray * chosenCards = [[NSMutableArray alloc] init];
            for (CGCard * otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [chosenCards addObject:otherCard];
                    if ([chosenCards count] == (self.matchMode - 1)) break;
                }
            }
            // Check matches if number of chosen cards is according to match mode
            if ([chosenCards count] == (self.matchMode - 1)) {
                // Match against other chosen cards
                int matchScore = [card match:chosenCards];
                // Set cards matched and chosen according to the match result
                card.matched = matchScore;
                for (CGCard * chosenCard in chosenCards) {
                    chosenCard.matched = matchScore;
                    chosenCard.chosen = matchScore;
                }
                self.pointsForCurrentMove = matchScore ? (matchScore * MATCH_BONUS) : (self.matchMode * -MISMATCH_PENALTY);
                self.score += self.pointsForCurrentMove;
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
