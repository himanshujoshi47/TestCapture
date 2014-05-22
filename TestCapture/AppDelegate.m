//
//  AppDelegate.m
//  Capture It
//
//  Created by Himanshu on 1/6/14.
//  Copyright (c) 2014 com.thinksys. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;

@synthesize transparentWindow;

@synthesize settingWindow;

@synthesize toggleImageAndMovieBtnSmall, toggleImageAndMovieBtnLarge, settingBtn;

@synthesize showWindowBtn;

@synthesize settingBGView;

/************************************************/
/******* Registration Window Synthesize *********/
/************************************************/

@synthesize registrationWindow;
@synthesize registrationResultLabel;
@synthesize registrationFilePath;
@synthesize continueTrialBtn, activateAppBtn;

/************************************************/
/******* Setting Window Synthesize *********/
/************************************************/

@synthesize captureMenuItem, switchMenuItem;
@synthesize captureSettingBtnLabel;
@synthesize modeSettingMatrix;
@synthesize swapModeLabel, swapModeFunctionLabel;
@synthesize swapSettingMatrix;
@synthesize imagePreviewSettingBtn, moviePreviewSettingBtn, saveToPathSettingBtn;
@synthesize pathSelectedSettingControl;
@synthesize mediaGallerySettingBtn, captureSettingBtn;




//Delegate Method Of CaptureItContentView
-(void)removeSettingView
{
    [self.window removeChildWindow:self.settingWindow];
    [self.settingWindow orderOut:self];
    
    isSettingsBtnPressed = NO;
    
}

-(void)moveWindow
{
    [self autoMoveWindow];
}


-(void)didCloseRegistrationWindow:(id)sender
{
    NSLog(@"Registration Window Closed");
    
    [self enableMenuItems];
    
    if (no_of_days > 0) {
        [self.registrationWindow orderOut:self];
        [self.registrationWindow close];
        [self.window makeKeyAndOrderFront:self];
        [self.window setLevel:NSScreenSaverWindowLevel];
    }
    
    else
    {
        [NSApp terminate:self];
    }
}

-(NSView *)createCaptureItToolsViewInContentView:(NSView *)contentView
{
    
    CaptureItContentView *view = [[CaptureItContentView alloc] initWithFrame:NSMakeRect(0, 0, 44, 120)];
    [view setDelegate:self];
    
    trackingAreaOfCaptureItWindowContentView = [[NSTrackingArea alloc] initWithRect:[view frame] options:(NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingEnabledDuringMouseDrag) owner:self userInfo:nil];
    
    [self.window.contentView addTrackingArea:trackingAreaOfCaptureItWindowContentView];
    
    
    
    
    toggleImageAndMovieBtnSmall = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 20, 20)];
    [toggleImageAndMovieBtnSmall setFrameOrigin:NSMakePoint((NSWidth([view bounds]) - NSWidth([toggleImageAndMovieBtnSmall frame])) / 2, [view frame].size.height - 30)];
    [toggleImageAndMovieBtnSmall setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin];
    [[toggleImageAndMovieBtnSmall cell] setImageScaling:NSImageScaleAxesIndependently];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LastActionSelected"] isEqualToString:@"movie"])
    {
        [toggleImageAndMovieBtnSmall setImage:[NSImage imageNamed:@"Camera-icon.png"]];
    }
    
    else
    {
        [toggleImageAndMovieBtnSmall setImage:[NSImage imageNamed:@"camera-film-icon.png"]];
    }
    
    [toggleImageAndMovieBtnSmall setBordered:NO];
    [[toggleImageAndMovieBtnSmall cell] setButtonType:NSMomentaryChangeButton];
    [toggleImageAndMovieBtnSmall setTarget:self];
    [toggleImageAndMovieBtnSmall setAction:@selector(actionToggleImageAndMovieSmall:)];
    [view addSubview:toggleImageAndMovieBtnSmall];
    
    
    
    toggleImageAndMovieBtnLarge = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 40, 40)];
    [toggleImageAndMovieBtnLarge setFrameOrigin:NSMakePoint((NSWidth([view bounds]) - NSWidth([toggleImageAndMovieBtnLarge frame])) / 2, [view frame].size.height - [toggleImageAndMovieBtnSmall frame].size.height - 60)];
    [toggleImageAndMovieBtnLarge setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin];
    [[toggleImageAndMovieBtnLarge cell] setImageScaling:NSImageScaleAxesIndependently];
    
    
    NSLog(@"Last Action Is : %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"LastActionSelected"]);
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LastActionSelected"] isEqualToString:@"movie"])
    {
        [toggleImageAndMovieBtnLarge setImage:[NSImage imageNamed:@"camera-film-icon.png"]];
    }
    else
    {
        [toggleImageAndMovieBtnLarge setImage:[NSImage imageNamed:@"Camera-icon.png"]];
    }
    
    [toggleImageAndMovieBtnLarge setBordered:NO];
    [[toggleImageAndMovieBtnLarge cell] setButtonType:NSMomentaryChangeButton];
    [toggleImageAndMovieBtnLarge setTarget:self];
    [toggleImageAndMovieBtnLarge setAction:@selector(actionToggleImageAndMovieBtnLarge:)];
    [view addSubview:toggleImageAndMovieBtnLarge];
    
    
    settingBtn = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 20, 20)];
    [settingBtn setFrameOrigin:NSMakePoint((NSWidth([view bounds]) - NSWidth([settingBtn frame])) / 2, [view frame].size.height - [toggleImageAndMovieBtnSmall frame].size.height - [toggleImageAndMovieBtnLarge frame].size.height - 50)];
    [settingBtn setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin];
    [[settingBtn cell] setImageScaling:NSImageScaleAxesIndependently];
    [settingBtn setImage:[NSImage imageNamed:@"settings.png"]];
    [settingBtn setBordered:NO];
    [[settingBtn cell] setButtonType:NSMomentaryChangeButton];
    [settingBtn setTarget:self];
    [settingBtn setAction:@selector(settingBtnAction:)];
    [view addSubview:settingBtn];
    
    
    
    return view;
}

