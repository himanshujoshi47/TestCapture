//
//  AppDelegate.h
//  Capture It
//
//  Created by Himanshu on 1/6/14.
//  Copyright (c) 2014 com.thinksys. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IOKit/IOKitLib.h>
#import <Carbon/Carbon.h>
#import <SystemConfiguration/SystemConfiguration.h>


#import "CaptureItContentView.h"
#import "TransparentWindow.h"
#import "SettingView.h"

@interface AppDelegate : NSWindow <NSApplicationDelegate, TransparentWindowDelegate, NSWindowDelegate, CaptureItWindowDelegate, NSXMLParserDelegate>
{
    NSColor *thinksysBlueColor;
    
    SettingView *settingView;
    BOOL isSettingsBtnPressed;
    
    NSInteger vedioQualitySelected;
    
    int previewImageState;
    int previewMovieState;
    int saveAtPathBtnState;
    
    NSInteger pathState;
    NSInteger imageSaveState;
    NSInteger movieSaveState;
    
    
    NSString *actionSelected;
    
    NSString *path;
    
    NSInteger captureMode;
    
    NSUserDefaults *usrDefault;
    
    int screenShotCheckBoxState, screenRecordingCheckBoxState;
    
    NSTrackingArea *trackingAreaOfCaptureItWindowContentView;
    
    float xOriginOfCaptureItWindow;
    float yOriginOfCaptureItWindow;
    
    /************************************************/
    /******* Registration Window iVars *********/
    /************************************************/
    
    NSString *macAddressString;
    NSString *machineSerialString;
    
    NSInteger no_of_days;
    
    //Registration Properties
    NSString *url;
    NSString *name;
    NSString *license;
    
}

@property (assign) IBOutlet NSWindow *window;

@property (strong) TransparentWindow *transparentWindow;

@property (strong) NSButton *toggleImageAndMovieBtnSmall;
@property (strong) NSButton *toggleImageAndMovieBtnLarge;
@property (strong) NSButton *settingBtn;

@property (weak) IBOutlet NSMenuItem *showWindowBtn;


/************************************************/
/******* Registration Window Properties *********/
/************************************************/


@property (unsafe_unretained) IBOutlet NSWindow *registrationWindow;
@property (weak) IBOutlet NSButton *continueTrialBtn;
@property (weak) IBOutlet NSTextField *registrationResultLabel;
@property (weak) IBOutlet NSButton *activateAppBtn;



@property (weak) IBOutlet NSMenuItem *captureMenuItem;
@property (weak) IBOutlet NSMenuItem *switchMenuItem;




- (IBAction)captureMenuItemAction:(id)sender;
- (IBAction)switchMenuItemAction:(id)sender;


- (void)actionToggleImageAndMovieSmall:(id)sender;
- (void)actionToggleImageAndMovieBtnLarge:(id)sender;
- (void)settingBtnAction:(id)sender;

- (IBAction)showWindowBtnAction:(id)sender;

/************************************************/
/******* Registration Window Action *********/
/************************************************/

- (IBAction)continueTrialBtnAction:(id)sender;
- (IBAction)activateAppBtnAction:(id)sender;



/************************************************/
/******* Setting Window Properties *********/
/************************************************/

@property (unsafe_unretained) IBOutlet NSWindow *settingWindow;
@property (weak) IBOutlet NSImageView *settingBGView;

@property (weak) IBOutlet NSMatrix *modeSettingMatrix;
@property (weak) IBOutlet NSTextField *swapModeLabel;
@property (weak) IBOutlet NSTextField *swapModeFunctionLabel;
@property (weak) IBOutlet NSMatrix *swapSettingMatrix;
@property (weak) IBOutlet NSPathControl *registrationFilePath;




@property (weak) IBOutlet NSButton *imagePreviewSettingBtn;
@property (weak) IBOutlet NSButton *moviePreviewSettingBtn;

@property (weak) IBOutlet NSButton *saveToPathSettingBtn;
@property (weak) IBOutlet NSPathControl *pathSelectedSettingControl;

@property (weak) IBOutlet NSButton *mediaGallerySettingBtn;

@property (weak) IBOutlet NSButton *captureSettingBtn;
@property (weak) IBOutlet NSTextField *captureSettingBtnLabel;





- (IBAction)radioModeAction:(id)sender;
- (IBAction)swapModeAction:(id)sender;


- (IBAction)imagePreviewSettingBtnAction:(id)sender;
- (IBAction)moviePreviewSettingBtnAction:(id)sender;
- (IBAction)saveToPathSettingBtnAction:(id)sender;

- (IBAction)mediaGalleryBtn:(id)sender;
- (IBAction)closeSettingBtn:(id)sender;
- (IBAction)captureSettingBtn:(id)sender;
- (IBAction)importLicenseFile:(id)sender;









@end
