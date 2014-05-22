//
//  CaptureItContentView.m
//  Capture It
//
//  Created by Himanshu on 2/10/14.
//  Copyright (c) 2014 com.thinksys. All rights reserved.
//

#import "CaptureItContentView.h"

@implementation CaptureItContentView

@synthesize delegate;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setWantsLayer:YES];
        [self.layer setCornerRadius:5.0f];
        [self.layer setBorderColor:[NSColor whiteColor].CGColor];
        [self.layer setBorderWidth:1.0f];
        [self.layer setBackgroundColor:[NSColor colorWithDeviceRed:9.0f/255.0f green:61.0/255.0f blue:96.0/255.0f alpha:1.0f].CGColor];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
}

-(void)mouseDown:(NSEvent *)theEvent
{
    NSLog(@"Mouse Down");
    [delegate removeSettingView];
}

-(void)mouseUp:(NSEvent *)theEvent
{
    [delegate moveWindow];
}

@end
