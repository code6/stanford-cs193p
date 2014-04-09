//
//  CGCardMatchingGame.h
//  Matchismo
//
//  Created by Jobert Sá on 4/9/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGDeck.h"
#import "CGCard.h"

@interface CGCardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(CGDeck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (CGCard *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;

@end
