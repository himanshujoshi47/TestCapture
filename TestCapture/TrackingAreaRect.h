//
//  TrackingAreaRect.h
//  Capture It
//
//  Created by Himanshu on 12/13/13.
//  Copyright (c) 2013 com.thinksys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackingAreaRect : NSObject
{
    float startingXValue;
    float startingYValue;
    float finalXValue;
    float finalYValue;
    
    
    float bottomRightXCoords;
    float bottomRightYCoords;
    
    
    float bottomLeftXCoords;
    float bottomLeftYCoords;
    
    int trackingAreaOption;
    
    //NSRect
    NSRect upperTrackingAreaRect;
    NSRect bottomTrackingAreaRect;
    NSRect leftTrackingAreaRect;
    NSRect rightTrackingAreaRect;
}

-(void)setStartingXValue:(float)x;
-(void)setStartingYValue:(float)y;
-(void)setFinalXValue:(float)x;
-(void)setFinalYValue:(float)y;


-(float)getBottomRightXCoords;
-(float)getBottomRightYCoords;

-(float)getBottomLeftXCoords;
-(float)getBottomLeftYCoords;


-(void)setTrackingAreaOption;
-(void)findingTrackingAreas;


-(NSRect)getUpperTrackingAreaRect;
-(NSRect)getBottomTrackingAreaRect;
-(NSRect)getRightTrackingAreaRect;
-(NSRect)getLeftTrackingAreaRect;
@end