-(void)mouseEntered:(NSEvent *)theEvent
{
    NSLog(@"Entered");
}

-(void)mouseExited:(NSEvent *)theEvent
{
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self autoMoveWindow];
    });
    NSLog(@"Exited");
}

-(void)windowWillMove:(NSNotification *)notification
{
    yOriginOfCaptureItWindow = [[self window] frame].origin.y;
    xOriginOfCaptureItWindow = [NSEvent mouseLocation].x;
    if (yOriginOfCaptureItWindow < 0) {
        yOriginOfCaptureItWindow = 0;
    }
    
}

-(void)windowDidMove:(NSNotification *)notification
{
    yOriginOfCaptureItWindow = [[self window] frame].origin.y;
    xOriginOfCaptureItWindow = [NSEvent mouseLocation].x;
    
    if (yOriginOfCaptureItWindow < 0) {
        yOriginOfCaptureItWindow = 0;
    }
    
}



-(void)autoMoveWindow
{
    if (xOriginOfCaptureItWindow <= [[NSScreen mainScreen] visibleFrame].size.width/2)
    {
        [self.window setFrame:NSMakeRect([[NSScreen mainScreen] visibleFrame].origin.x, yOriginOfCaptureItWindow, self.window.frame.size.width, self.window.frame.size.height) display:YES animate:YES];
    }
    else
    {
        if ([[[[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.apple.dock"] valueForKey:@"orientation"] isEqualToString:@"left"])
        {
            [self.window setFrame:NSMakeRect([[NSScreen mainScreen] frame].size.width - self.window.frame.size.width, yOriginOfCaptureItWindow, self.window.frame.size.width, self.window.frame.size.height) display:YES animate:YES];
        }
        
        else
        {
            [self.window setFrame:NSMakeRect([[NSScreen mainScreen] visibleFrame].size.width - self.window.frame.size.width, yOriginOfCaptureItWindow, self.window.frame.size.width, self.window.frame.size.height) display:YES animate:YES];
        }
        
        
    }
    
}



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{    
    macAddressString = [self getMacAddress];
    
    machineSerialString = [self UKSystemSerialNumber];
    
    
    [self.window setDelegate:self];
    
    xOriginOfCaptureItWindow = [[NSScreen mainScreen] visibleFrame].origin.x;
    yOriginOfCaptureItWindow = ([[NSScreen mainScreen] visibleFrame].size.height/2) - 125;
    
    [self.window setOpaque:NO];
    [self.window setBackgroundColor:[NSColor clearColor]];
    
    [self.window setFrameOrigin:NSMakePoint(xOriginOfCaptureItWindow, yOriginOfCaptureItWindow)];
    [self.window setMovableByWindowBackground:YES];
    
    [self.registrationWindow setFrameOrigin:NSMakePoint((NSWidth([[NSScreen mainScreen] visibleFrame]) - NSWidth([self.registrationWindow frame])) / 2, (NSHeight([[NSScreen mainScreen] visibleFrame]) - NSHeight([self.registrationWindow frame])) / 2)];
    
    [self disableMenuItems];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LastPathUsed"] == NULL)
    {
        [self createDirectoryForApp:@"TestCapture"];
    }
    
    else
    {
        path = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastPathUsed"];
    }
    
    usrDefault = [NSUserDefaults standardUserDefaults];
    
    thinksysBlueColor = [NSColor colorWithDeviceRed:9.0f/255.0f green:61.0/255.0f blue:96.0/255.0f alpha:1.0f];
    
    screenShotCheckBoxState = 1;
    screenRecordingCheckBoxState = 0;
    
    previewImageState = 1;
    previewMovieState = 1;
    
    
    NSView *captureItWindowContentView = [[NSView alloc] init];
    [captureItWindowContentView setWantsLayer:YES];
    [captureItWindowContentView.layer setBackgroundColor:[NSColor clearColor].CGColor];
    [self.window setContentView:captureItWindowContentView];
    
    
    
    NSView *captureItToolsView = [self createCaptureItToolsViewInContentView:captureItWindowContentView];
    [captureItWindowContentView addSubview:captureItToolsView];
    
    
    no_of_days = 30;
    
    NSDate *currentDate = [NSDate date];
    
    
    NSLog(@"System date %@", currentDate);
    
    NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT]; // You could also use the systemTimeZone method
    NSTimeInterval gmtTimeInterval = [currentDate timeIntervalSinceReferenceDate] - timeZoneOffset;
    NSDate *gmtDate = [NSDate dateWithTimeIntervalSinceReferenceDate:gmtTimeInterval];
    
    
    NSLog(@"GMT Date : %@", gmtDate);
    
    
    
    NSString *currentDateInString = [self convertDateToString:currentDate];
    NSDate *currentDateInFormat = [self convertStringToDate:currentDateInString];
    
    NSButton *registrationWindowCloseBtn = [self.registrationWindow standardWindowButton:NSWindowCloseButton];
    [registrationWindowCloseBtn setAction:@selector(didCloseRegistrationWindow:)];
    [registrationWindowCloseBtn setTarget:self];
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"TimeTrialPeriod"] == NULL)
    {
        NSLog(@"App Launches First Time");
        
        [self createDirectoryForApp:@"TestCapture"];
        
        [usrDefault setObject:@"30" forKey:@"TimeTrialPeriod"];
        [usrDefault setObject:currentDateInString forKey:@"AppInstallationDate"];
        
        [usrDefault setObject:[NSNumber numberWithInt:screenShotCheckBoxState] forKey:@"ScreenShotCheckBoxState"];
        [usrDefault setObject:[NSNumber numberWithInt:screenRecordingCheckBoxState] forKey:@"ScreenRecordingCheckBoxState"];
        [usrDefault setObject:@"image" forKey:@"LastActionSelected"];
        
        
        [usrDefault setObject:[NSNumber numberWithInt:previewImageState] forKey:@"PreviewImageKey"];
        [usrDefault setObject:[NSNumber numberWithInt:previewMovieState] forKey:@"PreviewMovieKey"];
        
        [usrDefault setObject:[NSNumber numberWithInt:0] forKey:@"LastCaptureModeUsed"];
        [usrDefault synchronize];
        
        
    }
    
    else
    {
        NSLog(@"Date of App Installation : %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"AppInstallationDate"]);
        
        NSString *appInstallationDateString = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppInstallationDate"];
        NSDate *appInstallationDate = [self convertStringToDate:appInstallationDateString];
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:appInstallationDate toDate:currentDateInFormat options:0];
        
        NSLog(@"No. of days to Install App : %ld", (long)components.day);
        
        no_of_days = components.day;
        
        no_of_days = 30 - no_of_days;
        
        NSString *daysLeftString = [NSString stringWithFormat:@"%ld", no_of_days];
        
        NSLog(@"Number Of Days Left : %@", daysLeftString);
        
    }
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LastActionSelected"] isEqualToString:@"movie"])
    {
        [captureMenuItem setTitle:@"Capture Screen Recording"];
        [switchMenuItem setTitle:@"Switch To Screen Shot"];
    }
    else
    {
        [captureMenuItem setTitle:@"Capture Screen Shot"];
        [switchMenuItem setTitle:@"Switch To Screen Recording"];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"App_Activated"] isEqualToString:@"Activated"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"ActivatedMacAddress"] isEqualToString:macAddressString])
    {
        [self.registrationWindow orderOut:self];
        [self.registrationWindow close];
        [self.window makeKeyAndOrderFront:self];
        [self.window setLevel:NSScreenSaverWindowLevel];
        [self enableMenuItems];
    }
    
    
    
    @try {
        
    
    
        NSString *input = [NSString stringWithFormat:@"%@/registration.xml", [self pathToAppContentFolder]];
    
    
        NSXMLDocument* doc = [[NSXMLDocument alloc] initWithContentsOfURL: [NSURL fileURLWithPath:input] options:0 error:NULL];
        
        NSMutableArray* activationKeys = [[NSMutableArray alloc] initWithCapacity:10];
    
        NSXMLElement* root  = [doc rootElement];
        
        NSArray* activationArray = [root nodesForXPath:@"//activation-key" error:nil];
        
        for(NSXMLElement* xmlElement in activationArray)
        {
            [activationKeys addObject:[xmlElement stringValue]];
        }
        
        NSString *macAddress = [NSString stringWithFormat:@"%@%@",[self getMacAddress], [self getMacAddress]];
        
        if ([[activationKeys objectAtIndex:0] isEqualToString:macAddress])
        {
            [self.registrationWindow orderOut:self];
            [self.registrationWindow close];
            [self.window makeKeyAndOrderFront:self];
            [self.window setLevel:NSScreenSaverWindowLevel];
            [self enableMenuItems];
        }
        
        else
        {
            //Show Registration Window In Front
            [registrationWindow makeKeyAndOrderFront:self];
        }
        
    }

    @catch (NSException *exception)
    {
        NSLog(@"%@", exception);
        
        //Show Registration Window In Front
        [registrationWindow makeKeyAndOrderFront:self];
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    else if (![self isInternetAvailable] && no_of_days >= 2)
    {
        [self.registrationWindow orderOut:self];
        [self.registrationWindow close];
        [self.window makeKeyAndOrderFront:self];
        [self.window setLevel:NSScreenSaverWindowLevel];
        [self enableMenuItems];
    }
    */
    /*
    else
    {
        //Show Registration Window In Front
        [registrationWindow makeKeyAndOrderFront:self];
        
        if (no_of_days <= 0)
        {
            [daysLeftLabel removeFromSuperview];
            [continueTrialBtn removeFromSuperview];
            [daysLabel setStringValue:@"Trial"];
            [leftLabel setStringValue:@"Ends"];
        }
    }
    */
    
    
    actionSelected = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastActionSelected"];
    captureMode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LastCaptureModeUsed"] integerValue];
    
    
    
    
    isSettingsBtnPressed = NO;
    
    [[toggleImageAndMovieBtnSmall cell] setBackgroundColor:thinksysBlueColor];
    [[toggleImageAndMovieBtnLarge cell] setBackgroundColor:thinksysBlueColor];
    [[settingBtn cell] setBackgroundColor:thinksysBlueColor];
    
    pathState = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DefaultPathsave"] intValue];
    
    imageSaveState = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PreviewImageKey"] intValue];
    movieSaveState = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PreviewMovieKey"] intValue];
    
    saveAtPathBtnState = (int)pathState;
    previewImageState = (int)imageSaveState;
    previewMovieState = (int)movieSaveState;
    
    
    
}

