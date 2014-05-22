//
//  RecordingWidgetView.m
//  Capture It
//
//  Created by Himanshu on 12/16/13.
//  Copyright (c) 2013 com.thinksys. All rights reserved.
//

#import "RecordingWidgetView.h"

@implementation RecordingWidgetView

@synthesize delegate;

@synthesize statusItemOriginX, statusItemOriginY;

- (id)initWithFrame:(NSRect)frame isScreenCropped:(BOOL)cropped areaCropped:(NSRect)rect optionSelected:(NSString *)option
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        
        
        didScreenCropped = cropped;
        
        croppedOrFullScreenRect = rect;
        
        optionSelected = option;
        
        
        playAndCaptureButton = [[NSButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        
        [playAndCaptureButton setFrameOrigin:NSMakePoint((NSWidth([self bounds]) - NSWidth([playAndCaptureButton frame])) / 2, (NSHeight([self bounds]) - NSHeight([playAndCaptureButton frame])) / 2)];
        [playAndCaptureButton setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin];
        
        if([optionSelected isEqualToString:@"movie"])
        {
            [playAndCaptureButton setImage:[NSImage imageNamed:@"play_low.png"]];
        }
        else
        {
            [playAndCaptureButton setImage:[NSImage imageNamed:@"capture_low.png"]];
        }
        
        [playAndCaptureButton setButtonType:NSMomentaryChangeButton];
        [playAndCaptureButton setBordered:NO];
        [[playAndCaptureButton cell] setImageScaling:NSImageScaleAxesIndependently];
        [playAndCaptureButton setToolTip:@"Start Recording"];
        if([optionSelected isEqualToString:@"movie"])
        {
            [playAndCaptureButton setAction:@selector(startRecording:)];
        }
        else
        {
            [playAndCaptureButton setAction:@selector(startCapture:)];
        }
        
        [playAndCaptureButton setTarget:self];
        [playAndCaptureButton setTag:1];
        [self addSubview:playAndCaptureButton];
        
        
        trackingAreaForPlayBtn = [[NSTrackingArea alloc] initWithRect:[playAndCaptureButton frame] options:NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
        [self addTrackingArea:trackingAreaForPlayBtn];
        
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    
    if(didScreenCropped)
    {
        [[NSColor clearColor] setFill];
        NSRectFill(dirtyRect);
        
    }
    else
    {
        [[[NSColor blackColor] colorWithAlphaComponent:0.0f] setFill];
        NSRectFill(dirtyRect);
    }
   
}

-(void)startCapture:(id)sender
{
    [self removeFromSuperview];
    
    [delegate captureButtonActionForRect:croppedOrFullScreenRect];
}

-(void)startRecording:(id)sender 
{
    NSLog(@"Recording Started");
    

    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        [self removeFromSuperview];
    }];
    [[NSAnimationContext currentContext] setDuration:0.2f];
    [self.animator setFrameOrigin:NSMakePoint(statusItemOriginX, statusItemOriginY)];
    [self.animator setAlphaValue:0.0f];
    [NSAnimationContext endGrouping];

    
    [delegate didRecordingStarted:YES];
    [delegate makeBorderAnimation];
    
    //Delegate Method for the Recording
    [delegate recordButtonActionForRect:croppedOrFullScreenRect didRemoveSuperView:!didScreenCropped];
    
    
}

-(void)stopRecording:(id)sender
{
    NSLog(@"Stop Recording");
    
    [delegate didRecordingStarted:NO];
    
    [delegate stopButtonActionForRecording];
}

-(void)mouseEntered:(NSEvent *)theEvent
{
    if([optionSelected isEqualToString:@"movie"])
    {
        [playAndCaptureButton setImage:[NSImage imageNamed:@"play.png"]];
    }
    else
    {
        [playAndCaptureButton setImage:[NSImage imageNamed:@"capture.png"]];
    }
    
}

-(void)mouseExited:(NSEvent *)theEvent
{
    if([optionSelected isEqualToString:@"movie"])
    {
        [playAndCaptureButton setImage:[NSImage imageNamed:@"play_low.png"]];
    }
    else
    {
        [playAndCaptureButton setImage:[NSImage imageNamed:@"capture_low.png"]];
    }
}

-(void)addMoveAnimationForPlayBtnLayer
{
    
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath,NULL,playAndCaptureButton.frame.origin.x, playAndCaptureButton.frame.origin.y);
    CGPathAddLineToPoint(thePath, NULL, 500.0, 500.0);
    
    CAKeyframeAnimation *theAnimation;
    
    // Create the animation object, specifying the position property as the key path.
    theAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    theAnimation.path=thePath;
    theAnimation.duration=1.0;
    
    // Add the animation to the layer.
    [playAndCaptureButton.layer addAnimation:theAnimation forKey:@"position"];
    
}

@end
