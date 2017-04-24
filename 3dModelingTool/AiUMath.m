//
//  AiUMath.m
//  3dModelingTool
//
//  Created by AiU on 09/05/14.
//  Copyright (c) 2014 AiU. All rights reserved.
//

#import "AiUMath.h"
#import <GLKit/GLKit.h>

@implementation AiUMath

#pragma mark -  get radians from world matrix

+(float)xRotation:(GLKMatrix4)matrix
{
    return atan2f(matrix.m12, matrix.m22);
}

+(float)yRotation:(GLKMatrix4)matrix
{
    return atan2f(-matrix.m02, sqrtf(matrix.m12 * matrix.m12 + matrix.m22 * matrix.m22));
}

+(float)zRotation:(GLKMatrix4)matrix
{
    return atan2f(matrix.m01, matrix.m00);
}
#pragma mark - mousePosition

+(GLKVector3)mouseVector3FromPosition:(NSPoint)mousePosition forZ:(float)z usingRatio:(float)ratio
{
    GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Identity;
    
    float x = mousePosition.x * (-z * (0.36 * ratio))   - modelViewProjectionMatrix.m30;
    float y = mousePosition.y * (-z * 0.36)             - modelViewProjectionMatrix.m31;
    
    return  GLKVector3Make(x, y, z);
}

+(GLKVector4)mouseVector4FromPosition:(NSPoint)mousePosition forZ:(float)z usingRatio:(float)ratio
{
    GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Identity;
    
    float x = mousePosition.x * (-z * (0.36 * ratio))   - modelViewProjectionMatrix.m30;
    float y = mousePosition.y * (-z * 0.36)             - modelViewProjectionMatrix.m31;
    
    return  GLKVector4Make(x, y, z, 1);
}





@end
