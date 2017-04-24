//
//  GeometricModelCone.m
//  3dModelingTool
//
//  Created by AiU on 11/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "GeometricModelCone.h"
#import <OpenGL/gl.h>

// Convert parametric coordinates of cone to XYZ coordinates, calculate normal
// vector, and render vertex.
static void normalVertex(double u, double t, double r, double h)
{
    // u: [0, h]
    // t: [0, 2pi]
    // r: radius
    // h: height
    
    double huh = ( h - u ) / h;
    
    double x = huh * r * cos(t);
    double y = huh * r * sin(t);
    double z = u;
    
    // FIXME - This normal vector is incorrect: it is being calculated from
    //         the origin of the cone.
    
    double len  =  sqrt(x*x + y*y + z*z);
    
    double a = x / len;
    double b = y / len;
    double c = z / len;
    
    glNormal3d(a, b, c);
    glVertex3d(x, y, z);
    
}

@implementation GeometricModelCone

+(id)create
{
    return  [[GeometricModelCone alloc] init];
}

-(id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

-(NSString *)description
{
    return @"Cone";
}

-(void)render:(GLenum)polygonMode color:(Color *)color
{
    glMatrixMode(GL_MODELVIEW);
    glPolygonMode(GL_FRONT_AND_BACK, polygonMode);
    
    glPushMatrix();
  
    //glTranslated(0, 0, -0.37); // move approximate centroid for aesthetics
    
    [color applyToColor];
    [color applyToFront:GL_AMBIENT];
    [color applyToFront:GL_DIFFUSE];
    [color applyToFront:GL_SPECULAR];
    
    double r = 0.03; // at base
    double h = 0.05;
    
    int uLimit = 360;
    int vLimit = 360;
    
    int n = 10;
    
    glBegin(GL_QUADS);
    {
        for (int u = 0; u < uLimit; u += n) {
            
            for (int v = 0; v < vLimit; v += n) {
                normalVertex((h / uLimit) * (n + u), (2.0 * M_PI) / vLimit *   (v), r, h);
                normalVertex((h / uLimit) *     (u), (2.0 * M_PI) / vLimit *   (v), r, h);
                normalVertex((h / uLimit) *     (u), (2.0 * M_PI) / vLimit * (n+v), r, h);
                normalVertex((h / uLimit) * (n + u), (2.0 * M_PI) / vLimit * (n+v), r, h);
            }
        }
    }
    
    glEnd();
    
    glBegin(GL_POLYGON);
    {
        glNormal3d(0, 0, -1);
        
        int u = 0;
        for (int v = vLimit; v > 0; v -= n) {
            
            double t = (2.0 * M_PI) / ((double) vLimit) * ((double)v);
            
            // u: [0, h]
            // t: [0, 2pi]
            // r: radius
            // h: height
            
            double huh = (h - u) / h;
            
            double x = huh * r * cos(t);
            double y = huh * r * sin(t);
            double z = u;
            
            glVertex3d(x, y, z);
        }
    }
    
    glEnd();
    
    glPopMatrix();
    glDisable(GL_CULL_FACE);
    /*
    GLfloat equatorialPlaneAmbientReflection[] = { 0.8, 0.8, 0.8, 0.5 };
    
    glDepthMask(GL_FALSE);
    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    glColor4f(0.9f, 0.9f, 0.9f, 0.5f);
    glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, equatorialPlaneAmbientReflection);
    glMaterialfv(GL_BACK, GL_AMBIENT_AND_DIFFUSE, equatorialPlaneAmbientReflection);
    glBegin(GL_QUADS);
    {
        glNormal3d(   0,   0,     1);
        glVertex3f(-1.0,  1.0,  0.0);
        glVertex3f(-1.0, -1.0,  0.0);
        glVertex3f( 1.0, -1.0,  0.0);
        glVertex3f( 1.0,  1.0,  0.0);
    }
    glEnd();*/
    glDepthMask(GL_TRUE);
}





@end
