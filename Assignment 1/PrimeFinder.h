//
//  PrimeFinder.h
//  Assignment 1
//
//  Created by Jeffrey Klarfeld on 1/15/14.
//  Copyright (c) 2014 Jeffrey Klarfeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface PrimeFinder : NSObject

@property (atomic, strong) AppDelegate *del;
@property (atomic, strong) NSNumber *numPrimesFound;
@property (atomic, strong) NSMutableArray *allPrimes;
- (PrimeFinder *)init;

- (void)findPrimesFrom:(NSDecimalNumber *)start upTo:(NSDecimalNumber *)finish;

- (NSArray *)lastTenPrimesFound;

- (NSNumber *)sumOfAllPrimes;

@end
