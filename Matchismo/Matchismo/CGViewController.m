//
//  CGViewController.m
//  Matchismo
//
//  Created by Jobert Sá on 4/7/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CGViewController.h"
#import "CGPlayingCardDeck.h"

@interface CGViewController ()

@property (weak, nonatomic) IBOutlet UILabel * flipsLabel;
@property (nonatomic) NSUInteger flipCount;
@property (strong, nonatomic) CGPlayingCardDeck * deck;

@end

@implementation CGViewController

- (CGPlayingCardDeck *)deck
{
    if (!_deck) _deck = [[CGPlayingCardDeck alloc] init];
    return _deck;
}

- (void)setFlipCount:(NSUInteger)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %lu", (unsigned long)flipCount];
    NSLog(@"flipCount changed to %lu", self.flipCount);
}

- (void)flipCardButton:(UIButton *)button
              withCard:(CGCard *)card
{
    if (card || [button.currentTitle length]) { // Has next card
        [button setBackgroundImage:[UIImage imageNamed:(card ? @"card_front" : @"card_back")]
                          forState:UIControlStateNormal];
        [button setTitle:card.contents forState:UIControlStateNormal];
        self.flipCount++;
    }
    else {
        [button setEnabled:NO];
    }
}

- (IBAction)touchCardButton:(UIButton *)button
{
    [self flipCardButton:button
                withCard:([button.currentTitle length] ? nil : [self.deck drawRandomCard])];
}

@end
