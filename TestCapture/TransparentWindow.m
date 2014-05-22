//
//  TransparentWindow.m
//  Capture It
//
//  Created by Himanshu on 1/6/14.
//  Copyright (c) 2014 com.thinksys. All rights reserved.
//

#import "TransparentWindow.h"

@implementation TransparentWindow

@synthesize delegate;

@synthesize statusItemOriginX, statusItemOriginY;

@synthesize fullCustomScreenView;

-(id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen actionPerform:(NSString*)action captureModeSelected:(NSInteger)mode saveAtpath:(NSString*)path saveToPathButtonChecked:(int)checked showImagePreview:(BOOL)imagePreview showMoviePreview:(BOOL)moviePreview
{
    self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag screen:screen];
    
    if(self)
    {
        //Monitor Key Event
        [self monitorEvent];
        
        actionSelected = action;
        
        selectedSessionPreset = AVCaptureSessionPresetPhoto;
        
        captureMode = mode;
        
        dataPath = path;
        
        didPaused = NO;
        
        didImagePreviewChecked = imagePreview;
        didMoviePreviewChecked = moviePreview;
        
        if ([action isEqualToString:@"movie"])
        {
            [self createTestCaptureStatusItem];
        }
        
        didSaveAtPathBtnChecked = checked;
        
        [self createAndOpenCustomViewFor:action];
        
        statusItemIndex = 1;
    }
    
    return self;
}

-(void)createTestCaptureStatusItem
{
    pauseAndResumeStatusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [pauseAndResumeStatusItem setImage:[NSImage imageNamed:@"pause_status_item1.png"]];
    [pauseAndResumeStatusItem setEnabled:YES];
    [pauseAndResumeStatusItem setTarget:self];
    [pauseAndResumeStatusItem setAction:@selector(pauseAndResumeRecordingAction:)];
    [pauseAndResumeStatusItem setHighlightMode:YES];
    
    stopStatusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [stopStatusItem setImage:[NSImage imageNamed:@"stop_status_item1.png"]];
    [stopStatusItem setEnabled:YES];
    [stopStatusItem setTarget:self];
    [stopStatusItem setAction:@selector(stopRecording:)];
    [stopStatusItem setHighlightMode:YES];
    
    
    statusItemOriginX = [[pauseAndResumeStatusItem valueForKey:@"window"] frame].origin.x;
    statusItemOriginY = [[pauseAndResumeStatusItem valueForKey:@"window"] frame].origin.y;
  
}


-(void)pauseAndResumeRecordingAction:(id)sender
{
    if(!didPaused)
    {
        didPaused = YES;
        [mMovieFileOutput pauseRecording];
        [pauseAndResumeStatusItem setImage:[NSImage imageNamed:@"play_status_item1.png"]];
        if (fullCustomScreenView.superview != nil) {
            [fullCustomScreenView pauseBorderAnimation];
        }
    }
    
    else
    {
        didPaused = NO;
        [mMovieFileOutput resumeRecording];
        [pauseAndResumeStatusItem setImage:[NSImage imageNamed:@"pause_status_item1.png"]];
        if (fullCustomScreenView.superview != nil) {
            [fullCustomScreenView makeBorderAnimation];
        }
    }
    
}


-(void)stopRecording:(id)sender
{
    NSLog(@"Stopping Recording");
    
    [[NSStatusBar systemStatusBar] removeStatusItem:pauseAndResumeStatusItem];
    [[NSStatusBar systemStatusBar] removeStatusItem:stopStatusItem];
    
    [self stopAnimatingStatusItem];
    
    [mMovieFileOutput stopRecording];
    
    if(fullCustomScreenView.superview != Nil)
    {
        [fullCustomScreenView removeFromSuperview];
    }
    
    if (!didSaveAtPathBtnChecked) {
        [self openCustomSavePanel];
    }
    
    else
    {
        if(didMoviePreviewChecked)
        {
            [self showPreviewOfPath:filePath];
        }
        
    }
    
    [stopRecordingMenuItem setEnabled:YES];
    
    [delegate showTestCaptureWindow];
    [delegate enableMenuItems];
}


-(void)createAndOpenCustomViewFor:(NSString *)snapShotOrRecording
{
    switch (captureMode) {
        case 0:
            if ([actionSelected isEqualToString:@"image"])
            {
                [self startCaptureForRect:[[NSScreen mainScreen] frame]];
            }
            
            else
            {
                [self startRecordingForRect:[[NSScreen mainScreen] frame]];
            }
            
            break;
            
        case 1:
            fullCustomScreenView = [[FullCustomScreenView alloc] initWithFrame:[[NSScreen mainScreen] frame] optionSelected:snapShotOrRecording];
            
            [fullCustomScreenView setStatusItemOriginX:statusItemOriginX];
            [fullCustomScreenView setStatusItemOriginY:statusItemOriginY];
            
            [fullCustomScreenView setWantsLayer:YES];
            [fullCustomScreenView setDelegate:self];
            
            [self.contentView addSubview:fullCustomScreenView];
            
            break;
            
        default:
            break;
    }
    
}

