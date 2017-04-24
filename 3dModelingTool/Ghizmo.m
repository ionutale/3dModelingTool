//
//  Ghizmo.m
//  3dModelingTool
//
//  Created by AiU on 16/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "Ghizmo.h"
#import <OpenGL/gl.h>
#import "Color.h"

#define HANDLE_X 1
#define HANDLE_Y 2
#define HANDLE_Z 3

@implementation Ghizmo

-(void)setDelegate:(id<GizmoDelegate>)delegate{
    if (_delegate != delegate) {
        _delegate = delegate;
    }
}

+(id)create
{
    return [[Ghizmo alloc] init];
}
//
-(id)init
{
    if (self = [super init]) {
        _type = 1;
        _color = [Color createRed:1.0 green:0.0 blue:0.0 alpha:1.0];
        _xHandle = [GizmoHandle create];
        [_xHandle setTag:1];
        [_xHandle setColor:[Color red]];
        
        _yHandle = [GizmoHandle create];
        [_yHandle setTag:2];
        [_yHandle setColor:[Color green]];
        
        _zHandle = [GizmoHandle create];
        _zHandle.tag = 3;
        [_zHandle setColor:[Color blue]];
        
        _handles = [NSArray arrayWithObjects:_xHandle, _yHandle, _zHandle, nil];

    }
    return self;
}

-(NSString *)description
{
    return @"Cube";
}

-(void)render
{
    switch (_type) {
        case 1:
            [self renderMove];
            break;
        case 2:
            [self renderRotation];
            break;
        case 3:
            [self renderScale];
            break;

            
        default:
            break;
    }
}


-(void)render:(GLenum)polygonMode color:(Color *)color
{
    glPushMatrix();
    glMatrixMode(GL_MODELVIEW);
    glPolygonMode(GL_FRONT_AND_BACK, polygonMode);
    
    glTranslatef(.5, 0.5, 0.5);
    
    glBegin(GL_LINES);
    {
        // TODO: create the gizmo axes ( moving axes )
        [[Color red] apply:GL_AMBIENT_AND_DIFFUSE, nil];
        glVertex3d(0.0, 0.0, 0.0);
        glVertex3d(1.0, 0.0, 0.0); // x line
    }
    glEnd();
    
    
    glDisable(GL_CULL_FACE);
    
    glPopMatrix();
}

-(void)renderMove
{
    glPushMatrix();
    glMatrixMode(GL_MODELVIEW);
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    
    [_color applyToColor];
    [_color applyToFront:GL_AMBIENT];
    [_color applyToFront:GL_DIFFUSE];
    [_color applyToFront:GL_SPECULAR];

    glLoadMatrixf(_currentObject.matrix.m);
    glScalef(1.01, 1.01, 1.01);
    
    glBegin(GL_QUADS);
    
    for (int i = 0; i < [_verticesArray count]; i+=3 ) {
        
        GLfloat x = [_verticesArray[i+0] floatValue]; // + _xPos;
        GLfloat y = [_verticesArray[i+1] floatValue]; // + _yPos;
        GLfloat z = [_verticesArray[i+2] floatValue]; // + _zPos;
        glVertex3f(x, y, z);
    }
    glEnd();
    glPopMatrix();
    
    glPushMatrix();
    glMatrixMode(GL_MODELVIEW);
    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);

    glLoadMatrixf([self gizmoMatrix].m);
    
    [_color applyToColor];
    [_color applyToFront:GL_AMBIENT];
    [_color applyToFront:GL_DIFFUSE];
    [_color applyToFront:GL_SPECULAR];
  // NSLog(@"the gizmo matrix %@", NSStringFromGLKMatrix4(_gizmoMatrix));
    glBegin(GL_LINES);
    {
        // TODO: create the gizmo axes ( moving axes )
       // [[Color red] apply:GL_AMBIENT_AND_DIFFUSE, nil];
        glVertex3d(0.0, 0.0, 0.0);
        glVertex3d(0.5, 0.0, 0.0); // x line
        
        glVertex3d(0.0, 0.0, 0.0);
        glVertex3d(0.0, 0.5, 0.0); // Y line
        
        glVertex3d(0.0, 0.0, 0.0);
        glVertex3d(0.0, 0.0, 0.5); // Z line
    }
    glEnd();
    
    [_xHandle render];
    [_yHandle render];
    [_zHandle render];

    glDisable(GL_CULL_FACE);
    glPopMatrix();
    

}
-(void)renderRotation
{
    
}
-(void)renderScale
{
    
}




