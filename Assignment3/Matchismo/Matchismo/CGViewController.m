//
//  CGViewController.m
//  Matchismo
//
//  Created by Jobert Sá on 4/7/14.
//  Copyright (c) 2014 http://codespark.co <*> codespark. All rights reserved.
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
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (strong, nonatomic) NSMutableString * chosenCardsContents;
@property (weak, nonatomic) CGCard * currentChosenCard;
@property (strong, nonatomic) NSMutableArray * history;

@end

@implementation CGViewController

- (NSMutableArray *)history
{
    if (!_history) _history = [[NSMutableArray alloc] init];
    return _history;
}

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
    self.history = nil;
    return newGame;
}

- (CGDeck *)createDeck
{
    return [[CGPlayingCardDeck alloc] init];
}

- (IBAction)slideHistory:(UISlider *)sender
{
    
    [self.historySlider setValue:(int) roundf(self.historySlider.value) animated:NO];
    [self updateResults];
}

- (void)updateResults
{
    self.resultLabel.text = (NSString *)self.history[(int)self.historySlider.value];
    self.resultLabel.textColor = (self.historySlider.value == ([self.history count] - 1)) ? [UIColor whiteColor] : [UIColor lightGrayColor];
}

- (IBAction)changeMatchMode:(UISegmentedControl *)sender
{
    self.game.matchMode = sender.selectedSegmentIndex == 0 ? 2 : 3;
}


- (IBAction)deal:(UIButton *)sender
{
    self.game = [self newGame];
    [self updateUI];
}

- (IBAction)touchCardButton:(UIButton *)button
{
    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:button];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (void)updateUI
{
    [self.history addObject:[self titleForResultOfCurrentMove]];
    self.matchModeSegmentedControl.enabled = [self.history count] == 1;
    self.historySlider.enabled = [self.history count] > 1;
    self.historySlider.maximumValue = ([self.history count] - 1);
    self.historySlider.value = self.historySlider.maximumValue;
    [self updateResults];
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

- (NSString *)titleForResultOfCurrentMove
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
        // Clear and add chosen cards. So, in case user deselect a card, it'll be consistent
        if (!self.game.pointsForCurrentMove) self.chosenCardsContents = nil;
        for (CGCard * card in chosenCards) {
            if ([self.chosenCardsContents rangeOfString:card.contents].location == NSNotFound) {
                [self.chosenCardsContents appendFormat:@" %@", card.contents];
                self.currentChosenCard = card;
            }
        }
        result = self.chosenCardsContents;
        if (self.game.pointsForCurrentMove > 0) {
            result = [NSString stringWithFormat:@"Matched %@ for %ld points!", self.chosenCardsContents, (long)self.game.pointsForCurrentMove];
            self.chosenCardsContents = nil;
        } else if (self.game.pointsForCurrentMove < 0) {
            result = [NSString stringWithFormat:@"%@ don't match! Penalty: %ld points", self.chosenCardsContents, (long)self.game.pointsForCurrentMove];
            // Because it was cleared, so put the current chosen card back there
            self.chosenCardsContents = self.currentChosenCard.contents.mutableCopy;
        } else {
            result = [@"Chose: " stringByAppendingString:self.chosenCardsContents];
        }
    }
    else {
        result = @"No card chosen";
    }
    // If there's no card chosen, then clear the label
    return result;
}

@end