-(void)createDirectoryForApp:(NSString *)dirName
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:dirName];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])    //Does directory already exist?
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
    }
    
    [usrDefault setObject:path forKey:@"LastPathUsed"];
    [usrDefault synchronize];
}

- (IBAction)showWindowBtnAction:(id)sender {
    [self showTestCaptureWindow];
}

- (IBAction)captureMenuItemAction:(id)sender
{
    [self captureMenuAction:sender];
}

- (IBAction)switchMenuItemAction:(id)sender
{
    [self switchMenuAction:sender];
}

-(void)captureMenuAction:(id)sender
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LastActionSelected"] isEqualToString:@"movie"])
    {
        [self actionToggleImageAndMovieSmall:sender];
        [self captureMovie];
    }
    else
    {
        [self actionToggleImageAndMovieSmall:sender];
        [self captureImage];
    }
    
    [self disableMenuItems];
}

-(void)switchMenuAction:(id)sender
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LastActionSelected"] isEqualToString:@"movie"])
    {
        screenShotCheckBoxState = 1;
        screenRecordingCheckBoxState = 0;
        
        [captureMenuItem setTitle:@"Capture Screen Shot"];
        [switchMenuItem setTitle:@"Switch To Screen Recording"];
        [toggleImageAndMovieBtnSmall setImage:[NSImage imageNamed:@"camera-film-icon.png"]];
        [toggleImageAndMovieBtnLarge setImage:[NSImage imageNamed:@"Camera-icon.png"]];
        
        [usrDefault setObject:@"image" forKey:@"LastActionSelected"];
        
        [usrDefault setObject:[NSNumber numberWithInt:screenShotCheckBoxState] forKey:@"ScreenShotCheckBoxState"];
        [usrDefault setObject:[NSNumber numberWithInt:screenRecordingCheckBoxState] forKey:@"ScreenRecordingCheckBoxState"];
        
        [usrDefault synchronize];
        
        [self.swapSettingMatrix setState:1 atRow:0 column:0];
        
    }
    else
    {
        screenShotCheckBoxState = 0;
        screenRecordingCheckBoxState = 1;
        
        [captureMenuItem setTitle:@"Capture Screen Recording"];
        [switchMenuItem setTitle:@"Switch To Screen Shot"];
        [toggleImageAndMovieBtnSmall setImage:[NSImage imageNamed:@"Camera-icon.png"]];
        [toggleImageAndMovieBtnLarge setImage:[NSImage imageNamed:@"camera-film-icon.png"]];
        
        [usrDefault setObject:@"movie" forKey:@"LastActionSelected"];
        
        [usrDefault setObject:[NSNumber numberWithInt:screenShotCheckBoxState] forKey:@"ScreenShotCheckBoxState"];
        [usrDefault setObject:[NSNumber numberWithInt:screenRecordingCheckBoxState] forKey:@"ScreenRecordingCheckBoxState"];
        
        [usrDefault synchronize];
        
        [self.swapSettingMatrix setState:1 atRow:1 column:0];
        
    }
}

