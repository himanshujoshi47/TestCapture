//
//  FullCustomScreenView.m
//  Capture It
//
//  Created by Himanshu on 12/12/13.
//  Copyright (c) 2013 com.thinksys. All rights reserved.
//

#import "FullCustomScreenView.h"


@implementation FullCustomScreenView

@synthesize recordingWidgetView;
@synthesize delegate;

@synthesize statusItemOriginX, statusItemOriginY;

- (id)initWithFrame:(NSRect)frame optionSelected:(NSString *)option
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        [self setWantsLayer:YES];
        
        isMouseDragged = NO;
        isRecordingStarted = NO;
        
        optionSelected = option;
        
        //[self createRecordingOrCaptureWidgetView];
        
        NSTrackingArea *fullScreenTrackingArea = [[NSTrackingArea alloc] initWithRect:[[NSScreen mainScreen] frame] options: (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingMouseMoved | NSTrackingCursorUpdate) owner:self userInfo:nil];
        
        [self addTrackingArea:fullScreenTrackingArea];
        
        trackingAreaRect = [[TrackingAreaRect alloc] init];
        
        [[NSCursor crosshairCursor] push];
        [[NSCursor crosshairCursor] set];
        
        screenText = [[NSTextField alloc] initWithFrame:NSMakeRect(0, self.frame.size.height/2, self.frame.size.width, 100)];
        [screenText setStringValue:@"Hold And Drag The Mouse To Select Area"];
        [screenText setFont:[NSFont fontWithName:@"Verdana-Bold" size:30.0f]];
        [screenText setTextColor:[NSColor whiteColor]];
        [screenText setAlignment:NSCenterTextAlignment];
        [screenText setEditable:NO];
        [screenText setBordered:NO];
        [screenText setBackgroundColor:[NSColor clearColor]];
        [self addSubview:screenText];
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    [[[NSColor blackColor] colorWithAlphaComponent:0.6f] setFill];
    NSRectFill(dirtyRect);
    
    
    if(isMouseDragged)
    {
        
        CGRect rectIntersection = CGRectIntersection(croppedRect, dirtyRect );
        [[NSColor clearColor] setFill];
        NSRectFill(rectIntersection);
        
        shapeLayer = [CAShapeLayer layer];
        [shapeLayer setPath:(__bridge CGPathRef)([NSBezierPath bezierPathWithRect:croppedRect])];
        [shapeLayer setFillColor:[[NSColor clearColor] CGColor]];
        [shapeLayer setStrokeColor:[[NSColor greenColor] CGColor]];
        [shapeLayer setLineWidth:2.0f];
        [shapeLayer setLineJoin:kCALineJoinRound];
        [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:10], [NSNumber numberWithInt:5], nil]];
        
        NSRect rect;
        
        
        // Setup the path
        CGMutablePathRef path = CGPathCreateMutable();
        if ((finalPoint.x - startingPoint.x) > 0 && (finalPoint.y - startingPoint.y) < 0)
        {
            rect = NSInsetRect(croppedRect, -3, 3);
        }
        else if ((finalPoint.x - startingPoint.x) < 0 && (finalPoint.y - startingPoint.y) > 0)
        {
            rect = NSInsetRect(croppedRect, 3, -3);
        }
        else if ((finalPoint.x - startingPoint.x) > 0 && (finalPoint.y - startingPoint.y) > 0)
        {
            rect = NSInsetRect(croppedRect, -3, -3);
        }
        else if ((finalPoint.x - startingPoint.x) < 0 && (finalPoint.y - startingPoint.y) < 0)
        {
            rect = NSInsetRect(croppedRect, 3, 3);
        }
        
        CGPathAddRect(path, NULL, rect);
        [shapeLayer setPath:path];
        CGPathRelease(path);
        
    }
    
    
}

