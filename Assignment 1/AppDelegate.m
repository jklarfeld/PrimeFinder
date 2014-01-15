//
//  AppDelegate.m
//  Assignment 1
//
//  Created by Jeffrey Klarfeld on 1/13/14.
//  Copyright (c) 2014 Jeffrey Klarfeld. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize debugBox = _debugBox;
@synthesize textView = _textView;

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

}

- (IBAction)CalculateButton:(NSButton *)sender
{
	[self PrintText:@"hergderg"];
}

- (void)PrintText:(NSString *)text
{
	[_textView insertText:[NSString stringWithFormat:@"\n%@", text]];
}
@end