-(void)disableMenuItems
{
    [captureMenuItem setEnabled:NO];
    [captureMenuItem setAction:NULL];
    
    [switchMenuItem setEnabled:NO];
    [switchMenuItem setAction:NULL];
}

-(void)enableMenuItems
{
    [captureMenuItem setEnabled:YES];
    [captureMenuItem setTarget:self];
    [captureMenuItem setAction:@selector(captureMenuAction:)];
    
    [switchMenuItem setEnabled:YES];
    [switchMenuItem setTarget:self];
    [switchMenuItem setAction:@selector(switchMenuAction:)];
}

- (void)actionToggleImageAndMovieSmall:(id)sender {
    
    if (isSettingsBtnPressed)
    {
        [self.window removeChildWindow:self.settingWindow];
        [self.settingWindow orderOut:self];
        
        isSettingsBtnPressed = NO;
        
    }
    
    if ([actionSelected isEqualToString:@"image"])
    {
        
        NSLog(@"In If Movie");
        
        
        actionSelected = @"movie";
        
        [usrDefault setObject:actionSelected forKey:@"LastActionSelected"];
        
        [toggleImageAndMovieBtnSmall setImage:[NSImage imageNamed:@"Camera-icon.png"]];
        [toggleImageAndMovieBtnLarge setImage:[NSImage imageNamed:@"camera-film-icon.png"]];
        
        
        screenShotCheckBoxState = 0;
        screenRecordingCheckBoxState = 1;
        
        
        [usrDefault setObject:[NSNumber numberWithInt:screenShotCheckBoxState] forKey:@"ScreenShotCheckBoxState"];
        [usrDefault setObject:[NSNumber numberWithInt:screenRecordingCheckBoxState] forKey:@"ScreenRecordingCheckBoxState"];
        
        [usrDefault synchronize];
        
    }
    else
    {
        NSLog(@"In else Image");
        
        actionSelected = @"image";
        
        [usrDefault setObject:actionSelected forKey:@"LastActionSelected"];
        
        [toggleImageAndMovieBtnSmall setImage:[NSImage imageNamed:@"camera-film-icon.png"]];
        [toggleImageAndMovieBtnLarge setImage:[NSImage imageNamed:@"Camera-icon.png"]];
        
        
        screenShotCheckBoxState = 1;
        screenRecordingCheckBoxState = 0;
        
        [usrDefault setObject:[NSNumber numberWithInt:screenShotCheckBoxState] forKey:@"ScreenShotCheckBoxState"];
        [usrDefault setObject:[NSNumber numberWithInt:screenRecordingCheckBoxState] forKey:@"ScreenRecordingCheckBoxState"];
        
        [usrDefault synchronize];
        
    }
}

