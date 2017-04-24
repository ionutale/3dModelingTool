
//
//  CustomModel.m
//  3dModelingTool
//
//  Created by AiU on 14/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "CustomModel.h"
#import <OpenGL/gl.h>
#import <GLKit/GLKit.h>
#import "Color.h"

@implementation CustomModel


+(id)create
{
    return  [[CustomModel alloc] init];
}

-(id)init
{
    if (self = [super init]) {
        _xPos = 1.0;
        _yPos = 0.000001;
        _zPos = 0.000001;
        
        _xRot = 1.0;
        _yRot = 1.0;
        _zRot = 1.0;
        _angle = 1.0;
        
        _xAngle = _yAngle = _zAngle = 0.0;
        
        _xScale = _yScale = _zScale = 1.0;
        
        
        _normalVertArray = [NSMutableArray arrayWithObjects:
                            @"0", @"0", @"1",
                            @"0", @"0", @"-1",
                            @"0", @"-1", @"0",
                            @"0", @"1", @"0",
                            @"-1", @"0", @"0",
                            @"1", @"0", @"0",nil];
        
        _verticesArray = [NSMutableArray arrayWithObjects:
                          @" 0.25", @" 0.25", @" 0.25",
                          @"-0.25", @" 0.25", @" 0.25",
                          @"-0.25", @"-0.25", @" 0.25",
                          @" 0.25", @"-0.25", @" 0.25",
        
                          @"-0.25", @"-0.25", @"-0.25",
                          @"-0.25", @" 0.25", @"-0.25",
                          @" 0.25", @" 0.25", @"-0.25",
                          @" 0.25", @"-0.25", @"-0.25",
                          
                          @" 0.25", @"-0.25", @" 0.25",
                          @"-0.25", @"-0.25", @" 0.25",
                          @"-0.25", @"-0.25", @"-0.25",
                          @" 0.25", @"-0.25", @"-0.25",
                          
                          @"-0.25", @" 0.25", @" 0.25",
                          @" 0.25", @" 0.25", @" 0.25",
                          @" 0.25", @" 0.25", @"-0.25",
                          @"-0.25", @" 0.25", @"-0.25",
                          
                          @"-0.25", @"-0.25", @" 0.25",
                          @"-0.25", @" 0.25", @" 0.25",
                          @"-0.25", @" 0.25", @"-0.25",
                          @"-0.25", @"-0.25", @"-0.25",
                          
                          @" 0.25", @" 0.25", @" 0.25",
                          @" 0.25", @"-0.25", @" 0.25",
                          @" 0.25", @"-0.25", @"-0.25",
                          @" 0.25", @" 0.25", @"-0.25",
                          nil];
        
        _history = [NSMutableArray arrayWithObjects:
                    @{@"name":@"rotation", @"angle": @"10", @"x": @"0.0", @"y": @"0.0", @"z": @"1.0"},
                    @{@"name": @"translation", @"x": @"0.0", @"y": @"1.0", @"z": @"0.0"},
                    @{@"name": @"rotation", @"angle": @"10", @"x": @"1.0", @"y": @"0.0", @"z": @"0.0"},nil];
        
        _color = [Color createRed:.5 green:.5 blue:.5 alpha:1.0];
        _objID = 0;
        _min = -0.25;
        _max =  0.25;
    
    }
    return self;
}

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
    
    double len = sqrt(x*x + y*y + z*z);
    
    double a = x / len;
    double b = y / len;
    double c = z / len;
    
    glNormal3d(a, b, c);
    glVertex3d(x, y, z);
}

#pragma mark - ++++++++++++++++++
#pragma mark - + my custom cube +
#pragma mark - ++++++++++++++++++
-(void)render:(GLenum)polygonMode color:(Color *)color
{
    [self renderMArray:polygonMode color:color];
}

-(void)renderMArray:(GLenum)polygonMode color:(Color *)color
{
    glPushMatrix();
    glPolygonMode(GL_FRONT_AND_BACK, polygonMode);
    
    

    glMatrixMode(GL_MODELVIEW);
   
    
    GLKMatrix4 smartMatrix;
    glGetFloatv(GL_MODELVIEW_MATRIX, smartMatrix.m);
    
    smartMatrix = GLKMatrix4TranslateWithVector3(smartMatrix, GLKVector3Make(_xPos, _yPos, _zPos));
    smartMatrix = GLKMatrix4TranslateWithVector3(smartMatrix, _newPosition);
    glLoadMatrixf(smartMatrix.m);
    _matrixGLK = smartMatrix;
    [self setMatrix:smartMatrix];
    
    glRotatef(_xAngle, 1.0, 0.0, 0.0);
    glRotatef(_yAngle, 0.0, 1.0, 0.0);
    glRotatef(_zAngle, 0.0, 0.0, 1.0);
    
    glScalef(_xScale, _yScale, _zScale);
    
    [_color applyToColor]; // In case someone turns off the lights;
    [_color applyToFront:GL_AMBIENT];
    [_color applyToFront:GL_DIFFUSE];
    [_color applyToFront:GL_SPECULAR];
    int vertex = 0;
    int face = 0;
   
    
    glBegin(GL_QUADS);
    {
        for (int i = 0; i < [_verticesArray count]; i+=3 ) {
            
            if (vertex == 0) {
                GLfloat normalX = [_normalVertArray[face+0] floatValue];
                GLfloat normalY = [_normalVertArray[face+1] floatValue];
                GLfloat normalZ = [_normalVertArray[face+2] floatValue];
                
                glNormal3f(normalX, normalY, normalZ);
            }
            vertex++;
            if (vertex == 4) { face+=3; vertex = 0; }
             
            GLfloat x = [_verticesArray[i+0] floatValue]; // + _xPos;
            GLfloat y = [_verticesArray[i+1] floatValue]; // + _yPos;
            GLfloat z = [_verticesArray[i+2] floatValue]; // + _zPos;
            
            glVertex3f(x, y, z);
           // glVertex4f(x, y, z, 3.0);
        }
    }
    glEnd();
    // debug lines
    if (_debug) {
        glBegin(GL_LINES);
        glVertex3f(-1000.0, 0.0,  0.0);
        glVertex3f( 1000.0, 0.0,  0.0);
            
        glVertex3f( 0.0, 0.0,  -1000.0);
        glVertex3f( 0.0, 0.0,   1000.0);
        glEnd();
    }
    // selection lines
    if (_isSelected) {
        glBegin(GL_LINES);
        int lineVertex = 0;
        for (int i = 0; i < [_verticesArray count]; i+=3 ) {
        if (lineVertex == 4) { lineVertex = 0; }
            
            GLfloat x = [_verticesArray[i+0] floatValue]; // + _xPos;
            GLfloat y = [_verticesArray[i+1] floatValue]; // + _yPos;
            GLfloat z = [_verticesArray[i+2] floatValue]; // + _zPos;
                
            glVertex3f(x, y, z);
        }
        glEnd();
    }
    
    glPopMatrix();
    glEnable(GL_CULL_FACE);

}

