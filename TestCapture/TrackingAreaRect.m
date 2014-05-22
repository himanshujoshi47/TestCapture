//
//  TrackingAreaRect.m
//  Capture It
//
//  Created by Himanshu on 12/13/13.
//  Copyright (c) 2013 com.thinksys. All rights reserved.
//

#import "TrackingAreaRect.h"

@implementation TrackingAreaRect

-(id)init
{
    self = [super init];
    if(self)
    {
        
    }
    
    return self;
}

-(void)setStartingXValue:(float)x
{
    startingXValue = x;
}

-(void)setStartingYValue:(float)y
{
    startingYValue = y;
}

-(void)setFinalXValue:(float)x
{
    finalXValue = x;
}

-(void)setFinalYValue:(float)y
{
    finalYValue = y;
}

-(void)setTrackingAreaOption
{
    if ((finalXValue - startingXValue) > 0 && (finalYValue - startingYValue) < 0)
    {
        trackingAreaOption = 0;
    }
    else if ((finalXValue - startingXValue) < 0 && (finalYValue - startingYValue) > 0)
    {
        trackingAreaOption = 1;
    }
    else if ((finalXValue - startingXValue) > 0 && (finalYValue - startingYValue) > 0)
    {
        trackingAreaOption = 2;
    }
    else if ((finalXValue - startingXValue) < 0 && (finalYValue - startingYValue) < 0)
    {
        trackingAreaOption = 3;
    }
    
    [self findingTrackingAreas];
}

-(void)findingTrackingAreas
{
    switch (trackingAreaOption) {
            
        case 0:
            
            upperTrackingAreaRect = NSMakeRect(startingXValue, startingYValue, abs(finalXValue - startingXValue), 15);
            bottomTrackingAreaRect = NSMakeRect(startingXValue, finalYValue - 15, abs(finalXValue - startingXValue), 15);
            rightTrackingAreaRect = NSMakeRect(finalXValue, finalYValue, 15, abs(finalYValue - startingYValue));
            leftTrackingAreaRect = NSMakeRect(startingXValue - 15, finalYValue, 15, abs(finalYValue - startingYValue));
            
            
            bottomRightXCoords = finalXValue;
            bottomRightYCoords = finalYValue;
            
            bottomLeftXCoords = startingXValue;
            bottomLeftYCoords = finalYValue;
            
            break;
            
        case 1:
            
            upperTrackingAreaRect = NSMakeRect(finalXValue, finalYValue, abs(finalXValue - startingXValue), 15);
            bottomTrackingAreaRect = NSMakeRect(finalXValue, startingYValue - 15, abs(finalXValue - startingXValue), 15);
            rightTrackingAreaRect = NSMakeRect(startingXValue, startingYValue, 15, abs(finalYValue - startingYValue));
            leftTrackingAreaRect = NSMakeRect(finalXValue - 15, startingYValue, 15, abs(finalYValue - startingYValue));
            
            
            bottomRightXCoords = startingXValue;
            bottomRightYCoords = startingYValue;
            
            bottomLeftXCoords = finalXValue;
            bottomLeftYCoords = startingYValue;
            
            break;
            
        case 2:
            
            upperTrackingAreaRect = NSMakeRect(startingXValue, finalYValue, abs(finalXValue - startingXValue), 15);
            bottomTrackingAreaRect = NSMakeRect(startingXValue, startingYValue - 15, abs(finalXValue - startingXValue), 15);
            rightTrackingAreaRect = NSMakeRect(finalXValue, startingYValue, 15, abs(finalYValue - startingYValue));
            leftTrackingAreaRect = NSMakeRect(startingXValue - 15, startingYValue, 15, abs(finalYValue - startingYValue));
            
            
            bottomRightXCoords = finalXValue;
            bottomRightYCoords = startingYValue;
            
            bottomLeftXCoords = startingXValue;
            bottomLeftYCoords = startingYValue;
            
            break;
            
        case 3:
            
            upperTrackingAreaRect = NSMakeRect(finalXValue, startingYValue, abs(finalXValue - startingXValue), 15);
            bottomTrackingAreaRect = NSMakeRect(finalXValue, finalYValue - 15, abs(finalXValue - startingXValue), 15);
            rightTrackingAreaRect = NSMakeRect(startingXValue, finalYValue, 15, abs(finalYValue - startingYValue));
            leftTrackingAreaRect = NSMakeRect(finalXValue - 15, finalYValue, 15, abs(finalYValue - startingYValue));
            
            
            bottomRightXCoords = startingXValue;
            bottomRightYCoords = finalYValue;
            
            bottomLeftXCoords = finalXValue;
            bottomLeftYCoords = finalYValue;
            
            break;
            
        default:
            break;
    }
}

-(NSRect)getUpperTrackingAreaRect
{
    return upperTrackingAreaRect;
}

-(NSRect)getBottomTrackingAreaRect
{
    return bottomTrackingAreaRect;
}

-(NSRect)getRightTrackingAreaRect
{
    return rightTrackingAreaRect;
}

-(NSRect)getLeftTrackingAreaRect
{
    return leftTrackingAreaRect;
}

-(float)getBottomRightXCoords
{
    return bottomRightXCoords;
}

-(float)getBottomRightYCoords
{
    return bottomRightYCoords;
}

-(float)getBottomLeftXCoords
{
    return bottomLeftXCoords;
}

-(float)getBottomLeftYCoords
{
    return bottomLeftYCoords;
}


@end
