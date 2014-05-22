//
//  TransparentWindow.h
//  Capture It
//
//  Created by Himanshu on 1/6/14.
//  Copyright (c) 2014 com.thinksys. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>


#import "FullCustomScreenView.h"

@protocol TransparentWindowDelegate <NSObject>

-(void)enableMenuItems;
-(void)showTestCaptureWindow;

@end


@interface TransparentWindow : NSWindow <FullCustomScreenDelegate, AVCaptureFileOutputRecordingDelegate, NSWindowDelegate>
{
    
    
    id<TransparentWindowDelegate> delegate;
    
    AVCaptureSession *mSession;
    AVCaptureFileOutput *mMovieFileOutput;
    
    
    NSString *dataPath;
    NSString *filePath;

    NSString *actionSelected;
    
    NSString *selectedSessionPreset;
    
    NSURL *saveURL;
    BOOL didImagePreviewChecked;
    BOOL didMoviePreviewChecked;
    
    id eventMonitor;
    BOOL didSaveAtPathBtnChecked;   
    
    
    NSStatusItem *pauseAndResumeStatusItem;
    NSStatusItem *stopStatusItem;
    
    
    
    BOOL didPaused;
    NSMenuItem *pauseAndResumeRecordingMenuItem; //Pause A Video
    NSMenuItem *stopRecordingMenuItem; //Stop Recording Status Menu Item
    
    
    NSInteger captureMode;
    
    NSString *dateString;
    NSString *recordedMovieFilePath;
    
    NSString *recordedImageFilePath;
    
    int statusItemIndex;
    NSTimer* animTimer;

}


@property(strong) id<TransparentWindowDelegate> delegate;

@property (strong) FullCustomScreenView *fullCustomScreenView;

@property (assign) float statusItemOriginX;
@property (assign) float statusItemOriginY;



-(id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen actionPerform:(NSString*)action captureModeSelected:(NSInteger)mode saveAtpath:(NSString*)path saveToPathButtonChecked:(int)checked showImagePreview:(BOOL)imagePreview showMoviePreview:(BOOL)moviePreview;




@end