- (void)actionToggleImageAndMovieBtnLarge:(id)sender {
    
    if (isSettingsBtnPressed)
    {
        [self.window removeChildWindow:self.settingWindow];
        [self.settingWindow orderOut:self];
        
        isSettingsBtnPressed = NO;
        
    }
    
    if([actionSelected isEqualToString:@"image"])
    {
        [self captureImage];
    }
    else
    {
        [self captureMovie];
    }
    
    [self disableMenuItems];
}


- (void)settingBtnAction:(id)sender {
    
    NSRect captureItWindowFrame = self.window.frame;
    
    if (!isSettingsBtnPressed)
    {
        [self.modeSettingMatrix setState:1 atRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"LastCaptureModeUsed"] integerValue] column:0];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"LastActionSelected"] isEqualToString:@"image"])
        {
            [self.swapSettingMatrix setState:1 atRow:0 column:0];
        }
        
        else
        {
            [self.swapSettingMatrix setState:1 atRow:1 column:0];
        }
        
        [self.imagePreviewSettingBtn setState:[[[NSUserDefaults standardUserDefaults] objectForKey:@"PreviewImageKey"] integerValue]];
        [self.moviePreviewSettingBtn setState:[[[NSUserDefaults standardUserDefaults] objectForKey:@"PreviewMovieKey"] integerValue]];
        
        [self.saveToPathSettingBtn setState:saveAtPathBtnState];
        
        NSString *lastPathUsed = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastPathUsed"];
        [self.pathSelectedSettingControl setURL:[NSURL fileURLWithPath:lastPathUsed]];
        
        
        
        [self.captureSettingBtnLabel setAttributedStringValue:[self getAttributedStringWithWhiteColor:@"F5"]];
        [self.captureSettingBtn setAttributedTitle:[self getAttributedStringWithWhiteColor:@"Capture"]];
        
        [self.mediaGallerySettingBtn setAttributedTitle:[self getAttributedStringWithWhiteColor:@"Media Gallery"]];
        
        [self.modeSettingMatrix.cells[0] setAttributedTitle:[self getAttributedStringWithWhiteColor:@"Full Window"]];
        [self.modeSettingMatrix.cells[1] setAttributedTitle:[self getAttributedStringWithWhiteColor:@"Crop Window"]];
        
        [self.swapModeLabel setAttributedStringValue:[self getAttributedStringWithWhiteColor:@"Swap To Mode"]];
        [self.swapModeFunctionLabel setAttributedStringValue:[self getAttributedStringWithWhiteColor:@"F6"]];
        
        [self.swapSettingMatrix.cells[0] setAttributedTitle:[self getAttributedStringWithWhiteColor:@"Screen Shot"]];
        [self.swapSettingMatrix.cells[1] setAttributedTitle:[self getAttributedStringWithWhiteColor:@"Screen Recording"]];        
        
        [self.imagePreviewSettingBtn setAttributedTitle:[self getAttributedStringWithWhiteColor:@"Show Image Preview"]];
        [self.moviePreviewSettingBtn setAttributedTitle:[self getAttributedStringWithWhiteColor:@"Show Movie Preview"]];
        
        [self.saveToPathSettingBtn setAttributedTitle:[self getAttributedStringWithWhiteColor:@"Save To Path"]];        
        
        if (captureItWindowFrame.origin.x < [[NSScreen mainScreen] visibleFrame].size.width/2)
        {
            [self.settingBGView setImage:[NSImage imageNamed:@"setting_bg_left.png"]];
            [self.settingWindow setFrameOrigin:NSMakePoint(captureItWindowFrame.size.width, captureItWindowFrame.origin.y - 130)];
        }
        
        else
        {
            [self.settingBGView setImage:[NSImage imageNamed:@"setting_bg_right.png"]];
            [self.settingWindow setFrameOrigin:NSMakePoint(captureItWindowFrame.origin.x - self.settingWindow.frame.size.width, captureItWindowFrame.origin.y - 130)];
        }
        
        [self.settingWindow setOpaque:NO];
        [self.settingWindow setBackgroundColor:[NSColor clearColor]];
        [self.window addChildWindow:self.settingWindow ordered:NSWindowAbove];
        
        
        isSettingsBtnPressed = YES;
        
    }
    
    else if (isSettingsBtnPressed)
    {
        
        [self.window removeChildWindow:self.settingWindow];
        [self.settingWindow orderOut:self];
        
        isSettingsBtnPressed = NO;
        
    }
    
}

