//
//  CGViewController.m
//  Matchismo
//
//  Created by Jobert Sá on 4/7/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CGViewController.h"
#import "CGPlayingCardDeck.h"
#import "CGCardMatchingGame.h"

@interface CGViewController ()

@property (strong, nonatomic) CGCardMatchingGame * game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchModeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) NSMutableString * chosenCardsContents;
@property (weak, nonatomic) CGCard * lastCardChosen;

@end

@implementation CGViewController

- (NSMutableString *)chosenCardsContents
{
    if (!_chosenCardsContents) _chosenCardsContents = [[NSMutableString new] init];
    return _chosenCardsContents;
}

- (CGCardMatchingGame *)game
{
    if (!_game) _game = [self newGame];
    return _game;
}

- (CGCardMatchingGame *)newGame
{
    CGCardMatchingGame * newGame = [[CGCardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                                       usingDeck:[self createDeck]];
    newGame.matchMode = self.matchModeSegmentedControl.selectedSegmentIndex == 0 ? 2 : 3;
    self.chosenCardsContents = nil;
    return newGame;
}

- (CGDeck *)createDeck
{
    return [[CGPlayingCardDeck alloc] init];
}

- (IBAction)changeMatchMode:(UISegmentedControl *)sender
{
    self.game.matchMode = sender.selectedSegmentIndex == 0 ? 2 : 3;
}


- (IBAction)deal:(UIButton *)sender
{
    self.matchModeSegmentedControl.enabled = YES;
    self.game = [self newGame];
    [self updateUI];
}

- (IBAction)touchCardButton:(UIButton *)button
{
    self.matchModeSegmentedControl.enabled = NO;
    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:button];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (void)updateUI
{
    self.resultLabel.text = [self titleForResultOfLastMove];
    for (UIButton * cardButton in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        CGCard * card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}

- (NSString *)titleForCard:(CGCard *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(CGCard *)card
{
    return [UIImage imageNamed:card.isChosen ? @"card_front" : @"card_back"];
}

- (NSString *)titleForResultOfLastMove
{
    NSString * result = @"";
    NSMutableArray * chosenCards = [[NSMutableArray alloc] init];
    for (UIButton * cardButton in self.cardButtons) {
        if (cardButton.isEnabled) { // Means it's not matched
            NSUInteger indexOfCard = [self.cardButtons indexOfObject:cardButton];
            CGCard * card = [self.game cardAtIndex:indexOfCard];
            if (card.isChosen) [chosenCards addObject:card];
        }
    }
    if ([chosenCards count]) {
        if (!self.game.pointsForLastMove) self.chosenCardsContents = nil;
        for (CGCard * card in chosenCards) {
            if ([self.chosenCardsContents rangeOfString:card.contents].location == NSNotFound) {
                [self.chosenCardsContents appendFormat:@" %@", card.contents];
                self.lastCardChosen = card;
            }
        }
        result = self.chosenCardsContents;
        if (self.game.pointsForLastMove > 0) {
            result = [NSString stringWithFormat:@"Matched %@ for %ld points!", self.chosenCardsContents, (long)self.game.pointsForLastMove];
            self.chosenCardsContents = nil;
        }
        else if (self.game.pointsForLastMove < 0) {
            result = [NSString stringWithFormat:@"%@ don't match! Penalty: %ld points", self.chosenCardsContents, (long)self.game.pointsForLastMove];
            self.chosenCardsContents = self.lastCardChosen.contents.mutableCopy;
        }
    }
    return result;
}

@end
