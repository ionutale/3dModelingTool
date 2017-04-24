//
//  Matrix4x4.m
//  3dModelingTool
//
//  Created by AiU on 28/04/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "Matrix4x4.h"


@implementation Matrix4x4

-(id)initWithMatrix:(GLKMatrix4 )matrix
{
    if (self = [super init]) {
        _matrix = matrix;
    }
    return self;
}

+(id)initWithMatrix:(GLKMatrix4 )matrix
{
    return [self initWithMatrix:matrix];
}

#pragma mark - camera Matrix
// move forward
-(GLKMatrix4)moveToForward:(GLKMatrix4)worldMatrix
{
    GLKMatrix4 newMatrix = worldMatrix;
    newMatrix.m32 += 1.0;
    return  newMatrix;
}

+(GLKMatrix4)moveToForward:(GLKMatrix4)worldMatrix
{/*
   // float xSin = worldMatrix.m00 * worldMatrix.m30;
    return GLKMatrix4MakeLookAt(worldMatrix.m30, worldMatrix.m31, worldMatrix.m32 + 1, worldMatrix.m30, worldMatrix.m31 - 2, worldMatrix.m32 + 3, 0.0, 1.0, 0.0);   //GLKMatrix4Translate(worldMatrix, 0.0, 0.0, 1.0);
  */
    GLKMatrix4 newMatrix = worldMatrix;
    newMatrix.m32 += 1.0;
    return  newMatrix;
}

// move right
-(GLKMatrix4)moveToRight:(GLKMatrix4)worldMatrix
{
    GLKMatrix4 newMatrix = worldMatrix;
    newMatrix.m30 += 1.0;
    return  newMatrix;
}

+(GLKMatrix4)moveToRight:(GLKMatrix4)worldMatrix
{
    GLKMatrix4 newMatrix = worldMatrix;
    newMatrix.m30 += 1.0;
    return  newMatrix;
}

// move backword
-(GLKMatrix4)moveToBackWard:(GLKMatrix4)worldMatrix
{
    GLKMatrix4 newMatrix = worldMatrix;
    newMatrix.m32 += -1.0;
    return  newMatrix;

}

+(GLKMatrix4)moveToBackWard:(GLKMatrix4)worldMatrix
{
    GLKMatrix4 newMatrix = worldMatrix;
    newMatrix.m32 += -1.0;
    return  newMatrix;
}

// move left
-(GLKMatrix4)moveToLeft:(GLKMatrix4)worldMatrix
{
    GLKMatrix4 newMatrix = worldMatrix;
    newMatrix.m30 += -1.0;
    return  newMatrix;
}

+(GLKMatrix4)moveToLeft:(GLKMatrix4)worldMatrix
{
    GLKMatrix4 newMatrix = worldMatrix;
    newMatrix.m30 += -1.0;
    return  newMatrix;
}

// move up
-(GLKMatrix4)moveToUp:(GLKMatrix4)worldMatrix
{
    GLKMatrix4 newMatrix = worldMatrix;
    newMatrix.m31 += -1.0;
    return  newMatrix;
}

+(GLKMatrix4)moveToUp:(GLKMatrix4)worldMatrix
{
    GLKMatrix4 newMatrix = worldMatrix;
    newMatrix.m31 += -1.0;
    return  newMatrix;
}

// move down
-(GLKMatrix4)moveToDown:(GLKMatrix4)worldMatrix
{
    GLKMatrix4 newMatrix = worldMatrix;
    newMatrix.m31 += 1.0;
    return  newMatrix;
}

+(GLKMatrix4)moveToDown:(GLKMatrix4)worldMatrix
{
    GLKMatrix4 newMatrix = worldMatrix;
    newMatrix.m31 += 1.0;
    return  newMatrix;
}

#pragma mark - camea matrix



// not sure what is sopose to do
-(GLKMatrix4)moveCameraInPosition:(GLKMatrix4)matrix
{
    return matrix;
}


@end
