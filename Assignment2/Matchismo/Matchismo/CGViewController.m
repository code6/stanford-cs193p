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

@end

@implementation CGViewController

- (CGCardMatchingGame *)game
{
    if (!_game) _game = [[CGCardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                            usingDeck:[self createDeck]];
    return _game;
}

- (CGDeck *)createDeck
{
    return [[CGPlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)button
{
    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:button];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton * cardButton in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        CGCard * card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    }
}

- (NSString *)titleForCard:(CGCard *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(CGCard *)card
{
    return [UIImage imageNamed:card.isChosen ? @"card_front" : @"card_back"];
}

@end
