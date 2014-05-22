//
//  RecordingWidgetView.h
//  Capture It
//
//  Created by Himanshu on 12/16/13.
//  Copyright (c) 2013 com.thinksys. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@protocol RecordingWidgetViewDelegate <NSObject, NSWindowDelegate>

-(void)didRecordingStarted:(BOOL)recordingStarted;
-(void)recordButtonActionForRect:(NSRect)rect didRemoveSuperView:(BOOL)removeSuperView;
-(void)captureButtonActionForRect:(NSRect)rect;
-(void)stopButtonActionForRecording;
-(void)makeBorderAnimation;

@end

@interface RecordingWidgetView : NSView
{
    NSButton *playAndCaptureButton;
    NSButton *stopButton;
    
    NSRect croppedOrFullScreenRect;
    
    BOOL didScreenCropped;
    
    NSTrackingArea *trackingAreaForPlayBtn;
    
    NSString *optionSelected;
}

@property (strong) id<RecordingWidgetViewDelegate> delegate;


@property (assign) float statusItemOriginX;
@property (assign) float statusItemOriginY;


- (id)initWithFrame:(NSRect)frame isScreenCropped:(BOOL)cropped areaCropped:(NSRect)rect optionSelected:(NSString*)option;

@end
