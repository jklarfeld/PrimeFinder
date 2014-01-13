//
//  AppDelegate.h
//  Assignment 1
//
//  Created by Jeffrey Klarfeld on 1/13/14.
//  Copyright (c) 2014 Jeffrey Klarfeld. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSScrollView *debugBox;

@property (strong) NSTextView *textView;

- (IBAction)CalculateButton:(NSButton *)sender;

@end
