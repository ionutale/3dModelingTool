//
//  GeometricModelVector.m
//  3dModelingTool
//
//  Created by AiU on 12/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "GeometricModelVector.h"
#import <OpenGL/gl.h>

@implementation GeometricModelVector

+(id)createFrom:(GLdouble *)a to:(GLdouble *)b
{
    return [[GeometricModelVector alloc] initFrom:a to:b];
}

-(id)initFrom:(GLdouble *)a to:(GLdouble *)b
{
    if (self = [super init]) {
        _from[0] = a[0];
        _from[1] = a[1];
        _from[2] = a[2];

        _to[0] = b[0];
        _to[1] = b[1];
        _to[2] = b[2];
    }
    return self;
}

- (NSString *)description
{
    return @"Vector";
}

-(void)render:(GLenum)polygonMode color:(Color *)color
{
    glPolygonMode(GL_FRONT_AND_BACK, polygonMode);
    [color apply:GL_AMBIENT, GL_DIFFUSE, GL_SPECULAR, nil];
    
    glMatrixMode(GL_MODELVIEW);
    
    glPushAttrib(GL_ENABLE_BIT);
    glLineStipple(5, 0xAAAA);
    glEnable(GL_LINE_STIPPLE);
    
    glBegin(GL_LINES);
    glVertex3dv(_from);
    glVertex3dv(_to);
    glEnd();
    
    glDisable(GL_LINE_STIPPLE);
    glPopAttrib();
}

@end
