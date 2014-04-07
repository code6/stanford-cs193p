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

- (IBAction)touchCardButton:(UIButton *)button
{
    if ([button.currentTitle length])
    {
        [button setBackgroundImage:[UIImage imageNamed:@"card_back"]
                          forState:UIControlStateNormal];
        [button setTitle:@"" forState:UIControlStateNormal];
        self.flipCount++;
    }
    else
    {
        CGCard * playingCard = [self.deck drawRandomCard];
        if (playingCard) {
            [button setBackgroundImage:[UIImage imageNamed:@"card_front"]
                              forState:UIControlStateNormal];
            [button setTitle:playingCard.contents forState:UIControlStateNormal];
            self.flipCount++;
        }
        else {
            // All cards were drawn - disable button
            [button setEnabled:NO];
        }
    }
}

@end
