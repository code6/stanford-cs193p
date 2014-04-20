//
//  CGCard.h
//  Matchismo
//
//  Created by Jobert Sá on 4/7/14.
//  Copyright (c) 2014 http://codespark.co <*> codespark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGCard : NSObject

@property (strong, nonatomic) NSString * contents;

@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;

- (int)match:(NSArray *)otherCards;

@end
