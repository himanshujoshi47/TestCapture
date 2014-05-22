//
//  FullCustomScreenView.h
//  Capture It
//
//  Created by Himanshu on 12/12/13.
//  Copyright (c) 2013 com.thinksys. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

#import "TrackingAreaRect.h"

#import "RecordingWidgetView.h"


@protocol FullCustomScreenDelegate <NSObject>

-(void)startCaptureForRect:(NSRect)rect;
-(void)startRecordingForRect:(NSRect)rect;
-(void)resumeMovie;

@end


@interface FullCustomScreenView : NSView <NSWindowDelegate, RecordingWidgetViewDelegate>
{
    NSPoint startingPoint;
    NSPoint finalPoint;
    
    CGRect croppedRect;  //Cropped Rectangle
    NSBezierPath *croppedRectBezierPath;  //Cropped Rect Bezier Path
    
    BOOL isMouseDragged; //Mouse Dragged State
    BOOL isRecordingStarted;  //Recording Button Pressed State
    
    
    //Tracking Areas
    NSTrackingArea *upperTrackingArea;
    NSTrackingArea *bottomTrackingArea;
    NSTrackingArea *leftTrackingArea;
    NSTrackingArea *rightTrackingArea;
    NSTrackingArea *upperLeftTrackingArea;
    NSTrackingArea *upperRightTrackingArea;
    NSTrackingArea *bottomLeftTrackingArea;
    NSTrackingArea *bottomRightTrackingArea;
    
    
    //Area Rects
    NSRect upperTrackingAreaRect;
    NSRect bottomTrackingAreaRect;
    NSRect leftTrackingAreaRect;
    NSRect rightTrackingAreaRect;
    
    TrackingAreaRect *trackingAreaRect;
    
    
    CAShapeLayer *shapeLayer;
    
    NSString *optionSelected;
    
    NSButton *pauseAndResumeBtn;
    
    NSTextField *screenText;
    
}

@property(strong) RecordingWidgetView *recordingWidgetView;

@property(strong) id<FullCustomScreenDelegate> delegate;

@property (assign) float statusItemOriginX;
@property (assign) float statusItemOriginY;

- (id)initWithFrame:(NSRect)frame optionSelected:(NSString *)option;

-(void)closeFullCustomScreenView;

-(void)makeBorderAnimation;
-(void)pauseBorderAnimation;



@end
