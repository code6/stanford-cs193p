//
//  CGCardMatchingGame.h
//  Matchismo
//
//  Created by Jobert Sá on 4/9/14.
//  Copyright (c) 2014 http://codespark.co <*> codespark. All rights reserved.
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

@property (nonatomic, readonly) NSInteger pointsForCurrentMove;
@property (nonatomic, readonly) NSInteger score;
//@property (nonatomic, readonly) NSString * result
/*
 * 2 for 2-card match
 * 3 for 3-card match
 * Other values will be ignored
 */
@property (nonatomic) NSUInteger matchMode;

@end
