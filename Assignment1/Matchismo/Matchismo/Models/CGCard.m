//
//  CGCard.m
//  Matchismo
//
//  Created by Jobert Sá on 4/7/14.
//  Copyright (c) 2014 CS193p. All rights reserved.
//

#import "CGCard.h"

@implementation CGCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (CGCard * card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    
    return score;
}

@end
