//
//  CGDeck.h
//  Matchismo
//
//  Created by Jobert Sá on 4/7/14.
//  Copyright (c) 2014 http://codespark.co <*> codespark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGCard.h"

@interface CGDeck : NSObject

- (void)addCard:(CGCard *)card atTop:(BOOL)atTop;
- (void)addCard:(CGCard *)card;

- (CGCard *)drawRandomCard;

@end