-(void)mouseDown:(NSEvent *)theEvent
{
    if (![screenText isHidden]) {
        [screenText removeFromSuperview];
    }
    
    if(!CGRectContainsPoint(croppedRect, [NSEvent mouseLocation]))
    {
        if(recordingWidgetView.superview != nil)
        {
            [recordingWidgetView removeFromSuperview];
        }
        
        if(!isRecordingStarted)
        {
            startingPoint = [self convertPoint:[theEvent locationInWindow] fromView:self];
            
            NSLog(@"%f, %f", startingPoint.x, startingPoint.y);
            
            [trackingAreaRect setStartingXValue:startingPoint.x];
            [trackingAreaRect setStartingYValue:startingPoint.y];
            
        }
    }
    
    
    
    
}

-(void)mouseDragged:(NSEvent *)theEvent
{
    if(recordingWidgetView.superview != nil)
    {
        [recordingWidgetView removeFromSuperview];
    }
    
    if (!isRecordingStarted)
    {
        
        isMouseDragged = YES;
        
        finalPoint = [self convertPoint:[theEvent locationInWindow] fromView:self];
        
        [trackingAreaRect setFinalXValue:finalPoint.x];
        [trackingAreaRect setFinalYValue:finalPoint.y];
        
        croppedRect = CGRectMake(startingPoint.x, startingPoint.y, finalPoint.x - startingPoint.x, finalPoint.y - startingPoint.y);
        
        NSSize croppedRectNewSize = NSMakeSize(croppedRect.size.width + [theEvent deltaX], croppedRect.size.height - [theEvent deltaY]);
        croppedRect.size = croppedRectNewSize;
        
        [self setNeedsDisplay:YES];
        
        //Setting Tracking Area Option
        [trackingAreaRect setTrackingAreaOption];

    }
    
}


- (BOOL)acceptsFirstResponder
{
    return YES;
}

-(void)cursorUpdate:(NSEvent *)event
{
    [[NSCursor crosshairCursor] push];
    [[NSCursor crosshairCursor] set];
    
    if(CGRectContainsPoint([pauseAndResumeBtn frame], [NSEvent mouseLocation]))
    {
        [NSCursor pop];
    }

}


-(void)mouseEntered:(NSEvent *)theEvent
{
    [[NSCursor crosshairCursor] push];
    [[NSCursor crosshairCursor] set];
    
    if(CGRectContainsPoint([pauseAndResumeBtn frame], [NSEvent mouseLocation]))
    {
        [pauseAndResumeBtn setImage:[NSImage imageNamed:@"play.png"]];
    }
}


-(void)mouseExited:(NSEvent *)theEvent
{
    NSLog(@"Mouse Exited");
    [NSCursor pop];
    
    [pauseAndResumeBtn setImage:[NSImage imageNamed:@"pause.png"]];
}


-(void)mouseUp:(NSEvent *)theEvent
{
    NSLog(@"Mouse Up");
    
    [self createRecordingOrCaptureWidgetView];
    
}

-(void)createRecordingOrCaptureWidgetView
{
    if(!isRecordingStarted)
    {
        if(!isMouseDragged)
        {
            recordingWidgetView = [[RecordingWidgetView alloc] initWithFrame:NSMakeRect(0, 0, 50, 50) isScreenCropped:NO areaCropped:[[NSScreen mainScreen] frame] optionSelected:optionSelected];
            
            [recordingWidgetView setFrameOrigin:NSMakePoint((NSWidth([self bounds]) - NSWidth([recordingWidgetView frame])) / 2, (NSHeight([self bounds]) - NSHeight([recordingWidgetView frame])) / 2)];
            [recordingWidgetView setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin];
            
        }
        
        else
        {
            
            float originX = [trackingAreaRect getBottomLeftXCoords] + abs(croppedRect.size.width/2);
            float originY = [trackingAreaRect getBottomLeftYCoords] + abs(croppedRect.size.height/2);
            
            recordingWidgetView = [[RecordingWidgetView alloc] initWithFrame:NSMakeRect(originX - 25, originY - 25, 50, 50) isScreenCropped:YES areaCropped:croppedRect optionSelected:optionSelected];
            
        }
        
        [recordingWidgetView setDelegate:self];
        
        [recordingWidgetView setStatusItemOriginX:statusItemOriginX];
        [recordingWidgetView setStatusItemOriginY:statusItemOriginY];
        
        
        [self addSubview:recordingWidgetView];
        
    }
}


