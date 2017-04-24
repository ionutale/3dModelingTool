//
//  GeometricModelSphere.m
//  3dModelingTool
//
//  Created by AiU on 12/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "GeometricModelSphere.h"
#import <OpenGL/gl.h>

@implementation GeometricModelSphere

+(id)create
{
    return [[GeometricModelSphere alloc] init];
}

+(id)createRadius:(double)radius
{
    return [[GeometricModelSphere alloc] initRadius:radius];
}

-(id)init
{
    if (self = [super init]) {
        _radius = 0.5;
    }
    return self;
}

-(id)initRadius:(double)radius
{
    if (self = [super init]) {
        _radius = radius;
    }
    return self;
}

-(NSString *)description
{
    return @"Sphere";
}

-(void)renderLatitude:(double) lat longitude:(double) lon altitude:(double) alt
{
    assert(lat >= -90);
    assert(lat <=  90);
    assert(lat >= -180);
    assert(lat <=  180);
    
    //    lat = (lat +  90.0) * (M_PI / 180.0);
    //    lon = (lon + 180.0) * (M_PI / 180.0);
    
        lat = (lat +  0.0) * (M_PI / 180.0);
        lon = (lon +  0.0) * (M_PI / 180.0);

    double r = [self radius];
    
    double x = (r + alt) * cos(lat) * cos(lon);
    double y = (r + alt) * cos(lat) * sin(lon);
    double z = (r + alt) * sin(lat);
    
    double len = sqrt(x*x + y*y + z*z);
    
    double t = x / len;
    double u = y / len;
    double v = z / len;
    
    glNormal3d(t, u, v);
    glVertex3d(x, y, z);
}

-(void)render:(GLenum)polygonMode color:(Color *)color
{
    glPushMatrix();
    glMatrixMode(GL_MODELVIEW);
    
    glEnable(GL_CULL_FACE);
    glPolygonMode(GL_FRONT_AND_BACK, polygonMode);
    
    [color applyToColor];
    [color applyToFront:GL_AMBIENT];
    [color applyToFront:GL_DIFFUSE];
    [color applyToFront:GL_SPECULAR];
    GL_POSITION;
    glTranslated(0.0, 0.5, 0.0);
    
    glBegin(GL_QUADS);
    {
        int n = 10;
        for (int lat = -90; lat < 90; lat += n) {
            for (int lon = -180; lon < 180; lon += n) {
                [self renderLatitude: n + lat  longitude:   lon altitude:0];
                [self renderLatitude:     lat  longitude:   lon altitude:0];
                [self renderLatitude:     lat  longitude: n + lon altitude:0];
                [self renderLatitude: n + lat  longitude: n + lon altitude:0];

                
            }
        }
    }
    
    glEnd();
    glPopMatrix();
    
    glDisable(GL_CULL_FACE);
    
    GLfloat equatorialPlaneAmbientReflection[] = { 0.8, 0.8, 0.8, 0.5 };
    GLfloat math_shiness[] = { 50.0 };
    GLfloat light_position[] = { -3.0, 3.0, 3.0, 1.0 };
    
    glDepthMask(GL_FALSE);
    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    glColor4f(0.9f, 0.9f, 0.9f, 0.5f);
    glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, equatorialPlaneAmbientReflection);
    glMaterialfv(GL_BACK, GL_AMBIENT_AND_DIFFUSE, equatorialPlaneAmbientReflection);
    glMaterialfv(GL_FRONT, GL_SHININESS, math_shiness);
    glLightfv(GL_LIGHT0, GL_POSITION, light_position);
    
    glBegin(GL_QUADS);
    {
        glNormal3d(0,0.5,0.5);
        glVertex3f(-100.0, 0.0,  100.0);
        glVertex3f(-100.0, 0.0, -100.0);
        glVertex3f( 100.0, 0.0, -100.0);
        glVertex3f( 100.0, 0.0,  100.0);
    }
    glEnd();
    
    

    glBegin(GL_LINES);
    {
        glColor4f(0.9f, 0.0f, 0.0f, 0.5f);
        glVertex3f(-1000.0, 0.0,  0.0);
        glVertex3f( 1000.0, 0.0,  0.0);
        
        glColor4f(0.0f, 0.0f, 0.9f, 0.5f);
        glVertex3f( 0.0, 0.0,  -1000.0);
        glVertex3f( 0.0, 0.0,   1000.0);

    }
    glEnd();
    
    glDepthMask(GL_TRUE);
    
}

@end