-(void)openPanelPopUp
{
    
    NSOpenPanel *openPanel = [[NSOpenPanel alloc] init];
    [openPanel setTitle:@"Save To Path"];
    
    [openPanel setCanChooseFiles:NO];
    [openPanel setCanChooseDirectories:YES];
    
    if ([openPanel runModal] == NSOKButton)
    {
        path = [[openPanel URL] path];
        [self.pathSelectedSettingControl setURL:[NSURL fileURLWithPath:path]];
        [usrDefault setObject:path forKey:@"LastPathUsed"];
        [usrDefault synchronize];
    }
}

-(void)captureImage
{
    [self.window setReleasedWhenClosed:FALSE];
    
    if ([self.registrationWindow isVisible]) {
        [self.registrationWindow close];
    }
    
    
    [self.window close];
    
    transparentWindow = [[TransparentWindow alloc] initWithContentRect:[[NSScreen mainScreen] frame] styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO screen:[NSScreen mainScreen] actionPerform:@"image" captureModeSelected:captureMode saveAtpath:path saveToPathButtonChecked:saveAtPathBtnState showImagePreview:previewImageState showMoviePreview:previewMovieState];
    
    [transparentWindow setDelegate:self];
    
    [transparentWindow setLevel:CGShieldingWindowLevel()];
    
    [transparentWindow setOpaque:NO];
    
    [transparentWindow setBackgroundColor:[NSColor clearColor]];
    
    [transparentWindow makeKeyAndOrderFront:self];
    
}

-(void)captureMovie
{
    [self.window setReleasedWhenClosed:FALSE];
    [self.window close];
    
    
    transparentWindow = [[TransparentWindow alloc] initWithContentRect:[[NSScreen mainScreen] frame]  styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO screen:[NSScreen mainScreen]  actionPerform:@"movie" captureModeSelected:captureMode saveAtpath:path saveToPathButtonChecked:saveAtPathBtnState showImagePreview:previewImageState showMoviePreview:previewMovieState];
    
    [transparentWindow setDelegate:self];
    
    [transparentWindow setLevel:CGShieldingWindowLevel()];
    
    [transparentWindow setOpaque:NO];
    
    [transparentWindow setBackgroundColor:[NSColor clearColor]];
    
    [transparentWindow makeKeyAndOrderFront:self];
}

-(void)showTestCaptureWindow
{
    if(![self.window isVisible])
    {
        [self.window makeKeyAndOrderFront:self];
        [self.window setLevel:NSScreenSaverWindowLevel];
    }
}

-(void)saveApplicationState
{
    [usrDefault setObject:[NSNumber numberWithInt:saveAtPathBtnState] forKey:@"DefaultPathsave"];
    
    [usrDefault setObject:[NSNumber numberWithInt:previewImageState] forKey:@"PreviewImageKey"];
    [usrDefault setObject:[NSNumber numberWithInt:previewMovieState] forKey:@"PreviewMovieKey"];
    
    [usrDefault synchronize];
    
    
    NSLog(@"path status is %ld",(long)pathState);
    
}

-(NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    [self saveApplicationState];
    
    return NSTerminateNow;
}



/***********************************************************/
/******* Registration Window Method Implementation *********/
/***********************************************************/