-(GLKMatrix4)gizmoMatrix
{
    GLKMatrix4 newMatrix = GLKMatrix4Identity;
    GLKMatrix4 fromMatrix = _currentObject.matrix;
    
    newMatrix.m00 = fromMatrix.m00;
    newMatrix.m01 = fromMatrix.m01;
    newMatrix.m02 = fromMatrix.m02;
    newMatrix.m03 = 0;
    
    newMatrix.m10 = fromMatrix.m10;
    newMatrix.m11 = fromMatrix.m11;
    newMatrix.m12 = fromMatrix.m12;
    newMatrix.m13 = 0;

    newMatrix.m20 = fromMatrix.m20;
    newMatrix.m21 = fromMatrix.m21;
    newMatrix.m22 = fromMatrix.m22;
    newMatrix.m23 = 0;
    _aspectRatio = [_delegate viewPortRatio];
    NSLog(@"_aspect ratio %f", _aspectRatio);
    float z = fromMatrix.m32 ;
    float x = fromMatrix.m30 / (-z * 0.33); //* _aspectRatio);
    float y = fromMatrix.m31 / (-z * 0.33);
    //NSLog(@"z = %f- from %f", z, fromMatrix.m32);
    NSLog(@"x: %f, y: %f, z:%f", x, y, z);
    
    newMatrix.m30 = x;
    newMatrix.m31 = y;
    newMatrix.m32 = -3.0f;
    newMatrix.m33 = 1.0;

    NSLog(@"\n from matrix \n %@ \n and new matrix \n %@", NSStringFromGLKMatrix4(fromMatrix), NSStringFromGLKMatrix4(newMatrix));

    return newMatrix;
}

-(void)setCurrentObject:(CustomModel *)currentObject
{
    if (_currentObject != currentObject) {
        _currentObject = currentObject;
    }
    
    ////NSLog(@"setting the new current object");
    [self setMatrix:_currentObject.matrix];
    [self setVerticesArray:_currentObject.verticesArray];
    
    // TODO: read all the vertices from the current object and create the lines
}


-(BOOL)isGizmoActive
{
    // this may need to be adjusted
    // this has one cicle run delay for the correct values
    return isnan([self gizmoMatrix].m30) ? NO : YES;
}

-(int)mouseDownInPosition:(NSPoint)mousePosition
{
    int tag = [self mousePosition:mousePosition BasedOnHandle:_handles];
    return tag;
}


-(int)mousePosition:(NSPoint)mousePosition BasedOnHandle:(NSArray *)handlesArray
{
    for (GizmoHandle *tempHandle in handlesArray) {
        float ratio = [_delegate viewPortRatio];
        float z = tempHandle.matrix.m32;
        // generating the mouse coordinates
        float x = mousePosition.x * (-z * (0.36 * ratio));
        float y = mousePosition.y * (-z * 0.36);
        
        if ([self checkPointInGizmoHandle:tempHandle mouse3DPosition:GLKVector3Make(x, y, z)])
        {
            return tempHandle.tag;
        }
    }
    return 0;
}


-(BOOL)checkPointInGizmoHandle:(GizmoHandle *)gizmoHandle mouse3DPosition:(GLKVector3)mouseVector
{
    
    NSRect objRect   = NSMakeRect(gizmoHandle.matrix.m30 , gizmoHandle.matrix.m31 - 0.05, 0.1, 0.1);;
    NSPoint mouseRect = NSMakePoint(mouseVector.x, mouseVector.y);
    return NSPointInRect(mouseRect, objRect);
}


@end
