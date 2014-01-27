//
//  PrimeFinder.m
//  Assignment 1
//
//  Created by Jeffrey Klarfeld on 1/15/14.
//  Copyright (c) 2014 Jeffrey Klarfeld. All rights reserved.
//

#import "PrimeFinder.h"

@implementation PrimeFinder

@synthesize del = _del;
@synthesize numPrimesFound = _numPrimesFound;
@synthesize allPrimes = _allPrimes;

- (PrimeFinder *)init
{
	self = [super init];
	if (self)
	{
		_numPrimesFound = [[NSNumber alloc] initWithInt:1];
		_allPrimes = [[NSMutableArray alloc] init];
		[_allPrimes addObject:[NSNumber numberWithInt:2]];
		return self;
	}
	else
	{
		return nil;
	}
}

- (void)findPrimesFrom:(NSDecimalNumber *)start upTo:(NSDecimalNumber *)finish
{
	@synchronized(self)
	{
		NSMutableArray *returnArray = [[NSMutableArray alloc] init];
		
		int starting = start.intValue;
		
		if (start.intValue%2 == 0)
		{
			starting++;
		}
		
		NSLock *arrayLock = [[NSLock alloc] init];
		
		for (int i=starting; i<finish.intValue; i=i+2)
		{
			//NSLog(@"Testing %d for primality..", i);
			
			if ([self isPrime:i] && i != 0 && i != 1)
			{
				//NSLog(@"%d is prime!", i);
				[returnArray addObject:[NSNumber numberWithInt:i]];
				
				NSLock *numberLock = [[NSLock alloc] init];
				
				[numberLock lock];
				_numPrimesFound = [NSNumber numberWithInt:_numPrimesFound.intValue+1];
				[numberLock unlock];
			}
		}
		
		[arrayLock lock];
		[_allPrimes addObjectsFromArray:returnArray.copy];
		[arrayLock unlock];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"threadCompleted" object:self];
	}
}

- (BOOL)isPrime:(int)number
{
	if (number == 3 || number == 2)
	{
		return YES;
	}
	
	if (number%3 == 0)
	{
		return NO;
	}
	
	int i = 5;
	int w = 2;
	
	while (i*i <= number)
	{
		if (number%i == 0)
		{
			return NO;
		}
		
		i+=w;
		w = 6 - w;
	}
	return YES;
}

- (BOOL)isThisNumberPrime:(int)number
{
	for (int i=2; i<number/2; i++)
	{
		if (number%i == 0)
		{
			return NO;
		}
	}
	return YES;
}

- (NSArray *)lastTenPrimesFound
{
	//return all for now, finish later
	NSMutableArray *lastTen = [[NSMutableArray alloc] init];
	
	for (NSUInteger i=_allPrimes.count-1; i>_allPrimes.count-10; i--)
	{
		NSLock *arrayLock = [[NSLock alloc] init];
		
		[arrayLock lock];
		[lastTen addObject:[_allPrimes objectAtIndex:i]];
		[arrayLock unlock];
	}
	
    NSSortDescriptor *desc = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    NSArray *descriptors = [[NSArray alloc] initWithObjects:desc, nil];
    
	return [lastTen sortedArrayUsingDescriptors:descriptors];
}

- (NSNumber *)sumOfAllPrimes
{
    int tempSum = 0;
    
    for (NSNumber *aNum in _allPrimes)
    {
        tempSum += aNum.intValue;
    }
    
    return [NSNumber numberWithInt:tempSum];
}

@end