-(NSString*)getMacAddress
{
    NSPipe *outPipe = [NSPipe pipe];
    NSTask* theTask = [[NSTask alloc] init];
    
    NSString *s;
    //Built-in ethernet
    [theTask setStandardOutput:outPipe];
    [theTask setStandardError:outPipe];
    [theTask setLaunchPath:@"/sbin/ifconfig"];
    [theTask setCurrentDirectoryPath:@"~/"];
    [theTask setArguments:[NSArray arrayWithObjects:@"en0", nil]];
    [theTask launch];
    [theTask waitUntilExit];
    
    NSString *str = [[NSString alloc] initWithData:[[outPipe fileHandleForReading] readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    
    if (![str isEqualToString:@"ifconfig: interface en0 does not exist"]) {
        s = str;
        NSRange f;
        f = [s rangeOfString:@"ether "];
        if (f.location != NSNotFound) {
            s = [s substringFromIndex:f.location + f.length];
            
            str = [s substringWithRange:NSMakeRange(0, 17)];
        }
        
        str = [str stringByReplacingOccurrencesOfString:@":" withString:@""];
        
        NSLog(@"String Is : %@", str);
        
    }
    
    return str;
    
}

-(NSString*) UKSystemSerialNumber
{
    mach_port_t             masterPort;
    kern_return_t           kr = noErr;
    io_registry_entry_t     entry;
    CFTypeRef               prop;
    CFTypeID                propID;
    NSString*               str = nil;
    
    kr = IOMasterPort(MACH_PORT_NULL, &masterPort);
    
    entry = IORegistryGetRootEntry( masterPort );
    
    prop = IORegistryEntrySearchCFProperty(entry, kIODeviceTreePlane, CFSTR("serial-number"), nil, kIORegistryIterateRecursively);
    
    propID = CFGetTypeID( prop );
    
    const char* buf = [(__bridge NSData*)prop bytes];
    NSUInteger len = [(__bridge NSData*)prop length], x;
    
    char    secondPart[256];
    char    firstPart[256];
    char*   currStr = secondPart; // Version number starts with second part, then NULLs, then first part.
    int     y = 0;
    
    for( x = 0; x < len; x++ )
    {
        if( buf[x] > 0 && (y < 255) )
            currStr[y++] = buf[x];
        else if( currStr == secondPart )
        {
            currStr[y] = 0;     // Terminate string.
            currStr = firstPart;
            y = 0;
        }
    }
    currStr[y] = 0; // Terminate string.
    
    str = [NSString stringWithFormat: @"%s%s", firstPart, secondPart];
    
    NSLog(@"Machine Serial Number is : %@", str);
    
    
    return str;
}








- (IBAction)continueTrialBtnAction:(id)sender
{
    [self enableMenuItems];
    
    [self.window makeKeyAndOrderFront:self];
    [self.window setLevel:NSScreenSaverWindowLevel];
    [self.registrationWindow close];
    
}


- (IBAction)activateAppBtnAction:(id)sender
{
    
    NSURL *regURL = [[NSURL alloc] initWithString:url];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:regURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    
    NSHTTPURLResponse* urlResponse = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:nil];
    
    NSInteger statusCode = [urlResponse statusCode];
    
    NSLog(@"Status Code IS : %ld", (long)statusCode);
    
    if (statusCode == 200)
    {
        NSXMLElement* rootNode = [[NSXMLElement alloc] initWithName:@"TestCapture"];
        
        NSXMLElement *urlElement = [[NSXMLElement alloc] initWithName:@"url"];
        [urlElement setStringValue:url];
        [rootNode addChild:[urlElement copy]];
        
        NSXMLElement *registrantElement = [[NSXMLElement alloc] initWithName:@"registrant"];
        [registrantElement setStringValue:name];
        [rootNode addChild:[registrantElement copy]];
        
        NSXMLElement *activationKeyElement = [[NSXMLElement alloc] initWithName:@"activation-key"];
        NSString *macAddress = [NSString stringWithFormat:@"%@%@",[self getMacAddress], [self getMacAddress]];
        [activationKeyElement setStringValue:macAddress];
        [rootNode addChild:[activationKeyElement copy]];
        
        NSXMLElement *licenseKeyElement = [[NSXMLElement alloc] initWithName:@"license-key"];
        [licenseKeyElement setStringValue:license];
        [rootNode addChild:[licenseKeyElement copy]];
        
        
        NSXMLDocument *xmlRequest = [NSXMLDocument documentWithRootElement:rootNode];
        NSLog(@"XML Document\n%@", xmlRequest);
        
        NSData *xmlData = [xmlRequest XMLDataWithOptions:NSXMLNodePrettyPrint];
        NSString *filePath = [NSString stringWithFormat:@"%@/registration.xml", [self pathToAppContentFolder] ];
        [xmlData writeToFile:filePath atomically:YES];
        
        [registrationResultLabel setTextColor:[NSColor colorWithCalibratedRed:0.0/255.0 green:102.0/255.0 blue:0.0/255.0 alpha:1.0]];
        [registrationResultLabel setStringValue:@"Registered Successfully"];
        
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.registrationWindow orderOut:self];
            [self.registrationWindow close];
            [self.window makeKeyAndOrderFront:self];
            [self.window setLevel:NSScreenSaverWindowLevel];
            [self enableMenuItems];
        });
        
        
    }
    

}

-(NSString*)pathToAppContentFolder
{
    NSArray* arguments = [[NSProcessInfo processInfo] arguments];
    NSString* contentFolderPath = [arguments objectAtIndex:0];
    
    contentFolderPath = [[NSBundle mainBundle] bundlePath];
    
    
    NSLog(@"Path Is : %@", contentFolderPath);
    
    return contentFolderPath;
}

-(NSDate*)convertStringToDate:(NSString*)str
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSDate *date = [dateFormat dateFromString:str];
    
    return date;
}

-(NSString*)convertDateToString:(NSDate*)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *systemTimeZone = [NSTimeZone systemTimeZone];
    formatter.timeZone = systemTimeZone;
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
}