-(NSString*)pathForScreenCaptureOrRecord
{
    NSDateFormatter *formatter;
   
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    NSLog(@"Date is %@",dateString);
    
    if([actionSelected isEqualToString:@"movie"])
    {
        recordedMovieFilePath = [NSString stringWithFormat:@"/ScreenRecording%@.mp4",dateString];
        
        filePath = [dataPath stringByAppendingPathComponent:recordedMovieFilePath];
        
        NSLog(@"path is originally %@",filePath);
        
    }
    else
        
    {   recordedImageFilePath = [NSString stringWithFormat:@"/ScreenCapture%@.png",dateString];
        filePath = [dataPath stringByAppendingPathComponent:recordedImageFilePath];
        
         NSLog(@"path is originally %@",filePath);
        
    }
    
    
    return filePath;
}


-(void)startCaptureForRect:(NSRect)rect
{
    NSLog(@"Capturing Started");
    
    if(fullCustomScreenView.superview != Nil)
    {
        [fullCustomScreenView removeFromSuperview];
    }
    
    CGImageRef selectedScreenImage;
    selectedScreenImage = CGDisplayCreateImageForRect(kCGDirectMainDisplay, rect);
    
    NSData *data = (NSData *)CFBridgingRelease(CGDataProviderCopyData(CGImageGetDataProvider(selectedScreenImage)));
    NSLog(@"kkvfv%@", data);
    
    [self CGImageWriteFile:selectedScreenImage toPath:[self pathForScreenCaptureOrRecord]];
    
    
}

-(void) CGImageWriteFile:(CGImageRef) image toPath: (NSString*)path {
    
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);
    CGImageDestinationAddImage(destination, image, nil);
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"Failed to write image to %@", path);
    }
    
    CFRelease(destination);
    
    if (didSaveAtPathBtnChecked)
    {
        NSLog(@"In If Part");
        NSLog(@"%d", didImagePreviewChecked);
        if(didImagePreviewChecked)
        {
            NSLog(@"Image Checked");
            [self showPreviewOfPath:path];
        }
        
    }
    
    else
    {
        NSLog(@"In Else Part");
        [self openCustomSavePanel];
    }
    
    
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [delegate showTestCaptureWindow];
        [delegate enableMenuItems];
    });
}

-(void)startRecordingForRect:(NSRect)rect
{
    NSLog(@"Starting Recording");
    
    [self startAnimatingStatusItem];
    
    [self takeScreenRecording:rect saveAtPath:[NSURL fileURLWithPath:[self pathForScreenCaptureOrRecord]]];
}

-(void)takeScreenRecording:(NSRect)rect saveAtPath:(NSURL*)destPath
{
    [self setIgnoresMouseEvents:YES];
    
    // Create a capture session
    mSession = [[AVCaptureSession alloc] init];
    
    // If you're on a multi-display system and you want to capture a secondary display,
    // you can call CGGetActiveDisplayList() to get the list of all active displays.
    // For this example, we just specify the main display.
    CGDirectDisplayID displayId = kCGDirectMainDisplay;
    
    // Create a ScreenInput with the display and add it to the session
    AVCaptureScreenInput *input = [[AVCaptureScreenInput alloc] initWithDisplayID:displayId];
    
    [input setCropRect:rect];
    
    [mSession setSessionPreset:AVCaptureSessionPreset1280x720];
    
    if (!input) {
        mSession = nil;
        return;
    }
    if ([mSession canAddInput:input])
        [mSession addInput:input];
    
    // Create a MovieFileOutput and add it to the session
    mMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    if ([mSession canAddOutput:mMovieFileOutput])
        [mSession addOutput:mMovieFileOutput];
    
    // Start running the session
    [mSession startRunning];
    
    // Delete any existing movie file first
    if ([[NSFileManager defaultManager] fileExistsAtPath:[destPath path]])
    {
        NSError *err;
        if (![[NSFileManager defaultManager] removeItemAtPath:[destPath path] error:&err])
        {
            NSLog(@"Error deleting existing movie %@",[err localizedDescription]);
        }
    }
    
    // Start recording to the destination movie file
    // The destination path is assumed to end with ".mov", for example, @"/users/master/desktop/capture.mov"
    // Set the recording delegate to self
    [mMovieFileOutput startRecordingToOutputFileURL:destPath recordingDelegate:self];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"Did finish recording to %@ due to error %@", [outputFileURL description], [error description]);
    
    [mSession stopRunning];
    mSession = nil;
}

