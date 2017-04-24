//
//  CameraModelOrthographic.m
//  3dModelingTool
//
//  Created by AiU on 11/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "CameraModelOrthographic.h"
#import <OpenGL/gl.h>

@implementation CameraModelOrthographic

+(id)create
{
    return [[CameraModelOrthographic alloc] init];
}

-(NSString *)description
{
    return @"Orthographic";
}

-(void)applyProjection:(NSRect)bounds
{
    GLdouble fieldOfViewDegrees = 40; // measured verticaly ( y-axis )
    GLdouble fieldOfViewRadians = fieldOfViewDegrees * ( M_PI / 180.0 );
    
    GLdouble aspectRatio = NSWidth(bounds) / NSHeight(bounds);
    

    //         These should probably be scene/geometry dependent?
    
    GLdouble zMin = 1; // Near Clipping plane; 0 < zMin < zMax
    GLdouble zMax = 500; // Far Clipping plane; 0 < zMin < <Max
    
    GLdouble yMax = zMin * tan( fieldOfViewRadians / 2.0 );
    GLdouble yMin = -yMax;
    
    GLdouble xMax = aspectRatio * yMax;
    GLdouble xMin = aspectRatio * yMin;
    
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(xMin, xMax, yMin, yMax, zMin, zMax);
    
}

@end
