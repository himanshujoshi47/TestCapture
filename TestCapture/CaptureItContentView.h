//
//  CaptureItContentView.h
//  Capture It
//
//  Created by Himanshu on 2/10/14.
//  Copyright (c) 2014 com.thinksys. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol CaptureItWindowDelegate <NSObject>

-(void)removeSettingView;
-(void)moveWindow;

@end

@interface CaptureItContentView : NSView

-(id)initWithFrame:(NSRect)frameRect;

@property(strong, nonatomic) id<CaptureItWindowDelegate> delegate;

@end
