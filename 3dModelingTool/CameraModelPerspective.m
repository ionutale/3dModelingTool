//
//  CameraModelPerspective.m
//  3dModelingTool
//
//  Created by AiU on 11/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "CameraModelPerspective.h"
#import <OpenGL/gl.h>

@implementation CameraModelPerspective

+(id)create
{
    return [[CameraModelPerspective alloc] init];
}

-(NSString *)description
{
    return @"Perspective";
}

-(void)applyProjection:(NSRect)bounds
{
    GLdouble w = NSWidth(bounds);
    GLdouble h = NSHeight(bounds);
    
    GLdouble aspectRatio = w / h;
    
    GLdouble fieldOfDegrees = 40; // Measured vertically (y-axis)
    GLdouble fieldOfRadians = fieldOfDegrees  * ( M_PI / 180 );
    
    
    // FIXME - Inappropriate hard-coded values: zMin, zMax
    //         These should probably be scene/geometry dependent?
    
    
    GLdouble zMin = 1; // near clipping plane; 0 < zMin < zMax
    GLdouble zMax = 15000; // near clipping plane; 0 < zMin < zMax
    
    GLdouble yMax = zMin * tan( fieldOfRadians / 2.0 );
    GLdouble yMin = -yMax;
    
    GLdouble xMax = aspectRatio * yMax;
    GLdouble xMin = aspectRatio * yMin;
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glFrustum(xMin, xMax, yMin, yMax, zMin, zMax);
}

@end
