//
//  AppDelegate.m
//  Assignment 1
//
//  Created by Jeffrey Klarfeld on 1/13/14.
//  Copyright (c) 2014 Jeffrey Klarfeld. All rights reserved.
//

#import "AppDelegate.h"
#import "PrimeFinder.h"

@implementation AppDelegate

@synthesize debugBox = _debugBox;
@synthesize textView = _textView;
@synthesize threadsAlloced = _threadsAlloced;

PrimeFinder *calculator;

int threadsAllocated = 0;
bool complete = NO;

NSDate *start;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
	[_debugBox setDrawsBackground:YES];
	[_debugBox setBackgroundColor:[NSColor blackColor]];
	
	NSSize contentSize = [_debugBox contentSize];
	
	_textView = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, contentSize.height, contentSize.width)];
	
	[_textView setMinSize:NSMakeSize(0.0, contentSize.height)];
	[_textView setMaxSize:NSMakeSize(FLT_MAX, FLT_MAX)];
	[_textView setVerticallyResizable:YES];
	[_textView setHorizontallyResizable:NO];
	[_textView setAutoresizingMask:NSViewWidthSizable];
	
	[[_textView textContainer]
	 setContainerSize:NSMakeSize(contentSize.width, FLT_MAX)];
	[[_textView textContainer] setWidthTracksTextView:YES];
	[_textView setBackgroundColor:[NSColor blackColor]];
	[_textView setTextColor:[NSColor whiteColor]];
	
	[_debugBox setDocumentView:_textView];
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(threadCompleted)
												 name:@"threadCompleted"
											   object:nil];
	_threadsAlloced = [[NSNumber alloc] initWithInt:0];
	
	[self addObserver:self forKeyPath:@"threadsAlloced" options:NSKeyValueObservingOptionNew context:nil];
	//[self redirectConsoleLogToDocumentFolder];
}

- (void) redirectConsoleLogToDocumentFolder
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														 NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"assignment1.log"];
	freopen([logPath fileSystemRepresentation],"a+",stderr);
}

- (IBAction)CalculateButton:(NSButton *)sender
{
	complete = NO;
	if (calculator)
	{
		calculator = nil;
	}
	calculator = [[PrimeFinder alloc] init];
	
	NSLock *printLock = [[NSLock alloc] init];
	[printLock lock];
	[self PrintText:@"Running..." andAlsoToScreen:YES];
	[printLock unlock];
	[self threadAllocator];
	//[self watchForThreadsFinished];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	int threads = [[change objectForKey:@"new"] intValue];
	//[NSThread sleepForTimeInterval:2];
	if (threads == 0)
	{
		NSLock *printLock = [[NSLock alloc] init];
		NSDate *stopDate = [NSDate date];
		NSTimeInterval finalTime = [stopDate timeIntervalSinceDate:start];
		NSLog(@"finalTime: %f", finalTime);
		if (finalTime > 0.0)
		{
			[NSThread sleepForTimeInterval:3];
			[printLock lock];
			[self PrintText:@"All threads completed" andAlsoToScreen:NO];
			[printLock unlock];
			[self printOutPut:finalTime];
		}
	}
}

- (void)threadAllocator
{
	start = [NSDate date];
	//for (int exp=0; exp < 6; exp++)
	int exp = 7;
	while (exp >= 0)
	{
		
		NSDecimalNumber *lowerBound = [NSDecimalNumber decimalNumberWithMantissa:1 exponent:exp isNegative:NO];
		NSDecimalNumber *lowerMiddleBound = [NSDecimalNumber decimalNumberWithMantissa:5 exponent:exp isNegative:NO];
		NSDecimalNumber *upperBound = [NSDecimalNumber decimalNumberWithMantissa:10 exponent:exp isNegative:NO];
		//NSLog(@"from: %@ to: %@", lowerBound, upperBound);
		
		if (_threadsAlloced < [NSNumber numberWithInt:7])
		{
			NSArray *lowerArguments = [[NSArray alloc] initWithObjects:lowerBound, lowerMiddleBound, nil];
			[NSThread detachNewThreadSelector:@selector(startThread:) toTarget:self withObject:lowerArguments];

			NSArray *upperArguments = [[NSArray alloc] initWithObjects:lowerMiddleBound, upperBound, nil];
			[NSThread detachNewThreadSelector:@selector(startThread:) toTarget:self withObject:upperArguments];
			_threadsAlloced = [NSNumber numberWithInt:_threadsAlloced.intValue + 2];
			
			exp--;
		}
		/*else
		{
			NSLog(@"Max threads allocated, rolling back");
			exp--;
		}*/
	}
}

- (void)startThread:(NSArray *)args
{
	[calculator findPrimesFrom:[args objectAtIndex:0] upTo:[args objectAtIndex:1]];
}

- (void)PrintText:(NSString *)text andAlsoToScreen:(BOOL)toScreen
{
	NSLog(@"%@", text);
	if (toScreen)
	{
		[_textView insertText:[NSString stringWithFormat:@"\n%@", text]];
	}
}

- (void)threadCompleted
{
	if (_threadsAlloced > [NSNumber numberWithInt:0])
	{
		NSLock *countLock = [[NSLock alloc] init];
		[countLock lock];
		//NSLog(@"threadCompleted(Before): %@", _threadsAlloced);
		[self willChangeValueForKey:@"threadsAlloced"];
		_threadsAlloced = [NSNumber numberWithInt:_threadsAlloced.intValue - 1];
		[self didChangeValueForKey:@"threadsAlloced"];
		//NSLog(@"threadCompleted(After): %@", _threadsAlloced);
		[countLock unlock];
	}
}

- (void)printOutPut:(NSTimeInterval)time
{
	//[NSThread sleepForTimeInterval:3];
	NSLock *printLock = [[NSLock alloc] init];
	[printLock lock];
	[self PrintText:[NSString stringWithFormat:@"Number of primes Found: %@", calculator.numPrimesFound] andAlsoToScreen:NO];
	[self PrintText:[NSString stringWithFormat:@"Last ten primes Found: %@", [calculator lastTenPrimesFound]] andAlsoToScreen:NO];
	[self PrintText:[NSString stringWithFormat:@"Time taken (in seconds): %f", time] andAlsoToScreen:NO];
	[printLock unlock];
}
@end