-(void)resumeMovie
{
    [self setIgnoresMouseEvents:NO];
    //[mMovieFileOutput resumeRecording];
}

-(void)openCustomSavePanel
{
    
    NSURL* originURL = [NSURL fileURLWithPath:filePath];
    NSLog(@"source URL is %@",originURL);
    
    // create the save panel
    NSSavePanel *panel = [NSSavePanel savePanel];
    
    // set a new file name for image and video
    
    if ([actionSelected isEqualToString:@"movie"]) {
    
        NSString *defaultFilesavedname = [[NSString alloc]initWithFormat:@"ScreenRecording%@.mp4",dateString];
        
        [panel setNameFieldStringValue:defaultFilesavedname];
        NSLog(@"hello this is in if part");
    }
   
    else
    {
        
         NSString *defaultFilesavedname = [[NSString alloc]initWithFormat: @"ScreenCapture%@.png",dateString];
        [panel setNameFieldStringValue:defaultFilesavedname];
    }
    
    // display the panel
    [panel beginWithCompletionHandler:^(NSInteger result) {
        
        if (result == NSFileHandlingPanelOKButton) {
            
            saveURL = [panel URL];
            
             NSLog(@"path is saveally %@",saveURL);
            
            // First check if the directory existst
            if([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO)
                
            {
                NSLog(@"Creating content directory: %@",dataPath);
                
                NSError *error=nil;
                
                if([[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error]==NO)
                {
                    NSLog(@"There was an error in creating the directory: %@",error);
                }
            }
            
            [[NSFileManager defaultManager] moveItemAtURL:originURL toURL:saveURL error:NULL];
            
            
            if(didImagePreviewChecked || didMoviePreviewChecked)
                [self showPreviewOfPath:saveURL.absoluteString];
            
        }
        
    
        
        [self close];
    }];
}


-(void)showPreviewOfPath:(NSString*)path
{
    NSLog(@"Showing Preview");
    
    NSArray *args;
    
    if ([actionSelected isEqualToString:@"movie"])
    {
        args = [[NSArray alloc] initWithObjects:@"-a", @"/Applications/QuickTime Player.app", path, nil];
        
    }
    
    else
        args = [[NSArray alloc] initWithObjects:@"-a", @"/Applications/Preview.app", path, nil];
    
    NSTask *task = [NSTask new];
    [task setLaunchPath:@"/usr/bin/open"];
    [task setArguments:args];
    
    [task launch];
    
}




// Escape Event

-(void)monitorEvent
{
    NSEvent* (^handler)(NSEvent*) = ^(NSEvent *theEvent) {
        NSWindow *targetWindow = theEvent.window;
        if (targetWindow == self) {
            return theEvent;
        }
        
        NSEvent *result = theEvent;
        if (theEvent.keyCode == 53)
        {
            [[NSStatusBar systemStatusBar] removeStatusItem:pauseAndResumeStatusItem];
            [[NSStatusBar systemStatusBar] removeStatusItem:stopStatusItem];
            [self close];
            [NSCursor pop];
            
            [delegate enableMenuItems];
            [delegate showTestCaptureWindow];
            
            [NSEvent removeMonitor:eventMonitor];
            result = nil;
        }
        
        return result;
    };
    
    eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:handler];
}

-(void)startAnimatingStatusItem
{
    animTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateStatusItemImage:) userInfo:nil repeats:YES];
}

- (void)stopAnimatingStatusItem
{
    [animTimer invalidate];
}

- (void)updateStatusItemImage:(NSTimer*)timer
{
    NSImage* image = [NSImage imageNamed:[NSString stringWithFormat:@"stop_status_item%d.png",statusItemIndex]];
    [stopStatusItem setImage:image];
    
    NSImage* pauseAndResumeImage;
    
    if (didPaused)
    {
        pauseAndResumeImage = [NSImage imageNamed:[NSString stringWithFormat:@"play_status_item%d.png",statusItemIndex]];
        [pauseAndResumeStatusItem setImage:pauseAndResumeImage];
    }
    
    else
    {
        pauseAndResumeImage = [NSImage imageNamed:[NSString stringWithFormat:@"pause_status_item%d.png",statusItemIndex]];
        [pauseAndResumeStatusItem setImage:pauseAndResumeImage];
    }
    
    ++statusItemIndex;
    
    if (statusItemIndex == 3) {
        statusItemIndex = 1;
    }
}

@end