-(NSAttributedString *)getAttributedStringWithWhiteColor:(NSString *)str
{
    NSAttributedString *whiteColorString;
    whiteColorString = [[NSAttributedString alloc] initWithString:str attributes:[NSDictionary dictionaryWithObject:[NSColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
    return whiteColorString;
}


- (IBAction)radioModeAction:(id)sender
{
    NSLog(@"%ld",[sender selectedRow]);
    captureMode = [sender selectedRow];
    [usrDefault setObject:[NSNumber numberWithInteger:captureMode] forKey:@"LastCaptureModeUsed"];
    [usrDefault synchronize];
}

- (IBAction)swapModeAction:(id)sender
{
    if ([sender selectedRow] == 0)
    {
        actionSelected = @"image";
        
        [toggleImageAndMovieBtnSmall setImage:[NSImage imageNamed:@"camera-film-icon.png"]];
        
        [toggleImageAndMovieBtnLarge setImage:[NSImage imageNamed:@"Camera-icon.png"]];
        
        [usrDefault setObject:@"image" forKey:@"LastActionSelected"];
        [usrDefault synchronize];
    }
    else
    {
        actionSelected = @"movie";
        
        [toggleImageAndMovieBtnSmall setImage:[NSImage imageNamed:@"Camera-icon.png"]];
        
        [toggleImageAndMovieBtnLarge setImage:[NSImage imageNamed:@"camera-film-icon.png"]];
        
        [usrDefault setObject:@"movie" forKey:@"LastActionSelected"];
        [usrDefault synchronize];
    }
}

- (IBAction)imagePreviewSettingBtnAction:(id)sender
{
    if ([[sender cell] state] == NSOnState)
    {
        previewImageState = 1;
    }
    else
    {
        previewImageState = 0;
    }
    
    [usrDefault setObject:[NSNumber numberWithInt:previewImageState] forKey:@"PreviewImageKey"];
    [usrDefault synchronize];
}

- (IBAction)moviePreviewSettingBtnAction:(id)sender
{
    if ([[sender cell] state] == NSOnState)
    {
        previewMovieState = 1;
    }
    else
    {
        previewMovieState = 0;
    }
    
    [usrDefault setObject:[NSNumber numberWithInt:previewMovieState] forKey:@"PreviewMovieKey"];
    [usrDefault synchronize];
    
}

- (IBAction)saveToPathSettingBtnAction:(id)sender
{
    if ([[sender cell] state] == NSOnState)
    {
        saveAtPathBtnState = 1;
        [self openPanelPopUp];
    }
    else
    {
        saveAtPathBtnState = 0;
        [self createDirectoryForApp:@"TestCapture"];
    }
    
    
    [usrDefault setObject:[NSNumber numberWithInt:saveAtPathBtnState] forKey:@"DefaultPathsave"];
    [usrDefault synchronize];
    
}

- (IBAction)mediaGalleryBtn:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL fileURLWithPath:path]];
}

- (IBAction)closeSettingBtn:(id)sender
{
    [usrDefault setObject:[NSNumber numberWithInt:screenShotCheckBoxState] forKey:@"ScreenShotCheckBoxState"];
    [usrDefault setObject:[NSNumber numberWithInt:screenRecordingCheckBoxState] forKey:@"ScreenRecordingCheckBoxState"];
    [usrDefault synchronize];
    
    [self.window removeChildWindow:self.settingWindow];
    [self.settingWindow orderOut:self];
    
    isSettingsBtnPressed = NO;
}

- (IBAction)captureSettingBtn:(id)sender
{
    if([actionSelected isEqualToString:@"image"])
    {
        [self captureImage];
    }
    else
    {
        [self captureMovie];
    }
    
    [self disableMenuItems];
}

-(BOOL)isInternetAvailable
{
    NSURL *googleURL = [[NSURL alloc] initWithString:@"http://www.google.com"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:googleURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    BOOL connectedToInternet = NO;
    
    if ([NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil]) {
        connectedToInternet = YES;
    }
    return connectedToInternet;
}

- (IBAction)importLicenseFile:(id)sender
{
    NSLog(@"Import Button Pressed");
    
    NSOpenPanel *openPanel  = [NSOpenPanel openPanel];
    
    NSInteger result  = [openPanel runModal];
    
    [openPanel setAllowedFileTypes:@[@"xml"]];
    
    if(result == NSOKButton){
        
        NSString * input =  [[openPanel URL] path];
        
        NSLog(@"ljljj%@", input);
        
        NSXMLDocument* doc = [[NSXMLDocument alloc] initWithContentsOfURL: [NSURL fileURLWithPath:input] options:0 error:NULL];
        
        NSMutableArray* urls = [[NSMutableArray alloc] initWithCapacity:10];
        NSMutableArray* titles = [[NSMutableArray alloc] initWithCapacity:10];
        NSMutableArray* licenses = [[NSMutableArray alloc] initWithCapacity:10];
        
        
        @try {
            NSXMLElement* root  = [doc rootElement];
            
            NSArray* urlArray = [root nodesForXPath:@"//url" error:nil];
            for(NSXMLElement* xmlElement in urlArray)
                [urls addObject:[xmlElement stringValue]];
            
            NSArray* titleArray = [root nodesForXPath:@"//registrant" error:nil];
            for(NSXMLElement* xmlElement in titleArray)
                [titles addObject:[xmlElement stringValue]];
            
            NSArray* licenseArray = [root nodesForXPath:@"//license" error:nil];
            for(NSXMLElement* xmlElement in licenseArray)
                [licenses addObject:[xmlElement stringValue]];
            
            url = [urls objectAtIndex:0];
            name = [titles objectAtIndex:0];
            license = [licenses objectAtIndex:0];
            
            NSString *output = [NSString stringWithFormat:@"Registrant Name:  %@", name];
            
            [registrationResultLabel setTextColor:[NSColor colorWithCalibratedRed:0.0/255.0 green:102.0/255.0 blue:0.0/255.0 alpha:1.0]];
            [registrationResultLabel setStringValue:output];
            [registrationFilePath setURL:[NSURL URLWithString:input]];
            
            [activateAppBtn setEnabled:YES];
            
        }
        
        @catch (NSException *exception)
        {
            NSLog(@"%@", exception);
            [registrationResultLabel setTextColor:[NSColor redColor]];
            [registrationResultLabel setStringValue:@"You have imported a wrong file"];
        }
        
    }
    
}

@end