-(void)closeFullCustomScreenView
{
    if(self.superview != nil)
    {
        [self removeFromSuperview];
    }
}


//DELEGATES METHOD OF RECORDING WIDGET VIEW

-(void)captureButtonActionForRect:(NSRect)rect
{
    [NSCursor pop];
    
    [self removeFromSuperview];
    
    if (CGRectEqualToRect(rect, [[NSScreen mainScreen] frame])) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            [delegate startCaptureForRect:[[NSScreen mainScreen] frame]];
        });
    }
    
    else
    {
        startingPoint.y = [[NSScreen mainScreen] frame].size.height - startingPoint.y;
        finalPoint.y = [[NSScreen mainScreen] frame].size.height - finalPoint.y;
        
        NSRect selectedAreaRect = CGRectMake(startingPoint.x, startingPoint.y, (finalPoint.x - startingPoint.x), (finalPoint.y - startingPoint.y));
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [delegate startCaptureForRect:selectedAreaRect];
        });
    }
    
}


-(void)recordButtonActionForRect:(NSRect)rect didRemoveSuperView:(BOOL)removeSuperView
{
    [NSCursor pop];
    
    [delegate startRecordingForRect:rect];
    
    if(removeSuperView)
    {
        [self removeFromSuperview];
    }
    
}

-(void)makeBorderAnimation
{
    [self.layer addSublayer:shapeLayer];
    
    if ([shapeLayer animationForKey:@"linePhase"])
        [shapeLayer removeAnimationForKey:@"linePhase"];
    else {
        CABasicAnimation *dashAnimation;
        dashAnimation = [CABasicAnimation
                         animationWithKeyPath:@"lineDashPhase"];
        
        [dashAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
        [dashAnimation setToValue:[NSNumber numberWithFloat:15.0f]];
        [dashAnimation setDuration:0.75f];
        [dashAnimation setRepeatCount:HUGE_VALF];
        
        [shapeLayer addAnimation:dashAnimation forKey:@"linePhase"];        
    }

}

-(void)pauseBorderAnimation
{
    [shapeLayer removeAnimationForKey:@"linePhase"];
}

-(void)stopButtonActionForRecording
{
    
    [self removeFromSuperview];
}

-(void)didRecordingStarted:(BOOL)recordingStarted
{
    isRecordingStarted = recordingStarted;
}

/*
-(void)showPauseAndResumeButton
{
    if(!isMouseDragged)
    {
        pauseAndResumeBtn = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 50, 50)];
        [pauseAndResumeBtn setFrameOrigin:NSMakePoint((NSWidth([self bounds]) - NSWidth([pauseAndResumeBtn frame])) / 2, (NSHeight([self bounds]) - NSHeight([pauseAndResumeBtn frame])) / 2)];
        [pauseAndResumeBtn setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin];
    }
    
    else
    {
        
        float originX = [trackingAreaRect getBottomLeftXCoords] + abs(croppedRect.size.width/2);
        float originY = [trackingAreaRect getBottomLeftYCoords] + abs(croppedRect.size.height/2);
        
        pauseAndResumeBtn = [[NSButton alloc] initWithFrame:NSMakeRect(originX - 25, originY - 25, 50, 50)];
    }
    
    [pauseAndResumeBtn setImage:[NSImage imageNamed:@"pause.png"]];
    [[pauseAndResumeBtn cell] setImageScaling:NSImageScaleAxesIndependently];
    [pauseAndResumeBtn setBordered:NO];
    [pauseAndResumeBtn setTarget:self];
    [pauseAndResumeBtn setAction:@selector(pauseAndResumeBtnAction)];
    
    [self addSubview:pauseAndResumeBtn];
    
    NSTrackingArea *pauseAndResumeButtonTrackingArea = [[NSTrackingArea alloc] initWithRect:[pauseAndResumeBtn frame] options:(NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingCursorUpdate) owner:self userInfo:nil];
    [self addTrackingArea:pauseAndResumeButtonTrackingArea];

}
*/

/*
-(void)pauseAndResumeBtnAction
{
    [pauseAndResumeBtn removeFromSuperview];
    [delegate resumeMovie];
}
 */

@end
