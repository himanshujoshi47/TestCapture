//
//  SettingView.m
//  Capture It
//
//  Created by Himanshu on 11/25/13.
//  Copyright (c) 2013 com.thinksys. All rights reserved.
//

#import "SettingView.h"

@implementation SettingView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
    
    [[NSColor clearColor] setFill];
    
    NSRectFill(dirtyRect);
    
}

@end
