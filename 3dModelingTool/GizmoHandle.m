//
//  GizmoHandle.m
//  3dModelingTool
//
//  Created by AiU on 18/05/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "GizmoHandle.h"


@implementation GizmoHandle



+(id)create
{
    return  [[GizmoHandle alloc] init];
}

-(id)init
{
    if (self = [super init]) {
        
        _tag = 0;
        _color = [Color createWhite:0.5 alpha:1.0];
        _cone = [GeometricModelCone create];
        
    }
    return self;
}


-(void)render
{
    glPushMatrix();
    glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
    glMatrixMode(GL_MODELVIEW);

    
    GLKMatrix4 smartMatrix;
    switch (_tag) {
        case 1:
            glTranslatef(0.5, 0.0, 0.0);
            glRotatef(90, 0.0, 1.0, 0.0);
            break;
            
        case 2:
            glTranslatef(0.0, 0.5, 0.0);
            glRotatef(-90, 1.0, 0.0, 0.0);
            break;
            
        case 3:
            glTranslatef(0.0, 0.0, 0.5);

            break;
            
        default:
            break;
    }
    glGetFloatv(GL_MODELVIEW_MATRIX, smartMatrix.m);


   // glLoadMatrixf(self.matrix.m);

    [self setMatrix:smartMatrix];
    //NSLog(@"handle. %i - matrix %@", _tag, NSStringFromGLKMatrix4(smartMatrix));
    [_color applyToColor]; // In case someone turns off the lights;
    [_color applyToFaces:GL_AMBIENT];
    [_color applyToFaces:GL_DIFFUSE];
    [_color applyToFaces:GL_SPECULAR];
    
    [_cone render:GL_FILL color:_color];


    
    glPopMatrix();
    glEnable(GL_CULL_FACE);

}

-(NSRect)boundingBox
{
    float x = 0.0 + self.matrix.m30;
    float y = -0.2 + self.matrix.m31;
    float width  = 0.4;
    float height = 0.4;
    
    return NSMakeRect(x, y, width, height);
}


@end