-(void)renderInIdenity
{
    
    glPushMatrix();
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    glLoadIdentity();
    
    
    glMatrixMode(GL_MODELVIEW);
    
    
    GLKMatrix4 smartMatrix;
    glGetFloatv(GL_MODELVIEW_MATRIX, smartMatrix.m);

    smartMatrix = GLKMatrix4TranslateWithVector3(smartMatrix, GLKVector3Make(_xPos, _yPos, _zPos));
    smartMatrix = GLKMatrix4TranslateWithVector3(smartMatrix, _newPosition);
    glLoadMatrixf(smartMatrix.m);
    _matrixGLK = smartMatrix;
    [self setMatrix:smartMatrix];

    glRotatef(_xAngle, 1.0, 0.0, 0.0);
    glRotatef(_yAngle, 0.0, 1.0, 0.0);
    glRotatef(_zAngle, 0.0, 0.0, 1.0);
    
    glScalef(_xScale, _yScale, _zScale);
    
   
    
    if (_debug) {
        [_color applyToColor]; // In case someone turns off the lights;
        [_color applyToFront:GL_AMBIENT];
        [_color applyToFront:GL_DIFFUSE];
        [_color applyToFront:GL_SPECULAR];
        
        glBegin(GL_QUADS);
        {
            for (int i = 0; i < [_verticesArray count]; i+=3 ) {
                
                GLfloat x = [_verticesArray[i+0] floatValue]; // + _xPos;
                GLfloat y = [_verticesArray[i+1] floatValue]; // + _yPos;
                GLfloat z = [_verticesArray[i+2] floatValue]; // + _zPos;
                
                glVertex3f(x, y, z);
            }
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
    }
    
    glPopMatrix();
    glEnable(GL_CULL_FACE);
}

-(void)renderTest
{
    
    glPushMatrix();
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    glLoadIdentity();
    
    
    glMatrixMode(GL_MODELVIEW);
    
    

    glLoadMatrixf(self.matrix.m);


    
    glRotatef(_xAngle, 1.0, 0.0, 0.0);
    glRotatef(_yAngle, 0.0, 1.0, 0.0);
    glRotatef(_zAngle, 0.0, 0.0, 1.0);
    
    glScalef(_xScale, _yScale, _zScale);
    
    
    

        [_color applyToColor]; // In case someone turns off the lights;
        [_color applyToFront:GL_AMBIENT];
        [_color applyToFront:GL_DIFFUSE];
        [_color applyToFront:GL_SPECULAR];
        
        glBegin(GL_QUADS);
        {
            for (int i = 0; i < [_verticesArray count]; i+=3 ) {
                
                GLfloat x = [_verticesArray[i+0] floatValue]; // + _xPos;
                GLfloat y = [_verticesArray[i+1] floatValue]; // + _yPos;
                GLfloat z = [_verticesArray[i+2] floatValue]; // + _zPos;
                
                glVertex3f(x, y, z);
            }
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
    
    
    glPopMatrix();
    glEnable(GL_CULL_FACE);
}

-(void)setXRot:(GLfloat)xRot
{
    if (_xRot != xRot) {
        _xRot = xRot;
    }
}

-(void)setYRot:(GLfloat)yRot
{
    if (_yRot != yRot) {
        _yRot = yRot;
    }
}

-(void)setZRot:(GLfloat)zRot
{
    if (_zRot != zRot) {
        _zRot = zRot;
    }
}

-(void)getMatrixTrasnformationWithDescription:(NSString *)description
{
    GLdouble objMatrix[] =
    {
        1, 0, 0, 1,
        0, 1, 0, 1,
        0, 0, 1, 0,
        0, 0, 0, 1
    };
    
    glGetDoublev(GL_MODELVIEW_MATRIX, objMatrix);
    
    objMatrix[3] *= 7.0;
    [self logTheMatrix:objMatrix withdescription:description];
    
}

-(void)logTheMatrix:(double *)matrix withdescription:(NSString *)description
{
    NSMutableString *mString = [NSMutableString string];
    [mString appendFormat:@"\n%@\n", description ];
    int index = 0;
    for (int i = 0; i < 16; i++) {
        if (index == 4) {
            [mString appendString:@"\n"];
            index = 0;
        }
        [mString appendFormat:@"%f, ", matrix[i]];
        index++;
    }
}

-(void)saveCopyOfMatrix:(float *)matrix
{
    _matrixGLK = GLKMatrix4MakeWithArray(matrix);
}



@end
